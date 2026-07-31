return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      ensure_installed = {},
      automatic_setup = true,
    })
    local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
      },
    }

    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    })

    require("nvim-dap-virtual-text").setup({
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value:gsub("%s+", " ")
        else
          return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
        end
      end,
      virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil,
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f6b26b" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "", numhl = "" })

    dap.configurations.javascript = {
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to Node.js process",
        port = 9229,
        address = "127.0.0.1",
      },
    }

    dap.configurations.typescript = {
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to Node.js process",
        port = 9229,
        address = "127.0.0.1",
      },
    }

    local function debug_npm_script()
    if dap.session() then
      dap.continue()
      return
    end

    vim.ui.input({
      prompt = "Enter command (e.g., 'npm run dev', 'node server.js'): ",
      default = "",
    }, function(input)
      if not input or input == "" then
        vim.notify("Debug cancelled: no command provided", vim.log.levels.WARN)
        return
      end

      local parts = vim.split(input, " ")

      dap.run({
        type = "pwa-node",
        request = "launch",
        name = "Launch: " .. input,
        runtimeExecutable = parts[1],
        runtimeArgs = { unpack(parts, 2) },
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
      })
    end)
  end

  vim.keymap.set("n", "<F5>", function()
    local ft = vim.bo.filetype

    if ft == "javascript" or ft == "typescript" then
      debug_npm_script()
    else
      dap.continue()
    end
  end, { desc = "Debug: Continue/Launch" })

  vim.keymap.set("n", "<F6>", function()
    if not dap.session() then
      vim.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    dap.step_over()
  end, { desc = "Debug: Step Over" })

  vim.keymap.set("n", "<F7>", function()
    if not dap.session() then
      vim.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    dap.step_into()
  end, { desc = "Debug: Step Into" })

  vim.keymap.set("n", "<F8>", function()
    if not dap.session() then
      vim.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    dap.step_out()
  end, { desc = "Debug: Step Out" })

  vim.keymap.set("n", "<leader>b", function()
    dap.toggle_breakpoint()
  end, { desc = "Debug: Toggle Breakpoint" })

  vim.keymap.set("n", "<leader>dr", function()
    dapui.open({ reset = true })
  end, { desc = "Debug: Reset UI" })

  vim.keymap.set("n", "<leader>dt", function()
    dapui.toggle()
  end, { desc = "Debug: Toggle UI" })

  vim.keymap.set("n", "<leader>dB", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, { desc = "Debug: Set Log Point" })

  vim.keymap.set("n", "<leader>dp", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "Debug: Set Conditional Breakpoint" })

  vim.keymap.set("n", "<leader>dh", function()
    if not dap.session() then
      vim.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    dapui.float_element("scopes", { enter = true })
  end, { desc = "Debug: Show Scopes" })

  vim.keymap.set("n", "<leader>dk", function()
    if not dap.session() then
      vim.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    dapui.float_element("stacks", { enter = true })
  end, { desc = "Debug: Show Stacks" })

  vim.keymap.set("n", "<leader>dw", function()
    if not dap.session() then
      vim.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    dapui.float_element("watches", { enter = true })
  end, { desc = "Debug: Show Watches" })

  vim.keymap.set("n", "<leader>tv", function()
    if not dap.session() then
      vim.notify("No active debug session", vim.log.levels.WARN)
      return
    end
    require("nvim-dap-virtual-text").toggle()
  end, { desc = "Debug: Toggle Virtual Text" })
end,
}
