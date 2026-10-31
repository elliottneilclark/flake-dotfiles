# Slate: ThinkPad T14 Gen 7 Intel

This host targets **21WN00BUUS**, Core Ultra 7 365 / Panther Lake. It uses the shared Hyprland desktop, applications and `elliott` account, with Intel `xe` graphics, Intel VA-API decoding, redistributable firmware and SOF audio firmware. NetworkManager, Bluetooth, UPower, power-profiles-daemon and fwupd are enabled. Waybar adds battery and power-profile widgets. Inbound SSH is disabled.

Linux uses **LUKS2 with an interactive passphrase only**. There is no TPM unlock, TPM enrollment or measured-boot setup. The root account stays locked; use `elliott` and `sudo`. Encryption protects the root filesystem, including the Secure Boot signing keys. The EFI System Partition (ESP) is necessarily unencrypted; Lanzaboote signs the installed boot artifacts.

## Before erasing Windows

The installer **erases the entire selected internal NVMe**, including Windows, recovery partitions and the existing ESP. This is not a dual-boot installation. Back up personal files, Windows/BitLocker recovery material and any required Lenovo recovery media to another device, and check that the backups can be read. Keep AC connected.

Record the current firmware settings. Save the current Secure Boot PK, KEK, db and **dbx** to external recovery storage before changing firmware keys; the live image includes `efi-readvar` from efitools. For example, replace the path below with a mounted external backup device, not the internal NVMe or the live USB's read-only filesystem:

```sh
backup=/path/on/external-storage/slate-recovery
sudo install -d -m 0700 "$backup"
for variable in PK KEK db dbx; do
  sudo efi-readvar -v "$variable" -o "$backup/$variable.esl"
done
```

Temporarily **disable Secure Boot**, but leave existing keys and revocations intact. The ISO is not signed with your future owner keys. Do not select **Clear All Secure Boot Keys**. Setup Mode and owner enrollment happen manually after installing, not in the installer.

## Build and boot the USB

On an x86_64 Linux machine with Nix flakes enabled, from this repository:

```sh
nix build path:.#slate-iso
```

Use `path:.` so newly added, not-yet-git-tracked host and installer files are included. The flake's source snapshot is cleaned before embedding: `.git` and build-result links are not installation inputs. Never put private keys or other secrets in this repository.

Write `result/iso/*.iso` as a **raw image to the whole USB device**, using a disk-imaging tool; this erases that USB. Do not copy the ISO as a file or write it to a partition. Double-check the USB model, serial number and capacity before writing. Boot the USB using the firmware's UEFI boot menu with Secure Boot temporarily disabled.

Live login: **`elliott` / `slate-live`**. This is a disposable live-only password. The live root filesystem and writable Nix store are RAM-backed; the image does not configure internal root/EFI mounts or LUKS unlock, and has neither signing keys nor inbound SSH/keychain services. Firmware-update services are disabled in the live image; use the installed system for firmware updates.

The repository is at `/iso/flake-dotfiles`. The ISO also contains the installed Slate system closure, so installing that prebuilt closure need not download its packages. **This is not a guarantee of a completely offline installation**: the installer's flake build/evaluation still needs its pinned flake inputs and evaluation sources available locally or from the network. Connect through the NetworkManager applet or `nmtui` before starting if those inputs are not cached. A source tree plus `flake.lock` alone is not an input cache.

## Select the internal disk and install

Inspect devices before choosing a target:

```sh
lsblk -d -o NAME,SIZE,MODEL,SERIAL,TRAN,RM
ls -l /dev/disk/by-id/nvme-*
cd /iso/flake-dotfiles
sudo bash ./install-slate.sh --check /dev/disk/by-id/<whole-internal-NVMe>
sudo bash ./install-slate.sh /dev/disk/by-id/<whole-internal-NVMe>
```

Replace the angle-bracketed placeholder with the actual persistent **whole-disk NVMe ID**, not a `-partN` link. Do not select the boot USB, an external disk or a disk containing recovery backups. `--check` performs the installer's preflight checks without erasing anything; it does not prove that all subsequent builds or hardware will work.

Before erasing, the installer builds `path:$repo#nixosConfigurations.slate.config.system.build.toplevel`. It asks for destructive confirmation, then creates this GPT layout:

| Partition | Format / label | Installed mount |
| --- | --- | --- |
| First 2 GiB | FAT32, `SLATE-EFI` | `/boot/efi` |
| Remaining space | LUKS2, `slate-crypt`, opened as `cryptroot` | encrypted container |
| `/dev/mapper/cryptroot` | ext4, `slate-root` | `/` |

The writable 2 GiB ESP provides space for signed boot generations and firmware-update capsules. Five installed boot generations are retained in the boot menu. There is no disk swap or hibernation configuration; zram provides compressed RAM swap.

Choose and record the **LUKS encryption passphrase** when cryptsetup prompts. It is needed at every installed boot and for recovery. Later, choose the **`elliott` login/sudo password** when `passwd` prompts; this is separate from the encryption passphrase and the live-only password. Root is not assigned a password.

The installer copies the built closure to the encrypted target and generates file-backed signing keys **inside `/var/lib/sbctl` on that target before installing/signing the bootloader**. Keys are never generated into the repository, ISO, Nix store or unencrypted ESP. It does not enroll keys into firmware or reboot automatically. Read its completion message before rebooting; leave Secure Boot disabled for the first installed boot.

