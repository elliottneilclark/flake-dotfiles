#

{ lib, inputs, nixpkgs, home-manager, user, location, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  desktop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs user location;
    };
    modules = [
      ../neovim
      ../zsh
      ../docker
      ../kde
      ../defaults

      # Add the per host specific modules
      ./desktop
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
	home-manager.extraSpecialArgs = {
          inherit user;
        };
	home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./desktop/home.nix)];
        };
      }
    ];
  };
}
