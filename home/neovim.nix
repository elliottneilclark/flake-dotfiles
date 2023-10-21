{ config, pkgs, ... }:

{
  config = {

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; [
        # Defaults
        vim-sensible

        # Languages
        vim-elixir
        vim-nix

        # Left tree
        nvim-web-devicons
        nvim-tree-lua
      ];
    };

    home.packages = with pkgs; [ fd ripgrep ];
  };
}
