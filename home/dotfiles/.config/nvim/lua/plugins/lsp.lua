local servers = {
  "bashls",
  "lua_ls",
  "nil_ls",
  "vimls",
  --"clangd",
  --"pyright",
  --"texlab",
}

-- Remove annoying popup
-- See https://github.com/neovim/nvim-lspconfig/pull/2536
local lua_ls_settings = {
  Lua = {
    workspace = {
      checkThirdParty = false,
    },
  },
}

local config = function()
  local lspconfig = require("lspconfig")
  for _, lsp in ipairs(servers) do
    if lsp == "lua_ls"
    then
      lspconfig[lsp].setup({settings = lua_ls_settings})
    else
      lspconfig[lsp].setup({})
    end
  end
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    end,
  })
end


return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "folke/neodev.nvim", config = true },
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  config = config,
}
