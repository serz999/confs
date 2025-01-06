return {
    "folke/trouble.nvim",
     config = function()
         require("trouble").setup {
             icons = false,
         }

         vim.keymap.set("n", "T", "<cmd>TroubleToggle<cr>")
     end
}
