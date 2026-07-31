# Pilner Dotfiles

A macOS shell and application configuration repository. It installs system packages via Homebrew, links configuration into your home directory with GNU Stow, and optionally sets up Oh My Zsh with custom themes. The installer is structured to be extensible for future OS support, but macOS is currently the only supported platform.

## Prerequisites

Make sure you have the following on your system (the installer may install some of these for you):

- **Git** — clone this repository
- **Bash** — the installer is a Bash script
- **curl** — used for Homebrew and Oh My Zsh installers

If Homebrew is missing, `main.sh` installs it. Package lists live in `packages/Brewfile`.

## Setup

1. **Clone the repository**

```bash
git clone https://github.com/Pilner/pilner-dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. **Run the installer**

From the repository root:

```bash
chmod +x main.sh
./main.sh
```

By default this uses **zsh**. To use **bash** instead:

```bash
./main.sh bash
```

The script will:

- Install Homebrew packages via `brew bundle`
- Run **GNU Stow** on the `config_files/shared` and `config_files/macos` packages and on either `zsh` or `bash`
- On zsh: install **Oh My Zsh** if needed and stow the `zsh_themes/` package into `~/.oh-my-zsh/custom/themes`
- Apply macOS system defaults (key repeat, dock autohide, etc.)

3. **Restart your terminal** (or open a new session) so updated shell config and paths take effect.

## Running the installer

You only need to run `./main.sh` when you want to (re)apply packages and symlinks after cloning or pulling changes. There is no long-running server.

```bash
./main.sh        # zsh (default)
./main.sh bash   # bash
```

## Stopping / reverting Stow links

The installer does not leave a background process. To **remove** the symlinks Stow created (without deleting files inside this repo), from the repo root:

```bash
./main.sh -u
```

or directly:

```bash
stow -d config_files -D shared
stow -d config_files -D macos
stow -D zsh    # or: stow -D bash
```

Run `stow -D` for each package you previously stowed. Restore or re-run `./main.sh` when you want the links again.

## Running checks (optional)

There is no bundled test suite. After installation you can sanity-check:

- **Zsh:** `zsh --version` and open a new terminal to confirm your prompt and aliases load.
- **Git / tools:** `git --version`, `stow --version`, and any tools you added in `packages/Brewfile`.

## Adding or changing packages

Edit `packages/Brewfile`, then run `brew bundle --file=packages/Brewfile` (or run `./main.sh` again so the bundle step runs).

## Adding new Stow packages

1. Add a new directory at the repo root whose layout mirrors paths under `$HOME` (e.g. `foo/.config/...`).
2. List paths to ignore in `.stow-local-ignore` if needed.
3. From the repo root: `stow foo` (or add a `stow foo` line to `lib/stow.sh` if you want it in the default install).

Config files are split into `config_files/shared/` (cross-platform) and `config_files/macos/` (macOS-only), stowed as separate packages. A path may only exist in one subdir — `shared/` and `macos/` can't both own the same target, or Stow will report a conflict. Only `nvim/` and `ghostty/` under `shared/` are tracked in git; `macos/` is an empty placeholder (kept via `.gitkeep`) for future macOS-specific configs. Other local configs (e.g. linearmouse, opencode, neofetch, github-copilot) live only on your machine and are excluded by `config_files/shared/.config/.gitignore`.

## Resetting a “clean” home layout

To tear down Stow-managed links and reinstall from scratch:

```bash
cd ~/dotfiles   # or your clone path
./main.sh -u
./main.sh
```
Review anything under `~/` that was not created by Stow before deleting manual copies of configs.

## Additional Notes

- **GNU Stow** must be installed before `create_symlinks` runs; on macOS it is included via the Brewfile.
- `~/.config` is created as a real directory in the setup phase; only repo-managed configs are symlinked into it as leaf links, so non-managed configs there are left untouched. GNU Stow's default ignore list skips `.gitignore`, so `~/.config/.gitignore` is linked manually by the script to mirror the repo copy.
- Only `nvim/` and `ghostty/` are tracked in this repo; everything else under `config_files/` is local-only and git-ignored. `config_files/macos/` is kept in git as an empty placeholder (`.gitkeep`) for future macOS-specific configs; stow skips a package when its directory is missing from the repo, so setup won't fail on older clones.
- Custom Zsh themes live in `zsh_themes/` and are stowed as symlinks into `~/.oh-my-zsh/custom/themes` during setup.
- **iTerm2** and other tools may be installed as casks—see `packages/Brewfile` for the full list.
- The installer is split into modules under `lib/` (`logging.sh`, `platform.sh`, `macos.sh`, `shell.sh`, `stow.sh`) sourced by `main.sh`. All macOS-specific logic (packages, font, defaults, `os_stow_packages`) lives in `lib/macos.sh`; `stow.sh` is OS-agnostic. Adding another OS later means adding a module like `lib/macos.sh` (with an `os_stow_packages()` function) and registering it in `main.sh`.
