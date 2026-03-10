# Dotfiles

Minimal, modern dotfiles for zsh, tmux, and git using chezmoi. Works on macOS and Ubuntu/WSL2.

## Quick Start

### macOS

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew install ansible
ansible-playbook -i localhost, -c local -K provision.yml
```

Use the `-K` flag to be prompted for your sudo password.

### Ubuntu / WSL2

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
sudo apt-get update && sudo apt-get install -y ansible
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
ansible-playbook -i localhost, -c local -K provision.yml
```

Use the `-K` flag to be prompted for your sudo password.

### Selective Installation

Install specific roles using tags:

```bash
ansible-playbook -i localhost, -c local provision.yml --tags=zsh,fzf

# Or skip specific roles
ansible-playbook -i localhost, -c local provision.yml --skip-tags=gnome-terminal
```

## Post-Installation Steps

### iTerm2 Theme (macOS)

The Catppuccin Mocha theme is automatically downloaded and installed via the `iterm2` role. To apply it:

1. Open iTerm2 → Settings → Profiles → Colors
2. Click the "Color Presets" dropdown and select "Catppuccin Mocha"

You can skip this role during provisioning with `--skip-tags=iterm2` if you prefer not to install the theme.

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

## Managing Dotfiles

```bash
chezmoi update      # Update from repository
chezmoi edit FILE   # Edit a dotfile
chezmoi diff        # See what would change
chezmoi apply       # Apply changes
```

## Environment Variables

Set before provisioning or applying:

- `CHEZMOI_GIT_NAME` - Your name for git config
- `CHEZMOI_GIT_EMAIL` - Your email for git config

```bash
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
chezmoi apply
```

## Links

- [Zsh](https://www.zsh.org/)
- [FZF](https://github.com/junegunn/fzf)
- [Chezmoi](https://www.chezmoi.io/)
- [Tmux](https://github.com/tmux/tmux)
