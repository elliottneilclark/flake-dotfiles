{ ... }:
let
  template = builtins.readFile ./jj/default-description.template;
in
{
  programs = {
    jujutsu = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        user.name = "Elliott Clark";
        user.email = "elliott@batteriesincl.com";
        ui.default-description = template;
      };
    };
  };
}
