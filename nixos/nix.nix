{ inputs, pkgs, ... }:

{

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];
  };



  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
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
      max-jobs = 1;
      cores = 8;
    };
    gc = {
      automatic = true;
    };
    package = pkgs.nixVersions.latest;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    registry.nixpkgs.flake = inputs.nixpkgs;
  };

}
