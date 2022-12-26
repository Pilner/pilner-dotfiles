vim.g.mapleader = " "

local keymap = vim.keymap

-- Regarding Tabs
keymap.set("n", "<leader>tn", ":tabnew<cr>")
keymap.set("n", "<leader>t<leader>", ":tabnext")
keymap.set("n", "<leader>tm", ":tabmove")
keymap.set("n", "<leader>tc", ":tabclose<cr>")
keymap.set("n", "<leader>to", ":tabonly<cr>")

-- Use CTRL+<hjkl> to switch between split windows
keymap.set("n", "<C-H>", "<C-W>h")
keymap.set("n", "<C-J>", "<C-W>j")
keymap.set("n", "<C-K>", "<C-W>k")
keymap.set("n", "<C-L>", "<C-W>l")
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- equal width
keymap.set("n", "<leader>sx", ":close<cr>") -- close current split windows

-- Move highlighted text up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy to system clipboard
keymap.set({"n", "v"}, "<leader>y", [["+y]])
keymap.set("n", "<leader>Y", [["+Y]])
-- Paste from system clipboard
keymap.set({"n", "v"}, "<leader>p", [["+p]])
keymap.set("n", "<leader>P", [["+P]])

-- Use alt + hjkl to resize windows
keymap.set("n", "<M-h>", ":vertical resize -2<CR>", {})
keymap.set("n", "<M-l>", ":vertical resize +2<CR>", {})
keymap.set("n", "<M-j>", ":horizontal resize -2<CR>", {})
keymap.set("n", "<M-k>", ":horizontal resize +2<CR>", {})
keymap.set("n", "<leader>zz", ":w<cr>")
