#
#  Hyprland Home-manager configuration
#

{ user, config, lib, pkgs, host, ... }:

{

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  programs.swaylock.settings = {
    #image = "$HOME/.config/wall";
    color = "000000f0";
    font-size = "24";
    indicator-idle-visible = false;
    indicator-radius = 100;
    indicator-thickness = 20;
    inside-color = "00000000";
    inside-clear-color = "00000000";
    inside-ver-color = "00000000";
    inside-wrong-color = "00000000";
    key-hl-color = "79b360";
    line-color = "000000f0";
    line-clear-color = "000000f0";
    line-ver-color = "000000f0";
    line-wrong-color = "000000f0";
    ring-color = "ffffff50";
    ring-clear-color = "bbbbbb50";
    ring-ver-color = "bbbbbb50";
    ring-wrong-color = "b3606050";
    text-color = "ffffff";
    text-ver-color = "ffffff";
    text-wrong-color = "ffffff";
    show-failed-attempts = true;
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { event = "lock"; command = "lock"; }
    ];
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
    systemdTarget = "xdg-desktop-portal-hyprland.service";
  };
}
