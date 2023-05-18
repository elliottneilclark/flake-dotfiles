# Git
#
{ config, ... }:

{
  programs = {
    gh = {
      enable = true;
      enableGitCredentialHelper = true;
    };
    git = {
      enable = true;
      userName = "Elliott Clark";
      userEmail = "elliott@batteriesincl.com";
      aliases = {
        a = "add";
        co = "checkout";
        st = "status";
        ll = "log -p";
        sl = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all --since='90 days ago'";
      };
      ignores = [
        # IntelliJ files and folders
        ".idea/"
        "*.iml"
        # backupfiles and shadow copies done by editors
        "*~"
        "\\#*\\#"
        ".#*"
        # Elixir language server
        "/.elixir_ls"
        # MyPy Cache
        ".mypy_cache"
        # Visual Studio Code project configuration
        "/.vscode"
        # Result folder for nix builds
        "result"
        "result-*"
        # direnv caches
        ".direnv/"
        # emacs/python stuff
        "flycheck_*.py"
      ];
      lfs.enable = true;
      extraConfig = {
        core.editor = "nvim";
        color.ui = "auto";
        commit.template = "${config.xdg.configHome}/git/commit.template";
        init = { defaultBranch = "master"; };
      };

    };
  };

  xdg.configFile."git/ignore".text = ''
    .direnv
    .elixir_ls
  '';

  xdg.configFile."git/commit.template" = {
    source = ../modules/git/commit.template;
  };
}
