{ pkgs, ... }:

{
  virtualisation.docker = { enable = true; enableNvidia = true; };
  users.groups.docker.members = [ "elliott" ];
  environment.systemPackages = with pkgs; [ docker-compose ];
}
