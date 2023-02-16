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
    xkbVariant = "";
  };

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };
  };

  networking.hostName = "anton";
}
