{ config, pkgs, ... }:

{
  # ──────────────────────────────────────────────────────────────
  # Zsh Configuration
  # ──────────────────────────────────────────────────────────────

  programs.zsh = {
    enable = true;

    # History settings - large, shared, smart deduplication
    history = {
      size = 1000000;
      save = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    # Enable built-in features
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Antidote - lightweight & fast plugin manager
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-completions kind:fpath"
        "zsh-users/zsh-autosuggestions"
        "zdharma-continuum/fast-syntax-highlighting"
        # fzf-tab رو حذف کن — دستی source می‌کنیم
      ];
    };

    # Custom initialization code (runs after everything else)
    # initExtra = ''
    initContent = ''
      # ── Shell options (setopt) ─────────────────────────────────────
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt EXTENDED_GLOB
      setopt NO_BEEP
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_FIND_NO_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt INC_APPEND_HISTORY

      # Source fzf-tab manually from Nixpkgs (stable and no hash needed)
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # fzf-tab styling & preview
      zstyle ':fzf-tab:complete:*' fzf-preview 'eza -1 --color=always -- "$realpath"'
      zstyle ':fzf-tab:*' switch-group ','

      # Completion menu & case-insensitive matching
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Completion cache
      autoload -Uz compinit
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
      compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

      # Function for extracting any archive file
      extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.tar.xz)    tar xJf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.zst)   unzstd $1    ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
    '';

    # Common aliases (ls family, tmux, nvim, config editing)
    shellAliases = {
      ls  = "eza --icons --group-directories-first";
      ll  = "eza -l --icons --group-directories-first --time-style=long-iso";
      la  = "eza -la --icons";
      lt  = "eza --tree --level=2 --icons";

      cat = "bat --style=plain";

      # tmux shortcuts
      t   = "tmux";
      ta  = "tmux attach -t";
      tn  = "tmux new -s";
      tl  = "tmux list-sessions";
      tk  = "tmux kill-session -t";

      # nvim shortcuts
      v   = "nvim";
      vi  = "nvim";
      vim = "nvim";
      vs  = "tmux split-window -h nvim";
      vh  = "tmux split-window -v nvim";

      # Quick config edit
      ez  = "$EDITOR ~/.config/home-manager/home.nix";
    };
  };

  # ──────────────────────────────────────────────────────────────
  # Starship Prompt
  # ──────────────────────────────────────────────────────────────

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # ──────────────────────────────────────────────────────────────
  # fzf - Fuzzy finder
  # ──────────────────────────────────────────────────────────────

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  # ──────────────────────────────────────────────────────────────
  # zoxide - Smart cd command
  # ──────────────────────────────────────────────────────────────

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ──────────────────────────────────────────────────────────────
  # Better ls & cat
  # ──────────────────────────────────────────────────────────────

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.bat.enable = true;
}
