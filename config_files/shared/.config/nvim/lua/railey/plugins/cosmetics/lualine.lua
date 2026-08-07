return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = "edge",
			globalStatus = true,
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
		},
		sections = {
			lualine_c = { {
				"filename",
				path = 1,
			} },
		},
		tabline = {
			lualine_a = { "buffers" },
		},
	},
}
