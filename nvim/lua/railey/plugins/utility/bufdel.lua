return {
	"ojroques/nvim-bufdel",
	config = function()
		-- Set 'tw' (Normal mode, Window Close) to delete the current buffer 
		-- using the command provided by nvim-bufdel
		vim.keymap.set(
			"n", 
			"tw", 
			"<CMD>BufDel<CR>", 
			{ desc = "Delete current buffer (preserve window layout)" }
		)
        
		-- Optional: You can also call setup here if you want to change default options, 
		-- e.g., to stop Neovim from quitting when the last buffer is deleted:
        -- require("bufdel").setup({
        --     quit = false,
        -- })
	end
}

