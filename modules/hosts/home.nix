# General Home-manager configuration

{ config, lib, pkgs, user, ... }:

{
  imports = [
    (import ../../imports/udiskie.nix)
    (import ../../imports/direnv.nix)
    (import ../../imports/ssh.nix)
    (import ../../imports/git.nix)
    (import ../../imports/zsh.nix)
    (import ../../imports/exa.nix)
    (import ../../imports/tmux.nix)
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [ jq btop ranger tmux pinta unzip zip unrar jujutsu ];
    stateVersion = "22.11";
  };

  programs = { home-manager.enable = true; };
}

