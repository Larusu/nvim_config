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
  "qmlls",        -- for quickshell or qml
  "clangd",       -- for C / C++
  "rust_analyzer", -- for Rust
  "gopls",        -- for Go
  -- NOTE: Java (jdtls) is managed by nvim-jdtls (see plugins/init.lua), NOT here.
  -- Like flutter-tools/roslyn, adding "jdtls" to this list would spawn a second,
  -- conflicting LSP client on Java buffers.
  "bashls",       -- for Bash / shell scripts
  "marksman",     -- for Markdown
  "dockerls",     -- for Dockerfiles
  "yamlls",       -- for YAML
  "taplo",        -- for TOML
  "intelephense", -- for PHP / Laravel
  "sqls",         -- for SQL (schema-aware; connects to DBs)
  "postgres_lsp"  -- for PostgreSQL (syntax checking via libpg_query)
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

vim.lsp.config("qmlls", {
  capabilities = nvlsp.capabilities,
  on_attach = on_attach,
  cmd = { "/usr/lib/qt6/bin/qmlls" },
  filetypes = { "qml", "qmljs" },
  root_markers = { "CMakeLists.txt", "*.pro", ".git" },
  settings = {
    qmlls = {
      buildDir = vim.fn.getcwd() .. "/build",  -- adjust to your build dir
    },
  },
})

-- IMPORTANT: pin `filetypes` for the SQL servers. If the installed nvim-lspconfig
-- version doesn't ship a base config for a server (postgres_lsp is fairly new),
-- vim.lsp.config creates a config with NO filetype filter, and vim.lsp.enable
-- then attaches it to *every* buffer (e.g. spamming SQL errors on C#/Python).
vim.lsp.config("sqls", {
  capabilities = nvlsp.capabilities,
  on_attach = on_attach,
  filetypes = { "sql", "mysql" },
})

-- The Postgres LS binary was renamed (postgrestools -> postgres-language-server),
-- so point the command at the new executable explicitly.
vim.lsp.config("postgres_lsp", {
  capabilities = nvlsp.capabilities,
  on_attach = on_attach,
  cmd = { "postgres-language-server", "lsp-proxy" },
  filetypes = { "sql" },
})

vim.lsp.enable(servers)

return {
  on_attach = on_attach,
  capabilities = nvlsp.capabilities,
}
