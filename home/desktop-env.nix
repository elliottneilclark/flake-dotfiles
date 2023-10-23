{ pkgs, ... }:

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

    cursorTheme = {
      name = "Nordzy-white-cursors";
      package = pkgs.nordzy-cursor-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home = {
    sessionVariables.GTK_THEME = "Nordic";
    packages = with pkgs; [
      feh # Image Viewer
      pavucontrol # Audio Control
      google-chrome # Browser
      slack
      spotify
      discord
      signal-desktop
      pavucontrol
      easyeffects

      nordic
      nordzy-icon-theme
      nordzy-cursor-theme

      gimp
      pinta
    ];
  };
}
