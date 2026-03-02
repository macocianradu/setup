local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.after.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.after.event_exited["dapui_config"] = function() dapui.close() end

local dotnet = require("dap.dap-dotnet")
local odoo = require("dap.dap-odoo")
local haskell = require("dap.dap-haskell")


vim.keymap.set("n", "<leader>5", function()
    if odoo.is_odoo_project() then
        odoo.debug_odoo()
        return
    end
    local ft = vim.bo.filetype
    if ft == "cs" or ft == "fsharp" or ft == "vb" then
        dotnet.debug_dotnet_from_sln()
        return
    end

    if dotnet.find_sln_upwards and dotnet.find_sln_upwards() then
        dotnet.debug_dotnet_from_sln()
        return
    end

    dap.continue()
end)

vim.keymap.set("n", "<leader><Up>", function() dap.continue() end)
vim.keymap.set("n", "<leader><Down>", function() dap.step_over() end)
vim.keymap.set("n", "<leader><Right>", function() dap.step_into() end)
vim.keymap.set("n", "<leader><Left>", function() dap.step_out() end)
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
vim.keymap.set("n", "<leader>qd", function() dap.terminate() end)
vim.keymap.set("n", "<leader>rd", function() dap.restart() end)
vim.keymap.set("n", "<leader>dt", odoo.run_odoo_test_at_cursor, { desc = "Debug Odoo Test unde Cursor" })

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch Odoo",
        program = "/home/admac/projects/odoo/odoo/odoo-bin",
        pythonPath = function()
            return "/home/admac/projects/odoo/venv/bin/python3"
        end,
        args = function()
            local db_name = vim.fn.input('Odoo DB: ', 'master')
            return {
                "--addons-path", "/home/admac/projects/odoo/enterprise/,/home/admac/projects/odoo/odoo/addons/",
                "--dev", "all",
                "-d", db_name
            }
        end
    }
}

dap.configurations.javascript = {
    {
        type = "pwa-chrome",
        request = "attach",
        name = "Launch Odoo JS Tour",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        port = 9222,
        webRoot = '${workspaceFolder}',
        sourceMaps = true,
        protocol = 'inspector',
    }
}
