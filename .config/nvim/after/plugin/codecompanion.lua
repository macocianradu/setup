require('codecompanion').setup({
    extensions = {
        history = {
            enabled= true,
        },
    },
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
            claude_code = function()
                return require("codecompanion.adapters").extend("claude_code", { })
            end
        }
    },
    interactions = {
        chat = {
            adapter = "claude_code",
        }
    }
})

vim.keymap.set('n', '<leader>gpt', function() require("codecompanion").chat({strategy = "agent" }) end);
