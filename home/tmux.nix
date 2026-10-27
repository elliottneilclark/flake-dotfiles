{ pkgs, lib, ... }:

let
  clipboardCommand =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "/usr/bin/pbcopy"
    else
      "${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
in
{
  config = {
    home.packages = lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.wl-clipboard;
    programs.tmux = {
      enable = true;

      baseIndex = 1;

      shortcut = "b";
      keyMode = "vi";

      mouse = true;

      clock24 = true;
      terminal = "screen-256color";

      historyLimit = 5000;

      extraConfig = ''
        set-option -ga update-environment " WAYLAND_DISPLAY XDG_RUNTIME_DIR"
        bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "${clipboardCommand}"
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${clipboardCommand}"
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "${clipboardCommand}"

        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';

      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.resurrect
        tmuxPlugins.continuum
      ];
    };
  };
}
