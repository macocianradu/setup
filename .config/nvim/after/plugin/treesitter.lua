local ts = require('nvim-treesitter')

ts.setup{}

ts.install({
    "vimdoc",
    "javascript",
    "typescript",
    "c_sharp",
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "yaml",
    "haskell"
})

vim.api.nvim_create_autocmd('FileType', {
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        local available_langs = ts.get_available()
        local is_available = vim.tbl_contains(available_langs, lang)
        if is_available then
            local installed_langs = ts.get_installed()
            local installed = vim.tbl_contains(installed_langs, lang)
            if not installed then
                ts.install(lang):await()
            end
            vim.treesitter.start()
            ts.indentexpr()
        end
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
