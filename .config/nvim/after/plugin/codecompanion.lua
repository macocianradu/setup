require('codecompanion').setup({
    extensions = {
        history = {
            enabled = true,
            opts = {
                title_generation_opts = {
                    adapter = "openrouter",
                    model = "minimax/minimax-m2.7"
                }
            },
            summary = {
                generation_opts = {
                    adapter = "openrouter",
                    model = "minimax/minimax-m2.7"
                }
            }
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
                            default = "qwen3.5:9b",
                        }
                    }
                })
            end,
            openrouter = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                        url = "https://openrouter.ai/api",
                        api_key = os.getenv("OPENROUTER_API_KEY"),
                        chat_url = "/v1/chat/completions",
                    },
                    schema = {
                        model = {
                            default = "qwen/qwen3.6-flash",
                        },
                    },
                })
            end,
        },
        acp = {
            claude_code = function()
                return require("codecompanion.adapters").extend("claude_code", {})
            end
        }
    },
    interactions = {
        chat = {
            adapter = "opencode",
        },
        inline = {
            adapter = "openrouter",
        }
    }
})

vim.keymap.set('n', '<leader>gpt', function() require("codecompanion").chat({ strategy = "agent" }) end);

vim.keymap.set('n', 'gpi', function()
  Snacks.input({ prompt = "Prompt: " }, function(input)
    if input and input ~= "" then
      vim.cmd("CodeCompanion " .. input)
    end
  end)
end)

vim.keymap.set('v', 'gpi', function()
  Snacks.input({ prompt = "Prompt (with context): " }, function(input)
    if input and input ~= "" then
      vim.cmd("'<,'>CodeCompanion " .. input)
    end
  end)
end)
