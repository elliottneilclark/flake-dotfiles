# Git
#

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
        co = "checkout";
        st = "status";
        ll = "log -p";
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
      extraConfig = { init = { defaultBranch = "master"; }; };
    };
  };

  xdg.configFile."git/ignore".text = ''
    .direnv
  '';
}
