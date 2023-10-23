{ self, ... }:

{
  flake = {
    osxModules = {
      common = {
        imports = [
          ./users.nix
          ./environment.nix
          ./system.nix
          ./homebrew.nix
        ];


        programs.zsh.enable = true;

        home-manager.users.elliott = {
          imports = [
            self.homeModules.common
            self.homeModules.common-darwin
          ];
          home.stateVersion = "23.11";
        };

        security.pam.enableSudoTouchIdAuth = true;
        services.nix-daemon.enable = true;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;
      };
    };
  };
}
