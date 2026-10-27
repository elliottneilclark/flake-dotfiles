#!/usr/bin/env bash
# From the Frost live USB, after connecting to the network:
#   sudo bash ./install-frost.sh
# Use a current frost-iso build, which includes the ext4 formatter.
# Erases the configured Linux root partition; preserves the existing EFI partition.
# Back up Ubuntu files and unpushed repository changes first. No automatic reboot.
# Only elliott gets a password. Root stays locked; use sudo -i as elliott.
# Use --check to validate targets without building, formatting, or installing.
set -euo pipefail

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
[[ $# == 0 || ( $# == 1 && $1 == --check ) ]] || die 'Usage: install-frost.sh [--check]'
[[ -d /sys/firmware/efi ]] || die 'Boot the USB in UEFI mode.'
[[ $(findmnt -n -o FSTYPE /) == tmpfs && $(findmnt -n -o FSTYPE --mountpoint /iso) == iso9660 ]] ||
  die 'Run this only from the Frost live USB, not the installed OS.'
(( EUID == 0 )) || die 'Run with sudo bash ./install-frost.sh'

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
flake="path:$repo#nixosConfigurations.frost.config"
for tool in nix nixos-install nixos-enter mkfs.ext4 blkid lsblk mount umount mountpoint; do
  command -v "$tool" >/dev/null || die "Missing required command: $tool"
done
root_spec=$(nix eval --raw "$flake.fileSystems.\"/\".device")
efi_spec=$(nix eval --raw "$flake.fileSystems.\"/boot/efi\".device")
[[ $root_spec == /dev/disk/by-uuid/* && $efi_spec == /dev/disk/by-uuid/* ]] ||
  die 'Frost must use UUID-based root and EFI partitions.'
[[ $(nix eval --raw "$flake.fileSystems.\"/\".fsType") == ext4 &&
   $(nix eval --raw "$flake.fileSystems.\"/boot/efi\".fsType") == vfat ]] ||
  die 'This installer supports the existing ext4 root and FAT EFI layout only.'
root_uuid=${root_spec##*/}
efi_uuid=${efi_spec##*/}
root_device=$(readlink -e -- "$root_spec") || die "Missing root partition: $root_spec"
efi_device=$(readlink -e -- "$efi_spec") || die "Missing EFI partition: $efi_spec"

validate_targets() {
  local device uuid parent
  [[ $root_device != "$efi_device" ]] || die 'Root and EFI must be different partitions.'
  for device in "$root_device" "$efi_device"; do
    [[ -b $device && $(lsblk -dn -o TYPE "$device") == part ]] || die "Not a partition: $device"
    [[ -z $(lsblk -n -o MOUNTPOINTS "$device" | tr -d '[:space:]') ]] ||
      die "Target is mounted or in use: $device. Unmount it first."
    parent=$(lsblk -dn -o PKNAME "$device")
    [[ -n $parent && $(lsblk -dn -o TRAN "/dev/$parent") == nvme ]] ||
      die "Target is not on an internal NVMe disk: $device"
  done
  [[ $(lsblk -dn -o PKNAME "$root_device") == "$(lsblk -dn -o PKNAME "$efi_device")" ]] ||
    die 'Root and EFI must be on the same NVMe disk.'
  for uuid in "$root_uuid" "$efi_uuid"; do
    device=$(blkid -c /dev/null -t "UUID=$uuid" -o device)
    [[ $device == "$root_device" || $device == "$efi_device" ]] ||
      die "Missing or duplicate filesystem UUID: $uuid"
  done
  [[ $(blkid -s TYPE -o value "$root_device") == ext4 &&
     $(blkid -s TYPE -o value "$efi_device") == vfat ]] || die 'Unexpected target filesystem types.'
}
validate_targets
printf '\nERASE Ubuntu root: %s (UUID %s)\nPreserve EFI: %s (UUID %s)\n' \
  "$root_device" "$root_uuid" "$efi_device" "$efi_uuid"
lsblk -o PATH,SIZE,MODEL,SERIAL,FSTYPE,UUID "/dev/$(lsblk -dn -o PKNAME "$root_device")"
[[ ${1:-} != --check ]] || exit 0
printf '\nAll files on the root partition will be lost. Type ERASE FROST to continue: '
read -r confirmation
[[ $confirmation == 'ERASE FROST' ]] || die 'Cancelled; nothing was formatted.'

work=$(mktemp -d /tmp/frost-install.XXXXXX)
target=$work/target
cleanup() {
  if mountpoint -q "$target/boot/efi"; then umount "$target/boot/efi" || return; fi
  if mountpoint -q "$target"; then umount "$target" || return; fi
  rm -rf -- "$work"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Resolve/build everything before erasing Ubuntu; keep a GC root until installation ends.
nix build "$flake.system.build.toplevel" --out-link "$work/system"
validate_targets
mkfs.ext4 -U "$root_uuid" "$root_device"
mkdir "$target"
mount "$root_device" "$target"
mkdir -p "$target/boot/efi"
mount "$efi_device" "$target/boot/efi"
nixos-install --root "$target" --system "$(readlink -f "$work/system")" --no-root-passwd
mkdir -p "$target/etc/nixos"
cp -a "$repo/." "$target/etc/nixos/"
# A locked password disables root password login, not sudo's ability to become root.
nixos-enter --root "$target" -c 'passwd -l root'
printf '\nSet the installed elliott password (not the live USB password):\n'
nixos-enter --root "$target" -c 'passwd elliott'
printf '\nFrost installed. Reboot, remove the USB, and select Linux Boot Manager.\n'
