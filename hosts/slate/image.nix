# Build with nix build path:.#slate-iso; live login is elliott / slate-live.
{ config, inputs, lib, pkgs, ... }:

{
  networking.hostName = lib.mkForce "slate-live";
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  # The live image must never unlock or mount the installed NVMe layout.
  fileSystems = lib.mkForce config.lib.isoFileSystems;
  swapDevices = lib.mkForce [ ];
  boot.initrd.luks.devices = lib.mkForce { };
  boot.resumeDevice = lib.mkForce "";
  boot.lanzaboote.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  isoImage.contents = [
    {
      source = lib.cleanSource inputs.self.outPath;
      target = "/flake-dotfiles";
    }
  ];
  # Reference the installed configuration, not this image's live toplevel.
  isoImage.storeContents = [ inputs.self.nixosConfigurations.slate.config.system.build.toplevel ];

  environment.systemPackages = with pkgs; [
    cryptsetup
    util-linux
    dosfstools
    e2fsprogs
    gptfdisk
    parted
    sbctl
    efitools
    pciutils
    usbutils
    nvme-cli
    smartmontools
    libva-utils
    alsa-utils
    fwupd
  ];

  services.openssh.enable = lib.mkForce false;
  services.fwupd.enable = lib.mkForce false;
  home-manager.users.elliott.programs.keychain.enable = lib.mkForce false;

  users.mutableUsers = lib.mkForce false;
  users.users.elliott = {
    password = lib.mkForce "slate-live";
    openssh.authorizedKeys.keys = lib.mkForce [ ];
  };
}
