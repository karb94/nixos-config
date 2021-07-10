-- INSTALL PACKER IF NOT PRESENT
local function file_exists(path)
    return vim.fn.empty(vim.fn.glob(path)) == 0
end
local install_path = '.local/share/nvim/site/pack/packer/start/packer.nvim'
local abs_install_path = vim.env.HOME ..  '/' .. install_path
local repo = 'https://github.com/wbthomason/packer.nvim'
local git_clone_cmd = '!git clone ' .. repo .. ' ' .. abs_install_path
-- If Packer directory does not exist clone repo and initialize Packer
if not file_exists(abs_install_path) then
    vim.api.nvim_command(git_clone_cmd)
    vim.api.nvim_command('packadd packer.nvim')
end


-- PLUGINS
return require('packer').startup(function()

    local plugins = {
        {'wbthomason/packer.nvim'},
        {'lukas-reineke/indent-blankline.nvim', branch='lua'},
        {'~/projects/neoscroll.nvim'},
        {'karb94/neoscroll.nvim'},
        {'machakann/vim-sandwich'},
        {'b3nj5m1n/kommentary'},
        {'TimUntersberger/neogit', requires='nvim-lua/plenary.nvim'},
        {'norcalli/nvim-colorizer.lua'},
        {'wellle/targets.vim'},
        {'romainl/vim-cool'},
        {'Vimjas/vim-python-pep8-indent', ft={'py'}},
        {'neomake/neomake', ft={'cpp'}},
        {'junegunn/vim-easy-align'},
        {'lervag/vimtex'},
        {'karb94/gruvbox.nvim', requires='rktjmp/lush.nvim'},
        {'mfussenegger/nvim-dap'},
        {'neovim/nvim-lspconfig', ft={'py', 'cpp', 'sh', 'tex', 'lua'}},
        {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'},
        {'nvim-treesitter/playground',
            requires='nvim-treesitter/nvim-treesitter'
        },
        {'nvim-treesitter/nvim-treesitter-textobjects',
            requires='nvim-treesitter/nvim-treesitter'
        },
        {'hrsh7th/nvim-compe'},
        {'~/projects/telescope.nvim',
            requires={'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
        },
        {'nvim-telescope/telescope-project.nvim',
            requires={'~/projects/telescope.nvim'},
        },
        {'nvim-telescope/telescope-fzf-native.nvim',
            requires={'~/projects/telescope.nvim'}, run = 'make'
        }
    }
    --[[ {'nvim-telescope/telescope.nvim',
        requires={'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    },
    {'nvim-telescope/telescope-project.nvim',
        requires={'nvim-telescope/telescope.nvim'},
    },
    {'nvim-telescope/telescope-fzf-native.nvim',
        requires={'nvim-telescope/telescope.nvim'}, run = 'make'
    } ]]

    local function check_for_config_file(repo)
        if file_exists(config_abs_path) then
            return config_rel_path
        else
            return nil
        end
    end

    local lua_dir = vim.env.HOME .. '/.config/nvim/lua/'
    for _, plugin in ipairs(plugins) do
        local plugin_repo = plugin[1]
        if plugin.config == nil then
            local filename = plugin_repo:gmatch('[/^]([^/%.]+)[^/]*$')()
            local plugins_folder = 'plugins/'
            local config_abs_path = table.concat({
                lua_dir, plugins_folder, filename, '.lua'
            })
            if file_exists(config_abs_path) then
                plugin.config = table.concat({
                    "require('", plugins_folder, filename, "')"
                })
            end
        end
        use(plugin)
    end

end)