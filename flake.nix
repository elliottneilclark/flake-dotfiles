{
  # Check all outputs: nix flake check --all-systems
  # Update pinned inputs: nix flake update
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, flake-parts, home-manager, nix-darwin, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      imports = [
        treefmt-nix.flakeModule
        ./nixos
        ./home
        ./darwin-nix
      ];


      flake = {
        darwinConfigurations = {
          # Activate with: sudo darwin-rebuild switch --flake .#air
          air = nix-darwin.lib.darwinSystem {
            specialArgs = { inherit inputs; };
            modules = [
              home-manager.darwinModules.home-manager
              self.darwinModules.common
              { nixpkgs.hostPlatform = "aarch64-darwin"; }
            ];
          };
        };

        nixosConfigurations = {
          # Activate with: sudo nixos-rebuild switch --flake .#frost
          frost = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              home-manager.nixosModules.home-manager
              self.nixosModules.default
              ./hosts/frost
            ];
          };
          slate = inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [
              home-manager.nixosModules.home-manager
              inputs.lanzaboote.nixosModules.lanzaboote
              self.nixosModules.default
              ./hosts/slate
            ];
          };
        };
      };

      perSystem = { config, lib, system, ... }: {
        # Bootable live images: nix build .#frost-iso or .#slate-iso
        packages = lib.optionalAttrs (system == "x86_64-linux") {
          frost-iso = self.nixosConfigurations.frost.config.system.build.images.iso;
          slate-iso = self.nixosConfigurations.slate.config.system.build.images.iso;
        };
        treefmt.config = {
          # Formatting is source-only; check it once on Linux.
          flakeCheck = system == "x86_64-linux";
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
          programs.deadnix.enable = true;
        };
        formatter = config.treefmt.build.wrapper;
      };
    };

}
