{ pkgs, ... }:

let
  openvsxExtensions = with pkgs.vscode-extensions; [
    astro-build.astro-vscode
    vadimcn.vscode-lldb
  ];
  extensions = with pkgs.vscode-marketplace; [
    # theme
    arcticicestudio.nord-visual-studio-code
    pkief.material-product-icons
    pkief.material-icon-theme
    eliverlara.andromeda

    # vim emulation
    vscodevim.vim

    # nix language support
    jnoortheen.nix-ide

    # direnv
    mkhl.direnv

    # Elixir
    florinpatrascu.vscode-elixir-snippets
    phoenix-liveview-snippets.phoenix-liveview-snippets
    phoenixframework.phoenix

    # Css
    bradlc.vscode-tailwindcss

    # Rust
    tamasfe.even-better-toml
    serayuzgur.crates


    # Markdown
    yzhang.markdown-all-in-one

    # Formatting
    esbenp.prettier-vscode

    # Sharing
    ms-vscode-remote.remote-ssh
    ms-vsliveshare.vsliveshare
  ];
  nixpkgs-fmt = pkgs.nixpkgs-fmt;
  home_packages = [
    nixpkgs-fmt
  ];
in
{
  home.packages = home_packages;
  programs.vscode = {
    enable = true;

    package = pkgs.vscode;

    mutableExtensionsDir = true;
    profiles.default.mutableUserSettings = true;
    profiles.default.enableUpdateCheck = false;
    profiles.default.enableExtensionUpdateCheck = false;

    profiles.default.userSettings = {
      files.insertFinalNewline = true;
      files.trimFinalNewlines = true;
      files.trimTrailingWhitespace = true;

      files.enableTrash = false;
      files.autoSave = "onFocusChange";
      files.exclude = {
        "**/node_modules" = true;
        "**/.sl" = true;
        "**/.jj" = true;
        "**/_build" = true;
        "**/target" = true;
      };

      editor = {
        formatOnType = true;

        fontFamily = "'FiraCode Nerd Font'";
        fontSize = 16;
        fontLigatures = true;
        inlineSuggest.enabled = true;
        inlineSuggest.suppressSuggestions = false;

        minimap = {
          enabled = false;
        };
      };

      workbench = {
        fontAliasing = "antialiased";
        startupEditor = "none";
        colorTheme = "Andromeda";
        iconTheme = "material-icon-theme";
        productIconTheme = "material-product-icons";
        smoothScrolling = true;
      };

      window.titleBarStyle = "custom";
      update.mode = "none";

      terminal = {
        integrated = {
          fontFamily = "FiraCode";
          fontSize = 16;
          scrollback = 6000;

          ignoreProcessNames = [
            "starship"
            "bash"
            "zsh"
            "fish"
            "nu"
          ];
        };
      };

      vim = {
        useSystemClipboard = true;
        handleKeys = {
          "<C-p>" = false;
          "<C-i>" = false;
        };
        cursorStylePerMode = {
          normal = "block";
          insert = "line";
          replace = "underline";
          visual = "block-outline";
          visualblock = "block-outline";
          visualline = "block-outline";
        };
      };

      git.autofetch = true;

      nix.formatterPath = "${nixpkgs-fmt}/bin/nixpkgs-fmt";
    };

    profiles.default.extensions = extensions ++ openvsxExtensions;
  };
}
