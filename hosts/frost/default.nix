# Specific system configuration settings for desktop
{ pkgs, config, ... }:

{
  imports = [ (import ./hardware-configuration.nix) ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.systemd-boot.memtest86.enable = false;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.tmp.cleanOnBoot = true;

  # Needed for flatpack
  security.polkit.enable = true;
  security.rtkit.enable = true;

  security.tpm2 = {
    enable = true;
  };

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

  environment.systemPackages = with pkgs; [
    conda
  ];
  networking.networkmanager.enable = true;


  networking.hostName = "frost";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  console.useXkbConfig = true;
}
