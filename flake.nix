{
  description = "Steven's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Declarative tap management with homebrew
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  {
    # Assumes computer hostname is "Stevens-MacBook-Air"
    darwinConfigurations."Stevens-MacBook-Air" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self; };
      modules = [
        ./modules/packages.nix
        ./modules/homebrew.nix
        ./modules/system.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "telecomsteve";

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        # Align homebrew taps config with nix-homebrew
        ({ config, ... }: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };
  };
}
