-- nvim-jdtls setup: starts a per-project jdtls server for each Java buffer.
--
-- Two ways to provide the jdtls server (this config auto-detects which):
--   1. System install (recommended on Arch, fast):  yay -S jdtls
--      -> puts a `jdtls` launcher on $PATH; we just call it.
--   2. Mason:  :MasonInstall jdtls
--      -> we build the full `java -jar ...launcher.jar` command ourselves.
--
-- Kept out of lspconfig.lua's server list so we don't spawn two competing
-- LSP clients on the same buffer.

local M = {}

function M.start()
  local ok, jdtls = pcall(require, "jdtls")
  if not ok then
    vim.notify("nvim-jdtls not available", vim.log.levels.WARN)
    return
  end

  -- Reuse the shared on_attach / capabilities from the main LSP config.
  local nvlsp = require "custom.configs.lspconfig"

  -- Detect the project root; fall back to the file's directory.
  local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", ".git" }
  local root_dir = require("jdtls.setup").find_root(root_markers)
  if not root_dir or root_dir == "" then
    root_dir = vim.fn.fnamemodify(vim.fn.expand "%:p", ":h")
  end

  -- One isolated workspace dir per project (jdtls requirement).
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. project_name

  -- Build `cmd`: prefer a system `jdtls` launcher (e.g. from the AUR package),
  -- otherwise fall back to the Mason jar-based invocation.
  local cmd
  if vim.fn.executable "jdtls" == 1 then
    cmd = { "jdtls", "-data", workspace_dir }
  else
    local mason = vim.fn.stdpath "data" .. "/mason/packages/jdtls"
    local launcher = vim.fn.glob(mason .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
    if launcher == "" then
      vim.notify(
        "jdtls not found — install it with `yay -S jdtls` or `:MasonInstall jdtls`",
        vim.log.levels.ERROR
      )
      return
    end
    local os_config = "config_linux"
    if vim.fn.has "mac" == 1 then
      os_config = "config_mac"
    elseif vim.fn.has "win32" == 1 then
      os_config = "config_win"
    end
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", launcher,
      "-configuration", mason .. "/" .. os_config,
      "-data", workspace_dir,
    }
  end

  -- Extra jdtls plugin bundles (Spring Boot, debug, tests, ...).
  local bundles = {}
  local has_spring, spring_boot = pcall(require, "spring_boot")
  if has_spring then
    vim.list_extend(bundles, spring_boot.java_extensions())
  end

  local config = {
    name = "jdtls",
    cmd = cmd,
    root_dir = root_dir,
    capabilities = nvlsp.capabilities,
    on_attach = nvlsp.on_attach,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" }, -- decompiler for .class files
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
          },
        },
        sources = {
          organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
        },
      },
    },
    init_options = { bundles = bundles },
  }

  jdtls.start_or_attach(config)
end

return M
