{ config, pkgs, ... }:

{
  home.username = "amir";
  home.homeDirectory = "/home/amir";
  home.stateVersion = "25.11";

  # اینجا بعداً برنامه‌ها و dotfiles رو اضافه می‌کنیم
  home.packages = with pkgs; [
    # مثلاً
    neovim
    git
  ];

  # مثلاً zsh رو فعال کنیم
  programs.zsh.enable = true;
}
