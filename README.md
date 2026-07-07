# Neovim Config (NvChad v2.5)

My personal Neovim setup built on top of [NvChad](https://github.com/NvChad/NvChad) v2.5.
This README is a setup guide for getting the config running on a **new machine** plus a
**cheatsheet** of the commands I always forget.

---

## 1. What this is

- **Base:** NvChad v2.5 (loaded as a plugin, pinned to branch `v2.5`).
- **Plugin manager:** [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-bootstraps on first launch).
- **Leader key:** `<Space>`
- **Config lives in:** `~/.config/nvim/lua/custom/`

Everything I customize is under `lua/custom/` so NvChad itself stays untouched.

```
lua/
├── chadrc.lua              # NvChad theme/UI overrides (theme = "aquarium")
└── custom/
    ├── autocmds.lua        # custom autocommands
    ├── mappings.lua        # custom keymaps (jk = ESC, ; = :, etc.)
    ├── options.lua         # custom vim options
    ├── configs/            # per-plugin config tables
    │   ├── cmp.lua         # completion
    │   ├── conform.lua     # formatters (format on save)
    │   ├── gitdiffview.lua # diffview.nvim config
    │   ├── lspconfig.lua   # LSP servers
    │   ├── telescope.lua
    │   ├── treesitter.lua
    │   └── ...
    └── plugins/
        └── init.lua        # my plugin list
```

---

## 2. Prerequisites

Install these **before** launching nvim. Commands are for **Arch Linux** (`pacman`);
adjust for your distro.

### Core (required)

```bash
sudo pacman -S neovim git ripgrep fd unzip gcc make
```

- **neovim** ≥ 0.10 (0.11+ recommended — this config uses the newer `vim.lsp.config` API)
- **git** — plugin manager + fugitive/diffview
- **ripgrep** (`rg`) & **fd** — Telescope live-grep / file finding
- **gcc / make** — compiling Treesitter parsers
- A **Nerd Font** (for icons) — e.g. `ttf-jetbrains-mono-nerd`:

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

Then set your terminal to use that font.

### Language runtimes (only what you use)

```bash
# JS/TS, web LSPs, prettier
sudo pacman -S nodejs npm

# Python
sudo pacman -S python python-pip

# C# (roslyn.nvim)
sudo pacman -S dotnet-sdk

# Flutter/Dart (flutter-tools.nvim) — via AUR or the official SDK
# yay -S flutter
```

### Optional: image.nvim (inline images)

Only works well in **Kitty** and needs ImageMagick:

```bash
sudo pacman -S imagemagick
```

If you're not on Kitty, you can disable the `3rd/image.nvim` block in
`lua/custom/plugins/init.lua`.

### Optional: WakaTime

`wakatime/vim-wakatime` tracks coding time. On first launch it asks for an API key
(stored in `~/.wakatime.cfg`). Remove the plugin if you don't want it.

---

## 3. Install on a new machine

```bash
# Back up any existing config first!
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

# Clone this repo into place
git clone <your-repo-url> ~/.config/nvim

# (Optional) if this is your own config and you don't want its git history:
# rm -rf ~/.config/nvim/.git

# Launch — lazy.nvim bootstraps itself and installs all plugins
nvim
```

On first launch:

1. **lazy.nvim** auto-clones and installs every plugin (watch the popup).
2. **Treesitter** parsers compile in the background.
3. **Mason** (bundled with NvChad) is where LSP servers / formatters get installed.

After it settles, restart nvim once so the theme cache builds cleanly.

---

## 4. Installing LSP servers, formatters & linters

Two options:

### A) Via Mason (recommended, self-contained)

Open the Mason UI and install what you need:

```
:Mason
```

Press `i` on a package to install, `X` to uninstall, `U` to update. Search with `/`.

**LSP servers this config expects** (`lua/custom/configs/lspconfig.lua`):

```
html  cssls  tailwindcss  ts_ls  jsonls  eslint  pyright  ruff  lua_ls  qmlls
```

Plus, managed by their own plugins (not in the list above):
- **roslyn** — C# (`seblj/roslyn.nvim`)
- **dartls** — via `flutter-tools.nvim`

**Formatters** (`lua/custom/configs/conform.lua`) — install via Mason or system:

| Language        | Formatter            |
|-----------------|----------------------|
| Lua             | `stylua`             |
| JS/TS/CSS/HTML/JSON/YAML/MD | `prettier` |
| Python          | `black`              |
| C / C++         | `clang-format`       |
| Java            | `google-java-format` |
| C#              | `csharpier`          |

### B) System-wide (alternative)

```bash
sudo pacman -S lua-language-server stylua prettier python-black clang
npm install -g prettier   # if not from pacman
pip install black ruff
```

> Tip: after installing servers, run `:checkhealth` to confirm nvim sees them.

---

## 5. Command cheatsheet

### Plugin management (lazy.nvim)

| Command        | What it does                                  |
|----------------|-----------------------------------------------|
| `:Lazy`        | Open the plugin dashboard                     |
| `:Lazy sync`   | Install missing + update + clean unused       |
| `:Lazy update` | Update all plugins                            |
| `:Lazy install`| Install missing plugins                       |
| `:Lazy clean`  | Remove plugins no longer in the config        |
| `:Lazy restore`| Pin plugins back to `lazy-lock.json`          |
| `:Lazy profile`| Startup time profiler                         |

### LSP / Mason / Treesitter

| Command                    | What it does                          |
|----------------------------|---------------------------------------|
| `:Mason`                   | Install/manage LSPs, formatters       |
| `:LspInfo`                 | Show LSP clients for current buffer   |
| `:LspRestart`              | Restart LSP clients                   |
| `:checkhealth`             | Diagnose config/tooling issues        |
| `:TSInstall <lang>`        | Install a Treesitter parser           |
| `:TSUpdate`                | Update all parsers                    |

### Editing / LSP keymaps (defaults)

| Key          | Action                          |
|--------------|---------------------------------|
| `gd`         | Go to definition                |
| `gr`         | Go to references                |
| `gi`         | Go to implementation            |
| `K`          | Hover docs                      |
| `<leader>ca` | Code action                     |
| `<leader>ra` | Rename symbol                   |
| `[d` / `]d`  | Prev / next diagnostic          |
| `<leader>fm` | Format buffer (conform)         |

### Formatting

- **Format on save** is ON by default.
- Toggle it off for the session: `:lua vim.g.disable_autoformat = true` (set back to `false` to re-enable).
  - There's no keymap wired for this yet; add one in `mappings.lua` if you want (e.g. `<leader>tf`).
- Manual format: `<leader>fm` or `:lua require("conform").format()`.

### Telescope (fuzzy finder)

| Key          | Action                    |
|--------------|---------------------------|
| `<leader>ff` | Find files                |
| `<leader>fw` | Live grep (search text)   |
| `<leader>fb` | Find open buffers         |
| `<leader>fh` | Help tags                 |
| `<leader>fo` | Recent files              |

### File tree (nvim-tree)

| Key         | Action                            |
|-------------|-----------------------------------|
| `<C-n>`     | Toggle file tree (opens on right) |
| `<leader>e` | Focus file tree                   |

### Git — fugitive

| Command        | What it does                                   |
|----------------|------------------------------------------------|
| `:Git`         | Status window (stage/unstage/commit here)      |
| `:Git add .`   | Stage everything                               |
| `:Git commit`  | Commit (opens message buffer, `:wq` to save)   |
| `:Gdiffsplit`  | Side-by-side diff of current file              |
| `:G blame`     | Inline git blame                               |

Inside the `:Git` status window:
- `s` = stage item under cursor · `u` = unstage · `=` = toggle inline diff
- `cc` = start a commit · `X` = discard change under cursor

### Git — diffview

| Command                    | What it does                          |
|----------------------------|---------------------------------------|
| `:DiffviewOpen`            | Full-repo diff of working changes     |
| `:DiffviewOpen main..HEAD` | Diff a range / against a branch       |
| `:DiffviewClose`           | Close the diff view                   |
| `:DiffviewFileHistory`     | History of the whole repo             |
| `:DiffviewFileHistory %`   | History of the current file           |

Inside diffview:
- `<Tab>` / `<S-Tab>` = next / prev file · `j`/`k` = move in file panel
- `[x` / `]x` = jump between merge conflicts

### Multi-cursor (vim-visual-multi)

| Key      | Action                                  |
|----------|-----------------------------------------|
| `<C-d>`  | Select next occurrence of word (VS Code style) |
| `<C-S-d>`| Select all occurrences                  |

### My custom mappings

| Key   | Mode | Action              |
|-------|------|---------------------|
| `;`   | n    | Enter command mode (`:`) |
| `jk`  | i    | Escape to normal mode    |
| `<leader>tw` | n/v | Toggle whitespace view (visual-whitespace) |

### NvChad essentials

| Key          | Action                     |
|--------------|----------------------------|
| `<leader>th` | Theme picker               |
| `<leader>ch` | NvChad cheatsheet (all keymaps!) |
| `<Tab>` / `<S-Tab>` | Cycle buffers/tabs  |
| `<leader>x`  | Close current buffer       |

> Forgot a key? Just hit `<leader>ch` in nvim for the full searchable cheatsheet.

---

## 6. Updating & maintenance

```bash
# Update plugins
nvim  →  :Lazy sync

# Update Treesitter parsers
nvim  →  :TSUpdate

# Update LSPs/formatters
nvim  →  :Mason  (press U)
```

Commit `lazy-lock.json` to pin exact plugin versions across machines.

---

## 7. Troubleshooting

- **Icons look like boxes** → install & select a Nerd Font in your terminal.
- **Telescope live-grep does nothing** → install `ripgrep` (`rg`).
- **Treesitter errors on install** → need a C compiler (`gcc`/`clang`) + `make`.
- **LSP not attaching** → `:LspInfo`, then install the server via `:Mason`.
- **Images not rendering** → `image.nvim` needs Kitty + `imagemagick`; otherwise disable it.
- **Everything broken after an update** → `:Lazy restore` to roll back to `lazy-lock.json`.
- **General diagnosis** → `:checkhealth`.

---

## Credits

- [NvChad](https://github.com/NvChad/NvChad) — the base framework.
- [LazyVim starter](https://github.com/LazyVim/starter) — inspiration for NvChad's starter.
