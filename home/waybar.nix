{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";
      position = "bottom";
      height = 32;
      spacing = 12;
      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "mpris" "pulseaudio" "network" "bluetooth" "tray" "custom/session" ];
      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{name}";
        persistent-workspaces."*" = [ 1 2 3 4 5 6 7 8 9 10 ];
      };
      "hyprland/window".max-length = 36;
      clock = {
        format = "{:%a %b %d  %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };
      mpris = {
        format = "{status_icon} {title}";
        status-icons = { playing = "▶"; paused = "Ⅱ"; stopped = "■"; };
        max-length = 24;
        tooltip-format = "{artist} — {title}\nClick: play/pause; right: next; middle: previous";
      };
      pulseaudio = {
        format = "Vol {volume}%";
        format-muted = "Muted";
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip-format = "{desc}\nClick: audio control; right: mute; scroll: volume";
      };
      network = {
        format-wifi = "Wi-Fi {essid}";
        format-ethernet = "LAN";
        format-disconnected = "Offline";
        tooltip-format = "{ifname}: {ipaddr}\nNetwork connections: click or use tray";
        on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };
      bluetooth = {
        format = "BT {status}";
        format-connected = "BT {num_connections}";
        on-click = "${pkgs.blueman}/bin/blueman-manager";
      };
      tray = { icon-size = 18; spacing = 8; };
      "custom/session" = {
        format = "Session";
        tooltip-format = "Click: lock, suspend, logout, reboot, shutdown\nSuper+Ctrl+L: lock\nSuper+Shift+E: session menu\nPrint: area screenshot; Shift+Print: desktop\nSuper+Enter: terminal; Super+Shift+Enter: browser\nSuper+D: launcher; Super+E: files\nSuper+H/J/K/L: focus; +Shift: move\nSuper+1–0: workspace; +Shift: move window\nSuper+F: fullscreen; Super+Shift+Space: float\nSuper+Shift+Q: close; Super+mouse: move/resize\nMedia keys: volume, microphone, playback, brightness";
        on-click = "desktop-session-menu";
      };
    };
    style = ''
      * {
        font-family: "FiraCode Nerd Font";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }
      window#waybar { background: #2e3440; color: #eceff4; }
      #workspaces button { padding: 0 8px; color: #d8dee9; }
      #workspaces button.active { background: #434c5e; color: #88c0d0; }
      #workspaces button.urgent { background: #bf616a; }
      #workspaces button:hover { background: #3b4252; }
      #window { color: #d8dee9; }
      #custom-session { padding-right: 12px; color: #88c0d0; }
      #pulseaudio.muted, #network.disconnected { color: #ebcb8b; }
      tooltip { background: #3b4252; border: 1px solid #88c0d0; }
      tooltip label { color: #eceff4; }
    '';
  };
}
