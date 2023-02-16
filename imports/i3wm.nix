{ config, lib, pkgs, ... }:
let
  mod = "Mod4";
  colors = import ./colors.nix;
in {
  config = {

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          theme = "dracula";
          icons = "awesome5";
        };
      };
    };

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;
        terminal = "alacritty";
        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 14.0;
        };

        colors = with colors.scheme.dracula; {
          background = base07;
          focused = {
            background = base0D;
            border = base0D;
            childBorder = base0C;
            indicator = base0D;
            text = base00;
          };
          focusedInactive = {
            background = base01;
            border = base01;
            childBorder = base01;
            indicator = base03;
            text = base05;
          };
          placeholder = {
            background = base00;
            border = base00;
            childBorder = base00;
            indicator = base00;
            text = base05;
          };
          unfocused = {
            background = base00;
            border = base01;
            childBorder = base01;
            indicator = base01;
            text = base05;
          };
          urgent = {
            background = base08;
            border = base08;
            childBorder = base08;
            indicator = base08;
            text = base00;
          };
        };

        window = {
          titlebar = false;
          hideEdgeBorders = "none";
        };
        floating.criteria = [{ class = "Pavucontrol"; }];

        startup = [
          {
            command = "systemctl --user restart polybar";
            always = true;
            notification = false;
          }
          {
            command = "autotiling -w 2 3 4 5 6 7 8 9";
            always = true;
            notification = false;
          }
          {
            command =
              "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            always = true;
            notification = false;
          }
        ];

        bars = [{
          position = "bottom";
          statusCommand =
            "i3status-rs $HOME/.config/i3status-rust/config-default.toml";
        }];

        defaultWorkspace = "workspace number 1";

        gaps = {
          inner = 8;
          outer = 10;
          smartBorders = "off";
          smartGaps = false;
        };

        focus = { followMouse = false; };
      };
    };

    home.packages = with pkgs; [ autotiling i3lock-fancy ];
  };
}
