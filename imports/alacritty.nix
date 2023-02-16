# Terminal Emulator

{ pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = rec {
          normal.family = "JetBrainsMono Nerd Font";
          size = 12;
        };
      };
    };
  };
}
