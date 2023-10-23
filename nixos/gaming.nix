# Gaming
#

{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.prismlauncher pkgs.jdk8 pkgs.jdk ];

  programs = {
    steam = { enable = true; };
    gamemode.enable = true;
  };

}
