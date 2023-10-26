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
          ./tools.nix
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
          ./vscode.nix
          ./desktop-env.nix
          ./easyeffects.nix
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
