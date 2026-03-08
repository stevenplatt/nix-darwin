{ self, ... }: {
  system.primaryUser = "telecomsteve";

  # System settings (https://mynixos.com/nix-darwin/options/system.defaults)
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "left";
      minimize-to-application = true;
      persistent-apps = [
        "/Applications/WhatsApp.app"
        "/System/Applications/Messages.app"
        "/Applications/Antigravity.app"
        "/Applications/Ghostty.app"
        "/Applications/Google Chrome.app"
        "/Applications/Spark Desktop.app"
      ];
      wvous-br-corner = 1;
      wvous-bl-corner = 1;
      wvous-tr-corner = 2;
      wvous-tl-corner = 1;
    };
    finder = {
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      AppleShowAllFiles = true;
      NewWindowTarget = "Documents";
      QuitMenuItem = true;
    };
    loginwindow.GuestEnabled = false;
    controlcenter.BatteryShowPercentage = true;
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
