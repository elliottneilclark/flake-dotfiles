#
# Git
#

{
  programs = {
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
}
