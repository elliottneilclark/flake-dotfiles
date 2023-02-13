
#
#  Specific system configuration settings for desktop

{ pkgs, lib, user, ... }:

{
  imports = [(import ./hardware-configuration.nix)];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  security.polkit.enable = true;
  security.rtkit.enable = true;
  
  # Configure keymap in X11
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    layout = "us";
    xkbVariant = "";
  };

  networking.hostName = "anton";
}
