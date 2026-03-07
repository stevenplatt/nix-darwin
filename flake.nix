{
  description = "Steven's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management with homebrew
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      system.primaryUser = "telecomsteve";
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.aichat
          pkgs.ansible
          pkgs.argocd
          pkgs.awscli2
          pkgs.btop
          pkgs.cmatrix
          pkgs.fastfetch
          pkgs.htop
          pkgs.google-cloud-sdk
          pkgs.k9s
          pkgs.kind
          pkgs.kubectl
          pkgs.kubernetes-helm
          pkgs.kustomize
          pkgs.nmap
          pkgs.stern
          pkgs.vim
        ];

      homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
            "affinity"
            "antigravity"
            "applite"
            "balenaetcher"
            "discord"
            "docker-desktop"
            "ghostty"
            "google-chrome"
            "lens"
            "logi-options+"
            "slack"
            "the-unarchiver"
            "wireshark-app"
            "zoom"
            "zotero"
        ];
        # Install apps from Mac App Store
        masApps = {
            "Davinci Resolve" = 571213070;
            "Mela" = 1568924476;
            "Slack" = 803453959;
            "Spark Mail" = 6445813049;
            "Swift Playground" = 1496833156;
            "WhatsApp" = 310633997;
            "XCode" = 497799835;
        };
        onActivation.cleanup = "zap"; # remove packages installe outside of nix
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      # System settings (https://mynixos.com/nix-darwin/options/system.defaults)
      system.defaults = {
        dock.autohide = true;
        dock.orientation = "left";
        dock.minimize-to-application = true;
        dock.persistent-apps = [
            "/Applications/WhatsApp.app"
            "/System/Applications/Messages.app"
            "/Applications/Antigravity.app"
            "/Applications/Ghostty.app"
            "/Applications/Google Chrome.app"
            "/Applications/Spark Desktop.app"
        ];
        dock.wvous-br-corner = 1;
        dock.wvous-bl-corner = 1;
        dock.wvous-tr-corner = 2;
        dock.wvous-tl-corner = 1;
        finder.FXPreferredViewStyle = "clmv";
        finder.ShowPathbar = true;
        finder.AppleShowAllFiles = true;
        finder.NewWindowTarget = "Documents";
        finder.QuitMenuItem = true;
        loginwindow.GuestEnabled = false;
        controlcenter.BatteryShowPercentage = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Assumes computer hostname is "Stevens-MacBook-Air"
    darwinConfigurations."Stevens-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "telecomsteve";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        # Optional: Align homebrew taps config with nix-homebrew
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
        ];
    };
  };
}
