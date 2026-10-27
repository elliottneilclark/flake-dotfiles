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
          ./mise.nix
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
          ./hyprland.nix
        ];
      };
      common-darwin = {
        imports = [
          self.homeModules.common
        ];
        home.sessionPath = [
          "/etc/profiles/per-user/$USER/bin"
          "/nix/var/nix/profiles/system/sw/bin"
          "/usr/local/bin"
        ];
      };
    };
  };
}
