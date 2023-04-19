{ pkgs, home-manager, user, inputs, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFa64P1p+IFzKghQSp0kEkz2qNppaRiffqb/xNlG4xpt elliott.neil.clark@gmail.com" ];
  };

  services.sshd.enable = true;
  time.timeZone = "America/Chicago";

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [ neovim killall pciutils usbutils wget ];
  };
}
