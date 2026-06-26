local dap = require("dap")

local M = {}

-- Locate the delve binary (prefer mason, fall back to PATH).
local function dlv_command()
    local mason = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/dlv")
    if vim.fn.filereadable(mason) == 1 then
        return mason
    end
    return "dlv"
end

-- Adapter: run delve in DAP server mode on a free port.
dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
        command = dlv_command(),
        args = { "dap", "-l", "127.0.0.1:${port}" },
    },
}

-- Walk upwards from the current file to find the Go module root (go.mod).
local function find_go_root()
    local start = vim.fn.expand("%:p:h")
    if start == "" then
        start = vim.fn.getcwd()
    end
    local found = vim.fs.find("go.mod", { upward = true, path = start })[1]
    if found then
        return vim.fn.fnamemodify(found, ":h")
    end
    return nil
end

-- Find the module root and launch a delve debug session of the whole project.
function M.debug_go()
    local root = find_go_root()
    if not root then
        vim.notify("No go.mod found upwards from current file.", vim.log.levels.ERROR)
        return
    end
    dap.run({
        type = "go",
        request = "launch",
        name = "Debug project",
        program = root,
        cwd = root,
    })
end

return M
