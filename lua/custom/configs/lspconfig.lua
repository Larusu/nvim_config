require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

local on_attach = function(client, bufnr)
  nvlsp.on_attach(client, bufnr)
end

-- List of servers to enable
local servers = {
  "html",
  "cssls",
  "tailwindcss",
  "ts_ls",
  "jsonls",
  "eslint",
  "pyright",
  "ruff",
  "lua_ls", -- for hyprland
  -- "qmlls"         -- for quickshell or qml
}

-- Setup servers using the new API
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    capabilities = nvlsp.capabilities,
    on_attach = on_attach,
  })
end

vim.lsp.config("pyright", {
  capabilities = nvlsp.capabilities,
  on_attach = on_attach,

  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        -- Optional but useful
        autoImportCompletions = true,
      },
    },
  },
})

vim.lsp.enable(servers)
