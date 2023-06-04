--vim.g.gruvbox_contrast_dark = 'hard'
--vim.g.gruvbox_contrast_light = 'soft'
--vim.g.gruvbox_sign_column = 'bg0'
--vim.cmd('colorscheme gruvbox')

return {
  "ellisonleao/gruvbox.nvim",
  priority=1000,
  opts = {
    inverse = false,
    contrast = "hard",
    overrides = {
      SignColumn = {bg = "#1d2021"},
      CursorLineNr = {
          bg = "#1d2021",
          bold = true
      },
    }
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.cmd([[colorscheme gruvbox]])
  end,
}
