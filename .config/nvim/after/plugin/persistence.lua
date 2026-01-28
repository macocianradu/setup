vim.keymap.set("n", "<leader>ql", function() require("persistence").load() end)
vim.keymap.set("n", "<leader>qs", function() require("persistence").select() end)
vim.keymap.set("n", "<leader>qL", function() require("persistence").load({ last = true }) end)
vim.keymap.set("n", "<leader>sq", function() require("persistence").stop() end)

