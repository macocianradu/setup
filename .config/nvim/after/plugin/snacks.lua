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
    terminal = {
        enabled = true,
    },
}

local picker = Snacks.picker
vim.keymap.set('n', '<leader>pf', function() picker.files() end)
vim.keymap.set('n', '<C-p>p', function() picker.git_files() end)
vim.keymap.set('n', '<leader>sw', function() picker.lsp_workspace_symbols() end)
vim.keymap.set('n', '<leader>ps', function()
    picker.grep({ search = vim.fn.input("Grep > "), live = false })
end)

local term_buf

local function find_term_win()
    if not (term_buf and vim.api.nvim_buf_is_valid(term_buf)) then return end
    for _, w in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(w) == term_buf then return w end
    end
end

local function toggle_term(fullscreen)
    local win_opts = fullscreen and {
        position = "float",
        width = 0.98,
        height = 0.98,
        border = "rounded",
    } or {
        position = "bottom",
        height = 0.2,
        border = "none",
    }

    local existing = find_term_win()
    if existing then
        local is_float = vim.api.nvim_win_get_config(existing).relative ~= ""
        vim.api.nvim_win_close(existing, true)
        if is_float == fullscreen then return end
    end

    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
        Snacks.win(vim.tbl_extend("force", win_opts, {
            buf = term_buf,
            enter = true,
            bo = { filetype = "snacks_terminal" },
        }))
        vim.cmd.startinsert()
    else
        local term = Snacks.terminal.toggle(nil, { win = win_opts })
        if term then term_buf = term.buf end
    end
end

vim.keymap.set({ "n", "t" }, "<leader>tt", function() toggle_term(false) end, { desc = "Terminal (split)" })
vim.keymap.set({ "n", "t" }, "<leader>tT", function() toggle_term(true) end, { desc = "Terminal (fullscreen)" })
