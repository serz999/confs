return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local telescope = require('telescope')

        telescope.setup({})

        vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files<cr>')
        vim.keymap.set('n', '<leader>g', '<cmd>Telescope live_grep<cr>')
    end
}
