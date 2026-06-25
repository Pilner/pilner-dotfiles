return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        -- 1. Neovim options required for UFO folding
        vim.o.foldcolumn = "1"
        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local builtin = require("statuscol.builtin")

        -- 2. Combined statuscol setup
        require("statuscol").setup({
          setopt = true,
          relculright = true,
          segments = {
            -- Segment 1: UFO Fold column
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },

            -- Segment 2: Git signs
            {
              sign = {
                namespace = { "gitsigns.*" },
                name = { "gitsigns.*" },
              },
              click = "v:lua.ScSa",
            },

            -- Segment 3: All other signs (LSP Diagnostics, etc.)
            {
              sign = {
                namespace = { ".*" },
                name = { ".*" },
                maxwidth = 1,
                colwidth = 1,
                auto = false,
              },
              click = "v:lua.ScSa",
            },

            -- Segment 4: Custom absolute and relative line numbers
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
          },
        })
      end,
    },
  },
  event = "BufReadPost",
  opts = {
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
  },
  init = function()
    -- Keymaps for UFO
    vim.keymap.set("n", "zR", function()
      require("ufo").openAllFolds()
    end)
    vim.keymap.set("n", "zM", function()
      require("ufo").closeAllFolds()
    end)
    vim.keymap.set("n", "H", "za", {
      remap = true,
      silent = true,
      desc = "Toggle Fold (using za)",
    })

    -- Hover definition (Note: I updated the fallback here for native LSP)
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        -- Since you set up nvim-lspconfig earlier, this triggers standard LSP hover
        vim.lsp.buf.hover()
      end
    end)
  end,
}
