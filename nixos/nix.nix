{ flake, pkgs, lib, ... }:

{

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-runtime"
        ];
      allowUnfree = true;
    };
    overlays = [
      flake.inputs.jj.overlays.default
      flake.inputs.nix-vscode-extensions.overlays.default
    ];
  };



  nix = {
    settings = {
      auto-optimise-store = true;
      extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 4d";
    };
    package = pkgs.nixVersions.unstable;
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ];

    registry.nixpkgs.flake = flake.inputs.nixpkgs;
  };

  system = {
    autoUpgrade = {
      enable = false;
    };
    stateVersion = "23.11";
  };
}
