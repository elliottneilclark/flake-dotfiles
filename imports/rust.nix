{ config, lib, pkgs, nixpkgs, rust-ovelay, system, ... }:

let rustToolchain = pkgs.rust-bin.stable.latest.complete;

in {

  home.packages = [ rustToolchain ];

}
