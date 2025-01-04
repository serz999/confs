--  Move a selected line through the buffer
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Stay cursor in center when command
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Hold cursor on place when J
vim.keymap.set("n", "J", "mzJ`z")

-- Don't add to nvim clipboard when p 
vim.keymap.set("x", "p", "\"_dP")

-- System clipboard interaction
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")

-- Buffers keymap 
vim.keymap.set ('n', 'q', '<cmd>bd<cr>')
-- TODO
-- vim.keymap.set('n', 'H', ':BufferLineCyclePrev<CR>')
-- vim.keymap.set('n', 'L', ':BufferLineCycleNext<CR>')

vim.keymap.set('n', '<leader><space>', '<Cmd>nohlsearch<CR>')

vim.cmd([[
    function! NetrwMapping()
         nmap <buffer> <leader>e -
    endfunction

    augroup netrw_mapping
      autocmd!
      autocmd filetype netrw call NetrwMapping()
    augroup END
]])

vim.keymap.set("n", "<leader>e", "<cmd>Ex<cr>")