## Recovery backups and manual Secure Boot enrollment

After booting the installed system and confirming login, create protected external backups of `/var/lib/sbctl` and the LUKS header. These backups belong on secure external storage, not only on the encrypted drive they recover:

```sh
backup=/path/on/external-storage/slate-recovery
sudo install -d -m 0700 "$backup"
sudo tar -C /var/lib -cpf "$backup/sbctl-private-keys.tar" sbctl
sudo cryptsetup luksHeaderBackup /dev/disk/by-label/slate-crypt \
  --header-backup-file "$backup/slate-luks2-header.img"
sudo chmod 0600 "$backup/sbctl-private-keys.tar" "$backup/slate-luks2-header.img"
sudo sbctl status
sudo sbctl verify
```

`sbctl verify` must show the fallback/systemd bootloaders and `EFI/Linux/nixos-generation-*.efi` as signed. Lanzaboote's separate `EFI/nixos/kernel-*` payload can be reported as unsigned; upstream documents this as expected. Do not disable signature enforcement to suppress that diagnostic.

Protect the backup device with encryption and keep a separate readable recovery copy. A LUKS header backup contains keyslot material; retain its matching passphrase and refresh it after intentional keyslot changes. Lost passphrases plus unusable header/recovery backups mean lost data. Lost signing keys prevent signing future boot generations with the enrolled owner key. Keep the live/recovery USB: it may require temporarily disabling Secure Boot to boot again.

Enroll manually only after the installed boot files verify and the firmware-variable backups are safe:

1. In ThinkPad firmware, open **Security → Secure Boot → Reset to Setup Mode**, the upstream-documented owner-key enrollment path. Preserve KEK, db and especially **dbx**; do not select **Clear All Secure Boot Keys**. If that exact Setup Mode label is absent, consult the firmware documentation for its custom/owner-key procedure: where supported, remove **only the Platform Key (PK)**. Do not guess. If the firmware cannot enter Setup Mode without clearing the databases, stop and establish a documented restore path first.
2. Boot installed Slate with Secure Boot still disabled. Confirm `sudo sbctl status` reports Setup Mode. Inspect `sudo sbctl list-enrolled-keys` and compare the retained trust databases with your backups.
3. Append owner keys while retaining existing trust and including Microsoft's and the firmware's built-in db/KEK certificates:

   ```sh
   sudo sbctl enroll-keys --append --microsoft --firmware-builtin=db,KEK
   sudo sbctl list-enrolled-keys
   sudo sbctl verify
   ```

   `--append` preserves existing KEK/db trust; `--microsoft` and `--firmware-builtin=db,KEK` also retain required Microsoft/vendor boot and option-ROM trust. This command does not replace **dbx**. If the firmware's default certificates are unavailable, required vendor trust is missing, or sbctl warns about option ROMs, stop and resolve the trust chain from the firmware documentation/backups. Do not bypass the warning with force/bricking flags, and do not add TPM/event-log enrollment.
4. Re-enable Secure Boot in firmware, boot Slate again, and confirm `sudo sbctl status` reports Secure Boot enabled and Setup Mode disabled. Set a firmware administrator/supervisor password according to your work policy so an untrusted person cannot simply disable Secure Boot; keep that password in your recovery records. Keep the LUKS passphrase: enabling Secure Boot does not change encryption unlock.

Lanzaboote signs subsequent `nixos-rebuild` boot installations using `/var/lib/sbctl`. Do not delete or relocate that directory, publish it, add it to the flake, or bake it into an ISO. Firmware updates or resets can alter Secure Boot settings; recheck status and retained trust afterward. Firmware and dbx revocation updates can require manual intervention or newly signed recovery media; never discard dbx to make an old image boot.

## Firmware, suspend and hardware checks

The hardware evidence comes from working Ubuntu with a 7.3 kernel: `xe` GPU, `iwlwifi`, `btintel_pcie`, SOF Panther Lake audio including microphone, USB Chicony camera `04f2:b87c`, Synaptics I2C touchpad, I2C touchscreen and Elan TrackPoint. The camera is **USB, not IPU7**. No speculative camera stack, PS/2 quirks, driver force-probe parameters or deep-sleep override are added. Slate and Frost use the shared current `linuxPackages_latest` kernel selection.

Only **s2idle** was exposed by the firmware. Closing the undocked lid requests suspend (also on AC); docked lid closure is ignored. The shared Hyprland/hypridle lock/resume configuration remains in use. **Suspend/resume and the firmware-update problem observed on Ubuntu are unresolved, not fixed by this configuration.** Test suspend/resume on AC and battery, lid/dock behavior, display, Wi-Fi/Bluetooth, audio/microphone, camera and input devices before relying on them. Shut down before putting the laptop in a bag until suspend is proven reliable.

From the installed system, with AC connected and recovery backups available:

```sh
fwupdmgr get-devices
sudo fwupdmgr refresh
fwupdmgr get-updates
sudo fwupdmgr update
```

The mounted writable ESP and fwupd/Lanzaboote integration support the normal update path; they do not guarantee that Lenovo offers an update or that a firmware/capsule defect is resolved. Follow each update's instructions and recheck Secure Boot and suspend afterward. `journalctl`, `lspci -nnk`, `lsusb`, `vainfo`, `aplay -l`, `arecord -l` and `nvme list` are available on the live image for diagnosis. Do not apply unverified power or driver workarounds simply to hide failures.
