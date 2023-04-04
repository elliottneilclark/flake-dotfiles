{ lib, inputs, nixpkgs, home-manager, user, location, jj, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    overlays = [ jj.overlays.default ];
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  anton = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = { inherit inputs user location; };
    modules = [

      # These are the modules that always need to be there
      # They have some system setup
      ../neovim
      ../zsh
      ../docker
      ../nix
      ../defaults

      # Specifics for desktop type machines.
      # But need to be installed wide.
      # Perfer to put things in home manager when possible.
      ../i3wm
      ../thunar
      ../steam
      ../sound
      ../fonts

      # Add the per host specific modules
      ./desktop

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) (import ./desktop/home.nix) ];
        };
      }
    ];
  };
}
