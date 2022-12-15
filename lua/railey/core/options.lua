local opt = vim.opt --for conciseness

--line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.showmatch = true
opt.incsearch = true

-- cursor line
opt.cursorline = true

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.hidden = true

-- enable mouse
vim.cmd [[ set mouse=a ]]


-- disable copilot
vim.g.copilot_enabled = "v:false"

