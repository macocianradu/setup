require("scrollbar").setup({
    -- Shows marks for gitsigns (add, change, delete)
    providers = {
        gitsigns = true,
    },
    -- You can customize the marks used
    marks = {
        GitAdd = { highlight = { fg = "#39993A" } },
        GitChange = { highlight = { fg = "#61AFEF" } },
        GitDelete = { highlight = { fg = "#E06C75" } },
        Error = { highlight = { fg = "#E06C75" } },
        Warn = { highlight = { fg = "#E5C07B" } },
        Info = { highlight = { fg = "#61AFEF" } },
        Hint = { highlight = { fg = "#C678DD" } },
    },
    scrollbar = {
        track = { highlight = { bg = "#2d353b" } },
        thumb = { highlight = { bg = "#7fbbb3" } },
    },
})
