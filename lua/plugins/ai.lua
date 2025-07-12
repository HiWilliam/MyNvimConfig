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
				url = "http://192.168.8.183:11435/api/chat",
				model = "qwen2.5-coder:14b",

				streaming_handler = local_llm_streaming_handler,
				parse_handler = local_llm_parse_handler,

				app_handler = {
					Completion = {
						handler = tools.completion_handler,
						opts = {
							url = "http://192.168.8.183:11435/v1/completions",
							model = "qwen2.5-coder:14b",
							api_type = "ollama",
							style = "virtual_text",
							timeout = 10,

							keymap = {
								virtual_text = {
									accept = {
										mode = "i",
										keys = "<A-a>",
									},
									next = {
										mode = "i",
										keys = "<A-n>",
									},
									prev = {
										mode = "i",
										keys = "<A-p>",
									},
									toggle = {
										mode = "n",
										keys = "<leader>cp",
									},
								},
							},
						},
					},
				},
			})
		end,
	},
}
