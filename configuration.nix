# configuration.nix — Base system configuration for NixOS
# Only essential settings: boot, user, networking, sound, bluetooth, and base terminal (zsh).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";

  # Main user
  users.users.amir = {
    isNormalUser = true;
    description = "amir";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.zsh;  # Set zsh as default shell
  };

  # Sound with pipewire (recommended for 2025+)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth base
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Base X server (for GUI if needed, but no WM yet)
  services.xserver.enable = true;

  # Essential system packages (focus on terminal tools)
  environment.systemPackages = with pkgs; [
    vim git curl wget htop tree ripgrep fd bat
    inetutils pciutils usbutils
  ];

  # Allow unfree packages (for future needs)
  nixpkgs.config.allowUnfree = true;

  # Enable zsh system-wide with basic completion
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Experimental features for flakes (optional but useful)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System state version
  system.stateVersion = "25.11";
}
