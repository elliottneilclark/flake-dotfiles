# General Home-manager configuration

{ pkgs, ... }:

{
  imports = [
    (import ../imports/udiskie.nix)
    (import ../imports/direnv.nix)
    (import ../imports/ssh.nix)
    (import ../imports/git.nix)
    (import ../imports/zsh.nix)
    (import ../imports/eza.nix)
    (import ../imports/tmux.nix)
    (import ../imports/jj.nix)
    (import ../imports/btop.nix)
  ];

  home = {
    username = "elliott";
    homeDirectory = "/home/elliott";
    packages = with pkgs; [ jq ranger tmux unzip zip unrar usbutils wget ];
    stateVersion = "23.05";
  };

  programs = { home-manager.enable = true; };
}
