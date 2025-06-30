require('mason').setup {}
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls",
        "cssls",
        "angularls",
        "gopls",
        "ts_ls",
        "eslint" },
}
