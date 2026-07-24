local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    vue = { "prettier" },
    python = { "black" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    java = { "google-java-format" },
    cs = { "csharpier" },
    rust = { "rustfmt" },
    go = { "gofmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    toml = { "taplo" },
    php = { "pint" }, -- Laravel Pint (uses project ./vendor/bin/pint when present)
    blade = { "blade-formatter" },
    sql = { "sql_formatter" },
    pgsql = { "sql_formatter" },
  },

  format_on_save = function(bufnr)
    -- Disable with global variable
    -- toggle format using <leader>tf
    if vim.g.disable_autoformat then
      return
    end
    return {
      timeout_ms = 1000,
      lsp_fallback = true,
    }
  end,
}

return options
