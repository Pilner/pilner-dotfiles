return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		input = { enabled = true },
		statuscolumn = { enabled = false },
		picker = {
			sources = {
				git_status = {
					win = {
						input = {
							keys = {
								-- Cycle down and up instead of staging
								["<Tab>"] = { "list_down", mode = { "i", "n" } },
								["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
								-- Remap staging to Ctrl+s so you can still stage files
								["<c-s>"] = { "git_stage", mode = { "i", "n" } },
							},
						},
					},
				},
			},
		},
	},
	keys = {
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
	},
}
