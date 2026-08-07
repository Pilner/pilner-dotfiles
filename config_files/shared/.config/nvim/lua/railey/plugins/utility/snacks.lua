return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		input = { enabled = true },
		statuscolumn = { enabled = false },
		notifier = { enabled = true, timeout = 3000 },
		words = { enabled = true },
		picker = {
			win = {
				input = {
					keys = {
						["<Tab>"] = { "list_down", mode = { "i", "n" } },
						["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
					},
				},
				list = {
					keys = {
						["<Tab>"] = { "list_down", mode = { "n", "x" } },
						["<S-Tab>"] = { "list_up", mode = { "n", "x" } },
					},
				},
			},
			sources = {
				git_status = {
					win = {
						input = {
							keys = {
								["<Tab>"] = { "list_down", mode = { "i", "n" } },
								["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
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
		{
			"<leader>ff",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "[F]ind by [G]rep",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep_word()
			end,
			mode = "v",
			desc = "[F]ind selected text by [G]rep",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "[F]ind [B]uffers",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "[F]ind [H]elp",
		},
		{
			"<C-u>",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n" },
		},
	},
}
