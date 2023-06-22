{ inputs, nixpkgs, home-manager, jj, nix-vscode-extensions, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    overlays = [ jj.overlays.default nix-vscode-extensions.overlays.default ];
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;

  base_modules = [
    ../modules/neovim
    ../modules/zsh
    ../modules/docker
    ../modules/nix
    ../modules/users
    ../modules/defaults

  ];

  desktop_modules = [
    # Specifics for desktop type machines.
    # But need to be installed wide.
    # Perfer to put things in home manager when possible.
    ../modules/i3wm
    ../modules/thunar
    ../modules/steam
    ../modules/sound
    ../modules/printing
    ../modules/fonts
  ];
in
{
  frost = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = { inherit inputs; };
    modules = base_modules ++ desktop_modules ++ [
      ./frost

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.elliott = {
          imports = [
            (import ./home.nix)
            (import ./desktop.nix)
            (import ./frost/home.nix)
          ];
        };
      }

    ];
  };
  anton = lib.nixosSystem {
    inherit system pkgs;
    specialArgs = { inherit inputs; };
    modules = base_modules ++ desktop_modules ++ [
      ./anton

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.elliott = {
          imports = [
            (import ./home.nix)
            (import ./desktop.nix)
            (import ./anton/home.nix)
          ];
        };
      }
    ];
  };
}
