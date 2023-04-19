{ config, lib, pkgs, ... }:

let
  extensions = with pkgs.vscode-marketplace; [
    # theme
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons

    # vim emulation
    vscodevim.vim

    # git
    eamodio.gitlens

    # nix language support
    jnoortheen.nix-ide

    # direnv
    # arrterian.nix-env-selector
    mkhl.direnv

    # Elixir
    jakebecker.elixir-ls
    florinpatrascu.vscode-elixir-snippets
    phoenix-liveview-snippets.phoenix-liveview-snippets
    phoenixframework.phoenix

    # Css
    bradlc.vscode-tailwindcss

    # Astro
    astro-build.astro-vscode

    # Rust
    tamasfe.even-better-toml
    serayuzgur.crates
    # rust-lang.rust-analyzer

    # Markdown
    yzhang.markdown-all-in-one

    # Formatting
    esbenp.prettier-vscode
  ];
in
{
  programs.vscode = {
    enable = true;

    package = pkgs.vscodium;

    mutableExtensionsDir = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;

      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;

      "files.enableTrash" = false;
      "files.autoSave" = "onFocusChange";
      "files.exclude" = {
        "**/node_modules" = true;
        "**/.sl" = true;
        "**/.jj" = true;
        "**/_build" = true;
      };

      editor = {
        formatOnSave = true;
        formatOnType = true;

        fontFamily = "JetBrains Mono Nerd Font";
        fontSize = 16;
        fontLigatures = true;

        minimap = {
          enabled = false;
        };
      };

      workbench = {
        fontAliasing = "antialiased";
        startupEditor = "none";
        colorTheme = "Catppuccin Mocha";
        iconTheme = "catppuccin-mocha";
      };

      "window.titleBarStyle" = "custom";

      terminal = {
        integrated = {
          cursorBlinking = true;
          cursorStyle = "line";
          cursorWidth = 2;
          fontFamily = "JetBrains Mono Nerd Font";
          fontSize = 16;
          smoothScrolling = true;
          scrollback = 5000;

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
        cursorStylePerMode = {
          normal = "block";
          insert = "line";
          replace = "underline";
          visual = "block-outline";
          visualblock = "block-outline";
          visualline = "block-outline";
        };
      };

      emmet = {
        showExpandedAbbreviation = "never";
        showSuggestionsAsSnippets = false;
      };
    };

    extensions = extensions;
  };

  home.packages = with pkgs; [
    nodePackages.prettier
    nixpkgs-fmt
  ];
}
