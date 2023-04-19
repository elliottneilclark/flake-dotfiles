# Terminal Emulator

{ pkgs, ... }:

let
  catppuccin-alacritty = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    rev = "3c808cbb4f9c87be43ba5241bc57373c793d2f17";
    sha256 = "07gvkxz9axvjjplpmwf6k0nk6n84gm20s0k5qkqsqkmv8ysdbmf3";
  };
in
{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        import = [ "${catppuccin-alacritty}/catppuccin-mocha.yml" ];
        font = {
          normal.family = "JetBrainsMono Nerd Font";
          bold.family = "JetBrainsMono Nerd Font";
          italic.family = "JetBrainsMono Nerd Font";
          bold_italic.family = "JetBrainsMono Nerd Font";
          size = 14;
        };
      };
    };
  };
}
