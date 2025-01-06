return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- LSP and DEP installing facility 
        {
            "williamboman/mason.nvim",
            dependencies = {
                "williamboman/mason-lspconfig.nvim",
            }
        },
        -- Complite LSP configurations.
        -- For this the configuration is placed in ftplugin/java.lua file
        "mfussenegger/nvim-jdtls",
        -- Autocomplition plugin
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                -- Required sources
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-cmdline',
                'hrsh7th/cmp-path',
            },
            config = function()
                -- Set max number of suggestions
                vim.cmd('set pumheight=15')

                local cmp = require('cmp')
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
                      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                      ['<C-f>'] = cmp.mapping.scroll_docs(4),
                      ['<C-Space>'] = cmp.mapping.complete(),
                      ['<C-e>'] = cmp.mapping.abort(),
                      ['<TAB>'] = cmp.mapping.confirm({ select = true }),
                    }),
                    sources = cmp.config.sources({
                       {
                          name = 'nvim_lsp',
                          entry_filter = function(entry)
                            -- Remove snippets suggestions
                            return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
                          end
                       },
                      { name = 'path' }
                    }),
                })
                -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline(':', {
                  mapping = cmp.mapping.preset.cmdline(),
                  sources = cmp.config.sources({
                    { name = 'path' },
                    { name = 'cmdline' }
                  })
                })
            end
        },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup({})

        -- LSP servers autoinstalling
        mason_lspconfig.setup({
            ensure_installed = {
                "lua_ls",
                "bashls",
                -- "asm_lsp",
                -- "rust_analyzer",
                -- "pyright",
                "tsserver",
                "clangd",
                "jdtls",
                -- "gopls",
                "marksman",
                -- "ltex",
                "sqlls",
                "jsonls",
                "taplo",
                "html",
                "cssls",
                "dockerls",
                "docker_compose_language_service",
                -- "cmake",
            },
        })

        -- LSP servers configuration.
        -- Extend capabilities of LSP servers for cmp plugin
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        mason_lspconfig.setup_handlers({
            function (server_name)
                lspconfig[server_name].setup({ capabilities = capabilities })
            end,
            lua_ls = function ()
                lspconfig.lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                -- Suppress "Undefinded global 'vim'" message
                                globals = { "vim" }
                            }
                        }
                    }
                })
            end,
        })

        -- Keymaps.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            opts
            )
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<space>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)
          end,
        })
    end
}
