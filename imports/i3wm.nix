{ config, lib, pkgs, ... }:
let
  mod = "Mod4";
in
{
  config = {

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          theme = "nord-dark";
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

        window = {
          titlebar = false;
          hideEdgeBorders = "none";
        };

        floating.criteria = [
          { class = "Pavucontrol"; }
          { title = "Steam - Update News"; }
          { title = "Steam Keyboard"; }
        ];

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

        keybindings = lib.mkOptionDefault {
          # vim style navigation
          "${mod}+j" = "focus down";
          "${mod}+h" = "focus left";
          "${mod}+l" = "focus right";
          "${mod}+k" = "focus up";

          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+k" = "move up";

          "${mod}+d" = "exec dmenu_run";
          "${mod}+Return" = "exec alacritty";
          "${mod}+Shift+Return" = "exec firefox";
        };

        bars = [{
          position = "bottom";
          statusCommand =
            "i3status-rs $HOME/.config/i3status-rust/config-default.toml";
        }];

        defaultWorkspace = "workspace number 1";

        gaps = {
          inner = 6;
          outer = 8;
          smartBorders = "off";
          smartGaps = false;
        };

        focus = { followMouse = false; };
      };
    };

    home.packages = with pkgs; [ autotiling i3lock ];
    services.blueman-applet.enable = true;
  };
}
