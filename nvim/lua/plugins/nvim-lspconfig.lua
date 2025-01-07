-- Configuration plugin for buildin nvim LSP client
return {
	"neovim/nvim-lspconfig",

	dependencies = {
		-- LSP and DEP installing facility
		{
			"williamboman/mason.nvim",
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
                "zapling/mason-conform.nvim"
			},
            config = function()
                require("mason").setup({})
            end
		},
		-- Complite LSP configurations.
		-- For this the configuration is placed in ftplugin/java.lua file
		"mfussenegger/nvim-jdtls",
		-- Autocomplition plugin
		{
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
		},
		-- Show function signature when you type
		{
			"ray-x/lsp_signature.nvim",
			opts = {
				debug = false, -- set to true to enable debug logging
				log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
				-- default is  ~/.cache/nvim/lsp_signature.log
				verbose = false, -- show debug line number

				bind = true, -- This is mandatory, otherwise border config won't get registered.
				-- If you want to hook lspsaga or other signature handler, pls set to false
				doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
				-- set to 0 if you DO NOT want any API comments be shown
				-- This setting only take effect in insert mode, it does not affect signature help in normal
				-- mode, 10 by default

				max_height = 12, -- max height of signature floating_window
				max_width = 120, -- max_width of signature floating_window
				noice = false, -- set to true if you using noice to render markdown
				wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
				floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

				floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
				-- will set to true when fully tested, set to false will use whichever side has more space
				-- this setting will be helpful if you do not want the PUM and floating win overlap
				floating_window_off_x = 1, -- adjust float windows x position. can be either a number or function
				floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
				-- can be either number or function, see examples

				close_timeout = 4000, -- close floating window after ms when laster parameter is entered
				fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
				hint_enable = false, -- virtual hint enable
				hint_prefix = "", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
				hint_scheme = "String",
				hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
				handler_opts = {
					border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
				},

				always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

				auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
				extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
				zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

				padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

				transparency = nil, -- disabled by default, allow floating win transparent value 1~100
				shadow_blend = 36, -- if you using shadow as border use this set the opacity
				shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
				timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
				toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
				toggle_key_flip_floatwin_setting = false, -- true: toggle float setting after toggle key pressed

				select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
				move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
			},
		},
		-- Provide lsp and treesitter foldmethod
		{
			"kevinhwang91/nvim-ufo",
			dependencies = {
				"kevinhwang91/promise-async",
			},
			config = function()
				vim.o.foldcolumn = "1" -- '0' is not bad
				vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true

				-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
				vim.keymap.set("n", "zR", require("ufo").openAllFolds)
				vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

				require("ufo").setup({
					provider_selector = function(bufnr, filetype, buftype)
						return { "lsp", "indent" }
					end,
				})
			end,
		},
		-- Formatter
		{
			"stevearc/conform.nvim",
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
                        c =  { "clang-format" },
                        ["c#"] = { "clang-format" },
                        ["c++"] = { "clang-format" },
						java = { "clang-format" },
                        typescript = { "prettier" },
                        javascript = { "prettier" },
                        css = { "prettier" },
                        html = { "prettier" },
                        json = { "prettier" },
                        markdown = { "prettier" },
                        yaml = { "prettier" }
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
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")

		-- LSP servers autoinstalling
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"bashls",
				"tsserver",
				"clangd",
				"jdtls",
				"marksman",
				"sqlls",
				"jsonls",
				"taplo",
				"html",
				"cssls",
				"dockerls",
				"docker_compose_language_service",
			},
		})

		-- LSP servers configuration.
		-- Extend capabilities of LSP servers for cmp plugin
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({ capabilities = capabilities })
			end,
			lua_ls = function()
				lspconfig.lua_ls.setup({
					settings = {
						Lua = {
							diagnostics = {
								-- Suppress "Undefinded global 'vim'" message
								globals = { "vim" },
							},
						},
					},
				})
			end,
		})

		-- Keymaps.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<space>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})
	end,
}
