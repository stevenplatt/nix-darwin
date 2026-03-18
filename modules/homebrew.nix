{ ... }: {
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = { cleanup = "zap"; autoUpdate = true; upgrade = true; };
    brews = [ "mas" ];
    casks = [
      "affinity"
      "antigravity"
      "balenaetcher"
      "discord"
      "docker-desktop"
      "google-chrome"
      "slack"
      "the-unarchiver"
      "wireshark-app"
      "zoom"
      "zotero"
    ];
    masApps = {
      "Davinci Resolve" = 571213070;
      "Mela" = 1568924476;
      "Slack" = 803453959;
      "Swift Playground" = 1496833156;
      "WhatsApp" = 310633997;
      "XCode" = 497799835;
    };
  };
}
