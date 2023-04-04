{pkgs, ...}:


{
  home.packages = [ pkgs.jujutsu ];
  xdg.configFile."jj/config.toml".text = ''
  [user]
  name = "Elliott Clark"
  email = "elliott@batteriesincl.com"
  '';
}
