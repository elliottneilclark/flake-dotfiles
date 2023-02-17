{ pkgs, home-manager, user, inputs, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "docker" ];
    shell = pkgs.zsh;
  };

  time.timeZone = "America/Chicago";

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [ neovim killall pciutils usbutils wget ];
  };
}
