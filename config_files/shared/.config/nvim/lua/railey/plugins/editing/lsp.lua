return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Enable showing errors/warnings while in insert mode
    vim.diagnostic.config({
      update_in_insert = true,
    })

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, {
          focusable = false, -- Prevents your cursor from jumping into the window
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = "always", -- Shows which LSP sent the error (e.g., gopls)
          prefix = " ",
        })
      end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
        vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Definition" }, opts)
        vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Go to Declaration" }, opts)
        vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Go to Implementation" }, opts)
        vim.keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Go to Type Definition" }, opts)
        vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "Go to References" }, opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
      end,
    })

    require("mason").setup()

    -- Tell our LSP servers that we support advanced autocomplete capabilities
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("mason-lspconfig").setup({
      ensure_installed = { "gopls" },

      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            -- Pass the autocomplete capabilities to every server Mason installs
            capabilities = capabilities,
          })
        end,
        ["gopls"] = function()
          require("lspconfig").gopls.setup({
            capabilities = capabilities,
            settings = {
              gopls = {
                gofumpt = true, -- Tells gopls to use gofumpt instead of standard gofmt
              },
            },
          })
        end,
      },
    })
  end,
}
