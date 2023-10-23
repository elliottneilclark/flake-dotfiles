{ ... }: {

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        # I'm ok with longer filenames
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Automatic";
        # How fast the keypress repeats
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        # Don't help me
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        show-recents = false;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
