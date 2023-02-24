# Bar
#

{ config, lib, pkgs, host, ... }:

let
  mypolybar = pkgs.polybar.override {
    # Extra packages to run polybar (mostly sound atm)
    alsaSupport = true;
    pulseSupport = true;
    i3GapsSupport = true;
  };
in
{
  services = {
    polybar = {
      enable = true;
      package = mypolybar;
    };
  };
}
