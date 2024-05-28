{ pkgs, nixpkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
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
    dogdns
    fd
    pstree
  ];
}
