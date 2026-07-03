return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_open_to_the_world = 1
		vim.g.mkdp_browserfunc = "OpenMkdpUrl"

		_G.MkdpCopyAndEcho = function(url)
			-- base64 编码(系统命令,GREP/BSD 均可用),去换行
			local h = io.popen("printf %s " .. vim.fn.shellescape(url) .. ' | base64 | tr -d "\\n"')
			local b64 = h and h:read("*a") or ""
			if h then
				h:close()
			end
			-- OSC52 写到 /dev/tty:SSH 下直接送达本地终端剪贴板,无需 v:tty
			local f = io.open("/dev/tty", "w")
			if f then
				f:write(string.format("\27]52;c;%s\7", b64))
				f:close()
			end
			vim.api.nvim_echo({ { "MarkdownPreview URL (已复制到剪贴板): ", "WarningMsg" }, { url } }, true, {})
		end

		vim.cmd([[
                        function! OpenMkdpUrl(url) abort
                                call v:lua.MkdpCopyAndEcho(a:url)
                        endfunction
                ]])
	end,
	ft = { "markdown" },
}
