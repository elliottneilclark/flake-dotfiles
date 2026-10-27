# Build with nix build .#frost-iso, then write result/iso/*.iso to the whole USB device.
# UEFI USB boot requires its EFI (FAT) partition; check with lsblk -f after flashing.
# Boot it on Frost to check the hardware before installing to the NVMe.
# The live system uses RAM/USB mounts only; it does not mount the internal EFI partition.
# Guest login: elliott / frost-live.
# After cloning the repo: sudo bash ./install-frost.sh (--check validates targets only).
# Installation erases Ubuntu root, preserves EFI, and sets only elliott's password.
{ config, lib, pkgs, ... }:

{
  networking.hostName = lib.mkForce "frost-live";

  # The bare ISO module defaults to BIOS CD boot, not UEFI USB boot.
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  # Keep all physical NVMe mounts and swap out of the live system.
  fileSystems = lib.mkForce config.lib.isoFileSystems;
  swapDevices = lib.mkForce [ ];

  # The installer needs mkfs.ext4 without fetching tools at installation time.
  environment.systemPackages = [ pkgs.e2fsprogs ];

  home-manager.users.elliott = {
    # No private SSH keys are copied onto this disposable medium.
    programs.keychain.enable = lib.mkForce false;
  };

  # Disposable credentials only; the installed system keeps mutable users.
  users.mutableUsers = lib.mkForce false;
  users.users.elliott = {
    password = lib.mkForce "frost-live";
    openssh.authorizedKeys.keys = lib.mkForce [ ];
  };
}
