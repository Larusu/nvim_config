local actions = require "diffview.actions"

return {
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See |diffview-config-enhanced_diff_hl|
  git_cmd = { "git" },      -- The git executable followed by default args.
  hg_cmd = { "hg" },        -- The hg executable followed by default args.
  use_icons = true,         -- Requires nvim-web-devicons
  show_help_hints = true,   -- Show hints for how to open the help panel
  watch_index = true,       -- Update views and index buffers when the git index changes.
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  view = {
    -- Configure the layout and behavior of different types of views.
    -- Available layouts:
    --  'diff1_plain'
    --    |'diff2_horizontal'
    --    |'diff2_vertical'
    --    |'diff3_horizontal'
    --    |'diff3_vertical'
    --    |'diff3_mixed'
    --    |'diff4_mixed'
    -- For more info, see |diffview-config-view.x.layout|.
    default = {
      -- Config for changed files, and staged files in diff views.
      layout = "diff2_horizontal",
      disable_diagnostics = false,  -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = false,          -- See |diffview-config-view.x.winbar_info|
    },
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_horizontal",
      disable_diagnostics = true,   -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = true,           -- See |diffview-config-view.x.winbar_info|
    },
    file_history = {
      -- Config for changed files in file history views.
      layout = "diff2_horizontal",
      disable_diagnostics = false,  -- Temporarily disable diagnostics for diff buffers while in the view.
      winbar_info = false,          -- See |diffview-config-view.x.winbar_info|
    },
  },
  file_panel = {
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
    win_config = {                      -- See |diffview-config-win_config|
      position = "left",
      width = 35,
      win_opts = {},
    },
  },
  file_history_panel = {
    log_options = {   -- See |diffview-config-log_options|
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
      hg = {
        single_file = {},
        multi_file = {},
      },
    },
    win_config = {    -- See |diffview-config-win_config|
      position = "bottom",
      height = 16,
      win_opts = {},
    },
  },
  commit_log_panel = {
    win_config = {},  -- See |diffview-config-win_config|
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See |diffview-config-hooks|
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      { "n", "<tab>",   actions.select_next_entry, { desc = "Open the diff for the next file" } },
      { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
      { "n", "[x",      actions.prev_conflict,     { desc = "In the merge-tool: jump to the previous conflict" } },
      { "n", "]x",      actions.next_conflict,     { desc = "In the merge-tool: jump to the next conflict" } },
      -- NOTE: THERE ARE SO MANY KEYMAPS IN REPO. IF YOU WANT MORE GO THERE
    },
    diff1 = {
      -- Mappings in single window diff layouts
      { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
    },
    file_panel = {
      { "n", "j",      actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
      { "n", "<down>", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
      { "n", "k",      actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
      { "n", "<up>",   actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
    },
  },
}
