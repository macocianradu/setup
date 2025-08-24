require('mason').setup {}
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls",
        "cssls",
        "angularls",
        "roslyn",
        "gopls",
        "ts_ls",
        "eslint" },
}
