require('codecompanion').setup({
    interactions = {
        chat = {
            adapter = "ollama",
            model = "deepseek-coder:6.7b"
        },
    },
    adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("openai", {
                env = {
                    url = "https:openwebui.estatecloud.org",
                    api_key = "sk-c7e3b3c942b34528a486eb443d200de6"
                },
                schema = {
                    model = {
                        default = "deepseek-coder:6.7b", -- Use the exact model name from your PC
                    }
                }
            })
        end,
    }
})
