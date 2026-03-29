# Pilner Dotfiles

A cross-platform shell and application configuration repository. It installs system packages, links configuration into your home directory with GNU Stow, and optionally sets up Oh My Zsh with custom themes so your environment stays consistent across machines.

## Prerequisites

Make sure you have the following on your system (the installer may install some of these for you):

- **Git** — clone this repository
- **Bash** — the installer is a Bash script
- **curl** — used for Homebrew and Oh My Zsh installers on macOS

**macOS:** If Homebrew is missing, `main.sh` installs it. Package lists live in `packages/Brewfile`.

**Linux:** Supported distros are **Arch** (`pacman`) and **Debian/Ubuntu** (`apt`). Package names are listed in `packages/packages.linux`.

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

- Install OS packages (Homebrew bundle on macOS, or `pacman` / `apt-get` on Linux)
- Run **GNU Stow** on the `config_files` package and on either `zsh` or `bash`
- On zsh: install **Oh My Zsh** if needed and copy themes from `zsh_themes/` into `~/.oh-my-zsh/custom/themes`

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
stow -D config_files
stow -D zsh    # or: stow -D bash
```

Run `stow -D` for each package you previously stowed. Restore or re-run `./main.sh` when you want the links again.

## Running checks (optional)

There is no bundled test suite. After installation you can sanity-check:

- **Zsh:** `zsh --version` and open a new terminal to confirm your prompt and aliases load.
- **Git / tools:** `git --version`, `stow --version`, and any tools you added in `packages/Brewfile` or `packages/packages.linux`.

## Adding or changing packages

- **macOS:** Edit `packages/Brewfile`, then run `brew bundle --file=packages/Brewfile` (or run `./main.sh` again so the bundle step runs).
- **Linux:** Edit `packages/packages.linux` (one package per line, `#` for comments), then install with your package manager or re-run `./main.sh`.

## Adding new Stow packages

1. Add a new directory at the repo root whose layout mirrors paths under `$HOME` (e.g. `foo/.config/...`).
2. List paths to ignore in `.stow-local-ignore` if needed.
3. From the repo root: `stow foo` (or add a `stow foo` line to `main.sh` if you want it in the default install).

## Resetting a “clean” home layout

To tear down Stow-managed links and reinstall from scratch:

```bash
cd ~/dotfiles   # or your clone path
stow -D config_files
stow -D zsh     # or stow -D bash
./main.sh
```

Review anything under `~/` that was not created by Stow before deleting manual copies of configs.

## Additional Notes

- **GNU Stow** must be installed before `create_symlinks` runs; on macOS it is included via the Brewfile.
- Custom Zsh themes live in `zsh_themes/` and are copied into `~/.oh-my-zsh/custom/themes` during setup.
- On macOS, **iTerm2** and other tools may be installed as casks—see `packages/Brewfile` for the full list.
