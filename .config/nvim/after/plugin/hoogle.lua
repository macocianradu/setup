local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function parse_query_mode(raw_query)
    local query = vim.trim(raw_query or "")
    if query:match("^text:%s*") then
        return "text", vim.trim((query:gsub("^text:%s*", "", 1)))
    end
    if query:match("^type:%s*") then
        return "type", vim.trim((query:gsub("^type:%s*", "", 1)))
    end

    -- Heuristic:
    --  - Queries that look like signatures/operators stay in type mode.
    --  - Everything else defaults to text mode so plain-language search works.
    local looks_like_type = query:match("::")
        or query:match("->")
        or query:match("=>")
        or query:match("[%[%]()%{%}]")
        or query:match("^%S+$")

    return looks_like_type and "type" or "text", query
end

local function hoogle_picker(query)
    if vim.fn.executable("hoogle") ~= 1 then
        vim.notify("hoogle not found in PATH", vim.log.levels.ERROR)
        return
    end

    local mode, normalized_query = parse_query_mode(query)
    if normalized_query == "" then
        return
    end

    local cmd = { "hoogle", "--count=200" }
    if mode == "text" then
        table.insert(cmd, "--text")
    end
    table.insert(cmd, normalized_query)

    local lines = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("hoogle failed:\n" .. table.concat(lines, "\n"), vim.log.levels.ERROR)
        return
    end

    local results = {}
    for _, line in ipairs(lines) do
        if line ~= "" and not line:match("^%d+ results found") then
            table.insert(results, line)
        end
    end

    pickers.new({}, {
        prompt_title = ("Hoogle (%s): %s"):format(mode, normalized_query),
        finder = finders.new_table({ results = results, }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local function open_result()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection and selection.value and selection.value.url then
                    vim.ui.open(selection.value.url)
                end
            end

            map("i", "<CR>", open_result)
            map("n", "<CR>", open_result)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command("Hoogle", function(opts)
    local query = opts.args ~= "" and opts.args or vim.fn.input("Hoogle > ")
    if query == "" then return end
    hoogle_picker(query)
end, { nargs = "*" })

vim.keymap.set("n", "<leader>hh", function()
    vim.cmd("Hoogle " .. vim.fn.expand("<cword>"))
end, { desc = "Hoogle current word" })

vim.keymap.set("n", "<leader>ht", function()
    vim.cmd("Hoogle " .. vim.fn.input("Hoogle type/text > "))
end, { desc = "Hoogle query" })

