# Terminal Emulator

{ pkgs, ... }:

let
  catppuccin-alacritty = pkgs.fetchFromGitHub {
    owner = "nordtheme";
    repo = "alacritty";
    rev = "9949642f3903e8fcb62bfc03f09410e3d78440c2";
    sha256 = "GYx3DpUgl9ljccASIoLKRDovX+LCC8MKFNUy0TK7rD4=";
  };
in
{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        import = [ "${catppuccin-alacritty}/src/nord.yml" ];
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
