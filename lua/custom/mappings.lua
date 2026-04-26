require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>"

-- LuaSnip keybinds for snippet choice navigation
map("i", "<C-j>", "<Plug>luasnip-next-choice", {})
map("s", "<C-j>", "<Plug>luasnip-next-choice", {})
map("i", "<C-k>", "<Plug>luasnip-prev-choice", {})
map("s", "<C-k>", "<Plug>luasnip-prev-choice", {})

-- Format with Conform (replaces Prettier keybinds)
map("n", "<leader>re", function()
  require("conform").format { lsp_fallback = true, async = false, timeout_ms = 1000 }
end, { desc = "Format buffer" })

map("v", "<leader>re", function()
  require("conform").format { lsp_fallback = true, async = false, timeout_ms = 1000 }
end, { desc = "Format selection" })

-- :Format on save toggle
map("n", "<leader>tf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  print("Format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
end, { desc = "Toggle format on save" })
