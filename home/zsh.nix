{ ... }:

{
  programs = {
    fzf.enable = true;
    #fzf.enableZshIntegration = true;

    # shell prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;

      localVariables = {
        EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
      };
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;


      prezto = {
        enable = true;
        tmux = {
          autoStartRemote = true;
          autoStartLocal = false;
        };
        ssh.identities = [ "id_ed25519" ];
        editor = { keymap = "vi"; };
        color = true;
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

          # extra
          "history-substring-search"
          "syntax-highlighting"
          "autosuggestions"

          "ssh"
          "tmux"
          "docker"
          "git"

        ];

        extraConfig = ''
          zstyle ':prezto:module:git:alias' skip 'yes'
        '';
      };

      shellAliases = {
        ".." = "cd ..";

        # Re-assign this back to sl
        # prezto above doesn't think that you really ever mean sl
        #
        # So swap it back
        #"sl" = "${pkgs.sapling}/bin/sl";
      };
    };
  };
}
