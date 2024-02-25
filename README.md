# Railey's DotFiles Configurations

A personal dotfiles configurations to suit my preference
and to easily adjust remote workspaces

## How to use

*Note: Make sure you have:*

- [vim-plug](https://github.com/junegunn/vim-plug)
- [NVIM](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- [NPM](https://www.npmjs.com/package/npm) installed.

*Note: This is based on a Linux Ubuntu System*

1. Clone this repository to `~/.config` in a temp folder

```bash
git clone https://github.com/Pilner/Nvim-Pilner -b directory-change ~/.config/temp
cd ~/.config/temp
```

2. Move all files/folders to `~/.config`
```bash
# pwd contains cloned files/folders
mv ./* ~/.config/. && mv ./.git* ~/.config/.
```

3. Install all dependencies of neovim plugins
  - Open `plugins-setup.lua` using nvim
```bash
nvim ~/.config/nvim/lua/railey/plugins-setup.lua
```
  - And then run this command in normal mode
```vim
:PlugInstall
```

4. Install all dependencies of COC extensions
```bash
cd ~/.config/coc/extensions && npm install
```

5. Now we're done! Enjoy!
