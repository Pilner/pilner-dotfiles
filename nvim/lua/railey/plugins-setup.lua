local Plug = vim.fn['plug#']


vim.call('plug#begin', '~/.config/nvim/lua/railey/plugins')

-- Discord Rich Presence
Plug 'andweeb/presence.nvim'

-- One Half 1/2 Color Scheme
Plug('sonph/onehalf', {rtp = 'vim'})

-- Airline Custom Status Bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

-- NVIM-Tree File Explorer
Plug 'nvim-tree/nvim-web-devicons' -- optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

-- Auto Pair Tags
Plug 'jiangmiao/auto-pairs'

-- Undo Tree
Plug 'mbbill/undotree'

-- Surround.vim
Plug 'tpope/vim-surround'

-- Auto Comment
Plug 'tpope/vim-commentary'

-- Indent Marker
Plug 'lukas-reineke/indent-blankline.nvim'

-- Vim Visual Multi
Plug('mg979/vim-visual-multi', {branch = 'master'})

-- GitHub Copilot
Plug 'github/copilot.vim'

-- Tree Sitter
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- Vim Fugitive
Plug 'tpope/vim-fugitive'

-- Vim Git Gutter
Plug 'airblade/vim-gitgutter'

-- Single Compile
Plug 'xuhdev/SingleCompile'

-- Telescope.nvim
Plug 'nvim-telescope/telescope.nvim'

-- Autotag
Plug 'windwp/nvim-ts-autotag'

-- Plenary Dependencies
Plug 'nvim-lua/plenary.nvim'

-- Markdown Preview
Plug('iamcco/markdown-preview.nvim', {['do'] = 'cd app && npx --yes yarn install'})

-- COC
Plug('neoclide/coc.nvim', {branch = 'release'})

vim.call('plug#end')
