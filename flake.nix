{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    jj = {
      url = "github:martinvonz/jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.nixos-flake.flakeModule
        ./nixos
        ./home
        ./darwin-nix
      ];


      flake = {
        darwinConfigurations = {
          air = self.nixos-flake.lib.mkMacosSystem {
            nixpkgs.hostPlatform = "aarch64-darwin";
            imports = [
              self.nixosModules.common
              self.osxModules.common
              self.darwinModules.home-manager
            ];
          };
        };

        # nixosConfigurations = {
        #   anton = self.nixos-flake.lib.mkLinuxSystem {
        #     imports = [
        #       self.nixosModules.default
        #       ./hosts/anton
        #     ];
        #   };
        #   frost = self.nixos-flake.lib.mkLinuxSystem {
        #     imports = [
        #       self.nixosModules.default
        #       ./hosts/anton
        #     ];
        #   };
        #  };
      };

      perSystem = { self', system, pkgs, lib, config, inputs', ... }: {
        treefmt.config = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
        };
        packages.default = self'.packages.activate;
        formatter = config.treefmt.build.wrapper;
      };
    };

}
