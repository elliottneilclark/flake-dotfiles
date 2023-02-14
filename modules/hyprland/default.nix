#
#  Hyprland configuration
#

{ user, config, lib, pkgs, host, ... }:

{
  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] &&  [ "$tty" = "/dev/tty1" ]; then
        Hyprland
      fi
    '';

    variables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
    };
    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";

      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };
  };

  environment.systemPackages = with pkgs; [
    grim
    mpvpaper
    slurp
    swappy
    swaylock
    wl-clipboard
    wlr-randr
  ];

  services.dbus.enable = true;

  security.pam.services.swaylock = {
    text = "auth  include  login";
  };

  programs = {
    hyprland = {
      enable = true;
      nvidiaPatches = true;
    };
  };
}
