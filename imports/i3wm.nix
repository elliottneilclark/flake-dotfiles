{ config, lib, pkgs, ... }:
let
  mod = "Mod4";
in
{
  config = {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;
        terminal = "alacritty";
        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 12.0;
        };

        colors.focused = {
          background = "#999999";
          border = "#999999";
          childBorder = "#999999";
          indicator = "#212121";
          text = "#999999";
        };

        window = {
          titlebar = false;
          hideEdgeBorders = "none";
        };
        floating.criteria = [{ class = "Pavucontrol"; }];

        startup = [
          { command = "systemctl --user restart polybar"; always = true; notification = false; }
          { command = "autotiling -w 2 3 4 5 6 7 8 9"; always = true; notification = false; }
          {
            command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            always = true;
            notification = false;
          }
        ];

        # bars = [ ];

        defaultWorkspace = "workspace number 1";

        gaps = {
          inner = 8;
          outer = 10;
          smartBorders = "off";
          smartGaps = false;
        };

        focus = {
          followMouse = false;
        };
      };
    };
    home.packages = with pkgs; [
      autotiling
      i3lock-fancy
    ];
  };
}
