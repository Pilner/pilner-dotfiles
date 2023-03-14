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

-- linewrap
opt.wrap = true
opt.linebreak = true
opt.list = false

-- clipboard
--opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.hidden = true

-- enable mouse
vim.cmd [[ set mouse=a ]]

-- Keep Undo Changes
opt.undofile = true

-- disable copilot
vim.g.copilot_enabled = "v:false"


opt.timeoutlen = 1000
opt.ttimeoutlen = 0

vim.cmd [[
if has('wsl')
    let g:clipboard = {
          \   'name': 'wslclipboard',
          \   'copy': {
          \      '+': '/usr/local/bin/win32yank.exe -i --crlf',
          \      '*': '/usr/local/bin/win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': '/usr/local/bin/win32yank.exe -o --lf',
          \      '*': '/usr/local/bin/win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 1,
          \ }
endif
]]

vim.api.nvim_command("autocmd TermOpen * setlocal nonu nornu")
