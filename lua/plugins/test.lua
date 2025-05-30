return {
	"hiwilliam-whid",
	dev = true,
	dir = "/root/workspace/lua/whid",
	config = function()
		require("whid").setup({ width = 50, height = 20 })
	end,
}
