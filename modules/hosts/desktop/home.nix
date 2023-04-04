# Home-manager configuration for desktop

{ pkgs, ... }:

{
  imports = [
    (import ../../../imports/alacritty.nix)
    (import ../../../imports/picom.nix)
    (import ../../../imports/i3wm.nix)
    (import ../../../imports/random-background.nix)
    (import ../../../imports/vscode.nix)
    (import ../../../imports/neovim.nix)
    (import ../../../imports/firefox.nix)
  ];

  home = {
    packages = with pkgs; [
      feh # Image Viewer
      pavucontrol # Audio Control
      google-chrome # Browser
      slack
      spotify
      signal-desktop
      pavucontrol
    ];
    pointerCursor = {
      gtk.enable = true;
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = { name = "JetBrainsMono Nerd Font"; };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
