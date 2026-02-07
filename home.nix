{ config, pkgs, ... }:

{
  # This is the state version for Home Manager
  home.stateVersion = "25.11";

  home.username = "amir";
  home.homeDirectory = "/home/amir";

  fonts.fontconfig.enable = true;

  # Base user packages (not managed by programs.*)
  home.packages = with pkgs; [
    neovim
    git
    htop

    # Qtile / desktop related
    brightnessctl
    flameshot
    betterlockscreen
    rofi
    pcmanfm

    # Terminal tools (some are enabled via programs.* but listed here for clarity)
    ripgrep
    fd

    # extract file 
    unzip
    unrar
    p7zip
    zstd
  ];

  # Import modular configurations
  imports = [
    ./modules/terminal.nix
    # ./modules/desktop.nix      # uncomment later
    # ./modules/editor.nix       # uncomment later
    # ./modules/git.nix          # uncomment later
  ];
}
