{ pkgs, ... }:
{
  home.packages = with pkgs; [
    omp
    jq
    ranger
    unzip
    zip
    unrar
    wget
    curl
    age
    whois
    dnsutils
    doggo
    fd
    pstree
  ];

  programs.claude-code = {
    enable = true;
    mutableSettings = true;
    # Disable commit, PR, and session-link attribution.
    settings.attribution = {
      commit = "";
      pr = "";
      sessionUrl = false;
    };
  };
}
