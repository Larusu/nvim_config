local function shiftwidth(ctx)
  return tostring(vim.bo[ctx.buf].shiftwidth)
end

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

  formatters = {
    -- JS, TS, JSX/TSX, CSS, SCSS, JSON, YAML, HTML, Markdown, GraphQL, and Vue
    prettier = {
      prepend_args = function(_, ctx)
        return { "--tab-width", shiftwidth(ctx) }
      end,
    },
    ["clang-format"] = {
      prepend_args = function(_, ctx)
        local w = shiftwidth(ctx)
        return {
          "--style={BasedOnStyle: LLVM, IndentWidth: " .. w .. ", TabWidth: " .. w .. ", UseTab: Never}",
        }
      end,
    },
    ["google-java-format"] = {
      prepend_args = { "--aosp" }, -- AOSP style = 4-space indent
    },
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
