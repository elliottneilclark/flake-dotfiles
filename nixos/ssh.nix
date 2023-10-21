{ ... }:

{

  services.sshd.enable = true;
  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
    };
  };

  programs.ssh.startAgent = true;
}
