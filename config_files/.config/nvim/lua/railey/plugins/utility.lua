return {
  {
    "rcarriga/nvim-notify",
    config = function()
	vim.notify = require("notify")

	vim.notify.setup({
		background_colour = "#000000",
	})
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
	-- disable netrw at the very start of your init.lua (strongly advised)
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- set termguicolors to enable highlight groups
	vim.opt.termguicolors = true

	local sort_by_name = true
	local function sort_by_natural(nodes)
		local function sorter(left, right)
			if left.type ~= "directory" and right.type == "directory" then
				return false
			elseif left.type == "directory" and right.type ~= "directory" then
				return true
			end
			left = left.name:lower()
			right = right.name:lower()

			if left == right then
				return false
			end

			for i = 1, math.max(string.len(left), string.len(right)), 1 do
				local l = string.sub(left, i, -1)
				local r = string.sub(right, i, -1)

				if
					type(tonumber(string.sub(l, 1, 1))) == "number"
					and type(tonumber(string.sub(r, 1, 1))) == "number"
				then
					local l_number = tonumber(string.match(l, "^[0-9]+"))
					local r_number = tonumber(string.match(r, "^[0-9]+"))

					if l_number ~= r_number then
						return l_number < r_number
					end
				elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
					return l < r
				end
			end
		end

		if sort_by_name then
			table.sort(nodes, sorter)
		else
			return "modification_time"
		end
	end

	require("nvim-tree").setup({
		on_attach = on_attach,
		sort_by = sort_by_natural,

		view = {
			adaptive_size = true,
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = false,
			git_ignored = false,
		},
		open_on_tab = true,
		sync_root_with_cwd = true, -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
		nested = true,
	})

	-- Toggle Nvim-Tree
	vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

	vim.keymap.set("n", "<leader>tf", ":NvimTreeFindFile<cr>")
    end
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
	-- 1. Neovim options required for UFO folding
	vim.o.foldcolumn = "1"
	vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
	vim.o.foldlevel = 99
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true

	local builtin = require("statuscol.builtin")

	-- 2. Combined statuscol setup
	require("statuscol").setup({
		setopt = true,
		relculright = true,
		segments = {
			-- Segment 1: UFO Fold column
			{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },

			-- Segment 2: Git signs
			{
				sign = {
					namespace = { "gitsigns.*" },
					name = { "gitsigns.*" },
				},
				click = "v:lua.ScSa",
			},

			-- Segment 3: All other signs (LSP Diagnostics, etc.)
			{
				sign = {
					namespace = { ".*" },
					name = { ".*" },
					maxwidth = 1,
					colwidth = 1,
					auto = false,
				},
				click = "v:lua.ScSa",
			},

			-- Segment 4: Custom absolute and relative line numbers
			{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
		},
	})
        end,
      },
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function()
	return { "treesitter", "indent" }
      end,
    },
    init = function()
	-- Keymaps for UFO
	vim.keymap.set("n", "zR", function()
		require("ufo").openAllFolds()
	end)
	vim.keymap.set("n", "zM", function()
		require("ufo").closeAllFolds()
	end)
	vim.keymap.set("n", "H", "za", {
		remap = true,
		silent = true,
		desc = "Toggle Fold (using za)",
	})

	-- Hover definition (Note: I updated the fallback here for native LSP)
	vim.keymap.set("n", "K", function()
		local winid = require("ufo").peekFoldedLinesUnderCursor()
		if not winid then
			-- Since you set up nvim-lspconfig earlier, this triggers standard LSP hover
			vim.lsp.buf.hover()
		end
	end)
    end,
  },

  {
    "andweeb/presence.nvim",
    event = "VimEnter",
    config = true
  },
  {
    "xuhdev/SingleCompile",
    event = "BufEnter",
    config = function()
	vim.keymap.set("n", "<F9>", ":SCCompile<cr>")
	vim.keymap.set("n", "<F10>", ":SCCompileRun<cr>")
    end
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
      statuscolumn = { enabled = false },
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    event = "VimEnter",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
	local telescope = require("telescope")

	telescope.setup({
		defaults = {
			layout_strategy = "horizontal",
			sorting_strategy = "ascending",
			preview = {
				treesitter = false,
			},
		},
    pickers = {
      find_files = {
        hidden = true
      }
    }
	})

	local builtin = require("telescope.builtin")
	-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	vim.keymap.set("n", "<leader>ff", function()
		require("telescope.builtin").find_files({
			find_command = { "rg", "--files", "--sortr=modified" }, -- Optional: sorts OS-level by date
			tiebreak = function(current_entry, existing_entry, _)
				-- This prioritizes more recently opened files in the fuzzy list
				return current_entry.index < existing_entry.index
			end,
		})
	end, { desc = "[F]ind [F]iles with Recency Bias" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c",
        "go",
        "tsx",
        "json",
        "javascript",
        "typescript",
        "python",
        "lua",
        "vim",
        "bash",
        "markdown",
      },
    },
  },
  {
    "mbbill/undotree",
    event = "BufEnter",
    config = function()
	vim.keymap.set("n", "<C-u>", ":UndotreeToggle<cr>")
    end
  },
  {
    "tpope/vim-commentary",
    event = "BufEnter"
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter", -- Loads when you open a buffer
    opts = {
      signs = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      -- delay = 1000,
    },
    config = function(_, opts)
	require("gitsigns").setup(opts)

	vim.opt.signcolumn = "yes"
    end
  },
}
