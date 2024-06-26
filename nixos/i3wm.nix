# i3wm
#
{ pkgs, ... }:

{
  xdg.portal = { enable = true; extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; };
  services.displayManager.defaultSession = "none+i3";

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
      lightdm = {
        enable = true; # Wallpaper and GTK theme
        background =
          pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
        greeters = {


          gtk = {
            theme = {
              name = "Nordic";
              package = pkgs.nordic;
            };

            cursorTheme = {
              name = "Nordzy-white-cursors";
              package = pkgs.nordzy-cursor-theme;
            };
          };
        };
      };

    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
      ];
    };
  };

  # Keys
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  environment.systemPackages = with pkgs; [ lxappearance ];
}
