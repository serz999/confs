return {
    'neovim/nvim-lspconfig',
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = {
                "williamboman/mason.nvim",
            },

        },
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-cmdline',
                'hrsh7th/cmp-nvim-lsp',
                {
                    'L3MON4D3/LuaSnip',
                    dependencies = {
                        "rafamadriz/friendly-snippets"
                    },
                },
                'saadparwaiz1/cmp_luasnip',
            },
            config = function()
                vim.cmd('set pumheight=15')

                require("luasnip.loaders.from_vscode").lazy_load()

                local cmp = require('cmp')

                cmp.setup({
                    snippet = {
                        expand = function(args)
                            require('luasnip').lsp_expand(args.body)
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
                      { name = 'nvim_lsp' },
                      { name = 'luasnip' },
                      { name = 'path' }
                    }, {
                      { name = 'buffer' },
                    }),
                  })

                  -- Set configuration for specific filetype.
                  cmp.setup.filetype('gitcommit', {
                    sources = cmp.config.sources({
                      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
                    }, {
                      { name = 'buffer' },
                    })
                  })

                  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
                  cmp.setup.cmdline({ '/', '?' }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                      { name = 'buffer' }
                    }
                  })

                  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                  cmp.setup.cmdline(':', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                      { name = 'path' }
                    }, {
                      { name = 'cmdline' }
                    })
                  })
            end
        },
    },
    config = function()
        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "bashls",
                -- "asm_lsp",
                "rust_analyzer",
                "pyright",
                "tsserver",
                "clangd",
                "jdtls",
                "gopls",
                -- OTHER SYNTAXES 
                "marksman",
                "ltex",
                "sqlls",
                "jsonls",
                "taplo",
                "html",
                "cssls",
                "dotls",
                "ansiblels",
                "dockerls",
                "docker_compose_language_service",
                -- "cmake",
            },
        })

        local cpm_default_capabilities = require('cmp_nvim_lsp').default_capabilities()

        require("mason-lspconfig").setup_handlers({
            function (server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = cpm_default_capabilities,
                })
            end,
            ["gopls"] = function ()
                local lspconfig = require("lspconfig")
                lspconfig.gopls.setup({
                    capabilities = cpm_default_capabilities,
                    settings = {
                        completeUnimported = true,
                    }
                })
            end,
        })

    -- Mappings.
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
