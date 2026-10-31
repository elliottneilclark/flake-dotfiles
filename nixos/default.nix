{ self, ... }:
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      common = { pkgs, ... }: {
        imports = [
          ./nix.nix
          ./environment.nix
        ];
        boot.kernelPackages = pkgs.linuxPackages_latest;
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
