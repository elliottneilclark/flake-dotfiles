{ pkgs, ... }:

{

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      # shortcut: 3.2.0 touches the watched flake-profile .rc on every cache hit,
      # so each shell reload invalidates every other shell; drop once a release ships the fix.
      # Upstream's own derivation; overrideAttrs on nixpkgs' resholve build loses installPhase.
      package = pkgs.callPackage "${
        pkgs.fetchFromGitHub {
          owner = "nix-community";
          repo = "nix-direnv";
          rev = "babed5598d2594b71677ca18674d027bc4549eb0";
          hash = "sha256-cf6klSXJ0WmICyHpFiFT5A+em5kuD8vVhBxgYktC0m8=";
        }
      }/default.nix"
        { };
    };
  };
}
