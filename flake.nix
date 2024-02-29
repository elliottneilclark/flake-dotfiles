{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixos-flake.url = "github:srid/nixos-flake";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.home-manager.follows = "home-manager";
    };

    jj = {
      url = "github:martinvonz/jj";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, nixos-flake, treefmt-nix, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
        treefmt-nix.flakeModule
        nixos-flake.flakeModule
        ./nixos
        ./home
        ./darwin-nix
      ];


      flake = {
        darwinConfigurations = {
          air = self.nixos-flake.lib.mkMacosSystem {
            nixpkgs.hostPlatform = "aarch64-darwin";
            imports = [
              home-manager.darwinModules.home-manager
              self.nixosModules.common
              self.osxModules.common
            ];
          };
        };

        nixosConfigurations = {
          anton = self.nixos-flake.lib.mkLinuxSystem {
            imports = [
              self.nixosModules.default
              ./hosts/anton
            ];
          };
          frost = self.nixos-flake.lib.mkLinuxSystem {
            imports = [
              self.nixosModules.default
              ./hosts/frost
            ];
          };
        };
      };

      perSystem = { self', config, ... }: {
        treefmt.config = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
          programs.deadnix.enable = true;
        };
        packages.default = self'.packages.activate;
        formatter = config.treefmt.build.wrapper;
      };
    };

}
