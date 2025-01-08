return {
	"stevearc/conform.nvim",
    dependencies = {
        "zapling/mason-conform.nvim"
    },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		-- It will install all dependencies from Mason repository
		-- that enumerated in formatters_by_ft at confrom setup
		require("mason-conform").setup({})

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "beautysh" },
				bash = { "beautysh" },
				zsh = { "beautysh" },
				c = { "clang-format" },
				["c#"] = { "clang-format" },
				["c++"] = { "clang-format" },
				java = { "clang-format" },
				typescript = { "prettier" },
				javascript = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>l", function()
			conform.format({
				-- Say to LSP to format if conform can't fullfil this
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end)
	end,
}
