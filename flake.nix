{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    jj = {
      url = "github:martinvonz/jj";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, jj, nix-vscode-extensions, ... }:
    let
      user = "elliott";
      location = "$HOME/.setup";
    in
    {
      nixosConfigurations = (import ./modules/hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager user location jj nix-vscode-extensions;
      });
    };
}
