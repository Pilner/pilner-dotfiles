return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local make_entry = require("telescope.make_entry")
		local conf = require("telescope.config").values

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
				hidden = true,
			},
		},
		})

		telescope.load_extension("fzf")

		local function build_rg_command(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }

			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			return vim.iter({
				args,
				{
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
			}):flatten():totable()
		end

		local function get_visual_selection()
			local saved_reg = vim.fn.getreg("v")
			vim.cmd('noau normal! "vy"')
			local selection = vim.fn.getreg("v")
			vim.fn.setreg("v", saved_reg)
			return selection
		end

		local function live_multigrep(opts)
			opts = opts or {}
			opts.cwd = opts.cwd or vim.uv.cwd()

			local finder = finders.new_async_job({
				command_generator = build_rg_command,
				entry_maker = make_entry.gen_from_vimgrep(opts),
				cwd = opts.cwd,
			})

			pickers
				.new(opts, {
					debounce = 100,
					prompt_title = "Multi Grep",
					finder = finder,
					previewer = conf.grep_previewer(opts),
					sorter = require("telescope.sorters").empty(),
					default_text = opts.search_text or "",
				})
				:find()
		end

		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({
				find_command = { "rg", "--files", "--sortr=modified" },
				tiebreak = function(current_entry, existing_entry, _)
					return current_entry.index < existing_entry.index
				end,
			})
		end, { desc = "[F]ind [F]iles with Recency Bias" })

		vim.keymap.set("n", "<leader>fg", live_multigrep, { desc = "[F]ind by [G]rep (multigrep)" })
		vim.keymap.set("v", "<leader>fg", function()
			local selection = get_visual_selection()
			live_multigrep({ search_text = selection })
		end, { desc = "[F]ind selected text by [G]rep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
	end,
}
