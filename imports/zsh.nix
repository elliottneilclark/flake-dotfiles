

{ user, config, lib, pkgs, host, ... }:

{
  programs = {
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" "kubectl" ];
      };

      shellAliases = { ".." = "cd .."; };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
