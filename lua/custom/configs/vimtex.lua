-- viewer
vim.g.vimtex_view_method = "zathura"

-- keep the pdf next to .tex file, then hide all the junk files
-- (.aux/.log/etc.) in build/
vim.g.vimtex_compiler_latexmk = {
  aux_dir = "build",
  -- stop generating synctex: for clean output
  -- options = {
  --   "-verbose",
  --   "-file-line-error",
  --   "-synctex=0",
  --   "-interaction=nonstopmode",
  -- },
}
