{ self, ... }:

{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      common = {
        imports = [
          ./nix.nix
          ./environment.nix
        ];
      };

      linux-home = {
        users.users.elliott.isNormalUser = true;
        home-manager.users.elliott = {
          home.stateVersion = "23.11";
          imports = [
            self.homeModules.common-linux
          ];
        };
      };

      default.imports = [
        self.nixosModules.home-manager
        self.nixosModules.linux-home
        self.nixosModules.common
        ./users.nix
        ./fonts.nix
        ./ssh.nix
        ./thunar.nix
        ./printing.nix
        ./gaming.nix
        ./i3wm.nix
        # ./sound.nix
      ];
    };
  };
}
