#
# Zsh + Zsh Oh My
#

{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      histSize = 100000;

      ohMyZsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "kubectl" ];
	theme = "crunch";
      };

    };
  };
}
