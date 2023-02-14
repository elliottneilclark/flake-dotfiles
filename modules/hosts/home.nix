#
#  General Home-manager configuration

{ config, lib, pkgs, user, ... }:

{
  imports = [
    (import ../../imports/direnv.nix)
    (import ../../imports/git.nix)
    (import ../../imports/zsh.nix)
    (import ../../imports/alacritty.nix)
    (import ../../imports/picom.nix)
    (import ../../imports/i3wm.nix)
    (import ../../imports/random-background.nix)
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      btop
      ranger # File Manager
      tldr # Helper
      feh # Image Viewer
      pavucontrol # Audio Control
      firefox # Browser
      google-chrome # Browser
      slack
      spotify
      vscode
      pavucontrol
      tmux

      unzip
      zip
      unrar
    ];
    pointerCursor = {
      gtk.enable = true;
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
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
    font = {
      name = "FiraCode Nerd Font Mono Medium";
    };
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}

