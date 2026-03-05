# Dotfiles

XDG-compliant dotfiles for zsh, tmux, and git using chezmoi for management. Works on macOS and Ubuntu.

## Quick Start

### Provision macOS

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install Ansible
brew install ansible

# Option 1: Using environment variables
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
ansible-playbook -i localhost, -c local provision.yml

# Option 2: Using vars file
cp vars.yml.example vars.yml
# Edit vars.yml with your name and email
ansible-playbook -i localhost, -c local provision.yml -e @vars.yml
```

### Provision Ubuntu

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install Ansible
sudo apt-get update
sudo apt-get install -y ansible

# Option 1: Using environment variables
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
ansible-playbook -i localhost, -c local provision.yml

# Option 2: Using vars file
cp vars.yml.example vars.yml
# Edit vars.yml with your name and email
ansible-playbook -i localhost, -c local provision.yml -e @vars.yml
```

The provisioner detects your OS and installs everything automatically.

### Provisioning Architecture

The provisioner is organized using Ansible roles for clarity and maintainability:

- **common**: Creates necessary directories (.oh-my-zsh, plugins, themes)
- **packages**: Installs packages using platform-specific package managers (Homebrew for macOS, apt for Ubuntu)
- **shell**: Sets default shell, installs oh-my-zsh, and configures all plugins and themes
- **chezmoi**: Installs chezmoi and applies your dotfiles

Each role is self-contained with its own tasks and variables, making it easy to modify or extend.

### Platform Notes

**macOS:**
- Installs Homebrew (if not present) and uses it for package management
- Sets zsh as default shell using `dscl`
- Group ownership uses `staff` instead of user

**Ubuntu:**
- Uses `apt-get` for package management
- Requires `sudo` for privilege escalation
- Sets zsh as default shell using `usermod`

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

### During Provisioning

You can provide git configuration in two ways:

**Option 1: Environment variables**
```bash
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
ansible-playbook -i localhost, -c local provision.yml
```

**Option 2: Ansible vars file**
```bash
cp vars.yml.example vars.yml
# Edit vars.yml with your values
ansible-playbook -i localhost, -c local provision.yml -e @vars.yml
```

### After Provisioning

To update git configuration later:
```bash
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your.email@example.com"
chezmoi apply
```

Variables used:
- `CHEZMOI_GIT_NAME` - Your name for git config
- `CHEZMOI_GIT_EMAIL` - Your email for git config

## Repository Structure

```
dotfiles/
├── home/                                    # Dotfiles managed by chezmoi
│   ├── dot_config/
│   │   ├── git/config
│   │   ├── zsh/
│   │   │   ├── zshrc
│   │   │   └── dot_p10k.zsh
│   │   └── tmux/tmux.conf
│   ├── dot_zshenv
│   └── dot_tmux.conf
├── roles/                                   # Ansible roles for provisioning
│   ├── common/
│   │   ├── tasks/main.yml                  # Create directories
│   │   └── vars/main.yml
│   ├── packages/
│   │   ├── tasks/main.yml                  # Install packages (macOS & Ubuntu)
│   │   └── vars/main.yml
│   ├── shell/
│   │   ├── tasks/main.yml                  # Set shell, install oh-my-zsh & plugins
│   │   └── vars/main.yml
│   └── chezmoi/
│       ├── tasks/main.yml                  # Install & initialize chezmoi
│       └── vars/main.yml
├── .chezmoi.yaml.tmpl                      # Chezmoi config with templates
├── .env.example                            # Example environment variables for chezmoi
├── .gitignore
├── vars.yml.example                        # Example Ansible variables for provisioning
├── provision.yml                           # Main provisioning playbook
└── README.md
```

## Links

- [Chezmoi](https://www.chezmoi.io/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Tmux](https://github.com/tmux/tmux)
