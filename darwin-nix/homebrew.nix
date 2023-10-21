{ ... }: {
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    global.brewfile = true;
    casks = [
      "discord"
      "firefox"
      "spotify"
      "slack"
      "signal"
      "visual-studio-code"
    ];
  };
}
