require("oil").setup({
    float = {
        padding = 2,
        max_width = 120,
        max_height = 0,
        border = "rounded",
        win_options = {
            winblend = 15,
        },
        preview_split = "vertical"
    },
    keymaps = {
        ["q"] = "actions.close",
        ["<Esc>"] = "actions.close",
    },
    view_options = {
        show_hidden = true
    }
})
