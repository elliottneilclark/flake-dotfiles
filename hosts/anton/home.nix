# Home-manager configuration for desktop

{ ... }:

{
  imports = [
    (import ../../imports/random-background.nix)
    (import ../../imports/woeusb.nix)
  ];
}
