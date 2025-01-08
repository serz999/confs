return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		-- Required sources
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-path",
	},
	config = function()
		-- Set max number of suggestions
		vim.cmd("set pumheight=15")

		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<TAB>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
					entry_filter = function(entry)
						-- Remove snippets suggestions
						return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Snippet"
					end,
				},
				{ name = "path" },
			}),
		})
		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
		})
	end,
}
