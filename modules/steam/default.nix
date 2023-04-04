# Gaming
#

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.prismlauncher pkgs.jdk8 pkgs.jdk ];

  programs = {
    steam = { enable = true; };
    gamemode.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
    ];
}
