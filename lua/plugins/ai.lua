local function local_llm_streaming_handler(chunk, ctx, F)
	if not chunk then
		return ctx.assistant_output
	end
	local tail = chunk:sub(-1, -1)
	if tail:sub(1, 1) ~= "}" then
		ctx.line = ctx.line .. chunk
	else
		ctx.line = ctx.line .. chunk
		local status, data = pcall(vim.fn.json_decode, ctx.line)
		if not status or not data.message.content then
			return ctx.assistant_output
		end
		ctx.assistant_output = ctx.assistant_output .. data.message.content
		F.WriteContent(ctx.bufnr, ctx.winid, data.message.content)
		ctx.line = ""
	end
	return ctx.assistant_output
end
local function local_llm_parse_handler(chunk)
	local assistant_output = chunk.message.content
	return assistant_output
end

return {
	{
		"Kurama622/llm.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
		cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
		config = function()
			local tools = require("llm.tools")
			require("llm").setup({
				url = "http://192.168.8.183:11434/api/chat",
				model = "qwen2.5-coder:14b",
				api_type = "ollama",
				fetch_key = function()
					return ""
				end,

				streaming_handler = local_llm_streaming_handler,
				parse_handler = local_llm_parse_handler,

				app_handler = {
					Completion = {
						handler = tools.completion_handler,
						opts = {
							url = "http://192.168.8.183:11434/v1/completions",
							model = "qwen2.5-coder:14b",
							api_type = "ollama",
							style = "blink.cmp",
							timeout = 10,
							auto_trigger = true,
							n_completions = 1,
						},
					},
				},
				keys = {
					-- The keyboard mapping for the input window.
					["Input:Submit"] = { mode = "n", key = "<cr>" },
					["Input:Cancel"] = { mode = { "n", "i" }, key = "<C-c>" },
					["Input:Resend"] = { mode = { "n", "i" }, key = "<C-r>" },

					-- only works when "save_session = true"
					["Input:HistoryNext"] = { mode = { "n", "i" }, key = "<C-j>" },
					["Input:HistoryPrev"] = { mode = { "n", "i" }, key = "<C-k>" },

					-- The keyboard mapping for the output window in "split" style.
					["Output:Ask"] = { mode = "n", key = "i" },
					["Output:Cancel"] = { mode = "n", key = "<C-c>" },
					["Output:Resend"] = { mode = "n", key = "<C-r>" },

					-- The keyboard mapping for the output and input windows in "float" style.
					["Session:Toggle"] = { mode = "n", key = "<leader>ac" },
					["Session:Close"] = { mode = "n", key = { "<esc>", "Q" } },

					-- Scroll [default]
					["PageUp"] = { mode = { "i", "n" }, key = "<C-b>" },
					["PageDown"] = { mode = { "i", "n" }, key = "<C-f>" },
					["HalfPageUp"] = { mode = { "i", "n" }, key = "<C-u>" },
					["HalfPageDown"] = { mode = { "i", "n" }, key = "<C-d>" },
					["JumpToTop"] = { mode = "n", key = "gg" },
					["JumpToBottom"] = { mode = "n", key = "G" },
				},
			})
		end,
	},
}
