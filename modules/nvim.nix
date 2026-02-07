{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # پکیج‌های اضافی که nvim نیاز داره (مثلاً برای telescope grep و ...)
    extraPackages = with pkgs; [
      ripgrep
      fd
      git
      gcc
      nodejs_20    # اگر بعداً برای某些 lspها لازم شد
      lua-language-server
      nil   # lsp برای nix
      stylua   # formatter برای lua
    ];

    plugins = with pkgs.vimPlugins; [
      # پایه lazy
      lazy-nvim

      # بقیه پلاگین‌ها رو lazy داخل lua مدیریت می‌کنه
      # فقط چندتا dependency مهم که بهتره از nix بیاد
      plenary-nvim
      nvim-treesitter.withAllGrammars   # یا فقط grammars مورد نیازت
    ];

    extraLuaConfig = ''
      -- تنظیمات اولیه
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", -- latest stable release
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        spec = {
          -- اینجا پلاگین‌ها رو import می‌کنیم (می‌تونی فایل جدا کنی)
          { import = "plugins" },   -- اگر می‌خوای plugins/ directory داشته باشی
        },

        performance = {
          rtp = {
            reset = false,   # مهم برای nix
          },
        },

        -- ui قشنگ‌تر
        ui = {
          border = "rounded",
        },

        -- lockfile برای reproducibility (اختیاری ولی خوبه)
        lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
      })
    '';
  };

  # اگر می‌خوای فایل‌های lua جداگانه داشته باشی
  xdg.configFile."nvim/lua/plugins" = {
    source = ./nvim/lua/plugins;   # فولدر plugins رو خودت بساز
    recursive = true;
  };

  # یا مستقیم چند پلاگین مهم رو اینجا تعریف کن (اختیاری)
  xdg.configFile."nvim/lua/plugins/core.lua".text = ''
    return {
      -- tokyonight
      { "folke/tokyonight.nvim", lazy = false, priority = 1000,
        config = function()
          require("tokyonight").setup({ style = "storm" })
          vim.cmd.colorscheme "tokyonight"
        end,
      },

      -- telescope
      { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          require("telescope").setup {}
        end,
      },

      -- treesitter
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup {
            ensure_installed = { "lua", "nix", "rust", "python", "bash", "markdown" },
            highlight = { enable = true },
            indent = { enable = true },
          }
        end,
      },

      -- و بقیه پلاگین‌ها ...
    }
  '';
}
