{ ... }:
let
  template = builtins.readFile ./jj/default-description.template;
in
{
  programs = {
    jujutsu = {
      enable = true;
      settings = {
        user.name = "Elliott Clark";
        user.email = "elliott.neil.clark@gmail.com";
        ui.default-description = template;
      };
    };
  };
}
