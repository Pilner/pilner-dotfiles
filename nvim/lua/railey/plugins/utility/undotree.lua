return {
	"mbbill/undotree",
	event = "BufEnter",
	config = function()
		vim.keymap.set("n", "<C-u>", ":UndotreeToggle<cr>")
	end
}
