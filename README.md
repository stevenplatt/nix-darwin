<p align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" width="150" alt="Nix Logo"/>
</p>

<h1 align="center">nix-darwin</h1>

<p align="center">
  Declarative macOS system configuration using <a href="https://nixos.org/">Nix</a> and <a href="https://github.com/nix-darwin/nix-darwin">nix-darwin</a>
</p>

---

## Overview

This repository contains a [Nix Flake](https://nixos.wiki/wiki/Flakes) that declaratively manages:

- **System packages** — CLI tools installed via Nix
- **Homebrew casks & Mac App Store apps** — GUI applications managed through [nix-homebrew](https://github.com/zhaofengli/nix-homebrew)
- **macOS system preferences** — Dock, Finder, login window, and Control Center settings

## File Structure

The configuration is split into focused modules for easier maintenance:

```
nix-darwin/
├── flake.nix              # Flake inputs and module wiring
├── flake.lock             # Pinned dependency versions
├── modules/
│   ├── packages.nix       # Nix system packages (CLI tools)
│   ├── homebrew.nix       # Homebrew brews, casks, and Mac App Store apps
│   └── system.nix         # macOS system preferences and nix settings
├── LICENSE
└── README.md
```

| File | Purpose | When to edit |
|------|---------|-------|
| `flake.nix` | Defines flake inputs and wires modules together | Adding new flake inputs or modules |
| `modules/packages.nix` | Nix CLI packages (`environment.systemPackages`) | Adding or removing CLI tools |
| `modules/homebrew.nix` | Homebrew brews, casks, and Mac App Store apps | Adding or removing GUI apps |
| `modules/system.nix` | macOS defaults (Dock, Finder, etc.) and nix settings | Changing system preferences |

## Prerequisites

### Basic Prerequisites

- macOS on Apple Silicon (`aarch64-darwin`)
- An administrator account
- A working internet connection

### Rosetta 2 Installation (for running x86_64 apps)

```bash
softwareupdate --install-rosetta
```

### Clean Bash and Zsh profiles

Nix will try to create these files and complain is they already exist. 

```
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

## Step 1 — Install Nix

Install Nix using the official multi-user installer:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

After installation, restart your terminal and verify Nix is working:

```bash
nix-shell -p fastfetch --run fastfetch
```

> [!NOTE]
> `nix-shell -p <package>` lets you temporarily use a package without permanently installing it.

## Step 2 — Enable Flakes

Flakes are an experimental Nix feature that must be explicitly enabled. If you haven't enabled them system-wide yet, you can pass the flag inline:

```bash
--extra-experimental-features 'nix-command flakes'
```

This is configured permanently in this flake via:

```nix
nix.settings.experimental-features = "nix-command flakes";
```

## Step 3 — Clone This Repository

```bash
git clone https://github.com/stevenplatt/nix-darwin.git ~/Documents/github/nix-darwin
cd ~/Documents/github/nix-darwin
```

## Step 4 — Bootstrap nix-darwin

If this is a fresh machine and nix-darwin is not yet installed, bootstrap it by running:

```bash
sudo nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake .#Stevens-MacBook-Air
```

> [!IMPORTANT]
> The hostname after `#` must match your Mac's hostname. This flake uses `Stevens-MacBook-Air`. You can check yours with `hostname`.

## Step 5 — Apply the Configuration

Once nix-darwin is installed, apply changes with:

```bash
sudo darwin-rebuild switch --flake ~/Documents/github/nix-darwin#Stevens-MacBook-Air
```

> [!TIP]
> Always use `./` or the full path to the flake directory. Using just the directory name (e.g., `nix-darwin`) causes Nix to look up the flake registry instead of the local directory.

## Updating

### Update flake inputs (Nix packages, nix-darwin, nix-homebrew)

```bash
nix flake update --flake ~/Documents/github/nix-darwin
```

### Rebuild after updating

```bash
sudo darwin-rebuild switch --flake ~/Documents/github/nix-darwin#Stevens-MacBook-Air
```

## What's Configured

### System Packages (via Nix)

CLI tools installed in the system profile. Browse available packages at [search.nixos.org](https://search.nixos.org/).

| Package | Description |
|---------|-------------|
| `vim` | Text editor |
| `awscli2` | AWS CLI v2 |
| `google-cloud-sdk` | Google Cloud SDK |
| `kubectl` | Kubernetes CLI |
| `kubernetes-helm` | Helm package manager |
| `ansible` | Automation tool |
| `fastfetch` | System info display |

### Homebrew Casks (GUI Applications)

Managed declaratively through [nix-homebrew](https://github.com/zhaofengli/nix-homebrew). These are installed and kept in sync automatically.

| Cask |
|------|
| `affinity` |
| `antigravity` |
| `applite` |
| `balenaetcher` |
| `discord` |
| `docker-desktop` |
| `google-chrome` |
| `lens` |
| `logi-options+` |
| `slack` |
| `the-unarchiver` |
| `zoom` |
| `zotero` |

### Mac App Store Apps

Installed via `mas` (Mac App Store CLI). Each entry needs the app's numeric ID.

| App | ID |
|-----|----|
| Davinci Resolve | `571213070` |
| Mela | `1568924476` |
| Slack | `803453959` |
| Swift Playground | `1496833156` |
| WhatsApp | `310633997` |
| XCode | `497799835` |

### macOS System Preferences

Configured under `system.defaults`. Reference all available options at [MyNixOS](https://mynixos.com/nix-darwin/options/system.defaults).

| Setting | Value |
|---------|-------|
| Dock autohide | `true` |
| Dock orientation | `left` |
| Finder view style | Column view |
| Finder show path bar | `true` |
| Finder show hidden files | `true` |
| Finder default folder | Documents |
| Guest account | Disabled |
| Battery show percentage | `true` |
| Hot corner (top-right) | Mission Control |

### Homebrew Settings

| Setting | Description |
|---------|-------------|
| `onActivation.cleanup = "zap"` | Remove packages installed outside of Nix |
| `onActivation.autoUpdate = true` | Auto-update Homebrew on activation |
| `onActivation.upgrade = true` | Upgrade all casks on activation |
| `mutableTaps = false` | Prevent imperative `brew tap` commands |

## Customization

### Adding a new CLI tool

Add the package to the list in `modules/packages.nix`:

```nix
environment.systemPackages = with pkgs; [
  vim
  your-new-package   # ← add here
];
```

### Adding a new Homebrew cask

Add the cask name to `homebrew.casks` in `modules/homebrew.nix`:

```nix
homebrew.casks = [
  "your-new-cask"   # ← add here
];
```

### Adding a Mac App Store app

Find the app's numeric ID (visible in the App Store URL) and add it to `homebrew.masApps` in `modules/homebrew.nix`:

```nix
homebrew.masApps = {
  "App Name" = 123456789;   # ← add here
};
```

### Changing macOS system preferences

Browse available options at [MyNixOS — system.defaults](https://mynixos.com/nix-darwin/options/system.defaults) and add them under `system.defaults` in `modules/system.nix`:

```nix
system.defaults = {
  dock.autohide = true;
  # Add more settings here
};
```

Then rebuild:

```bash
sudo darwin-rebuild switch --flake ~/Documents/github/nix-darwin#Stevens-MacBook-Air
```

## References

- [Nix Official Website](https://nixos.org/)
- [Nix Package Search](https://search.nixos.org/)
- [nix-darwin GitHub](https://github.com/nix-darwin/nix-darwin)
- [nix-homebrew GitHub](https://github.com/zhaofengli/nix-homebrew)
- [MyNixOS — nix-darwin options](https://mynixos.com/nix-darwin/options/system.defaults)
- [Dreams of Autonomy — Nix on macOS (YouTube)](https://www.youtube.com/watch?v=Z8BL8mdzWHI)
- [Dreams of Autonomy — Video Amendments](https://github.com/dreamsofautonomy/nix-darwin-amendments)
- [Spotlight Fix for Nix Apps (Gist)](https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3)

## License

[MIT](LICENSE)
