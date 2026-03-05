# Dotfiles Management with Chezmoi

This repository manages dotfiles for git, zsh, oh-my-zsh, and tmux using [chezmoi](https://www.chezmoi.io/).

## Repository Structure

```
dotfiles/
├── home/                          # Dotfiles managed by chezmoi
│   ├── dot_config/                # XDG Base Directory configs
│   │   ├── git/
│   │   │   └── config            # Git configuration (template)
│   │   ├── zsh/
│   │   │   ├── zshrc             # Zsh configuration
│   │   │   └── dot_p10k.zsh      # Powerlevel10k configuration
│   │   └── tmux/
│   │       └── tmux.conf         # Tmux configuration
│   ├── dot_zshenv                 # Zsh environment (points to .config/zsh)
│   └── dot_tmux.conf              # Tmux wrapper (sources .config/tmux)
├── .chezmoi.yaml.tmpl             # Chezmoi template config
├── .env.example                   # Example environment variables
├── provision.yml                  # Ansible playbook for Ubuntu provisioning
└── README.md                      # This file
```

### XDG Base Directory Specification

This setup follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), keeping configurations organized in `~/.config/` instead of scattered across the home directory.

## Oh My Zsh Setup

This dotfiles configuration comes with a curated selection of oh-my-zsh plugins and the powerlevel10k theme for an enhanced terminal experience.

### Included Plugins

- **zsh-syntax-highlighting** - Syntax highlighting for commands as you type
- **zsh-completions** - Additional completion definitions beyond oh-my-zsh defaults
- **zsh-autosuggestions** - Suggests completions based on your history
- **fzf-tab** - Uses fzf to provide an interactive completion menu
- **git** - Built-in oh-my-zsh plugin with git command aliases

### Theme

**powerlevel10k** - A fast, customizable prompt that shows useful information like:
- Current directory
- Git branch and status
- Command execution time
- Exit status
- And much more!

## Powerlevel10k Configuration

