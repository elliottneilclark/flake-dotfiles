{ self, inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        imports = [
          ./git.nix
          ./eza.nix
          ./alacritty.nix
          ./zsh.nix
          ./direnv.nix
          ./jj.nix
          ./ssh.nix
          ./neovim.nix
          ./tmux.nix
          ./btop.nix
          (import ./tools.nix inputs)
        ];
        home.sessionVariables.OTTR_ACCEPT_ANDROID_LICENSE = "1";
        home.sessionVariables.OTTR_ACCEPT_CHROME_LICENSE = "1";
      };
      common-linux = {
        imports = [
          self.homeModules.common
          ./gaming.nix
          ./udiskie.nix
          ./woeusb.nix
          ./firefox.nix
          ./vscode.nix
          ./desktop-env.nix
          ./easyeffects.nix
          ./hyprland.nix
        ];
      };
      common-darwin = { pkgs, ... }: {
        imports = [
          self.homeModules.common
        ];
        programs.alacritty.settings.env.TERMINFO = "${pkgs.alacritty.terminfo}/share/terminfo";
        home.sessionPath = [
          "/etc/profiles/per-user/$USER/bin"
          "/nix/var/nix/profiles/system/sw/bin"
          "/usr/local/bin"
        ];
      };
    };
  };
}
