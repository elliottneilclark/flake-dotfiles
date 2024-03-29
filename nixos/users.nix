{ pkgs, ... }:

{
  users.users.elliott = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFa64P1p+IFzKghQSp0kEkz2qNppaRiffqb/xNlG4xpt elliott.neil.clark@gmail.com" ];
  };

  # We need to enable zsh as a program since we use it as the default shell
  programs.zsh.enable = true;
}
