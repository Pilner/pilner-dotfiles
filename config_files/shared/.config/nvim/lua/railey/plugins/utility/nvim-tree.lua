return {
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

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			api.map.on_attach.default(bufnr)

			vim.keymap.del("n", "<C-e>", { buffer = bufnr })
		end

		require("nvim-tree").setup({
			on_attach = my_on_attach,
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
	end,
}
