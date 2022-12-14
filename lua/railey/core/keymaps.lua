vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>tn", ":tabnew<cr>")
keymap.set("n", "<leader>t<leader>", ":tabnext")
keymap.set("n", "<leader>tm", ":tabmove")
keymap.set("n", "<leader>tc", ":tabclose<cr>")
keymap.set("n", "<leader>to", ":tabonly<cr>")

keymap.set("n", "<C-H>", "<C-W>h")
keymap.set("n", "<C-J>", "<C-W>j")
keymap.set("n", "<C-K>", "<C-W>k")
keymap.set("n", "<C-L>", "<C-W>l")

keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- equal width
keymap.set("n", "<leader>sx", ":close<cr>") -- close current split windows

-- NVIM-Tree Toggle
keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

-- ALE Toggle
keymap.set("n", "<leader>at", ":ALEToggle<cr>")
