local Plug = vim.fn['plug#']

vim.g.ale_disable_lsp = 0

vim.call('plug#begin', '~/.config/nvim/lua/railey/plugins')

-- Deep-Space Color Scheme
Plug 'tyrannicaltoucan/vim-deep-space'

-- One Half 1/2 Color Scheme
Plug('sonph/onehalf', {rtp = 'vim'})

-- Ale Syntax Checker
Plug 'dense-analysis/ale'

-- Airline Custom Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

-- NVIM-Tree File Explorer
Plug 'nvim-tree/nvim-web-devicons' -- optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

-- Auto Pair Tags
Plug 'jiangmiao/auto-pairs'

-- Auto Comment
Plug 'tpope/vim-commentary'

-- Vim Visual Multi
Plug('mg979/vim-visual-multi', {branch = 'master'})

-- GitHub Copilot
Plug 'github/copilot.vim'

-- Tree Sitter
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- Vim Fugitive
Plug 'tpope/vim-fugitive'

-- COC
  -- COC Intellisense System
  Plug('neoclide/coc.nvim', {branch = 'release'})
  -- Emmet for HTML Snippets
  Plug 'mattn/emmet-vim'

vim.call('plug#end')

vim.g.ale_sign_column_always = 1
vim.g.ale_sign_error = '⦿'
vim.g.ale_sign_warning = '‣'
vim.g.ale_sign_info = '?'
vim.g.ale_set_highlights = 1
vim.g.coc_disable_startup_warning = 1

