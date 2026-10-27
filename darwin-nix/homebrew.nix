{ ... }: {
  homebrew = {
    enable = true;
    global.brewfile = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "openjdk@17"
      "podman"
    ];
    casks = [
      "discord"
      "firefox"
      "spotify"
      "slack"
      "signal"
      "visual-studio-code"
      "prismlauncher"
      "podman-desktop"
    ];
  };
}
