return {
  {
    "mong8se/actually.nvim",
  },
  {
    "vim-airline/vim-airline",
    priority = 1000,
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
  },
  {
    "sonph/onehalf",
    lazy = false,
    priority = 1000,
    config = function(plugin)
	vim.opt.rtp:append(plugin.dir .. "/vim")
	vim.cmd([[colorscheme onehalfdark]])
	vim.g.airline_theme = "onehalfdark"
    end,
  },
}
