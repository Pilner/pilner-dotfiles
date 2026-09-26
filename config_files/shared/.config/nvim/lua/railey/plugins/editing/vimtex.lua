return {
	"lervag/vimtex",
	lazy = false, -- required: lazy loading breaks :VimtexInverseSearch (PDF -> source sync)
	cond = function() return os.getenv("DOTFILES_PROFILE") == "personal" end, -- only load on personal machine (work profile skips)
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- configuration must be set before plugin loads (vimtex reads these at startup)
		vim.g.vimtex_view_method = "skim" -- macOS PDF viewer for forward/inverse search
	end,
}
