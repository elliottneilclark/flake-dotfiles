#!/usr/bin/env bash
# From the Slate custom NixOS ISO (Secure Boot temporarily disabled):
#   sudo bash ./install-slate.sh [--check] /dev/disk/by-id/nvme-<whole-disk-id>
# Erases the ENTIRE selected internal NVMe, including Windows and recovery data.
# Back up your files first. LUKS2 uses a passphrase only; no TPM or keyfiles.
# --check only validates/displays the target; it never builds or changes disks.
set -euo pipefail

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

check=false
if [[ ${1:-} == --check ]]; then check=true; shift; fi
[[ $# == 1 ]] || die 'Usage: install-slate.sh [--check] /dev/disk/by-id/<whole-internal-NVMe>'
disk_spec=$1
[[ $disk_spec == /dev/disk/by-id/nvme-* && ${disk_spec#/dev/disk/by-id/} != */* &&
   ! $disk_spec =~ -part[0-9]+$ && -L $disk_spec ]] ||
  die 'Supply an explicit whole-disk NVMe symlink under /dev/disk/by-id/.'
(( EUID == 0 )) || die 'Run this installer with sudo bash.'

for tool in nix nixos-install nixos-enter lsblk blkid findmnt swapon cryptsetup \
  sgdisk wipefs mkfs.fat mkfs.ext4 partprobe udevadm mount umount mountpoint \
  readlink mktemp chmod chown install mkdir rm rmdir touch sync od tr tar; do
  command -v "$tool" >/dev/null || die "Missing required command: $tool"
done
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
[[ -f $repo/flake.nix && -f $repo/flake.lock ]] || die 'Run the installer from the complete flake repository.'
flake="path:$repo#nixosConfigurations.slate.config"
disk=$(readlink -e -- "$disk_spec") || die 'The disk symlink does not resolve.'
serial=$(lsblk -dn -o SERIAL "$disk") || die 'Cannot read the target serial.'
[[ $serial == *[![:space:]]* && $serial != *$'\n'* ]] || die 'The disk must have a nonempty, single-line serial.'

validate_live() {
  [[ -d /sys/firmware/efi ]] || die 'Boot the Slate ISO in UEFI mode.'
  [[ $(</etc/hostname) == slate-live && $(</proc/sys/kernel/hostname) == slate-live ]] ||
    die 'Run this only from the custom slate-live ISO, never Frost or an installed OS.'
  [[ $(findmnt -n --first-only -o FSTYPE --target /) == tmpfs &&
     $(findmnt -n --first-only -o FSTYPE --target /iso) == iso9660 &&
     $(findmnt -n --first-only -o FSTYPE --target /nix/.ro-store) == squashfs &&
     $(findmnt -n --first-only -o FSTYPE --target /nix/store) == overlay ]] ||
    die 'The live RAM/ISO/store mounts do not match the custom NixOS ISO.'
  [[ $(</sys/class/dmi/id/product_name) == 21WN00BUUS ]] ||
    die 'This installer only supports the physical ThinkPad 21WN00BUUS.'
  local secure_boot=/sys/firmware/efi/efivars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c
  [[ -f $secure_boot && $(od -An -tu1 -j4 -N1 "$secure_boot" | tr -d '[:space:]') == 0 ]] ||
    die 'Temporarily disable Secure Boot enforcement before installation; do not clear firmware keys.'
}

validate_target() {
  validate_live
  local name controller node nodes mounts swaps swap label matches status iso_source ancestry ancestor
  [[ $(readlink -e -- "$disk_spec") == "$disk" && -b $disk ]] || die 'The selected disk changed or disappeared.'
  name=${disk##*/}
  [[ $name =~ ^nvme[0-9]+n[0-9]+$ && $(lsblk -dn -o TYPE "$disk") == disk &&
     $(lsblk -dn -o TRAN "$disk") == nvme && $(lsblk -dn -o RM "$disk") == 0 &&
     $(lsblk -dn -o HOTPLUG "$disk") == 0 ]] || die 'Target must be a non-removable, non-hotplug whole NVMe disk, not USB.'
  controller=${name%n*}
  [[ $(</sys/class/nvme/"$controller"/transport) == pcie ]] || die 'Target must be a local PCIe NVMe, not NVMe over fabrics.'
  [[ $(lsblk -dn -o SERIAL "$disk") == "$serial" ]] || die 'The disk serial changed.'
  [[ $(lsblk -bdn -o SIZE "$disk") -ge $((64 * 1024 * 1024 * 1024)) ]] || die 'Target must be at least 64 GiB.'
  [[ ! -e /dev/mapper/cryptroot ]] || die 'cryptroot already exists; close it yourself before installing.'

  nodes=$(lsblk -nrpo NAME "$disk") || die 'Cannot enumerate target descendants.'
  mounts=$(lsblk -nr -o MOUNTPOINTS "$disk") || die 'Cannot inspect target mounts.'
  [[ -z $(printf '%s' "$mounts" | tr -d '[:space:]') ]] || die 'Target or a descendant is mounted/in use; unmount it first.'
  swaps=$(swapon --show --noheadings --raw --output NAME) || die 'Cannot inspect active swap.'
  while IFS= read -r node; do
    [[ -b $node && -d /sys/class/block/${node##*/}/holders ]] || die "Cannot inspect block device: $node"
    if compgen -G "/sys/class/block/${node##*/}/holders/*" >/dev/null; then
      die "Target has an active holder (LUKS/LVM/RAID/etc.): $node"
    fi
    if findmnt -rn --source "$node" >/dev/null; then die "Target is mounted: $node"; fi
    while IFS= read -r swap; do
      [[ -z $swap ]] && continue
      [[ $(readlink -e -- "$swap") != "$node" ]] || die "Target has active swap: $node"
    done <<< "$swaps"
  done <<< "$nodes"

  iso_source=$(findmnt -n -o SOURCE --mountpoint /iso) || die 'Cannot identify installer media.'
  iso_source=$(readlink -e -- "$iso_source") || die 'Installer media must resolve to a block device.'
  [[ -b $iso_source ]] || die 'Installer media is not a block device.'
  ancestry=$(lsblk -snrpo NAME "$iso_source") || die 'Cannot inspect installer media ancestry.'
  while IFS= read -r ancestor; do
    [[ $ancestor != "$disk" ]] || die 'The selected disk contains the running installer.'
  done <<< "$ancestry"

  # Labels on this disk will be erased; the same labels elsewhere would be ambiguous.
  for label in SLATE-EFI slate-crypt slate-root; do
    if matches=$(blkid -c /dev/null -t "LABEL=$label" -o device); then
      while IFS= read -r node; do
        node=$(readlink -e -- "$node") || die "Cannot resolve existing label: $label"
        [[ $'\n'"$nodes"$'\n' == *$'\n'"$node"$'\n'* ]] || die "Label $label already exists on another disk: $node"
      done <<< "$matches"
    else
      status=$?
      (( status == 2 )) || die "Cannot scan for duplicate label: $label"
    fi
  done
}

validate_target
printf '\nERASE ENTIRE DISK: %s\nResolved target: %s\nSerial: %s\n' "$disk_spec" "$disk" "$serial"
lsblk -o PATH,SIZE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS "$disk"
if $check; then
  printf '\nCheck passed. No build, formatting, installation, or key creation was performed.\n'
  exit 0
fi
[[ -t 0 ]] || die 'An interactive terminal is required for erase confirmation and passwords.'
printf '\nWindows, recovery partitions, and ALL data on this disk will be lost.\nType exactly ERASE SLATE %s to continue: ' "$serial"
read -r confirmation || die 'Cancelled; nothing was erased.'
[[ $confirmation == "ERASE SLATE $serial" ]] || die 'Cancelled; nothing was erased.'

umask 077
work=$(mktemp -d /tmp/slate-install.XXXXXX)
target=$work/target
own_mapper=false
cleanup() {
  local result=$? mounts point
  trap - EXIT INT TERM
  if mountpoint -q "$target/boot/efi"; then
    umount "$target/boot/efi" || { printf 'Cleanup failed; keeping %s mounted and %s intact.\n' "$target/boot/efi" "$work" >&2; exit 1; }
  fi
  if mountpoint -q "$target"; then
    umount "$target" || { printf 'Cleanup failed; keeping %s and its mapper intact.\n' "$work" >&2; exit 1; }
  fi
  mounts=$(findmnt -rn -o TARGET) || { printf 'Cannot verify cleanup; keeping %s intact.\n' "$work" >&2; exit 1; }
  while IFS= read -r point; do
    if [[ $point == "$work" || $point == "$work/"* ]]; then
      printf 'Unexpected remaining mount %s; keeping %s intact.\n' "$point" "$work" >&2
      exit 1
    fi
  done <<< "$mounts"
  if $own_mapper; then
    cryptsetup close cryptroot || { printf 'Cannot close cryptroot; keeping %s intact.\n' "$work" >&2; exit 1; }
  fi
  # Never recursively remove a mount tree, even on failure.
  rm -f -- "$work/system"
  if [[ -d $target ]]; then rmdir -- "$target" || exit 1; fi
  rmdir -- "$work" || exit 1
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Resolve every dependency before the first destructive command; keep a GC root.
nix build "$flake.system.build.toplevel" --no-update-lock-file --out-link "$work/system"
system=$(readlink -e "$work/system") || die 'The built system closure is missing.'
[[ -x $system/sw/bin/sbctl && -x $system/sw/bin/passwd && -x $system/bin/switch-to-configuration ]] ||
  die 'The installed closure is missing sbctl, passwd, or the boot activation tool.'
# Leave room for the copied closure, EFI, filesystem overhead, and normal root use.
closure_info=$(nix path-info --closure-size "$system") || die 'Cannot measure the built closure.'
read -r closure_path closure_bytes <<< "$closure_info"
[[ $closure_path == "$system" && $closure_bytes =~ ^[0-9]+$ ]] || die 'Unexpected closure size output.'
[[ $(lsblk -bdn -o SIZE "$disk") -ge $((closure_bytes + 16 * 1024 * 1024 * 1024)) ]] || die 'Disk is too small for the built closure plus working space.'

validate_target
wipefs --all "$disk"
sgdisk --zap-all "$disk"
sgdisk --clear --new=1:0:+2G --typecode=1:ef00 --change-name=1:SLATE-EFI \
  --new=2:0:0 --typecode=2:8309 --change-name=2:slate-crypt "$disk"
partprobe "$disk"
udevadm settle
efi=${disk}p1
crypt=${disk}p2
[[ -b $efi && -b $crypt ]] || die 'New partitions did not appear.'
# Recheck the entire disk immediately before formatting the new partitions.
validate_target
wipefs --all "$efi" "$crypt"
mkfs.fat -F 32 -n SLATE-EFI "$efi"
printf '\nChoose the LUKS2 disk passphrase; it will be required at every boot.\n'
cryptsetup luksFormat --type luks2 --label slate-crypt "$crypt"
cryptsetup open --type luks2 "$crypt" cryptroot
own_mapper=true
mkfs.ext4 -L slate-root /dev/mapper/cryptroot
install -d -m 0755 "$target"
mount -t ext4 /dev/mapper/cryptroot "$target"
install -d -m 0755 "$target/boot/efi"
mount -t vfat "$efi" "$target/boot/efi"

# nixos-install requires world-traversable ancestors; no keys live in the workdir.
chmod 0755 "$work"
install -d -m 0755 "$target/etc/nixos"
tar -C "$repo" --exclude='./.git' --exclude='./.direnv' --exclude='./result*' \
  --exclude='./secrets' --exclude='./sbctl' --exclude='*.key' -cf - . | tar -C "$target/etc/nixos" -xf -
chown -R root:root "$target/etc/nixos"
# nixos-enter activates the copied system without installing its bootloader.
# Only this local copy skips signatures: our freshly built paths are not cache-signed.
nix copy --no-check-sigs --to "local?root=$target" "$system"
touch "$target/etc/NIXOS"
nixos-enter --root "$target" --system "$system" -c \
  'set -e; umask 077; install -d -m 0700 /var/lib/sbctl; sbctl create-keys --keytype file'
for key in PK KEK db; do
  [[ -s $target/var/lib/sbctl/keys/$key/$key.key && -s $target/var/lib/sbctl/keys/$key/$key.pem ]] ||
    die "Secure Boot key creation failed: $key"
done
chown -R root:root "$target/var/lib/sbctl"
chmod -R go-rwx "$target/var/lib/sbctl"
nixos-install --root "$target" --system "$system" --no-root-passwd --no-channel-copy
nixos-enter --root "$target" -c 'passwd -l root'
printf '\nSet the installed elliott password (separate from the LUKS passphrase):\n'
nixos-enter --root "$target" -c 'passwd elliott'
sync
printf '\nSlate installed. Root remains locked; use sudo as elliott. No keys were enrolled.\n'
printf 'Keep Secure Boot disabled for the first boot; remove the USB after shutdown.\n'
printf 'Read the Slate Secure Boot enrollment instructions before changing firmware.\n'
printf 'Check signed loader/UKI files with sudo sbctl verify; unsigned unrelated files may be reported.\n'
printf 'Manually enroll owner keys with required Microsoft/vendor trust and preserve dbx.\n'
printf 'Never use Clear All Secure Boot Keys. Keep /var/lib/sbctl private and backed up securely.\n'
printf 'No TPM unlock/enrollment and no automatic reboot were configured.\n'
