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

vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

local function attach(buf, lang)
    if not vim.api.nvim_buf_is_loaded(buf) then
        return
    end
    -- start() throws when the parser can't be loaded or its queries don't
    -- compile against it; never let that escape into the FileType chain.
    if not pcall(vim.treesitter.start, buf, lang) then
        return
    end
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.wo[win][0].foldmethod = 'expr'
        vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
end

-- Buffers waiting on an in-flight install, keyed by language, so opening two
-- files of the same new language doesn't start two concurrent installs.
local pending = {}

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('wicked.treesitter', { clear = true }),
    callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang or not vim.list_contains(ts.get_available(), lang) then
            return
        end
        -- Check for the compiled parser specifically: a language whose queries
        -- were linked but whose compile failed must not count as installed.
        if vim.list_contains(ts.get_installed('parsers'), lang) then
            attach(ev.buf, lang)
            return
        end
        if pending[lang] then
            table.insert(pending[lang], ev.buf)
            return
        end
        pending[lang] = { ev.buf }
        -- install() is async: start highlighting only once it has finished.
        ts.install(lang):await(function()
            vim.schedule(function()
                local bufs = pending[lang]
                pending[lang] = nil
                for _, buf in ipairs(bufs) do
                    attach(buf, lang)
                end
            end)
        end)
    end,
})
