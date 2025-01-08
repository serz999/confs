vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
-- Enable relative numbers for netrw
vim.g.netrw_bufsettings = "noma nomod nonu nobl nowrap ro rnu"

vim.g.mapleader = ','

vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.termguicolors = true

vim.opt.wrap = false

vim.opt.swapfile = false

vim.opt.updatetime = 50

vim.opt.signcolumn = "yes"

-- Keymaps.
-- Stay cursor in center when command
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Hold cursor on place when J
vim.keymap.set("n", "J", "mzJ`z")

-- System clipboard keymaps
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")

-- Buffer closing
vim.keymap.set ('n', '<leader>q', '<cmd>bd<cr>')

vim.keymap.set('n', '<leader><space>', '<Cmd>nohlsearch<CR>')

vim.keymap.set("n", "<leader>e", "<cmd>Ex<cr>")

-- Enable Ex keymap when you are in netrw
vim.cmd([[
    function! NetrwMapping()
         nmap <buffer> <leader>e -
    endfunction

    augroup netrw_mapping
      autocmd!
      autocmd filetype netrw call NetrwMapping()
    augroup END
]])
