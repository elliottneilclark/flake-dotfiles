{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
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

      "terminal.integrated.scrollback" = 5000;
    };
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./extensions.nix).extensions;
  };
}

