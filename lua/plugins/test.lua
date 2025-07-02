return {
	"hiwilliam-whid",
	dev = true,
	dir = "/root/workspace/lua/whid",
	config = function()
		require("whid").setup({ save_file = "/root/todos/default.json" })
	end,
}
