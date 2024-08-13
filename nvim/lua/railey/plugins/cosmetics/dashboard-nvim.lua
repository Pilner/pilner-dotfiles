return {
	'nvimdev/dashboard-nvim',
	lazy = true,
	event = 'VimEnter',
	config = function()
		require('dashboard').setup({
			theme = 'hyper',
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{
						icon = ' ',
						icon_hl = '@variable',
						desc = 'Files',
						group = 'Label',
						action = 'NvimTreeToggle',
						key = '<leader>e',
					},
					{
						desc = ' Find',
						group = 'DiagnosticHint',
						action = 'Telescope find_files',
						key = '<leader>ff',
					},
					{
						desc = ' Grep',
						group = 'Number',
						action = 'Telescope live_grep',
						key = '<leader>fg',
					},
				},
				mru = {
					cwd_only = true
				}
			},
		})  end,
	dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
