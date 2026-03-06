require('codecompanion').setup({
    adapters = {
        http = {
            webui = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                        url = "https://openwebui.estatecloud.org",
                        api_key = os.getenv("OPENWEBUI_API_KEY"),
                        chat_url = "/api/chat/completions",
                    },
                    schema = {
                        model = {
                            default = "qwen3.5:9b", -- Use the exact model name from your PC
                        }
                    }
                })
            end,
        },
        acp = {
            codex = function()
                return require("codecompanion.adapters").extend("codex", {
                    defaults = {
                        auth_method = "chatgpt"
                    },
                })
            end
        }
    },
    strategies = {
        chat = {
            adapter = "webui",
            tools = {
                ["cmd_runner"] = { auto_submit_errors = true },
                ["editor"] = { auto_submit_success = false },
                ["files"] = { auto_submit_success = true }
            }
        },
        agent = {
            adapter = "webui",
        },
        opts = {
        system_prompt = [[
            You are an expert coding assistant operating in agent mode.
            When asked about files or code, ALWAYS use the available tools to:
            - Read files with the `files` tool before answering questions about them
            - Use the `editor` tool to read the current buffer
            - Use `cmd_runner` to run tests or shell commands when relevant
            Never ask the user to paste file contents — fetch them yourself using tools.
        ]],
        }
    },
    interactions = {
        chat = {
            adapter = "webui",
            model = "qwen3.5:9b",
        },
    }
})

vim.keymap.set('n', '<leader>gpt', function() require("codecompanion").chat({strategy = "agent" }) end);
