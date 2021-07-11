require('telescope').setup {
    extensions = {
        project = {
            base_dirs = {vim.env.HOME .. '/projects/'},
            max_depth = 2
        }
    }
}

require'telescope'.load_extension('project')

-- Mappings
local map = function(mode, keymap, command, opts)
    opts = opts or { noremap = true, silent = true }
    vim.api.nvim_set_keymap(mode, keymap, command, opts)
end

map('n', '<leader>fp', [[:Telescope project display_type=full<CR>]])
