{ pkgs, ... }:
{
  home.packages = with pkgs; [
    omp
    claude-code
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
}
