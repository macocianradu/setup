require("scrollbar").setup({
    -- Shows marks for gitsigns (add, change, delete)
    handlers = {
        gitsigns = true,
    },
    -- You can customize the marks used
    marks = {
        GitAdd = { color = "#39993A" },
        GitChange = { color = "#61AFEF" },
        GitDelete = { color = "#E06C75" },
        DiagnosticError = { color = "#E06C75" },
        DiagnosticWarn = { color = "#E5C07B" },
        DiagnosticInfo = { color = "#61AFEF" },
        DiagnosticHint = { color = "#C678DD" },
    },
    handle = { color = "#a7c979", },
})

vim.api.nvim_set_hl(0, "Scrollbar", { bg = "#2d353b" })
vim.api.nvim_set_hl(0, "ScrollbarHandle", { bg = "#7fbbb3" })
