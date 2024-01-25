{ self, inputs, system, ... }:

let
  inherit (inputs) agenix;
  inherit inputs;
in
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      common = {
        imports = [
          agenix.nixosModules.age
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
            agenix.homeManagerModules.default
          ];
        };
      };

      default = {
        imports = [
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
          ./sound.nix
          ./docker.nix

          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
        system = {
          autoUpgrade = {
            enable = false;
          };
          stateVersion = "23.11";
        };
      };
    };
  };
}
