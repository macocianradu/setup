require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls",
        "cssls",
        "angularls",
        "tsserver",
        "eslint" },
}
