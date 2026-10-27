{ self, ... }:

{
  flake = {
    darwinModules = {
      common = {
        imports = [
          ../nixos/nix.nix
          ../nixos/environment.nix
          ./users.nix
          ./environment.nix
          ./system.nix
          ./homebrew.nix
        ];


        programs.zsh.enable = true;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.elliott = {
            imports = [
              self.homeModules.common-darwin
            ];
            home.stateVersion = "26.11";
          };
        };

        security.pam.services.sudo_local.touchIdAuth = true;
        system.primaryUser = "elliott";

        system.stateVersion = 7;
      };
    };
  };
}
