# Git
#

{
  programs = {
    gh = {
      enable = true;
      enableGitCredentialHelper = true;
    };
    git = {
      enable = true;
      userName = "Elliott Clark";
      userEmail = "elliott@batteriesincl.com";
      aliases = {
        co = "checkout";
        st = "status";
        ll = "log -p";
      };
    };
  };

  xdg.configFile."git/ignore".text = ''
    .direnv
  '';
}
