return {
  {
    "nvimdev/hlsearch.nvim",
    event = "BufRead",
    config = true
  },
  {
    'nvim-mini/mini.pairs',
    version = '*',
    opts = {},
  },

  {
    "tpope/vim-surround",
    event = "InsertEnter"
  },

  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "BufEnter"
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- Connects nvim-cmp to the LSP
      "L3MON4D3/LuaSnip",         -- Snippet engine (required by cmp)
      "saadparwaiz1/cmp_luasnip", -- Connects LuaSnip to nvim-cmp
    },
    config = function()
	local cmp = require("cmp")

	cmp.setup({
		-- Neovim needs a snippet engine to handle LSP snippets
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		-- Keybindings for the autocomplete menu
		mapping = cmp.mapping.preset.insert({
			["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to accept
			["<Tab>"] = cmp.mapping.select_next_item(), -- Tab to go down
			["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Shift+Tab to go up
		}),
		-- Where to get the autocomplete data from
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
		}),
	})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
	-- Enable showing errors/warnings while in insert mode
	vim.diagnostic.config({
		update_in_insert = true,
	})

	vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.diagnostic.open_float(nil, {
				focusable = false, -- Prevents your cursor from jumping into the window
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				source = "always", -- Shows which LSP sent the error (e.g., gopls)
				prefix = " ",
			})
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "LSP actions",
		callback = function(event)
			local opts = { buffer = event.buf }
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			client.server_capabilities.semanticTokensProvider = nil
			-- Jump to definition (Works across files)
			vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)

			-- Other highly recommended LSP keymaps:
			vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
			vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
			vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
			vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
			vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
			vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
			vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
			vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
		end,
	})

	require("mason").setup()

	-- Tell our LSP servers that we support advanced autocomplete capabilities
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	require("mason-lspconfig").setup({
		ensure_installed = { "gopls" },

		handlers = {
			function(server_name)
				require("lspconfig")[server_name].setup({
					-- Pass the autocomplete capabilities to every server Mason installs
					capabilities = capabilities,
				})
			end,
			["gopls"] = function()
				require("lspconfig").gopls.setup({
					capabilities = capabilities,
					settings = {
						gopls = {
							gofumpt = true, -- Tells gopls to use gofumpt instead of standard gofmt
						},
					},
				})
			end,
		},
	})
    end
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
	local conform = require("conform")

	conform.setup({
		-- Map filetypes to the formatters you want to use
		formatters_by_ft = {
			lua = { "stylua" },
			-- Use isort to sort imports, then black to format the code
			python = { "isort", "black" },
			-- Use gofumpt for strict Go formatting, and goimports to manage imports
			go = { "gofumpt", "goimports" },
			-- Prettier handles all web/frontend files perfectly
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			markdown = { "prettier" },
		},
	})

	-- Map the `=` key in both Normal and Visual mode to Conform
	vim.keymap.set({ "n", "v" }, "=", function()
		conform.format({
			lsp_fallback = true, -- If a formatter isn't found, try using the LSP (e.g., gopls)
			async = false,
			timeout_ms = 1000,
		})
		-- Automatically press Esc to clear visual highlight after formatting
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	end, { desc = "Format file or range with Conform" })
    end,
  },
}
