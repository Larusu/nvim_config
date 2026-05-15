package.path = package.path .. ";/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua"
package.cpath = package.cpath .. ";/usr/lib/lua/5.1/?.so"

local img_previewer = function(filepath, bufnr, opts)
  local image_ok, image_api = pcall(require, "image")

  if image_ok then
    image_api.clear()
  end

  local is_image = filepath:match("%.png$")
    or filepath:match("%.jpg$")
    or filepath:match("%.jpeg$")
    or filepath:match("%.gif$")
    or filepath:match("%.webp$")
    or filepath:match("%.svg$")

  if is_image and image_ok then
    local img = image_api.from_file(filepath, {
      buffer = bufnr,        -- the buffer telescope created for the preview window
      window = opts.winid,   -- the window ID of the preview pane
      with_virtual_padding = true,  -- adds blank lines so image doesn't overlap text
      x = 1,                 -- horizontal offset from left edge (in cells)
      y = 1,                 -- vertical offset from top edge (in cells)
      width = opts.winwidth and (opts.winwidth - 2) or 70,   -- image width: uses preview window width minus 2 cells for padding, falls back to 70 if unknown
      height = opts.winheight and (opts.winheight - 2) or 30, -- image height: uses preview window height minus 2 cells for padding, falls back to 30 if unknon
    })
    if img then
      img:render()
    end
  else
    -- properly fall back to default file previewer
    require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
  end
end

return {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "top",  -- search bar at top
      horizontal = {
        preview_width = 0.55,  -- preview takes 60% of width, file list gets 40%
      },
    },
    sorting_strategy = "ascending",  -- so results sort top-down
    file_ignore_patterns = {},
    buffer_previewer_maker = img_previewer,
  },
  pickers = {
    find_files = {
      hidden = true,
      no_ignore = true,
    },
  },
}
