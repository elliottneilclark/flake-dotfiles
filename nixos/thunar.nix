{ pkgs, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [ thunar-archive-plugin thunar-volman ];
  };
  services.tumbler.enable = true; # Thumbnail support for images

  services.gvfs.enable = true;

  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
}
