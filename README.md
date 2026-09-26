# Dotfiles

Ansible-provisioned dev environment for macOS and Ubuntu/WSL2. Ansible installs tools; chezmoi manages dotfiles.

```
┌─────────────────────────────────────────────────────┐
│                   provision.yml                     │
│                                                     │
│  packages ──► mise ──► zsh ──► fzf                  │
│      │                                   │          │
│  opencode ──► claude ──► rtk              │          │
│                                   │      │          │
│            oh-my-zsh ──► tmux ──► terminal          │
│                                   │                 │
│                               chezmoi ──► ~/        │
└─────────────────────────────────────────────────────┘
```

## Quick Start

**macOS**
```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
brew install ansible
ansible-playbook -i localhost, -c local -K ~/dotfiles/provision.yml
```

**Ubuntu / WSL2**
```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
sudo apt-get update && sudo apt-get install -y ansible
export CHEZMOI_GIT_NAME="Your Name"
export CHEZMOI_GIT_EMAIL="your@email.com"
ansible-playbook -i localhost, -c local -K ~/dotfiles/provision.yml
```

**Selective install**
```bash
ansible-playbook -i localhost, -c local provision.yml --tags=zsh,mise
ansible-playbook -i localhost, -c local provision.yml --skip-tags=iterm2
```

### Modular Playbooks

You can run specific playbooks instead of the full provision:

```bash
# Run everything (default)
ansible-playbook -i localhost, -c local -K provision.yml

# Basic system packages and config management (packages, chezmoi)
ansible-playbook -i localhost, -c local -K basic-setup.yml

# Terminal configuration (zsh, oh-my-zsh, tmux, fzf)
ansible-playbook -i localhost, -c local -K terminal.yml

# Terminal emulator themes (iterm2, gnome-terminal)
ansible-playbook -i localhost, -c local -K terminal-emulators.yml

# AI coding agents (opencode, claude, rtk)
ansible-playbook -i localhost, -c local -K coding-agents.yml
```

### Selective Installation with Tags
## What Gets Installed

| Role | Installs | Tag |
|---|---|---|
| `packages` | git, tmux, vim, bat, eza, jq + platform extras | `packages` |
| `mise` | Universal version manager + Node LTS | `mise` |
| `zsh` | zsh, sets as default shell, creates `~/.zshrc.local` | `zsh` |
| `fzf` | Fuzzy finder (built from source) | `fzf` |
| `opencode` | OpenCode CLI | `opencode` |
| `claude` | Claude Code CLI | `claude` |
| `rtk` | RTK binary + hooks for Claude Code & OpenCode | `rtk` |

| `oh-my-zsh` | Oh My Zsh + syntax-highlighting, autosuggestions, completions | `oh-my-zsh` |
| `tmux` | tpm (Tmux Plugin Manager) | `tmux` |
| `gnome-terminal` | Catppuccin Mocha theme *(Ubuntu only)* | `gnome-terminal` |
| `iterm2` | iTerm2 + Catppuccin Mocha theme *(macOS only)* | `iterm2` |
| `chezmoi` | Chezmoi + applies dotfiles from `home/` | `chezmoi` |

## Post-Install

**Tmux plugins** — first launch only:
```
prefix + I      # ` + I on macOS,  Ctrl-Space + I on Linux
```

**Terminal theme** — manual step after provisioning:
- *iTerm2*: Settings → Profiles → Colors → Color Presets → `Catppuccin Mocha`
- *GNOME Terminal*: Preferences → Profile → Appearance → `Catppuccin Mocha`

## Shell Config

Two-layer model keeps version-controlled config separate from tool-managed hooks:

```
~/.zshrc          ← chezmoi managed, git tracked
  │
  └── ~/.zshrc.local   ← Ansible managed, not tracked
                           safe for tools to append to (sdkman, etc.)
```

## Dotfiles (chezmoi)

```bash
chezmoi diff        # preview changes
chezmoi apply       # apply changes
chezmoi edit FILE   # edit a tracked file
chezmoi update      # pull + apply
```

Source lives in `home/` — chezmoi maps `dot_foo` → `~/.foo`.

## Version Management (mise)

Replaces nvm. Handles node, python, ruby, go, rust, and more.

```bash
mise use --global node@lts     # set global version
mise use node@20               # set in current project (.mise.toml)
mise ls                        # list installed versions
```

Per-project pinning via `.mise.toml`:
```toml
[tools]
node = "lts"
python = "3.12"
```

## .env Management (envlink)

Centralises all `.env` files under `~/projects/envs/`, symlinked into each project:

```
~/projects/envs/
  my-api.env ◄──── ~/projects/my-api/.env
  frontend.env ◄── ~/projects/frontend/.env
```

```bash
cd ~/projects/my-api && envlink add   # create central file + symlink
envlink edit my-api                   # edit central file
envlink ls                            # list all managed envs
envlink remove my-api                 # remove symlink, keep central file
```

> `~/projects/envs/` is the only directory that needs backing up or encrypting.

Override the central store: `export ENVLINK_DIR=~/.secrets/envs`
