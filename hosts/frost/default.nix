# Specific system configuration settings for desktop
{ config, lib, pkgs, ... }:
let
  # The VM variant swaps videoDrivers for modesetting, which disables all of this.
  nvidiaEnabled = builtins.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  imports = [
    (import ./hardware-configuration.nix)
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.systemd-boot.memtest86.enable = false;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];

  boot.tmp.cleanOnBoot = true;

  security.rtkit.enable = true;

  security.tpm2 = {
    enable = true;
  };

  # The native NVIDIA module uses videoDrivers even without an X server.
  services.xserver.videoDrivers = [ "nvidia" ];
  console.keyMap = "us";

  # Early KMS: load the NVIDIA modules from the initrd before the display is bound.
  boot.initrd.kernelModules = lib.mkIf nvidiaEnabled [ "nvidia" "nvidia_modeset" "nvidia_drm" ];
  # PCI-backed names avoid both changing card indices and AQ's colon separator.
  services.udev.extraRules = lib.mkIf nvidiaEnabled ''
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:01:00.0", SYMLINK+="dri/frost-nvidia"
    SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:18:00.0", SYMLINK+="dri/frost-amd"
  '';
  environment.sessionVariables = lib.mkIf nvidiaEnabled {
    # HDMI-A-1 is physically connected to the RTX 4090, not the AMD iGPU.
    AQ_DRM_DEVICES = "/dev/dri/frost-nvidia:/dev/dri/frost-amd";
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  services.blueman.enable = true;

  services.flatpak.enable = true;


  hardware = {
    enableRedistributableFirmware = true; # MT7922 Wi-Fi/Bluetooth and AMD graphics.
    nvidia-container-toolkit.enable = true;
    nvidia = {
      branch = "stable";
      open = true; # RTX 4090 (Ada) supports NVIDIA's open kernel modules.
      modesetting.enable = true;
      powerManagement.enable = true;
      videoAcceleration = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  environment.systemPackages = [
    pkgs.perf
  ];
  networking.networkmanager.enable = true;

  virtualisation.vmVariant = import ./vm.nix;
  image.modules.iso = ./image.nix;


  networking.hostName = "frost";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
