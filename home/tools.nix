{ pkgs, ...}:
{
  home.packages = with pkgs; [
    jq ranger unzip zip unrar usbutils wget curl
  ];
}
