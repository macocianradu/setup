local dap = require("dap")

local M = {}

-- Adapter (netcoredbg)
dap.adapters.coreclr = {
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg",
    args = { "--interpreter=vscode" },
}

-- -------- helpers --------

local function is_windows()
    return vim.loop.os_uname().sysname:match("Windows") ~= nil
end

local function joinpath(...)
    local sep = is_windows() and "\\" or "/"
    return table.concat({ ... }, sep)
end

local function parent_dir(path)
    return vim.fn.fnamemodify(path, ":h")
end

local function file_exists(path)
    return vim.fn.filereadable(path) == 1
end

local function find_csproj_upwards()
    local start = vim.api.nvim_buf_get_name(0)
    if start ~= "" then
        start = parent_dir(start)
    else
        start = vim.fn.getcwd()
    end

    local projs = vim.fs.find(function(name)
        return name:match("%.csproj$")
    end, { upward = true, path = start, type = "file" })

    if #projs == 0 then return nil end
    if #projs == 1 then return projs[1] end

    -- multiple csproj found upwards: pick one
    local display = { "Select project:" }
    for _, p in ipairs(projs) do
        table.insert(display, vim.fn.fnamemodify(p, ":~"))
    end
    local choice = vim.fn.inputlist(display)
    if choice < 2 then return nil end
    return projs[choice - 1]
end

local function find_sln_upwards()
    -- Prefer starting from current file's dir (if any), else cwd
    local start = vim.api.nvim_buf_get_name(0)
    if start ~= "" then
        start = parent_dir(start)
    else
        start = vim.fn.getcwd()
    end

    -- Requires Neovim 0.9+ (vim.fs.find)
    local slns = vim.fs.find(function(name)
        return name:match("%.sln$")
    end, { upward = true, path = start, type = "file" })

    if #slns == 0 then return nil end
    if #slns == 1 then return slns[1] end

    -- Multiple solutions found: pick one
    local choice = vim.fn.inputlist(vim.list_extend({ "Select solution:" }, slns))
    if choice < 1 then return nil end
    return slns[choice]
end

local function dotnet_sln_list_projects(sln)
    local out = vim.fn.system({ "dotnet", "sln", sln, "list" })
    if vim.v.shell_error ~= 0 then
        vim.notify(out, vim.log.levels.ERROR)
        return nil
    end

    local projects = {}
    local sln_dir = parent_dir(sln)

    for line in out:gmatch("[^\r\n]+") do
        -- dotnet sln list outputs relative paths like:
        -- "src/MyApp/MyApp.csproj"
        if line:match("%.csproj%s*$") then
            line = line:gsub("^%s+", ""):gsub("%s+$", "")
            local full = line

            -- Make absolute if needed
            if not full:match("^/") and not full:match("^[A-Za-z]:\\") then
                full = joinpath(sln_dir, line)
            end

            table.insert(projects, full)
        end
    end

    if #projects == 0 then
        vim.notify("No .csproj entries found in solution list output.", vim.log.levels.ERROR)
        return nil
    end

    table.sort(projects)
    return projects
end

local function pick_startup_project(projects)
    if #projects == 1 then return projects[1] end

    local display = { "Select startup project:" }
    for _, p in ipairs(projects) do
        table.insert(display, vim.fn.fnamemodify(p, ":~"))
    end

    local choice = vim.fn.inputlist(display)
    if choice < 2 then return nil end
    return projects[choice - 1]
end

local function dotnet_build(csproj)
    vim.notify("dotnet build: " .. vim.fn.fnamemodify(csproj, ":~"))
    local out = vim.fn.system({ "dotnet", "build", csproj, "-c", "Debug" })
    if vim.v.shell_error ~= 0 then
        vim.notify(out, vim.log.levels.ERROR)
        return false
    end
    return true
end

local function find_built_dll(csproj)
    local proj_dir = parent_dir(csproj)
    local proj_name = vim.fn.fnamemodify(csproj, ":t:r")

    -- Find all candidate DLLs under bin/Debug/**/<ProjectName>.dll
    local glob_pat = joinpath(proj_dir, "bin", "Debug", "*", proj_name .. ".dll")
    local matches = vim.fn.glob(glob_pat, false, true)

    if #matches == 0 then
        return nil
    end

    -- If multiple TFMs, pick the newest by mtime
    table.sort(matches, function(a, b)
        local sa = vim.loop.fs_stat(a)
        local sb = vim.loop.fs_stat(b)
        local ta = sa and sa.mtime.sec or 0
        local tb = sb and sb.mtime.sec or 0
        return ta < tb
    end)

    return matches[#matches]
end

-- -------- main --------

local function debug_dotnet_from_sln()
    local sln = find_sln_upwards()
    local csproj = nil
    if sln then
        local projects = dotnet_sln_list_projects(sln)
        if projects then
            csproj = pick_startup_project(projects)
        end
    end
    if not csproj then
        csproj = find_csproj_upwards()
        if not csproj then
            vim.notify("No .sln or .csproj found upwards from current file/cwd.", vim.log.levels.WARN)
            return
        end
    end


    if not dotnet_build(csproj) then
        vim.notify("Build failed — not starting debugger.", vim.log.levels.ERROR)
        return
    end

    local dll = find_built_dll(csproj)
    if not dll or not file_exists(dll) then
        vim.notify("Could not locate built DLL for: " .. csproj, vim.log.levels.ERROR)
        return
    end

    dap.run({
        type = "coreclr",
        request = "launch",
        name = "Debug .NET (sln startup)",
        program = dll,
        cwd = parent_dir(sln),
        console = "integratedTerminal",
        stopAtEntry = false,
        env = {
            ASPNETCORE_ENVIRONMENT = "Development",
            DOTNET_ENVIRONMENT = "Development",
        },
    })
end

-- Export if you want to require it elsewhere
M.debug_dotnet_from_sln = debug_dotnet_from_sln
M.find_sln_upwards = find_sln_upwards

return M
