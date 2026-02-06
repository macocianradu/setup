require('lualine').setup({
    sections = {
        lualine_c = {
            {
                function()
                    return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                end,
            },
            'filename',
        },
    },
})