This setup uses the **Pure-style** powerlevel10k theme, a minimalist configuration based on [sindresorhus/pure](https://github.com/sindresorhus/pure). The configuration is stored in `~/.config/zsh/.p10k.zsh`.

### Prompt Layout

The Pure-style theme uses a **2-line layout** for a clean, minimalist appearance:

```
~/projects/dotfiles (main ⇡)
❯ 
```

- **Line 1**: Current directory + Git status (when in a repository)
- **Line 2**: Prompt symbol `❯` (magenta for success, red for errors)

Optional elements that may appear on Line 1:
- **Command execution time** (yellow) - Shows only if previous command took ≥5 seconds
- **Python virtual environment** (grey) - Shows when inside a venv
- **User@host** (grey) - Shows when root or via SSH

### Customization

#### Interactive Configuration

To reconfigure the prompt interactively:

```bash
p10k configure
```

This launches the Powerlevel10k wizard which will regenerate `~/.config/zsh/.p10k.zsh` with your preferences.

#### Manual Configuration

To manually edit the configuration:

1. Edit the file: `~/.config/zsh/.p10k.zsh`
2. Look for lines starting with `POWERLEVEL9K_` to modify specific settings
3. Common customizations:
   - **Prompt segments**: Modify `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` and `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS`
   - **Colors**: Change variables like `POWERLEVEL9K_DIR_FOREGROUND`, `POWERLEVEL9K_PROMPT_CHAR_*`
   - **Time format**: Edit `POWERLEVEL9K_TIME_FORMAT` (currently `%D{%H:%M:%S}` for 24-hour format)
   - **Transient prompt**: Set `POWERLEVEL9K_TRANSIENT_PROMPT` to `always`, `off`, or `same-dir`

### Features

- **Transient prompt**: The prompt automatically simplifies to just the prompt symbol after you press Enter, keeping your terminal clean
- **Instant prompt**: A cached, minimal version of the prompt appears immediately when you open a terminal while plugins load in the background
- **Git integration**: Shows branch name, dirty status (`*`), and ahead/behind remote (`⇡`/`⇣`)
- **24-hour time format**: Displays time as HH:MM:SS (e.g., `18:51:02`)
- **No icons by default**: Uses text symbols for a minimal, universal appearance

### Pure Style Philosophy

The Pure-style theme emphasizes simplicity and clarity:
- Minimal visual clutter with just essential information
- No surrounding whitespace or separator symbols
- Color used sparingly to highlight important information
- Fast and responsive, even in large git repositories

## Quick Start - Apply to Existing System

### Prerequisites
- `wget` installed
- Git repository cloned or initialized

### Installation

```bash
# Set your personal data in environment variables (IMPORTANT!)
export CHEZMOI_NAME="Your Name"
export CHEZMOI_EMAIL="your.email@example.com"

# Initialize chezmoi with this repository
chezmoi init https://github.com/your-username/dotfiles.git
chezmoi apply
```

Or all in one command:

```bash
export CHEZMOI_NAME="Your Name"
export CHEZMOI_EMAIL="your.email@example.com"

sh -c "$(wget -qO- get.chezmoi.io)" -- init --apply your-username
```

## Provisioning a Fresh Ubuntu Install

### Prerequisites
- Ubuntu 20.04 or later
- Sudo access
- Ansible installed
- Your GitHub username
- Your name and email (for git configuration)

### One-Command Provisioning

The fastest way to provision a fresh Ubuntu system:

```bash
# Run the provisioner with your information
# Replace values in brackets with your own
ansible-playbook -i localhost, -c local provision.yml \
  -e "github_user=[your-github-username]" \
  -e "chezmoi_name='[Your Full Name]'" \
  -e "chezmoi_email='[your.email@example.com]'"
```

**Example:**
```bash
ansible-playbook -i localhost, -c local provision.yml \
  -e "github_user=alice" \
  -e "chezmoi_name='Alice Smith'" \
  -e "chezmoi_email='alice@example.com'"
```

### Step-by-Step Setup

1. **Clone the dotfiles repository** (if you haven't already):
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Install Ansible** (if not already installed):
   ```bash
   sudo apt-get update
   sudo apt-get install -y ansible
   ```

3. **Run the provisioning playbook**:
   ```bash
   ansible-playbook -i localhost, -c local provision.yml \
     -e "github_user=your-username" \
     -e "chezmoi_name='Your Name'" \
     -e "chezmoi_email='your.email@example.com'"
   ```

   If running as a specific user (not the current user):
   ```bash
   ansible-playbook -i localhost, -c local provision.yml \
     -e "ansible_user_id=username" \
     -e "github_user=your-username" \
     -e "chezmoi_name='Your Name'" \
     -e "chezmoi_email='your.email@example.com'"
   ```

### What the Provisioner Does

The playbook will automatically:
- Update package lists
- Install git, zsh, tmux, vim, wget, curl, and fzf
- Set zsh as the default shell
- Install oh-my-zsh
- Install and configure oh-my-zsh plugins:
  - zsh-syntax-highlighting
  - zsh-autosuggestions
  - zsh-completions
  - fzf-tab
- Install powerlevel10k theme
- Download and initialize chezmoi with your dotfiles (automatically clones the repository from GitHub)
- Apply all dotfiles to your system
- Set proper file permissions

After provisioning completes, your terminal will be fully configured with all plugins, theme, and dotfiles applied! Open a new terminal (or run `exec zsh`) to see the new prompt in action.

## Managing Dotfiles

### Adding New Dotfiles

1. Add the file to the `home/` directory with a `dot_` prefix
   ```bash
   chezmoi add ~/.config/yourapp/config
   ```

2. Edit the file:
   ```bash
   chezmoi edit ~/.config/yourapp/config
   ```

3. Apply changes:
   ```bash
   chezmoi apply
   ```

### Using Templates

Chezmoi supports templating with Go templates. For example, in `home/dot_config/git/config`:

```
[user]
    name = {{ .name }}
    email = {{ .email }}
```

These values are loaded from environment variables via `.chezmoi.yaml.tmpl`.

## File Organization Details

### Zsh Setup

- **`~/.zshenv`** (from `dot_zshenv`) - Sets `ZDOTDIR` to point to `~/.config/zsh`
- **`~/.config/zsh/zshrc`** (from `dot_config/zsh/zshrc`) - Main zsh configuration

This approach allows zsh to use XDG directories instead of home directory pollution.

### Tmux Setup

- **`~/.tmux.conf`** (from `dot_tmux.conf`) - Wrapper config that sources `~/.config/tmux/tmux.conf`
- **`~/.config/tmux/tmux.conf`** (from `dot_config/tmux/tmux.conf`) - Main tmux configuration

Tmux doesn't natively support XDG directories, so we use a wrapper to keep the actual config in `.config`.

### Git Setup

- **`~/.config/git/config`** (from `dot_config/git/config`) - Git configuration

Git supports XDG directories natively (since version 2.13.0).

**Note:** Git command aliases (like `git co`, `git br`, etc.) are provided by the oh-my-zsh git plugin, so they're not defined in the git config. This keeps the configuration minimal and leverages oh-my-zsh's comprehensive alias set.

### Updating Dotfiles

```bash
# Pull latest changes from remote
chezmoi update

# See what would change
chezmoi diff

# Apply changes
chezmoi apply
```

## Configuration

Edit or set environment variables for template data. Chezmoi will automatically read:

- `CHEZMOI_NAME` - Your name for git config
- `CHEZMOI_EMAIL` - Your email for git config (sensitive data, never commit)

```bash
# Set environment variables (do this before running chezmoi apply)
export CHEZMOI_NAME="Your Name"
export CHEZMOI_EMAIL="your.email@example.com"

# Then apply
chezmoi apply
```

These variables are defined in `.chezmoi.yaml.tmpl` which uses Go template syntax to load from environment variables. This file is committed to the repository, but the actual values are kept in your shell environment or `.env` file (which should be in `.gitignore`).

**Important:** The `.chezmoi.yaml` file is generated at runtime and should NOT be committed to version control. It contains your personal data. Add it to `.gitignore` if it appears in the repository.

## Useful Chezmoi Commands

- `chezmoi init` - Initialize chezmoi
- `chezmoi add <file>` - Add a dotfile to management
- `chezmoi edit <file>` - Edit a dotfile
- `chezmoi apply` - Apply dotfiles to home directory
- `chezmoi diff` - Show what would change
- `chezmoi update` - Pull latest changes from repository
- `chezmoi status` - Show status of dotfiles
- `chezmoi managed` - List all managed files

## Links

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Tmux](https://github.com/tmux/tmux/wiki)
