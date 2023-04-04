{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj = { 
      url = "github:martinvonz/jj"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, jj, ... }:
    let
      user = "elliott";
      location = "$HOME/.setup";
    in
    {
      nixosConfigurations = (import ./modules/hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager user location jj;
      });
    };
}

