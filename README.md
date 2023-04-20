vim-my-way
==========

Personal configuration files.

**Table of Contents**

- [NeoVim](#neovim)
- [Git Aliases](#git-aliases)
	- [Installation](#installation-1)
- [Shell aliases](#shell-aliases)
- [Tmux Conf](#tmux-conf)
	- [Requirements](#requirements)
	- [Installation](#installation-2)
- [Linux Bootstrapping](#linux-bootstrapping)
	- [Contents](#contents)
	- [Usage](#usage)

NeoVim
------

See [init.nvim repo](https://github.com/soutoner/init.nvim)

For easier usage (vim vs nvim command) see [Shell aliases](#shell-aliases) section.

Git Aliases
------

#### Installation

```
$ ln -s vim-my-way/gitalias.txt ~
$ ln -s vim-my-way/.gitconfig ~
```

Shell aliases
------

This step might vary dending or which shell are you using (Zsh, Bash, etc). E.g. for Zsh

```
$ ln -s vim-my-way/shell/.aliases ~
$ cat << EOF >> ~/.zshrc
if [ -f ~/.aliases ]; then
  . ~/.aliases
fi
EOF
```

Tmux Conf
------

#### Installation

`$ ln -s vim-my-way/tmux/.tmux.conf ~`

Linux Bootstrapping
-------------------

Script with configuration file that will bootstrap your brand new linux! Please, I encourage you to read the configuration file before using the script.

### Contents

```
####################################################
# Script that bootstraps a linux environment.
# All the tools marked with (opt) can be marked
# to install in the file "conf.yml". 
# Before executing this script please, take
# a look at it!
#
# Tested on:
#   - Ubuntu MATE 15.10
#
# Contents:
# 
#   . Utilities & tools
#       - Curl
#       - Composer
#       - KeepassX (opt)
#   · Development
#       - Oracle JVM
#       · Languages
#           - PHP 5
#           - Java 8
#       · VCS
#           - Git
#       · IDE
#           - Vim (w/ Vundle and 256-colors support)
#           - Gvim (opt)
#           - PHPStorm (opt)
#           - WebStorm (opt)
#   · Databases
#       - MySQL
#   · Application server
#       - Apache
#   · Notes
#       - Check available configs for
#           particular tools inside "conf.yml"
####################################################
```

### Usage

```
git clone https://github.com/soutoner/vim-my-way ~/vim-my-way
cd ~/vim-my-way/bootstrap
chmod +x linux.sh
./linux.sh
```
