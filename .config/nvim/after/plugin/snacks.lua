require("snacks").setup {
    image = {
        enabled = true,
        resolve = function(path, src)
            local api = require "obsidian.api"
            if api.path_is_note(path) then
                return api.resolve_attachment_path(src)
            end
        end
    },
    indent = {
        enabled = true,
        indent = {
            enabled = true,
            char = "┆"
        },
        scope = {
            enabled = true,
            char = "│"
        }
    },
    picker = {
        enabled = true,
        ui_select = true,
        formatters = {
            file = {
                truncate = "left",
                min_width = 160,
            },
        },
    },
    dashboard = {
        enabled = true,
    },
}

if vim.env.TMUX then
    local term = require("snacks.image.terminal")
    pcall(vim.fn.system, { "tmux", "set", "-p", "allow-passthrough", "all" })
    term.transform = function(data)
        return ("\027Ptmux;" .. data:gsub("\027", "\027\027")) .. "\027\\"
    end
    local name = vim.trim(vim.fn.system({ "tmux", "display-message", "-p", "#{client_termname}" }))
    term._terminal = { terminal = (name:gsub("^xterm%-", "")), version = "unknown" }
end

local picker = Snacks.picker
vim.keymap.set('n', '<leader>pf', function() picker.files() end)
vim.keymap.set('n', '<C-p>p', function() picker.git_files() end)
vim.keymap.set('n', '<leader>sw', function() picker.lsp_workspace_symbols() end)
vim.keymap.set('n', '<leader>ps', function()
    picker.grep({ search = vim.fn.input("Grep > "), live = false })
end)

