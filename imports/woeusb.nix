{ pkgs, ... }:


{
  home.packages = [
    pkgs.woeusb-ng
    pkgs.ntfs3g
  ];
}
