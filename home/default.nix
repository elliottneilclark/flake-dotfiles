{ self, ... }:
{
  flake = {
    homeModules = {
      common = {
        imports = [
          ./git.nix
          ./eza.nix
          ./zsh.nix
          ./direnv.nix
          ./jj.nix
          ./ssh.nix
          ./neovim.nix
          ./tmux.nix
          ./btop.nix
        ];
      };
      common-linux = {
        imports = [
          self.homeModules.common
          ./picom.nix
          ./i3wm.nix
          ./udiskie.nix
          ./woeusb.nix
          ./firefox.nix
          ./alacritty.nix
          ./steam.nix
        ];
      };
      common-darwin = {
        imports = [
          self.homeModules.common
        ];
      };
    };
  };
}
