{ config, lib, pkgs, user, ... }:

{
  services.random-background = {
    enable = true;
    imageDirectory = "%h/Pictures/Backgrounds";
    interval = "120";
  };
}
