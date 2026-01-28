local function get_root ()
    local root = vim.fs.root(0, ".git")
    return root or vim.fn.getcwd()
end

vim.keymap.set("n", "<leader>ql", function() require("persistence").load() end)
vim.keymap.set("n", "<leader>qs", function()
    vim.api.nvim_set_current_dir(get_root())
    require("persistence").save()
    require("persistence").select()
end)
vim.keymap.set("n", "<leader>qL", function() require("persistence").load({ last = true }) end)
vim.keymap.set("n", "<leader>sq", function() require("persistence").stop() end)

