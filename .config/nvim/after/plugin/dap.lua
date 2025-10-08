local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.after.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.after.event_exited["dapui_config"] = function()
    dapui.close()
end

require("dap-python").setup("~/Projects/odoo/venv/bin/python3")

vim.keymap.set("n", "<leader>5", function() dap.continue() end)
vim.keymap.set("n", "<leader>6", function() dap.step_over() end)
vim.keymap.set("n", "<leader>+", function() dap.step_into() end)
vim.keymap.set("n", "<leader>-", function() dap.step_out() end)
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
vim.keymap.set("n", "<leader>qd", function() dap.terminate() end)
vim.keymap.set("n", "<leader>rd", function() dap.restart() end)

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch Odoo",
        program = "/home/odoo/Projects/odoo/odoo/odoo-bin",
        pythonPath = function()
            return "/home/odoo/Projects/odoo/venv/bin/python3"
        end,
        args = {
            "--addons-path", "/home/odoo/Projects/odoo/enterprise/,/home/odoo/Projects/odoo/odoo/addons/",
            "--dev", "all",
            "-d", "rd-pos"
        }
    }
}
