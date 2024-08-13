return {
	-- One Half 1/2 Color Scheme
	"sonph/onehalf",
	lazy = false,
	priority = 1000,
	config = function(plugin)
		vim.opt.rtp:append(plugin.dir .. '/vim')
		vim.cmd([[colorscheme onehalfdark]])
		vim.g.airline_theme='onehalfdark'
	end,
}
