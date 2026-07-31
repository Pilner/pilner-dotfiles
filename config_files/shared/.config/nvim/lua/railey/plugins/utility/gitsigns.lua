return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter", -- Loads when you open a buffer
  opts = {
    signs = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    -- delay = 1000,

    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      -- Toggle current line blame
      vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "Toggle Git Blame" })
    end,
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)

    vim.opt.signcolumn = "yes"
  end,
}
