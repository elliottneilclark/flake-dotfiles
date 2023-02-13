#
# Terminal Emulator
#
# Hardcoded as terminal for rofi and doom emacs
#

{ pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = rec {
          normal.family = "FiraCode Nerd Font";
          bold = { style = "Bold"; };
        };
      };
    };
  };
}
