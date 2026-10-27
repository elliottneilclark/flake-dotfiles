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
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.elliott = {
            home.stateVersion = "26.11";
            imports = [
              self.homeModules.common-linux
            ];
          };
        };
      };

      default = {
        imports = [
          self.nixosModules.linux-home
          self.nixosModules.common
          ./users.nix
          ./fonts.nix
          ./ssh.nix
          ./thunar.nix
          ./printing.nix
          ./gaming.nix
          ./sound.nix
          ./docker.nix
          ./hyprland.nix
          ./oomd.nix

        ];
        system = {
          autoUpgrade = {
            enable = false;
          };
          stateVersion = "26.11";
        };
      };
    };
  };
}
