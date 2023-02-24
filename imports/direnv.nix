{ config, lib, pkgs, user, ... }:

{
  services.lorri.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
