{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme.name = "Nordic";
    theme.package = pkgs.nordic;
    font = { name = "FiraCode Nerd Font"; };

    iconTheme = {
      name = "Nordzy";
      package = pkgs.nordzy-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  # UWSM's preloader is a systemd unit that sources only /etc/profile and
  # ~/.profile, so home-manager's session variables never reach the session
  # unless this file hands them over.
  xdg.configFile."uwsm/env".text = ''
    . ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
  '';

  home = {
    pointerCursor = {
      enable = true;
      name = "Nordzy-white-cursors";
      package = pkgs.nordzy-cursor-theme;
      size = 24;
      gtk.enable = true;
    };
    sessionVariables = {
      GTK_THEME = "Nordic";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };
    packages = with pkgs; [
      imv # Native Wayland image viewer
      pavucontrol # Audio Control
      google-chrome # Browser
      slack
      spotify
      discord
      signal-desktop
      usbutils

      nordic
      nordzy-icon-theme
      nordzy-cursor-theme

      gimp
      pinta
    ];
  };
}
