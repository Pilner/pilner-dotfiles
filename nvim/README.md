# Railey's Nvim Configuration

A personal nvim config files to suit my preference and to easily adjust remote workspaces

## How to use

*Note: Make sure you have [NVIM](https://github.com/neovim/neovim/wiki/Installing-Neovim) installed. To check, run `nvim` in your terminal*

*Note: Make sure you also have [vim-plug](https://github.com/junegunn/vim-plug) installed.*

*Note: This is based on a Linux Ubuntu System*

1. Clone this repository into a local directory
```
git clone https://github.com/Pilner/Nvim-Pilner
```
2. Move all files/folders to `~/.config/nvim`
```
# pwd contains cloned files/folders
mv ./* ~/.config/nvim/.
```
3. Install all dependencies of vim plugins
  - Open `plugins-setup.lua` using nvim
```
nvim ~/.config/nvim/lua/railey/plugins-setup.lua
```
  - And then run this command in normal mode
```
:PlugInstall
```
4. Now we're done! Run nvim to check
```
nvim
```

## Plugins

- [Deep-Space Color Scheme](https://github.com/tyrannicaltoucan/vim-deep-space)
- [One Half 1/2 Color Scheme](https://github.com/sonph/onehalf)
- [COC Intellisense System](https://github.com/neoclide/coc.nvim)
- [Airline Custom Status Bar](https://github.com/vim-airline/vim-airline)
  - [Themes](https://github.com/vim-airline/vim-airline-themes)
- [NVIM-Tree File Explorer](https://github.com/nvim-tree/nvim-web-devicons)
  - [Icons](https://github.com/nvim-tree/nvim-tree.lua)
- [Auto Pair Tags](https://github.com/jiangmiao/auto-pairs)
- [Vim Surround](https://github.com/tpope/vim-surround)
- [Undo Tree](https://github.com/mbbill/undotree)
- [Auto Comment](https://github.com/tpope/vim-commentary)
- [Indent Blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
- [Vim Visual Multi](https://github.com/mg979/vim-visual-multi)
- [GitHub Copilot](https://github.com/github/copilot.vim)
- [Tree Sitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [Vim Fugitive](https://github.com/tpope/vim-fugitive)
- [Vim Git Gutter](https://github.com/airblade/vim-gitgutter)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [Plenary Dependencies](https://github.com/nvim-lua/plenary.nvim)
- [Markdown Preview](https://github.com/iamcco/markdown-preview.nvim)
- [Actually](https://github.com/mong8se/actually.nvim)
- [Dressing](https://github.com/stevearc/dressing.nvim)
