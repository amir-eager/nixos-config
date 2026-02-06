{ config, pkgs, ... }:

{
  # نسخه state برای home-manager
  home.stateVersion = "25.11";

  # username و homeDirectory (اختیاری اگر useUserPackages=true باشه)
  home.username = "amir";
  home.homeDirectory = "/home/amir";

  # برنامه‌های نمونه که فقط برای کاربر amir نصب می‌شن
  home.packages = with pkgs; [
    neovim
    git
    htop
    # بعداً می‌تونی zsh, tmux, qtile config و ... اضافه کنی
    # ----- qtlie apps -----
    brightnessctl
    flameshot
    betterlockscreen
    rofi-wayland   # یا rofi اگر X11 هست
    pcmanfm
  ];

  # مثلاً zsh رو فعال کنیم (اختیاری)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
  };

  # اینجا بعداً dotfiles مثل ~/.config/qtile/config.py رو تعریف می‌کنیم
}
