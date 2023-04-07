{pkgs, ...}:


{
  home.packages = with pkgs; [ jujutsu  meld ];
  xdg.configFile."jj/config.toml".text = ''
  [user]
  name = "Elliott Clark"
  email = "elliott@batteriesincl.com"
  '';
}
