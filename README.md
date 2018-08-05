vim-my-way
==========

Personal configuration files and vagrant environments.

**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [.vimrc](#)
	- [Installation](#)
- [Git Aliases](#)
	- [Installation](#)
- [Tmux Conf](#)
	- [Requirements](#)
	- [Installation](#)
- [Linux Bootstrapping](#)
	- [Contents](#)
	- [Usage](#)

.vimrc
------

Feel free to copy it.

#### Installation

First, let's install [vim-plug](https://github.com/junegunn/vim-plug)

* Vim:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

* NeoVim:

```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Additionaly we have to link our `.vimrc` to NeoVim (for further infor check [:help nvim-from-vim](https://neovim.io/doc/user/nvim.html#nvim-from-vim))

```
# ~/.config/nvim/init.vim

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
```

Common step:

```
$ vim +PlugInstall +qall
```

Git Aliases
------

#### Installation

```
$ ln -s vim-my-way/gitalias.txt ~
$ ln -s vim-my-way/.gitconfig
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
