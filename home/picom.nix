# Compositor
#

{ config, ... }:

{
  config = {
    services.picom = {
      enable = true;

      backend = "glx";
      vSync = true;

      activeOpacity = 0.97; # Node transparency
      inactiveOpacity = 0.93;

      opacityRules = [
        "100:class_g = 'firefox'"
        "100:name *= 'Minecraft'"
      ];

      shadowExclude = [
        "window_type *= 'menu'"
        "name ~= 'Firefox$'"
        "focused = 1"
      ];

      shadow = false;
      shadowOpacity = 0.75;
      fade = true;
      fadeDelta = 10;

      settings = {
        daemon = true;
        use-damage = false; # Fixes flickering and visual bugs with borders
        resize-damage = 1;
        refresh-rate = 0;
        corner-radius = 5;
        round-borders = 5;

        transition-length = 300;
        transition-pow-x = 0.5;
        transition-pow-y = 0.5;
        transition-pow-w = 0.5;
        transition-pow-h = 0.5;
        size-transition = true;

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
