{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    aichat
    ansible
    argocd
    awscli2
    cmatrix
    coreutils
    fastfetch
    gh
    go
    google-cloud-sdk
    htop
    iperf3
    jetbrains-mono
    jq
    k9s
    kind
    kubectl
    kubernetes-helm
    nmap
    stern
    tree
    unzip
    vim
    watch
    wget
  ];
}
