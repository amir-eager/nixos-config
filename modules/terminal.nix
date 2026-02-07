{ config, pkgs, ... }:

{
  # ──────────────────────────────────────────────────────────────
  # Zsh Configuration
  # ──────────────────────────────────────────────────────────────

  programs.zsh = {
    enable = true;

    history = {
      size = 1000000;
      save = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-completions kind:fpath"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };

    initContent = ''
      # Shell options
      setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS EXTENDED_GLOB NO_BEEP
      setopt HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS INC_APPEND_HISTORY

      # Improved fzf-tab preview
      zstyle ':fzf-tab:complete:*' fzf-preview '
        if [[ -d $realpath ]]; then
          eza -1 --color=always -- "$realpath"
        elif [[ -f $realpath ]]; then
          bat --color=always --style=plain -- "$realpath" || file -- "$realpath"
        else
          file -- "$realpath"
        fi'

      zstyle ':fzf-tab:*' switch-group ','

      # Completion styling
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Completion cache (always check freshness)
      autoload -Uz compinit
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
      if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit
      else
        compinit -C
      fi

      # Extract function
      extract () {
        if [ -f "$1" ] ; then
          case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.tar.xz)    tar xJf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *.deb)       ar x "$1"      ;;
            *.tar.zst)   unzstd "$1"    ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
    '';

    shellAliases = {
      ls  = "eza --icons --group-directories-first";
      ll  = "eza -l --icons --group-directories-first --time-style=long-iso";
      la  = "eza -la --icons";
      lt  = "eza --tree --level=2 --icons";

      cat = "bat --style=plain";

      # tmux
      t   = "tmux";
      ta  = "tmux attach -t";
      tn  = "tmux new -s";
      tl  = "tmux list-sessions";
      tk  = "tmux kill-session -t";

      # nvim
      v   = "nvim";
      vi  = "nvim";
      vim = "nvim";
      vs  = "tmux split-window -h nvim";
      vh  = "tmux split-window -v nvim";

      # Quick edit
      ez  = "$EDITOR ~/.config/home-manager/home.nix";

      # New: show key bindings
      bk  = "bindkey";
      bk-v = "bindkey -M vicmd";
      bk-i = "bindkey -M viins";
    };
  };

  # بقیه بخش‌ها (starship, fzf, zoxide, eza, bat) بدون تغییر
  programs.starship.enable = true;
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.eza.enable = true;
  programs.bat.enable = true;
}
