require('codecompanion').setup({
    adapters = {
        http = {
            webui = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                        url = "https://openwebui.estatecloud.org",
                        api_key = "sk-c7e3b3c942b34528a486eb443d200de6",
                        chat_url = "/api/chat/completions",
                    },
                    schema = {
                        model = {
                            default = "deepseek-coder:6.7b", -- Use the exact model name from your PC
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
    interactions = {
        chat = {
            adapter = "codex",
            model = "gpt-5",

            keymaps = {
                yolo_mode = false,
            },

            tools = {
                ["insert_edit_into_file"] = {
                    opts = {
                        require_approval_before = {
                            buffer = true, -- ask before editing current buffer
                            file = true, -- ask before editing files
                        },
                        require_confirmation_after = true,
                        allowed_in_yolo_mode = false,
                    },
                },
                ["create_file"] = {
                    opts = {
                        require_approval_before = true,
                        require_cmd_approval = true,
                        allowed_in_yolo_mode = false,
                    },
                },
                ["delete_file"] = {
                    opts = {
                        require_approval_before = true,
                        require_cmd_approval = true,
                        allowed_in_yolo_mode = false,
                    },
                },
            },
        },
    }
})

vim.keymap.set('n', '<leader>gpt', function(opts) require("codecompanion").chat(opts) end);
