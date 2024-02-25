local opt = vim.opt --for conciseness

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
vim.o.termguicolors = true

-- Comment line 10-15 & 24 if terminal colors are trash
-- Transparent Terminal
vim.api.nvim_command([[
    augroup ChangeBackgroudColour
        autocmd colorscheme * :hi normal ctermbg=NONE guibg=NONE
    augroup END
]])

-- Airline Custom Theme
vim.g.airline_theme='onehalfdark'

-- Nvim Colorscheme
vim.cmd [[ colorscheme onehalfdark ]]

-- Transparent Line Numbers
vim.cmd [[ hi LineNr guibg=NONE ]]
