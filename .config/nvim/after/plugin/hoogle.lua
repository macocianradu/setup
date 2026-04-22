local STOP_WORDS = {
    ["a"] = true,
    ["an"] = true,
    ["and"] = true,
    ["as"] = true,
    ["at"] = true,
    ["by"] = true,
    ["for"] = true,
    ["from"] = true,
    ["in"] = true,
    ["into"] = true,
    ["is"] = true,
    ["of"] = true,
    ["on"] = true,
    ["or"] = true,
    ["that"] = true,
    ["the"] = true,
    ["to"] = true,
    ["with"] = true,
}

local function parse_query_mode(raw_query)
    local query = vim.trim(raw_query or "")
    if query:match("^text:%s*") then
        return "text", vim.trim((query:gsub("^text:%s*", "", 1)))
    end
    if query:match("^type:%s*") then
        return "type", vim.trim((query:gsub("^type:%s*", "", 1)))
    end

    local looks_like_type = query:match("::")
        or query:match("->")
        or query:match("=>")
        or query:match("[%[%]()%{%}]")
        or query:match("^%S+$")

    return looks_like_type and "type" or "text", query
end

local function run_hoogle_query(query, count)
    local cmd = { "hoogle", ("--count=%d"):format(count or 200), "--json", query }
    local lines = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
        return nil, "hoogle failed:\n" .. table.concat(lines, "\n")
    end

    local ok, parsed = pcall(vim.json.decode, table.concat(lines, "\n"))
    if not ok or type(parsed) ~= "table" then
        return nil, "hoogle returned unexpected output"
    end

    return parsed, nil
end

local function normalize_docs(docs)
    return vim.trim((docs or ""):gsub("<.->", " "):gsub("%s+", " "):lower())
end

local function tokenize_text_query(query)
    local tokens = {}
    local seen = {}
    for token in query:lower():gmatch("[%w_]+") do
        if #token >= 3 and not STOP_WORDS[token] and not seen[token] then
            seen[token] = true
            table.insert(tokens, token)
        end
    end
    return tokens
end

local function hoogle_text_search(query)
    local tokens = tokenize_text_query(query)
    if #tokens == 0 then
        tokens = { query:lower() }
    end

    local ranked = {}
    local order = {}

    local function bump(entry, token, base_score)
        local key = entry.url or entry.item or (entry.module and entry.module.name) or vim.inspect(entry)
        local slot = ranked[key]
        if not slot then
            slot = { entry = entry, score = 0 }
            ranked[key] = slot
            table.insert(order, key)
        end

        local signature = (entry.item or ""):lower()
        local docs = normalize_docs(entry.docs)
        if signature:find(token, 1, true) then
            slot.score = slot.score + base_score + 2
        end
        if docs:find(token, 1, true) then
            slot.score = slot.score + base_score
        end
    end

    local exact, err = run_hoogle_query(query, 200)
    if exact then
        for _, entry in ipairs(exact) do
            bump(entry, query:lower(), 8)
        end
    end

    for i = 1, math.min(#tokens, 6) do
        local token = tokens[i]
        local partial, partial_err = run_hoogle_query(token, 120)
        if partial then
            for _, entry in ipairs(partial) do
                bump(entry, token, 3)
            end
        elseif not err then
            err = partial_err
        end
    end

    local items = {}
    for _, key in ipairs(order) do
        local slot = ranked[key]
        if slot and slot.score > 0 then
            table.insert(items, slot)
        end
    end
    table.sort(items, function(a, b)
        return a.score > b.score
    end)

    local out = {}
    for _, slot in ipairs(items) do
        table.insert(out, slot.entry)
    end

    if #out == 0 and err then
        return nil, err
    end
    return out, nil
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

    local decoded, err
    if mode == "text" then
        decoded, err = hoogle_text_search(normalized_query)
    else
        decoded, err = run_hoogle_query(normalized_query, 200)
    end
    if not decoded then
        vim.notify(err or "hoogle failed", vim.log.levels.ERROR)
        return
    end

    local items = {}
    for idx, entry in ipairs(decoded) do
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

        table.insert(items, {
            idx = idx,
            text = signature .. " " .. (docs or ""),
            signature = signature,
            docs = docs,
            url = url,
            display = display,
        })
    end

    Snacks.picker.pick({
        source = "hoogle",
        title = ("Hoogle (%s): %s"):format(mode, normalized_query),
        items = items,
        format = function(item)
            return { { item.display, "SnacksPickerLabel" } }
        end,
        preview = function(ctx)
            local item = ctx.item
            local lines = { item.signature or "" }
            if item.docs and item.docs ~= "" then
                table.insert(lines, "")
                vim.list_extend(lines, vim.split(item.docs, "\n", { plain = true }))
            else
                table.insert(lines, "")
                table.insert(lines, "No documentation available.")
            end
            if item.url and item.url ~= "" then
                table.insert(lines, "")
                table.insert(lines, item.url)
            end
            vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
        end,
        confirm = function(picker, item)
            picker:close()
            if item and item.url then
                vim.ui.open(item.url)
            end
        end,
    })
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
