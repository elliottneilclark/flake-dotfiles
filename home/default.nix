{ self, ... }:
{
  flake = {
    homeModules = {
      common = {
        imports = [
          ./mutability.nix
          ./git.nix
          ./eza.nix
          ./zsh.nix
          ./direnv.nix
          ./jj.nix
          ./ssh.nix
          ./neovim.nix
          ./tmux.nix
          ./btop.nix
          ./tools.nix
        ];
      };
      common-linux = {
        imports = [
          self.homeModules.common
          ./gaming.nix
          ./udiskie.nix
          ./woeusb.nix
          ./firefox.nix
          ./alacritty.nix
          ./vscode.nix
          ./desktop-env.nix
          ./easyeffects.nix
          ./picom.nix
          ./i3wm.nix
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
