# ThinkPad T14 Gen 7 Intel (21WN00BUUS): whole-disk LUKS2 installation.
{ config, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "xe" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.luks.devices.cryptroot.device = "/dev/disk/by-label/slate-crypt";

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "ext4";
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/SLATE-EFI";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
