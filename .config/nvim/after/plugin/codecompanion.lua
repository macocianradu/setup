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
        }
    },
    interactions = {
        chat = {
            adapter = "webui",
            model = "deepseek-coder:6.7b"
        },
    }
})
