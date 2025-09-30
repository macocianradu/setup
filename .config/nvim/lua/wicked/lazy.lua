-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            'nvim-telescope/telescope.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {
            'neanias/everforest-nvim',
            config = function()
                vim.cmd('colorscheme everforest')
            end
        },

        'macocianradu/odoo-neovim',
        'nvim-treesitter/nvim-treesitter',
        'theprimeagen/harpoon',
        'mbbill/undotree',
        'tpope/vim-surround',
        'nvim-telescope/telescope-ui-select.nvim',
        'idanarye/vim-merginal',
        'sphamba/smear-cursor.nvim',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        {
            "NeogitOrg/neogit",
            dependencies = {
                "sindrets/diffview.nvim", -- optional - Diff integration
            },
            config = true
        },
        'neovim/nvim-lspconfig',
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
        },
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        {
            'mfussenegger/nvim-dap',
            dependencies = {
                'mfussenegger/nvim-dap-python',
                'rcarriga/nvim-dap-ui',
                'nvim-neotest/nvim-nio'
            }
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "everforest" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
