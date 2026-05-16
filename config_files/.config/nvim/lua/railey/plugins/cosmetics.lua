return {
	{
		"mong8se/actually.nvim",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				theme = "edge",
			},
		},
	},
	{
		"sainnhe/edge",
		priority = 1000,
		lazy = false,
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/vim")
			vim.cmd([[colorscheme edge]])
		end,
	},
}
