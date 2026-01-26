local harpoon = require("harpoon");

harpoon:setup({
    settings = {
        save_on_toggle = true,

        key = function()
            local branch = vim.fn.system("git branch --show-current 2> /dev/null")
            if branch == "" then
                return vim.loop.cwd()
            else
                return vim.loop.cwd() .. "-" .. branch
            end
        end,
    },
})

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
