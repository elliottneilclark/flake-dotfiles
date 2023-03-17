{ user, config, lib, pkgs, host, ... }:

{
  programs = {
    fzf.enable = true;
    fzf.enableZshIntegration = true;

    zsh = {
      enable = true;

      prezto = {
        enable = true;
        tmux = {
          autoStartRemote = true;
          autoStartLocal = false;
        };
        ssh.identities = [ "id_ed25519" ];
        editor = { keymap = "vi"; };
        color = true;
        prompt.theme = "random";
        pmodules = [
          # Default modules
          "environment"
          "terminal"
          "editor"
          "history"
          "directory"
          "spectrum"
          "utility"
          "completion"
          "prompt"

          # extra
          "history-substring-search"
          "syntax-highlighting"
          "tmux"
          "docker"
          "git"

        ];
      };

      shellAliases = {
        ".." = "cd ..";

        # Re-assign this back to sl
        # prezto above doesn't thing that you really ever mean sl
        #
        # So swap it back
        #"sl" = "${pkgs.sapling}/bin/sl";
      };
    };
  };
}
