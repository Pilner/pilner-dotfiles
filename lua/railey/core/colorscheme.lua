local opt = vim.opt --for conciseness

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

vim.api.nvim_command([[
    augroup ChangeBackgroudColour
        autocmd colorscheme * :hi normal ctermbg=NONE guibg=NONE
    augroup END
]])
vim.o.termguicolors = true

vim.g.airline_theme='onehalfdark'

vim.cmd [[ colorscheme onehalfdark ]]
vim.cmd [[ hi LineNr guibg=NONE ]]
