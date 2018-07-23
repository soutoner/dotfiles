vim-my-way
==========

Personal configuration files and vagrant environments.

**Table of Contents**

- [.vimrc](#vimrc)
	- [Installation](#installation)
- [Git Aliases](#git-aliases)
	- [Installation](#installation-1)
- [Tmux Conf](#tmux-conf)
	- [Requirements](#requirements)
	- [Installation](#installation-2)
- [Linux Bootstrapping](#linux-bootstrapping)
	- [Contents](#contents)
	- [Usage](#usage)

.vimrc
------

Feel free to copy it.

#### Installation

```
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$ vim +PluginInstall +qall
```

Ratatata

Git Aliases
------

#### Installation

```
$ ln -s vim-my-way/gitalias.txt ~
$ ln -s vim-my-way/.gitconfig ~
```

Tmux Conf
------

#### Requirements

- Linux: `sudo apt install xclip`
- MacOS: `brew install reattach-to-user-namespace`

#### Installation

```
$ ln -s vim-my-way/tmux/.tmux-common.conf ~
```

- Linux: `$ ln -s vim-my-way/tmux/.tmux.conf ~`
- MacOS: 

```
$ ln -s vim-my-way/tmux/.tmux-macos.conf ~
$ echo "source '.tmux-macos.conf'" > .tmux.conf
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
