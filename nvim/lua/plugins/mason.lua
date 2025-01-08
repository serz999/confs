return {
	-- LSP, DAP, lintners and formatters packages installing facility
	"williamboman/mason.nvim",
	dependencies = {},
	config = function()
		require("mason").setup()
	end,
}
