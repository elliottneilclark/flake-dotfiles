# Terminal Emulator

{ ... }:

{
  programs = {
    alacritty = {
      enable = true;
      theme = "nord";
      settings = {
        font = {
          normal.family = "FiraCode Nerd Font";
          bold.family = "FiraCode Nerd Font";
          italic.family = "FiraCode Nerd Font";
          bold_italic.family = "FiraCode Nerd Font";
          size = 14;
        };
      };
    };
  };
}
