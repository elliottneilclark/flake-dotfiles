# Specific system configuration settings for desktop
{ pkgs, lib, user, config, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ];

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
    dpi = 100;
  };
  services.blueman.enable = true;
  xdg.portal.enable = true;
  services.flatpak.enable = true;


  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };
    bluetooth.enable = true;
  };


  networking.hostName = "anton";
  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;
}
