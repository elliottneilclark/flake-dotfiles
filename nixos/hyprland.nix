{ config, lib, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # No --sessions: the bare hyprland.desktop entry would start outside UWSM and
  # never reach graphical-session.target, so only the UWSM command is offered.
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session.command = lib.concatStringsSep " " [
      (lib.getExe pkgs.tuigreet)
      "--time --remember"
      "--cmd '${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland.desktop'"
    ];
  };

  # The native Hyprland module supplies both the Hyprland and GTK portals.
  xdg.portal.config.hyprland = {
    default = [ "hyprland" "gtk" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
  };

  # greetd includes login's PAM stack, which the keyring module configures.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprlock = { };
  programs.seahorse.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
