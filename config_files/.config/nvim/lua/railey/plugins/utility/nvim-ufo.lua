return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async"
	},
	config = function()
		-- use Neovim nightly branch
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

		-- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'
		vim.o.foldcolumn = '1' -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
		vim.keymap.set('n', 'zR', function() require('ufo').openAllFolds() end, { silent = true, desc = 'UFO: Open All Folds' })
		vim.keymap.set('n', 'zM', function() require('ufo').closeAllFolds() end, { silent = true, desc = 'UFO: Close All Folds' })
		vim.keymap.set('n', 'H', 'za', {
			remap = true, 
			silent = true,
			desc = 'Toggle Fold (using za)'
		})
		vim.keymap.set('n', 'K', function()
			local winid = require('ufo').peekFoldedLinesUnderCursor()
			if not winid then
				-- choose one of coc.nvim and nvim lsp
				vim.fn.CocActionAsync('definitionHover') -- coc.nvim
			end
		end)

		-- Option 3: treesitter as a main provider instead
		-- (Note: the `nvim-treesitter` plugin is *not* needed.)
		-- ufo uses the same query files for folding (queries/<lang>/folds.scm)
		-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
		require('ufo').setup({
			provider_selector = function(bufnr, filetype, buftype)
				return {'treesitter', 'indent'}
			end
		})
	end
}

