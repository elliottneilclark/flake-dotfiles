#
# Compositor
#

{ config, lib, pkgs, ... }:

{
  config = {
    services.picom = {
      enable = true;

      backend = "glx";
      vSync = true;

      activeOpacity = 0.97; # Node transparency
      inactiveOpacity = 0.93;

      shadow = false; # Shadows

      settings = {
        daemon = true;
        use-damage = false; # Fixes flickering and visual bugs with borders
        resize-damage = 1;
        refresh-rate = 0;
        corner-radius = 5; # Corners
        round-borders = 5;

        # Extras
        detect-rounded-corners = true; # Below should fix multiple issues
        detect-client-opacity = false;
        detect-transient = true;
        detect-client-leader = false;
        mark-wmwim-focused = true;
        mark-ovredir-focues = true;
        unredir-if-possible = true;
        glx-no-stencil = true;
        glx-no-rebind-pixmap = true;
      };
    };
  };
}
