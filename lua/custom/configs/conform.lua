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
