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
        "auto-allocate-uids"
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [ "root" "@wheel" "elliott" ];
    };
    gc = {
      automatic = true;
    };
    package = pkgs.nixVersions.git;
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ];

    registry.nixpkgs.flake = flake.inputs.nixpkgs;
  };

}
