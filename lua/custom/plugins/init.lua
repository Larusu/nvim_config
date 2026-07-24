return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "custom.configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    -- Load BEFORE the file is read so nvim-lspconfig's `lsp/<server>.lua` base
    -- configs (which provide each server's `cmd`) are on the runtimepath before
    -- `vim.lsp.enable()` resolves them. Loading later (e.g. on "User FilePost")
    -- resolves every server with `cmd = nil` and nothing attaches.
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "custom.configs.lspconfig"
    end,
  },
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
  {
    "mcauley-penney/visual-whitespace.nvim",
    opts = require "custom.configs.whitespace",
    keys = {
      {
        "<leader>tw",
        function()
          require("visual-whitespace").toggle()
        end,
        mode = { "n", "v" },
        desc = "Toggle whitespace",
      },
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
      },
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
      require "custom.configs.cmp" -- You'll need to create this file
    end,
  },
  {
    "wakatime/vim-wakatime",
    lazy = false, -- WakaTime should always run to track your time
  },
  {
    "3rd/image.nvim",
    build = false, -- no need to build
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {},
      max_width = 100,
      max_height = 30,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "3rd/image.nvim",  -- for image rendering
    },
    config = function()
      require("telescope").setup(require("custom.configs.telescope"))
    end,
  },
  {
    "mg979/vim-visual-multi",
    lazy = false, -- this is the multiple cursor like VS Code
    init = function()
      vim.g.VM_mouse_mappings = 1
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Select All"] = "<C-S-d>",
      }
    end,
  },
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "custom.configs.treesitter",
    vim.filetype.add {
      extension = { qml = "qmljs" },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPre", "BufNewFile" }, -- lazy-load for performance
    config = function()
      require("nvim-highlight-colors").setup(require "custom.configs.highlightcolor")
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {}, -- uses defaults, which are already great
  },
  {
    -- for Java: manages the jdtls server (install it with :MasonInstall jdtls)
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls_cfg = require "custom.configs.jdtls"
      -- Start jdtls for every Java buffer (each project gets its own workspace).
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = jdtls_cfg.start,
      })
      -- The buffer that triggered this ft-load already fired FileType, so start now.
      jdtls_cfg.start()
    end,
  },
  {
    -- Spring Boot support (bean nav, application.properties/yml completion).
    -- Provides jdtls extension jars consumed in custom/configs/jdtls.lua.
    -- Needs the server jars: :MasonInstall vscode-spring-boot-tools
    -- (NOT "spring-boot-tools" — that name only exists in nvim-java's registry)
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {},
  },
  {
    -- for CSharp
    "seblj/roslyn.nvim",
    ft = "cs", -- only loads when opening a .cs file
    config = function()
      local nvlsp = require "custom.configs.lspconfig"
      require("roslyn").setup {
        config = {
          capabilities = nvlsp.capabilities,
          on_attach = nvlsp.on_attach,
        },
      }
    end,
  },
  -- NOTE: Both flutter-tools and roslyn.nvim manage their own LSP lifecycle internally. 
  -- Adding dartls to servers would cause two conflicting LSP instances to attach 
  -- to your Dart buffers.
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
      local nvlsp = require "custom.configs.lspconfig"
      require("flutter-tools").setup {
        lsp = {
          on_attach = nvlsp.on_attach,
          capabilities = nvlsp.capabilities,
        },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    config = function()
      require("diffview").setup(require "custom.configs.gitdiffview")
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gwrite", "Gread", "Gvdiffsplit" },
  },
}
