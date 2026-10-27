{ lib, pkgs, osConfig, ... }:
let
  sessionMenu = pkgs.writeShellApplication {
    name = "desktop-session-menu";
    runtimeInputs = [ pkgs.fuzzel pkgs.systemd pkgs.uwsm ];
    text = ''
      choice=$(printf '%s\n' Lock Suspend Logout Reboot Shutdown | fuzzel --dmenu --prompt 'Session: ')
      case "$choice" in
        Lock) loginctl lock-session ;;
        Suspend) systemctl suspend ;;
        Logout) uwsm stop ;;
        Reboot) systemctl reboot ;;
        Shutdown) systemctl poweroff ;;
      esac
    '';
  };
  screenshot = pkgs.writeShellApplication {
    name = "desktop-screenshot";
    runtimeInputs = [ pkgs.grim pkgs.slurp pkgs.wl-clipboard pkgs.libnotify ];
    text = ''
      if [[ "''${1:-area}" == full ]]; then
        grim - | wl-copy --type image/png
      else
        geometry=$(slurp)
        grim -g "$geometry" - | wl-copy --type image/png
      fi
      notify-send 'Screenshot copied' 'Paste the image from the clipboard.'
    '';
  };
  lock = "${pkgs.systemd}/bin/loginctl lock-session";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in
{
  imports = [ ./waybar.nix ];

  # UWSM owns environment propagation and the graphical-session lifecycle.
  wayland.systemd.target = "graphical-session.target";
  # This controls applet protocol only; it does not enable an X session.
  xsession.preferStatusNotifierItems = true;
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    configType = "lua";
    settings = {
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      };
      config = {
        general = {
          gaps_in = 6;
          gaps_out = 8;
          border_size = 2;
          layout = "dwindle";
          resize_on_border = true;
          col = {
            active_border = "rgb(88c0d0)";
            inactive_border = "rgb(4c566a)";
          };
        };
        decoration = {
          rounding = 5;
          blur.enabled = false;
          shadow.enabled = false;
        };
        dwindle.preserve_split = true;
        input = {
          kb_layout = "us";
          follow_mouse = 0;
          touchpad.natural_scroll = true;
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          background_color = "rgb(2e3440)";
        };
      };
      window_rule = [
        { name = "float-audio-control"; match.class = "org.pulseaudio.pavucontrol"; float = true; }
        { name = "float-steam-news"; match.title = "Steam - Update News"; float = true; }
        { name = "float-steam-keyboard"; match.title = "Steam Keyboard"; float = true; }
      ];
    };
    extraConfig = ''
      hl.bind("SUPER + Return", hl.dsp.exec_cmd("${pkgs.uwsm}/bin/uwsm app -- ${pkgs.alacritty}/bin/alacritty"), { description = "Open terminal" })
      hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("${pkgs.uwsm}/bin/uwsm app -- ${pkgs.firefox}/bin/firefox"), { description = "Open browser" })
      hl.bind("SUPER + D", hl.dsp.exec_cmd("${pkgs.fuzzel}/bin/fuzzel"), { description = "Launch application" })
      hl.bind("SUPER + E", hl.dsp.exec_cmd("${pkgs.uwsm}/bin/uwsm app -- ${osConfig.programs.thunar.finalPackage}/bin/thunar"), { description = "Open file manager" })
      hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close(), { description = "Close window" })
      hl.bind("SUPER + F", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })
      hl.bind("SUPER + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
      hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("${lock}"), { description = "Lock screen" })
      hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("${lib.getExe sessionMenu}"), { description = "Session menu: lock, suspend, logout, power" })
      hl.bind("Print", hl.dsp.exec_cmd("${lib.getExe screenshot}"), { description = "Copy selected area screenshot" })
      hl.bind("SHIFT + Print", hl.dsp.exec_cmd("${lib.getExe screenshot} full"), { description = "Copy full desktop screenshot" })
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

      for key, direction in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
        hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }), { description = "Focus " .. direction })
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }), { description = "Move window " .. direction })
      end
      for workspace = 1, 10 do
        local key = workspace % 10
        hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }), { description = "Workspace " .. workspace })
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }), { description = "Move to workspace " .. workspace })
      end

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true, description = "Volume up" })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true, description = "Volume down" })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, description = "Mute speakers" })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, description = "Mute microphone" })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl play-pause"), { locked = true, description = "Play/pause media" })
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl play-pause"), { locked = true, description = "Play/pause media" })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl next"), { locked = true, description = "Next track" })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${pkgs.playerctl}/bin/playerctl previous"), { locked = true, description = "Previous track" })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${pkgs.brightnessctl}/bin/brightnessctl set 5%+"), { locked = true, repeating = true, description = "Brightness up" })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${pkgs.brightnessctl}/bin/brightnessctl set 5%-"), { locked = true, repeating = true, description = "Brightness down" })
    '';
  };

  home.packages = with pkgs; [ wl-clipboard grim slurp playerctl brightnessctl libnotify sessionMenu screenshot ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font:size=12";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        launch-prefix = "${pkgs.uwsm}/bin/uwsm app --";
        layer = "overlay";
      };
      colors = {
        background = "2e3440ff";
        text = "eceff4ff";
        match = "88c0d0ff";
        selection = "434c5eff";
        selection-text = "eceff4ff";
        selection-match = "8fbcbbff";
        border = "88c0d0ff";
      };
      border.radius = 5;
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = { hide_cursor = true; ignore_empty_input = true; };
      background = [{ color = "rgb(2e3440)"; }];
      input-field = [{
        size = "300, 60";
        position = "0, -60";
        dots_center = true;
        fade_on_empty = false;
        inner_color = "rgb(3b4252)";
        outer_color = "rgb(88c0d0)";
        font_color = "rgb(eceff4)";
        font_family = "FiraCode Nerd Font";
        placeholder_text = "Password";
      }];
      label = [{
        text = "Locked — $USER";
        color = "rgb(eceff4)";
        font_family = "FiraCode Nerd Font";
        font_size = 22;
        position = "0, 60";
      }];
    };
  };

  services = {
    hyprpolkitagent.enable = true;
    network-manager-applet.enable = true;
    blueman-applet.enable = true;
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${lib.getExe pkgs.hyprlock}";
          before_sleep_cmd = lock;
          after_sleep_cmd = "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
          inhibit_sleep = 3;
        };
        listener = [
          { timeout = 300; on-timeout = lock; }
          {
            timeout = 600;
            on-timeout = "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
            on-resume = "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
          }
        ];
      };
    };
    dunst = {
      enable = true;
      iconTheme = { name = "Nordzy"; package = pkgs.nordzy-icon-theme; };
      settings = {
        global = {
          font = "FiraCode Nerd Font 11";
          corner_radius = 5;
          frame_color = "#88c0d0";
          frame_width = 2;
          origin = "top-right";
          offset = "(12, 12)";
        };
        urgency_low = { background = "#2e3440"; foreground = "#d8dee9"; timeout = 5; };
        urgency_normal = { background = "#2e3440"; foreground = "#eceff4"; timeout = 8; };
        urgency_critical = { background = "#3b4252"; foreground = "#eceff4"; frame_color = "#bf616a"; timeout = 0; };
      };
    };
  };
  systemd.user.services.dunst.Install.WantedBy = [ "graphical-session.target" ];
  # Thunar is D-Bus activated from the unit NixOS ships; udiskie handles automounting.
}
