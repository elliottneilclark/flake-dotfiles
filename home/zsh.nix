{ ... }:

{
  programs = {
    fzf.enable = true;
    fzf.enableZshIntegration = true;

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

      enableCompletion = true;
      syntaxHighlighting.enable = true;

      autosuggestion.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "sudo"
          "terraform"
          "kubectl"
          "vi-mode"
          "git"
          "fzf"
        ];
      };

      history = {
        expireDuplicatesFirst = true;
        save = 100000000;
        size = 1000000000;
      };


      shellAliases = {
        ".." = "cd ..";
        g = "git";

        # Re-assign this back to sl
        # prezto above doesn't think that you really ever mean sl
        #
        # So swap it back
        #"sl" = "${pkgs.sapling}/bin/sl";
      };
    };
  };
}
