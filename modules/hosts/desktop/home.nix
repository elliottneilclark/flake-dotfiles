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
    (import ../../../imports/woeusb.nix)
  ];

  home = {
    packages = with pkgs; [
      feh # Image Viewer
      pavucontrol # Audio Control
      google-chrome # Browser
      slack
      spotify
      discord
      signal-desktop
      pavucontrol
      easyeffects
    ];
    pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaPink;
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };
  };


  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "standard";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "pink";
        flavor = "mocha";
      };
      name = "Papirus-Dark";
    };
    font = { name = "JetBrainsMono Nerd Font"; };
  };
}
