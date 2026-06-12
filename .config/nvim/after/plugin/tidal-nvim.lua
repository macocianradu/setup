vim.keymap.set("n", "<leader>tl", "<cmd>TidalLaunch<cr>")
vim.keymap.set("n", "<leader>tq", "<cmd>TidalQuit<cr>")

local scd = os.getenv("HOME") .. "/.local/share/tidal/BootSuperDirt.scd"

local function superdirt_running()
    local id = vim.g.superdirt_job
    return id and id > 0 and vim.fn.jobwait({ id }, 0)[1] == -1
end

local function log_buf()
    local b = vim.g.superdirt_buf
    if not (b and vim.api.nvim_buf_is_valid(b)) then
        b = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(b, "SuperDirt")
        vim.g.superdirt_buf = b
    end
    return b
end

local function append(_, data)
    if not data then return end
    vim.schedule(function()
        local lines = {}
        for _, l in ipairs(data) do
            l = l:gsub("\r", "")
            table.insert(lines, l)
            if l:match("SuperDirt:%s*listening") then
                vim.notify("SuperDirt ready", vim.log.levels.INFO)
            elseif l:match("ERROR") then
                vim.notify("SuperDirt: " .. l, vim.log.levels.ERROR)
            end
        end
        vim.api.nvim_buf_set_lines(log_buf(), -1, -1, false, lines)
    end)
end

vim.api.nvim_create_user_command("SuperDirtLog", function()
    vim.cmd("botright split")
    vim.api.nvim_win_set_buf(0, log_buf())
end, { desc = "Open SuperDirt output log" })

local group = vim.api.nvim_create_augroup("TidalSuperDirt", { clear = true })

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "TidalLaunch",
    callback = function()
        if superdirt_running() then
            vim.notify("SuperDirt already running", vim.log.levels.INFO)
            return
        end
        vim.fn.deletebufline(log_buf(), 1, "$")
        vim.g.superdirt_job = vim.fn.jobstart({ "sclang", scd }, {
            on_stdout = append,
            on_stderr = append,
            on_exit = function() vim.g.superdirt_job = nil end,
        })
        if vim.g.superdirt_job <= 0 then
            vim.notify("Failed to start sclang (is SuperCollider installed?)", vim.log.levels.ERROR)
        else
            vim.notify("Booting SuperDirt... (:SuperDirtLog for output)", vim.log.levels.INFO)
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
        if superdirt_running() then
            vim.fn.jobstop(vim.g.superdirt_job)
        end
    end,
})
