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
        {
            'shaunsingh/nord.nvim'
        },
        {
            "thgrund/tidal.nvim",
            opts = {
                boot = {
                    tidal = {
                        cmd = os.getenv("HOME") .. "/.ghcup/bin/ghci",
                        highlight = {
                            autostart = true,
                        },
                    },
                    sclang = {
                        enabled = true ,
                        file = os.getenv("HOME") .. "/.local/share/tidal/BootSuperDirt.scd",
                    },
                },
            },
            -- Recommended: Install TreeSitter parsers for Haskell and SuperCollider
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                opts = { ensure_installed = { "haskell", "supercollider" } },
            },
        },
        'odoo/odoo-neovim',
        'nvim-treesitter/nvim-treesitter',
        {
            'theprimeagen/harpoon',
            branch = 'harpoon2',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        'petertriho/nvim-scrollbar',
        'mbbill/undotree',
        {
            "MeanderingProgrammer/render-markdown.nvim",
            ft = { "markdown", "codecompanion" }
        },
        {
            "olimorris/codecompanion.nvim",
            version = "^18.0.0",
            opts = {
                opts = {
                    log_level = "TRACE",
                },
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
                "ravitemer/codecompanion-history.nvim",
            },
        },
        'tpope/vim-surround',
        'nvim-telescope/telescope-ui-select.nvim',
        'sphamba/smear-cursor.nvim',
        {
            "folke/persistence.nvim",
            event = "BufReadPre",
            opts = {
                dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")
            }
        },
        'williamboman/mason.nvim',
        {
            'obsidian-nvim/obsidian.nvim',
            ft = "markdown",
            --- @module 'obsidian'
            --- @type obsidian.config
            opts = {
                legacy_commands = false,
                ui = {
                    enable = false,
                },
                workspaces = {
                    {
                        name = "personal",
                        path = "~/notes",
                    }
                }
            }
        },
        "folke/snacks.nvim",
        'lewis6991/gitsigns.nvim',
        'tpope/vim-projectionist',
        'williamboman/mason-lspconfig.nvim',
        {
            "NeogitOrg/neogit",
            dependencies = {
                "sindrets/diffview.nvim", -- optional - Diff integration
            },
            config = true
        },
        {
            'nvimdev/dashboard-nvim',
            event = 'VimEnter',
            config = function()
                require('dashboard').setup {
                    -- config
                }
            end,
            dependencies = { { 'nvim-tree/nvim-web-devicons' } }
        },
        'neovim/nvim-lspconfig',
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
        },
        'hrsh7th/cmp-nvim-lsp',
        {
            'stevearc/oil.nvim',
            dependencies = { { "nvim-mini/mini.icons" } }
        },
        {
            "linrongbin16/gitlinker.nvim",
            cmd = "GitLink",
            opts = {},
            keys = {
                { "<leader>gy", "<cmd>GitLink<cr>",        mode = { "n", "v" }, desc = "Yank git link" },
                { "<leader>gY", "<cmd>GitLink!<cr>",       mode = { "n", "v" }, desc = "Open git link" },
                { "<leader>gB", "<cmd>GitLink! blame<cr>", mode = { "n", "v" }, desc = "Open git blame link" },
            },
        },
        'hrsh7th/cmp-buffer',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        {
            'mfussenegger/nvim-dap-python',
            dependencies = {
                'mfussenegger/nvim-dap',
                'rcarriga/nvim-dap-ui',
                'nvim-neotest/nvim-nio'
            },
            build = false,
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "everforest" } },
    -- automatically check for plugin updates
    rocks = {
        hererocks = true
    },
    checker = {
        enabled = true,
        frequency = 86400
    }
})
