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
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [ neovim killall pciutils usbutils wget ];
  };

  nix = {
    settings = { auto-optimise-store = true; };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;
  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.11";
  };
}
