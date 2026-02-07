# home.nix — User-specific configuration with Home-Manager
# Manages dotfiles, user packages, themes, and programs for amir

{ config, pkgs, ... }:

{
  # Important: must match the NixOS stateVersion
  home.stateVersion = "25.11";

  home.username = "amir";
  home.homeDirectory = "/home/amir";

  # ──────────────────────────────────────────────────────────────
  # User packages (not managed by programs.*)
  # ──────────────────────────────────────────────────────────────

  home.packages = with pkgs; [
    # Editors & dev tools
    neovim
    git

    # System monitoring
    htop

    # Desktop utilities
    brightnessctl
    flameshot
    betterlockscreen
    rofi           # application launcher
    pcmanfm        # lightweight file manager with thumbnails

    # Terminal & search tools
    ripgrep
    fd
    bat            # cat with syntax highlighting

    # Archive extraction
    unzip
    unrar
    p7zip
    zstd
  ];


  # ──────────────────────────────────────────────────────────────
  # Modular imports (add one by one as we progress)
  # ──────────────────────────────────────────────────────────────

  imports = [
    ./modules/terminal.nix
    # ./modules/desktop.nix
    # ./modules/editor.nix
    # ./modules/git.nix
  ];
}
