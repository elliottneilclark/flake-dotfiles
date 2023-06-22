{ ... }:

{
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
    enableZshIntegration = true;
    enableXsessionIntegration = true;
  };

}
