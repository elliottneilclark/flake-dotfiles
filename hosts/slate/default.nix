# ThinkPad T14 Gen 7 Intel, Core Ultra 7 365 (Panther Lake).
{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  image.modules.iso = ./image.nix;

  networking.hostName = "slate";
  networking.networkmanager.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 5;
  };
  boot.tmp.cleanOnBoot = true;

  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.sof-firmware ];
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.intel-media-driver ];
      extraPackages32 = [ pkgs.pkgsi686Linux.intel-media-driver ];
    };
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  security.rtkit.enable = true;
  users.users.root.hashedPassword = lib.mkForce "!";
  services = {
    openssh.enable = lib.mkForce false;
    blueman.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "ignore";
    };
  };
  zramSwap.enable = true;

  environment.systemPackages = [ pkgs.sbctl ];

  home-manager.users.elliott.programs.waybar.settings.main = {
    modules-right = lib.mkBefore [ "battery" "power-profiles-daemon" ];
    battery = {
      format = "Battery {capacity}%";
      format-charging = "Charging {capacity}%";
      states = { warning = 20; critical = 10; };
      tooltip-format = "{timeTo} ({power:.1f} W)";
    };
    power-profiles-daemon.format = "Power {profile}";
  };
}
