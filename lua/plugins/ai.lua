return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			adapters = {
				aliyun_deepseek = function()
					return require("codecompanion.adapters").extend("deepseek", {
						name = "aliyun_deepseek",
						url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
						env = {
							api_key = "sk-ce2dd265684d4f5982f7b696e3feb4cf",
						},
						schema = {
							model = {
								default = "deepseek-r1",
							},
							choices = {
								["deepseek-r1"] = { opts = { can_reason = false } },
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "aliyun_deepseek",
				},
				inline = {
					adapter = "aliyun_deepseek",
				},
			},
			opts = {
				language = "Chinese",
			},
		})
	end,
}
