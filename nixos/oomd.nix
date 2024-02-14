{ lib, ... }:

{
  systemd = {
    oomd = {
      enable = true;
      enableSystemSlice = true;
      enableRootSlice = true;
      enableUserSlices = true;
    };
    services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 350;
  };
}
