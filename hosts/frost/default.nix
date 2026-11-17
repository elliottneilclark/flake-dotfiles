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
  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;

  # Windows lives on its own ESP on the other NVMe disk, so systemd-boot can't
  # auto-detect it. A dedicated shell copy runs the startup.nsh next to it, which
  # scans the filesystems for the Windows boot manager instead of hardcoding a
  # device handle that can shift when drives change.
  boot.loader.systemd-boot.extraFiles = {
    "efi/windows/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";
    "efi/windows/startup.nsh" = pkgs.writeText "startup.nsh" ''
      @echo -off
      for %i in fs0 fs1 fs2 fs3 fs4 fs5 fs6 fs7 fs8 fs9
        if exist %i:\EFI\Microsoft\Boot\bootmgfw.efi then
          %i:\EFI\Microsoft\Boot\bootmgfw.efi
        endif
      endfor
      echo "Windows Boot Manager not found"
    '';
  };
  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title Windows
    efi /efi/windows/shell.efi
    options -nointerrupt -noversion -delay 0
    sort-key o_windows
  '';

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = [ "ntfs" ];

  environment.variables.OTTR_ML_CACHE_DIR = "/run/media/elliott/Seagate/dj-assistant-benchmarks";

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
      # Drive the LG TV with HDMI 2.0 TMDS signalling instead of HDMI 2.1 FRL.
      # Every compositor death on frost followed HDMI-A-1 hot-unplugging itself,
      # and the kernel logged "nvidia-modeset: HDMI FRL link training failed" a
      # few seconds before most of those unplugs. The TV's EDID allows 600 MHz
      # TMDS, which carries 3840x2160@60 8-bit RGB, so nothing used today is lost.
      moduleParams."nvidia-modeset".disable_hdmi_frl = 1;
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

  # Temporary diagnostic. Hyprland has died by a signal that leaves no core dump
  # and no crash report (start-hyprland reports waitpid ECHILD, so WIFSIGNALED,
  # and coredumpctl never lists it). Record who sends it so the next death is
  # attributable: journalctl -u hyprland-signal-trace. Remove once answered.
  systemd.services.hyprland-signal-trace = lib.mkIf nvidiaEnabled {
    description = "Log signals generated for the Hyprland process";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.bpftrace}/bin/bpftrace ${pkgs.writeText "hyprland-signal-trace.bt" ''
      tracepoint:signal:signal_generate
      / args->comm == ".Hyprland-wrapp" && args->sig != 17 && args->sig != 10 && args->sig != 13 /
      {
        printf("sig=%d to %s[%d] from %s[%d] code=%d result=%d\n",
          args->sig, args->comm, args->pid, comm, pid, args->code, args->result);
      }
    ''}";
  };
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
