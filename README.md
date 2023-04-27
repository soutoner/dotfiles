vim-my-way
==========

Personal configuration files.

**Table of Contents**

- [Tmux Conf](#tmux-conf)
- [NeoVim](#neovim)
- [Git Aliases](#git-aliases)
- [Shell aliases](#shell-aliases)
- [Linux Bootstrapping](#linux-bootstrapping)
	- [Contents](#contents)
	- [Usage](#usage)


Tmux Conf
------

1. Get latest [tmux](https://github.com/tmux/tmux/wiki/Installing)
2. Get latest [TPM](https://github.com/tmux-plugins/tpm#installation) 
3. 

```
$ mkdir ~/.config/tmux	# If it does not exist yet
$ ln -s ~/vim-my-way/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

Note: if you are using iTerm2 and you want to use opt character as Meta, please do the following:

![opt-as-meta-iterm2](images/opt-as-meta-iterm2.png)

NeoVim
------

See [init.nvim repo](https://github.com/soutoner/init.nvim)

For easier usage (vim vs nvim command) see [Shell aliases](#shell-aliases) section.

Git Aliases
------

```
$ ln -s vim-my-way/gitalias.txt ~
$ cp vim-my-way/.gitconfig ~/.gitconfig
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
