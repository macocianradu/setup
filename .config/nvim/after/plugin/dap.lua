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

require("dap-python").setup("~/projects/odoo/venv/bin/python3")
dap.adapters['pwa-chrome'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
        command = 'node',
        args = {
            vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '${port}',
        },
    }
}

local function run_odoo_test_at_cursor()
    -- Safely get the node at cursor
    local status, node = pcall(vim.treesitter.get_node)
    if not status or not node then
        print("Error: Tree-sitter parser not found. Ensure you are in a Python buffer.")
        return
    end

    -- Safety Limit: Prevent infinite loop if tree is malformed
    local attempts = 0
    while node do
        if node:type() == 'function_definition' then
            break
        end
        node = node:parent()
        attempts = attempts + 1
        if attempts > 50 then
            print("Error: Could not find function definition (traversal limit reached).")
            return
        end
    end

    if not node then
        print("Cursor is not inside a function definition.")
        return
    end

    -- Extract function name safely
    local func_name = nil
    for child in node:iter_children() do
        if child:type() == 'identifier' then
            func_name = vim.treesitter.get_node_text(child, 0)
            break
        end
    end

    if not func_name then
        print("Error: Could not extract function name.")
        return
    end

    local db = vim.fn.input("Database: ")
    if db == nil or db == "" then
        print("Canceled (no database provided).")
        return
    end

    print("Launching Debugger for: " .. func_name)

    dap.run({
        type = "python",
        request = "launch",
        name = "Debug Test: " .. func_name,
        pythonPath = "/home/admac/projects/odoo/venv/bin/python3",
        program = "/home/admac/projects/odoo/odoo/odoo-bin",
        args = {
            "--addons-path", "/home/admac/projects/odoo/enterprise/,/home/admac/projects/odoo/odoo/addons/",
            "-d", db,
            "--log-level=warn",
            "--test-tags", "." .. func_name,
            "--stop-after-init",
        },
        console = "externalTerminal",
    })
end

vim.keymap.set("n", "<leader>5", function() dap.continue() end)
vim.keymap.set("n", "<leader>6", function() dap.step_over() end)
vim.keymap.set("n", "<leader>+", function() dap.step_into() end)
vim.keymap.set("n", "<leader>-", function() dap.step_out() end)
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
vim.keymap.set("n", "<leader>qd", function() dap.terminate() end)
vim.keymap.set("n", "<leader>rd", function() dap.restart() end)
vim.keymap.set("n", "<leader>dt", run_odoo_test_at_cursor, { desc = "Debug Odoo Test unde Cursor" })

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
