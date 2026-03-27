-- Security: API keys should be set via environment variables
-- export DEEPSEEK_API_KEY=your-api-key
-- export CODE_PLAN_API_KEY=your-api-key
return {
	"yetone/avante.nvim",
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- ⚠️ must add this setting! ! !
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config
	opts = {
		-- add any opts here
		-- this file can contain specific instructions for your project
		instructions_file = "avante.md",
		-- for example
		provider = "glm5",
		auto_suggestion_provider = "deepseek",
		providers = {
			deepseek = {
				__inherited_from = "openai",
				endpoint = "https://api.deepseek.com",
				model = "deepseek-chat",
				-- Use environment variable instead of hardcoded key
				api_key_name = "DEEPSEEK_API_KEY",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.2,
					max_tokens = 8192,
				},
			},
			glm5 = {
				__inherited_from = "openai",
				endpoint = "https://coding.dashscope.aliyuncs.com/v1",
				model = "glm-5",
				api_key_name = "CODE_PLAN_API_KEY",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.2,
					max_tokens = 8192,
				},
			},
		},
		windows = {
			picker = "fzf-lua",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-mini/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
