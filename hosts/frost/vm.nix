# Build with nix build .#nixosConfigurations.frost.config.system.build.vm.
# Run the generated bin/run-frost-vm-vm from a disposable directory.
# Guest login: elliott / frost-vm; SSH listens on localhost:2222.
# View the graphical desktop with a VNC client at 127.0.0.1:5901.
{ config, lib, ... }:

{
  networking.hostName = lib.mkForce "frost-vm";

  # qemu-vm replaces physical filesystems/swap with its private image and read-only
  # Nix store share; no host block devices or production UUIDs reach the guest.
  virtualisation = {
    cores = 4;
    memorySize = 6144;
    diskSize = 32768;
    # Ubuntu has no /run/opengl-driver; keep the VM's host-side GL stack in Nix.
    qemu.package =
      let pkgs = config.virtualisation.host.pkgs;
      in pkgs.symlinkJoin {
        name = "frost-vm-qemu";
        paths = [ pkgs.qemu_kvm ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/qemu-system-x86_64" \
            --set GBM_BACKENDS_PATH ${pkgs.mesa}/lib/gbm \
            --set LIBGL_DRIVERS_PATH ${pkgs.mesa}/lib/dri \
            --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json
        '';
      };
    # qemu_kvm keeps native OpenGL/VirGL support; no GPU PCI passthrough.
    # Render on this host's AMD iGPU; view the guest at localhost:5901 (VNC).
    qemu.options = [
      "-vga none"
      "-device virtio-vga-gl"
      "-display egl-headless,rendernode=/dev/dri/by-path/pci-0000:18:00.0-render"
      "-vnc 127.0.0.1:1"
    ];
    forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 2222;
        guest.port = 22;
      }
    ];
  };

  # qemu-guest supplies early virtio graphics instead of the physical NVIDIA
  # initrd modules. Its videoDrivers override also excludes Frost's NVIDIA env.
  boot.kernelModules = lib.mkForce [ ];
  hardware.nvidia.powerManagement.enable = lib.mkForce false;
  hardware.nvidia-container-toolkit.enable = lib.mkForce false;
  security.tpm2.enable = lib.mkForce false;

  home-manager.users.elliott = {
    # No private SSH keys are copied into this disposable guest.
    programs.keychain.enable = lib.mkForce false;
  };

  # Disposable guest credentials only; production users are not weakened.
  users.mutableUsers = lib.mkForce false;
  users.users.elliott = {
    password = lib.mkForce "frost-vm";
    openssh.authorizedKeys.keys = lib.mkForce [ ];
  };
  services.greetd.settings.initial_session = {
    command = "${lib.getExe config.programs.uwsm.package} start -e -D Hyprland hyprland.desktop";
    user = "elliott";
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
