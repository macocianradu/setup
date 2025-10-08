local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("*", {
    capabilities = capabilities
})
-- vim.lsp.config("ts_ls", {})
vim.lsp.config("ruff", {})
vim.lsp.config("cssls", {})
vim.lsp.config("lua_ls", {})
vim.lsp.config("odoo_ls", {})
vim.lsp.config("lemminx", {})
vim.lsp.config("eslint", {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  root_markers = { ".eslintrc", ".eslintrc.json", ".eslintrc.js", "package.json", ".git" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  settings = {
    validate = "on",
    packageManager = "npm",
    workingDirectory = { mode = "auto" },
    debug = true,
    format = true,
  },
})

vim.lsp.enable({"odoo_ls", "ruff", "eslint", "cssls", "lua_ls", "lemminx"})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '<leader>gi', function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', '<leader>vca', function()
            vim.lsp.buf.code_action({
                context = {
                    diagnostics = vim.diagnostic.get(0),
                    only = { 'quickfix', 'refactor', 'source' }
                }
            })
        end, opts)
        vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
        vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set('n', '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
    end,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }


cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "xml",
    callback = function()
        vim.bo.indentexpr = ""
        vim.bo.cindent = false
        vim.bo.smartindent = false
    end
})

-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
