{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      woeusb-ng
      ntfs3g
    ];
  };
}
