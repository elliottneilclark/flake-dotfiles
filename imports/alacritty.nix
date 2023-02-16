# Terminal Emulator

{ pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = rec {
          normal.family = "JetBrainsMono Nerd Font";
          size = 14;
        };
        offset = {
          x = -1;
          y = 0;
        };
      };
    };
  };
}
