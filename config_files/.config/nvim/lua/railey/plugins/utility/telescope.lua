return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        preview = {
          treesitter = false,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    telescope.load_extension("fzf")

    local builtin = require("telescope.builtin")
    -- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set("n", "<leader>ff", function()
      require("telescope.builtin").find_files({
        find_command = { "rg", "--files", "--sortr=modified" }, -- Optional: sorts OS-level by date
        tiebreak = function(current_entry, existing_entry, _)
          -- This prioritizes more recently opened files in the fuzzy list
          return current_entry.index < existing_entry.index
        end,
      })
    end, { desc = "[F]ind [F]iles with Recency Bias" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord under cursor" })
    vim.keymap.set("v", "<leader>fw", builtin.grep_string, { desc = "[F]ind highlighted [W]ord" })
  end,
}
