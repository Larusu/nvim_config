vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { 
    "git",
    "clone",
    "--filter=blob:none",
    repo,
    "--branch=stable",
    lazypath 
  }
end

vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:prepend(lazypath)
--indentation
vim.opt.expandtab = true -- to allow <tab> 
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
-- ui
vim.opt.relativenumber = true
vim.opt.scrolloff = 12
vim.opt.termguicolors = true
-- line length guide
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80" -- if text goes beyond 80, not make a new line

local lazy_config = require "custom.configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "custom.plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "custom.options"
require "custom.autocmds"

vim.schedule(function()
  require "custom.mappings"
end)
