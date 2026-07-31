return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Connects nvim-cmp to the LSP
    "L3MON4D3/LuaSnip", -- Snippet engine (required by cmp)
    "saadparwaiz1/cmp_luasnip", -- Connects LuaSnip to nvim-cmp
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      -- Neovim needs a snippet engine to handle LSP snippets
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      -- Keybindings for the autocomplete menu
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to accept
        ["<Tab>"] = cmp.mapping.select_next_item(), -- Tab to go down
        ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Shift+Tab to go up
      }),
      -- Where to get the autocomplete data from
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }),
    })
  end,
}
