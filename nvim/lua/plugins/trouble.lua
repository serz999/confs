return {
    "folke/trouble.nvim",
     config = function()
         require("trouble").setup {
             icons = false,
         }

         vim.keymap.set("n", "T", "<cmd>TroubleToggle<cr>")
         -- vim.keymap.set("n", "T", "<cmd>TroubleToggle quickfix<cr>")
     end
}
