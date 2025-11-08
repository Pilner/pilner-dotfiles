# Railey's DotFiles Configurations

A personal dotfiles configurations to suit my preference
and to easily adjust remote workspaces

## How to use

*Note: Make sure you have this installed:*

- [NVIM](https://github.com/neovim/neovim/wiki/Installing-Neovim)

*Note: This is based on a Linux Ubuntu System*

1. Clone this repository to `~/.config` in a temp folder

```bash
git clone https://github.com/Pilner/Nvim-Pilner ~/.config/temp
cd ~/.config/temp
```

2. Move all files/folders to `~/.config`
```bash
# pwd contains cloned files/folders
mv ./* ~/.config/. && mv ./.git* ~/.config/.
```

3. Open up `nvim` and wait for it to finish installing all the plugins

4. Now we're done! Enjoy!
