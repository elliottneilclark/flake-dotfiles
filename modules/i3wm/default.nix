#
# i3wm
#
{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager = {
      defaultSession = "xfce+i3";

      lightdm = {
        enable = true; # Wallpaper and GTK theme
        background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
        greeters = {
          gtk = {
            theme = {
              name = "Dracula";
              package = pkgs.dracula-theme;
            };
            cursorTheme = {
              name = "Dracula-cursors";
              package = pkgs.dracula-theme;
              size = 16;
            };
          };
        };
      };

    };
    windowManager.i3.enable = true;
  };
}
