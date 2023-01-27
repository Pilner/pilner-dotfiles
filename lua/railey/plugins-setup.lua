local Plug = vim.fn['plug#']


vim.call('plug#begin', '~/.config/nvim/lua/railey/plugins')

-- Deep-Space Color Scheme
Plug 'tyrannicaltoucan/vim-deep-space'

-- One Half 1/2 Color Scheme
Plug('sonph/onehalf', {rtp = 'vim'})

-- Code Dark
Plug('tomasiser/vim-code-dark')

-- Airline Custom Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

-- NVIM-Tree File Explorer
Plug 'nvim-tree/nvim-web-devicons' -- optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

-- Auto Pair Tags
Plug 'jiangmiao/auto-pairs'

-- Surround.vim
Plug 'tpope/vim-surround'

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

-- Single Compile
Plug 'xuhdev/SingleCompile'

-- Telescope.nvim
Plug 'nvim-telescope/telescope.nvim'

-- Plenary Dependencies
Plug 'nvim-lua/plenary.nvim'

-- COC
  -- COC Intellisense System
  Plug('neoclide/coc.nvim', {branch = 'release'})
  -- Emmet for HTML Snippets
  Plug 'mattn/emmet-vim'

vim.call('plug#end')
