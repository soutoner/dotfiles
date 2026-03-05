# Dotfiles

Minimal, modern dotfiles for fish shell, tmux, and git using chezmoi. Works on macOS and Ubuntu/WSL2.

## Quick Start

### macOS
```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew install ansible
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
ansible-playbook -i localhost, -c local provision.yml
```

### Ubuntu / WSL2
```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo apt-get update && sudo apt-get install -y ansible
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
ansible-playbook -i localhost, -c local -K provision.yml
```

Use the `-K` flag on Ubuntu to be prompted for your sudo password.

### Selective Installation

Install specific roles using tags:
```bash
# Install only fish and fzf
ansible-playbook -i localhost, -c local provision.yml --tags=fish,fzf

# Skip tmux installation
ansible-playbook -i localhost, -c local provision.yml --skip-tags=tmux
```

Available tags: `packages`, `fish`, `fzf`, `tmux`, `gnome-terminal`, `chezmoi`

## What Gets Installed

- **Fish** shell with built-in syntax highlighting, autosuggestions, and completions
- **FZF** built from source for fuzzy finding and history search
- **Git** configuration (XDG-compliant)
- **Tmux** configuration with plugin manager (tpm)
- **Chezmoi** for dotfiles management

## Post-Installation Steps

### GNOME Terminal Theme (Ubuntu)
The Catppuccin Mocha theme is automatically installed via the `gnome-terminal` role. To apply it:
1. Open GNOME Terminal → Edit → Preferences (or Ctrl+,)
2. Go to Profiles tab → Select profile → Appearance section
3. Choose "Catppuccin Mocha" from the Color scheme dropdown
4. Close and reopen terminal for changes to take effect

You can skip this role during provisioning with `--skip-tags=gnome-terminal` if you prefer not to install the theme.

### Tmux Plugins
Start tmux and install plugins:
```bash
tmux
```
Press prefix + `I` to install plugins:
- **macOS**: `` ` `` + `I`
- **Linux**: `Ctrl-Space` + `I`

### Set Fish as Default Shell

If your system doesn't set fish as your default shell during provisioning, set it manually:
```bash
chsh -s $(which fish)
```

## Managing Dotfiles

```bash
chezmoi update      # Update from repository
chezmoi edit FILE   # Edit a dotfile
chezmoi diff        # See what would change
chezmoi apply       # Apply changes
```

## File Organization

- `~/.config/fish/config.fish` - Fish shell configuration (XDG-compliant)
- `~/.config/fish/functions/` - Fish functions
- `~/.config/git/config` - Git configuration (XDG-compliant)
- `~/.config/tmux/tmux.conf` - Tmux configuration (XDG-compliant)

## Environment Variables

Set before provisioning or applying:
- `CHEZMOI_GIT_NAME` - Your name for git config
- `CHEZMOI_GIT_EMAIL` - Your email for git config

```bash
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
chezmoi apply
```

## Why Fish?

Fish shell is a user-friendly shell with modern features out-of-the-box:
- **Built-in syntax highlighting** - No plugins needed
- **Built-in autosuggestions** - Smart history-based suggestions
- **Built-in completions** - Powerful and easy to configure
- **XDG compliant** - Automatically uses `~/.config/fish/`
- **Simple configuration** - Function-based, easy to understand

## Links

- [Fish Shell](https://fishshell.com/)
- [FZF](https://github.com/junegunn/fzf)
- [Chezmoi](https://www.chezmoi.io/)
- [Tmux](https://github.com/tmux/tmux)

