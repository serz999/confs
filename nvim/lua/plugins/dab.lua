return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio"
    },
    config = function ()
        local dap = require("dap")
        local dapui = require("dapui")

        -- Automaitc UI opening after the debugging have been started
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end

        vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, {})
        vim.keymap.set('n', '<Leader>c', dap.continue, {})
    end
}
