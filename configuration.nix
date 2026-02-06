# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # ────────────────────────────────────────────────────────────────
  # Keyboard layout: US + Persian (Iran) - switch with Alt + Shift
  # ────────────────────────────────────────────────────────────────
  services.xserver.xkb = {
    layout  = "us,ir";
    options = "grp:alt_shift_toggle";     # Left Alt + Shift switches between layouts
    # اگر می‌خوای Right Alt + Shift باشه:
    # options = "grp:lalt_shift_toggle,grp_led:scroll";   # یا فقط grp:ralt_shift_toggle
  };

  # ────────────────────────────────────────────────────────────────
  # Qtile window manager + lightdm (light display manager)
  # ────────────────────────────────────────────────────────────────
  services.xserver.windowManager.qtile = {
    enable = true;

    # اضافه کردن پکیج‌های اضافی برای ویجت‌ها و امکانات بیشتر (اختیاری ولی مفید)
    extraPackages = pythonPackages: with pythonPackages; [
      qtile-extras
    ];
  };

  services.xserver.displayManager.lightdm.enable = true;
  # اگر می‌خوای greeter ساده‌تر یا متفاوت:
  # services.xserver.displayManager.lightdm.greeters.gtk.enable = true;

  # کاملاً غیرفعال کردن GNOME و حذف پکیج‌های اضافی‌اش
  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = false;

  environment.gnome.excludePackages = (with pkgs; [
    gnome.gnome-terminal
    gnome.nautilus
    gnome.gnome-system-monitor
    gnome.eog
    gnome.totem
    gnome.gedit
    gnome.cheese
    gnome.geary
    gnome.gnome-music
    gnome.gnome-photos
    gnome.gnome-calendar
    gnome.gnome-maps
    gnome.gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-shell
    gnome-shell-extensions
    gdm
  ]);

  # کاربر شما
  users.users.amir = {
    isNormalUser = true;
    description = "amir";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages (اگر بعداً nvidia یا چیزهای دیگه اضافه شد)
  nixpkgs.config.allowUnfree = true;

  # پکیج‌های پایه + چیزهای مفید برای Qtile
  environment.systemPackages = with pkgs; [
    vim git curl wget htop tree unzip ripgrep fd bat
    inetutils pciutils usbutils

    # برای Qtile و استفاده روزمره
    alacritty      # ترمینال سریع (پیشنهاد می‌کنم)
    rofi           # launcher (Super + d یا Mod + d)
    firefox
    # picom        # compositor برای transparency و سایه‌ها (اختیاری)
  ];

  # Sound with pipewire (keep as is)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Nix experimental features (keep as is)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
