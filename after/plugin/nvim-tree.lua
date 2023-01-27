-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
-- require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  auto_close = true,
  open_on_tab = true,
  sync_root_with_cwd = true -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
})

vim.keymap.set('n', "<leader>e", ":NvimTreeToggle<cr>")

vim.api.nvim_create_autocmd('BufEnter', {
   command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
   nested = true,
})
