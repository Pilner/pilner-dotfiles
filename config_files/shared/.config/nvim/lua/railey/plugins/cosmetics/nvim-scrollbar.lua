return {
	"petertriho/nvim-scrollbar",
	event = "BufReadPost",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	config = function(_, opts)
		require("scrollbar").setup(opts)
	end,
}
