{ lib, ... }:

{
  systemd = {
    oomd = {
      enable = true;
      enableSystemSlice = true;
      enableRootSlice = true;
      enableUserSlices = true;
    };
    slices.nix-daemon.sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "70%";
    };
    services.nix-daemon.serviceConfig.Slice = "nix-daemon.slice";

    # If a kernel-level OOM event does occur anyway,
    # strongly prefer killing nix-daemon child processes
    services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 400;
  };
}
