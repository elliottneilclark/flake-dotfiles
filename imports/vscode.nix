{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    package = pkgs.vscodium;

    mutableExtensionsDir = true;
    enableUpdateCheck = false;
    userSettings = {
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;

      "files.trimTrailingWhitespace" = true;
      "files.autoSave" = "onFocusChange";
      "files.exclude" = {
        "**/node_modules" = true;
        "**/.sl" = true;
        "**/_build" = true;
      };

      "editor.fontFamily" = "JetBrains Mono Nerd Font";
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;

      "editor.minimap.enabled" = false;
      "workbench.colorTheme" = "Dracula";
      "workbench.fontAliasing" = "antialiased";
      "workbench.startupEditor" = "none";

      "terminal.integrated.scrollback" = 4000;
      "rust-analyzer.trace.extension" = true;
    };
  };
}

