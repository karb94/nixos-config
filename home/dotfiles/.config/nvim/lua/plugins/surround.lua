return {
  "kylechui/nvim-surround",
  opts = {
    keymaps = {
      insert = "<C-g>s",
      insert_line = "<C-g>S",
      normal = "gs",
      normal_cur = "gss",
      normal_line = "gS",
      normal_cur_line = "gSS",
      visual = "s",
      visual_line = "ss",
      delete = "ds",
      change = "cs",
      change_line = "cS",
    },
  },
}
