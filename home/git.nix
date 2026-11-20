{ config, pkgs, ... }:

{
  programs = {
    gh = {
      enable = true;
      extensions = with pkgs; [ gh-markdown-preview ];
      settings = {
        version = "1";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    git = {
      enable = true;
      settings.user = {
        name = "Elliott Clark";
        email = "elliott.neil.clark@gmail.com";
      };
      settings.alias = {
        a = "add";
        br = "branch";
        ci = "commit";
        cl = "clone";
        co = "checkout";
        cp = "cherry-pick";
        dc = "diff --cached";
        f = "!git ls-files | grep -i";
        fl = "log -u";
        graph = ''log --graph --date-order -C -M --pretty=format:"<%h> %ad [%an] %Cgreen%d%Creset %s" --all --date=short'';
        lg = "log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%an%d%Creset %s %Cgreen(%cr)%Creset' --date=relative";
        ll = "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cgreen [%cn]' --decorate --numstat";
        ls = "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cgreen [%cn]' --decorate";
        st = "status -s";
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
      settings = {
        core.editor = "nvim";
        apply.whitespace = "fix";
        color.ui = "auto";
        color.branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        color.diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
        };
        color.status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
        merge.log = true;
        pager.branch = false;
        commit.template = "${config.xdg.configHome}/git/commit.template";
        init = { defaultBranch = "master"; };
      };
      settings.url = {
        "git://github.com/".insteadOf = "github:";
        "git@github.com:" = {
          insteadOf = "gh:";
          pushInsteadOf = [ "github:" "git://github.com/" ];
        };
      };

    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        syntax-theme = "Nord";
        line-numbers = true;
        decorations = true;
      };
    };
  };

  xdg.configFile."git/ignore".text = ''
    .direnv
    .elixir_ls
  '';

  xdg.configFile."git/commit.template" = {
    source = ./git/commit.template;
  };
}
