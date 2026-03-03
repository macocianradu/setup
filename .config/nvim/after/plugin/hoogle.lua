local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")
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

    local cmd = { "hoogle", "--count=200", "--json" }
    if mode == "text" then
        table.insert(cmd, "--text")
    end
    table.insert(cmd, normalized_query)

    local lines = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("hoogle failed:\n" .. table.concat(lines, "\n"), vim.log.levels.ERROR)
        return
    end

    local decoded = nil
    local ok, parsed = pcall(vim.json.decode, table.concat(lines, "\n"))
    if ok and type(parsed) == "table" then
        decoded = parsed
    else
        vim.notify("hoogle returned unexpected output", vim.log.levels.ERROR)
        return
    end

    local results = {}
    for _, entry in ipairs(decoded) do
        local signature = entry.item or ""
        local docs = entry.docs or ""
        local url = entry.url
        local docs_one_line = vim.trim((docs:gsub("%s+", " ")))

        if #docs_one_line > 140 then
            docs_one_line = docs_one_line:sub(1, 137) .. "..."
        end

        local display = signature
        if docs_one_line ~= "" then
            display = display .. " - " .. docs_one_line
        end

        table.insert(results, {
            signature = signature,
            docs = docs,
            url = url,
            display = display,
        })
    end

    pickers.new({}, {
        prompt_title = ("Hoogle (%s): %s"):format(mode, normalized_query),
        finder = finders.new_table({
            results = results,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.signature .. " " .. (entry.docs or ""),
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry)
                local value = entry.value or {}
                local preview_lines = { value.signature or "" }

                if value.docs and value.docs ~= "" then
                    table.insert(preview_lines, "")
                    vim.list_extend(preview_lines, vim.split(value.docs, "\n", { plain = true }))
                else
                    table.insert(preview_lines, "")
                    table.insert(preview_lines, "No documentation available.")
                end

                if value.url and value.url ~= "" then
                    table.insert(preview_lines, "")
                    table.insert(preview_lines, value.url)
                end

                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)
            end,
        }),
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

