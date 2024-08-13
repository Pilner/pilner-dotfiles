return {
	"tpope/vim-fugitive",
	opts = {},
	config = function()
		vim.keymap.set("n", "<leader>gs", ":Git<cr>")
	end

}
