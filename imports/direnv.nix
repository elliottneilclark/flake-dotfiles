{ config, lib, pkgs, user, ... }:

{

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
