local opt = vim.opt --for conciseness

--line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.autoindent = true
opt.expandtab = true -- Converts tabs to spaces
opt.smartindent = true

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
opt.breakindent = true

-- word separators
opt.iskeyword:remove({"-", "_"})

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

-- Decrease update time for faster CursorHold (diagnostic hover)
opt.updatetime = 250

-- If WSL is being used
if vim.fn.has("win32") == 1 then
	vim.g.clipboard = {
	name = "WslClipboard",
	copy = {
	    ['+'] = "clip.exe",
	    ['*'] = "clip.exe",
	},
	paste = {
	    ['+'] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
	    ['*'] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
	},
	cache_enabled = 0,
	}
end

vim.api.nvim_command("autocmd TermOpen * setlocal nonu nornu")

vim.cmd [[autocmd FileType * set formatoptions-=ro]]


