{ pkgs, ... }:

let
  openvsxExtensions = with pkgs.vscode-extensions; [
    astro-build.astro-vscode
  ];
  extensions = with pkgs.vscode-marketplace; [
    # theme
    arcticicestudio.nord-visual-studio-code
    pkief.material-product-icons
    pkief.material-icon-theme

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
    # jakebecker.elixir-ls
    florinpatrascu.vscode-elixir-snippets
    phoenix-liveview-snippets.phoenix-liveview-snippets
    phoenixframework.phoenix

    # Css
    bradlc.vscode-tailwindcss

    # Rust
    tamasfe.even-better-toml
    serayuzgur.crates
    # rust-lang.rust-analyzer

    # Markdown
    yzhang.markdown-all-in-one

    # Formatting
    esbenp.prettier-vscode

    # Sharing
    ms-vscode-remote.remote-ssh
    ms-vsliveshare.vsliveshare
  ];
in
{
  programs.vscode = {
    enable = true;

    package = pkgs.vscode;

    mutableExtensionsDir = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;
      "telemetry.telemetryLevel" = "off";

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
        "**/target" = true;
      };

      editor = {
        formatOnType = true;

        fontFamily = "'FiraCode Nerd Font'";
        fontSize = 16;
        fontLigatures = true;

        minimap = {
          enabled = false;
        };
      };

      workbench = {
        fontAliasing = "antialiased";
        startupEditor = "none";
        colorTheme = "Nord";
        iconTheme = "material-icon-theme";
        productIconTheme = "material-product-icons";
        smoothScrolling = true;
      };

      "window.titleBarStyle" = "custom";

      terminal = {
        integrated = {
          cursorBlinking = true;
          cursorStyle = "line";
          cursorWidth = 2;
          fontFamily = "FiraCode";
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
    };

    extensions = extensions ++ openvsxExtensions;
  };
}
