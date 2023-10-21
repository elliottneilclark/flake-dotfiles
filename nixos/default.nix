{ self, config, ... }:

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

      my-home = {
        users.users.elliott.isNormalUser = true;
        home-manager.users.elliott = {
          imports = [
            self.homeModules.common-linux
          ];
        };
      };

      default.imports = [
        self.nixosModules.my-home
        self.nixosModules.common
        ./users.nix
        ./fonts.nix
        ./ssh.nix
        ./thunar.nix
        ./printing.nix
      ];
    };
  };
}
