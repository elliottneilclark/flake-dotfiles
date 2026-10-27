# Frost: AMD Raphael desktop, NVMe Linux root and its existing EFI partition.
{ config, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/535023a7-e902-40f9-942c-56a84d634030";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/F257-C5CD";
      fsType = "vfat";
    };

  # NixOS creates the swap file on first boot when it is missing or not 8192 MiB.
  swapDevices = [{ device = "/swap.img"; size = 8192; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
