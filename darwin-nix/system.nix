{ ... }: {

  system = {
    defaults = {
      # login window settings
      loginwindow = {
        # disable guest account
        GuestEnabled = false;
        # show name instead of username
        SHOWFULLNAME = false;
      };

      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.0;
        AppleInterfaceStyle = "Dark";
        # I'm ok with longer filenames
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Automatic";
        # Dont allow press and hold since it stops
        # key repeat
        ApplePressAndHoldEnabled = false;
        # How fast the keypress repeats
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        # Don't help me
        # Disable autocorrect
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
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
