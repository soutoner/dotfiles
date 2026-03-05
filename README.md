# Dotfiles

XDG-compliant dotfiles for zsh, tmux, and git using chezmoi for management.

## Quick Start

### Provision a Fresh Ubuntu System

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles

sudo apt-get update
sudo apt-get install -y ansible

ansible-playbook -i localhost, -c local provision.yml \
  -e "chezmoi_git_name='Your Name'" \
  -e "chezmoi_git_email='your.email@example.com'"
```

The provisioner will install everything and apply dotfiles automatically.

### Apply to Existing System

```bash
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"

sh -c "$(wget -qO- get.chezmoi.io)" -- init --apply ~/dotfiles
```

## What You Get

- **Zsh** with oh-my-zsh and plugins (syntax-highlighting, autosuggestions, completions, fzf-tab)
- **Powerlevel10k** theme with Pure-style configuration (minimalist 2-line prompt)
- **Git** configuration with XDG compliance
- **Tmux** configuration with XDG wrapper
- **Chezmoi** installed and ready for managing dotfiles

## Configuration

### Powerlevel10k Prompt

Reconfigure the prompt:
```bash
p10k configure
```

Edit directly:
```bash
$EDITOR ~/.config/zsh/.p10k.zsh
```

Features:
- 2-line layout: directory + git status on line 1, prompt symbol on line 2
- 24-hour time format
- Transient prompt (simplifies after command execution)
- Instant prompt (cached prompt while plugins load)

## Managing Dotfiles

```bash
# Update from repository
chezmoi update

# Edit a dotfile
chezmoi edit ~/.config/zsh/zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

## File Organization

Using XDG Base Directory Specification:

- `~/.zshenv` - Sets ZDOTDIR to ~/.config/zsh
- `~/.config/zsh/zshrc` - Zsh configuration
- `~/.config/zsh/.p10k.zsh` - Powerlevel10k configuration
- `~/.config/git/config` - Git configuration
- `~/.config/tmux/tmux.conf` - Tmux configuration
- `~/.tmux.conf` - Wrapper sourcing ~/.config/tmux/tmux.conf (tmux doesn't natively support XDG)

## Environment Variables

Chezmoi loads these from environment variables via `.chezmoi.yaml.tmpl` for git configuration:

- `CHEZMOI_GIT_NAME` - Your name for git config
- `CHEZMOI_GIT_EMAIL` - Your email for git config

Set before applying:
```bash
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
chezmoi apply
```

## Repository Structure

```
dotfiles/
├── home/                          # Dotfiles managed by chezmoi
│   ├── dot_config/
│   │   ├── git/config
│   │   ├── zsh/
│   │   │   ├── zshrc
│   │   │   └── dot_p10k.zsh
│   │   └── tmux/tmux.conf
│   ├── dot_zshenv
│   └── dot_tmux.conf
├── .chezmoi.yaml.tmpl             # Chezmoi config with templates
├── .gitignore
├── provision.yml                  # Ansible provisioning playbook
└── README.md
```

## Links

- [Chezmoi](https://www.chezmoi.io/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Tmux](https://github.com/tmux/tmux)
