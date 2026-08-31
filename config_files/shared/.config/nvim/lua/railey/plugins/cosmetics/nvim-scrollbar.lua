return {
	"petertriho/nvim-scrollbar",
	event = "BufReadPost",
	dependencies = {
		"lewis6991/gitsigns.nvim",
	},
	config = function(_, opts)
		require("scrollbar").setup({
			handle = {
				text = " ",
				blend = 30,
				color = nil,
				highlight = "CursorColumn",
			},
			marks = {
				Error = {
					text = { "-", "=" },
					priority = 2,
					color = "#ff0000",
					highlight = "DiagnosticVirtualTextError",
				},
				Warn = {
					text = { "-", "=" },
					priority = 3,
					color = "#ffa500",
					highlight = "DiagnosticVirtualTextWarn",
				},
				Info = {
					text = { "-", "=" },
					priority = 4,
					highlight = "DiagnosticVirtualTextInfo",
				},
				Hint = {
					text = { "-", "=" },
					priority = 5,
					highlight = "DiagnosticVirtualTextHint",
				},
			},
			handlers = {
				diagnostic = true,
				gitsigns = true,
			},
		})
	end,
}
