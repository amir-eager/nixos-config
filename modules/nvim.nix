{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [ ripgrep fd git gcc nil lua-language-server ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      plenary-nvim
      nvim-treesitter.withAllGrammars
    ];

    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      -- bootstrap lazy
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        spec = {
          { "folke/tokyonight.nvim", lazy = false, priority = 1000,
            config = function() vim.cmd.colorscheme "tokyonight" end
          },
          { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
          { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        },
        performance = { rtp = { reset = false } },
      })
    '';
  };
}
