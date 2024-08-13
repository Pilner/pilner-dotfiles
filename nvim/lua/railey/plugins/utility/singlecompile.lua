return {
	"xuhdev/SingleCompile",
	event = "BufEnter",
	config = function()
		vim.keymap.set("n", "<F9>", ":SCCompile<cr>")
		vim.keymap.set("n", "<F10>", ":SCCompileRun<cr>")
	end
}
