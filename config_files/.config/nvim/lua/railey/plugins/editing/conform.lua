return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      -- Map filetypes to the formatters you want to use
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use isort to sort imports, then black to format the code
        python = { "isort", "black" },
        -- Use gofumpt for strict Go formatting, and goimports to manage imports
        go = { "gofumpt", "goimports" },
        -- Prettier handles all web/frontend files perfectly
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>fm", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })

      -- If triggered from visual mode, clear the highlight naturally
      local mode = vim.api.nvim_get_mode().mode
      if mode:match("^[vV\x16]") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end, { desc = "Format file or range with Conform" })
  end,
}
