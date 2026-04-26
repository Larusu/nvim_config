return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "custom.configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("custom.configs.lspconfig")
    end,
  },
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood"
  },
  {
    'mcauley-penney/visual-whitespace.nvim',
    opts = require 'custom.configs.whitespace',
    keys = {
      {
        "<leader>tw",
        function()
          require("visual-whitespace").toggle()
        end,
        mode = { "n", "v" },
        desc = "Toggle whitespace",
      }
    },
    event = "ModeChanged", -- optionally, lazy load on entering visual mode
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = true, -- enables git integration
        ignore = false, -- show files/directories listed in gitignore
      },
      filters = {
        dotfiles = false,
      },
      view = {
        side = "right",
        width = 32,
      }
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-nvim-lsp-signature-help", --remove since incompatible with nvim 0.12+
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require "custom.configs.cmp"  -- You'll need to create this file
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false, -- WakaTime should always run to track your time
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = require "custom.configs.telescope",
  },
  {
    "mg979/vim-visual-multi",
    lazy = false, -- this is the multiple cursor like VS Code
    init = function()
      vim.g.VM_mouse_mappings = 1
      vim.g.VM_maps = {
        ['Find Under']         = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
        ["Select All"]         = "<C-S-d>",
      }
    end,
  },
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  		  "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript",
        "python",
        "json",
      },
      highlight = {
        enable = true,
      }
  	},
  },
}
