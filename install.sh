#!/bin/bash

function link() {
    file="$dir/$1"
    target="$HOME/$1"
    if [ -L "$target" ]; then
        echo "Skipping $target... already done."
        return
    elif [ -e "$target" ]; then
        echo "$target exists... backing up and linking."
        mv "$target" "$target"-$(date +%Y_%m_%d_%h%s)
    fi
    echo "Linking $file into ~."
    ln -s "$file" "$target"
}

function apt_install() {
    if ! dpkg-query -l "$1" &> /dev/null; then
        sudo apt-get install "$1"
    fi
}

cd $(dirname $0)
dir=$(pwd)
link .tmux.conf
link .bashrc
link .gdbinit
link .gitconfig
link .dircolors

git submodule init
git submodule update
link .vimrc.before.local
link .vimrc.bundles.local
if [ ! -d ~/.spf13-vim-3 ]; then
    pushd spf13-vim
    ./bootstrap.sh
    popd
    rm ~/.vimrc.local
fi
link .vimrc.local

mkdir -p ~/.vim/syntax
link .vim/syntax/llvm.vim

if [ ! -d ~/.gdb_printers ]; then
    mkdir ~/.gdb_printers
    pushd ~/.gdb_printers
    svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python
    popd
fi

mkdir -p ~/bin
link bin/up
link bin/qemu-ctags
link bin/doge

git submodule init
git submodule update
if which lsb_release && ( lsb_release -d | grep -q Ubuntu ) && \
        dpkg-query -l ubuntu-desktop &> /dev/null; then
    # Ubuntu Desktop
    echo "Linking in Powerline fonts & fontconfig information..."
    mkdir -p ~/.fonts.conf.d ~/.config/fontconfig/conf.d ~/.fonts/
    ln -s "$dir"/powerline/font/PowerlineSymbols.otf ~/.fonts/
    ln -s "$dir"/powerline/font/10-powerline-symbols.conf ~/.fonts.conf.d/
    ln -s "$dir"/powerline/font/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
    fc-cache -vf ~/.fonts/

    echo "Setting up Gnome Terminal profile..."
    apt_install dconf-cli
    gnome-terminal-colors-solarized/set_dark.sh

    echo "Mapping Caps to Escape..."
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

    echo "Removing icons from launcher..."
    apt_install libglib2.0-bin
    python - <<EOF
import subprocess, shlex
exec("l = " + subprocess.check_output(
    shlex.split("gsettings get com.canonical.Unity.Launcher favorites")
))
l = [s for s in l if 'amazon' not in s and 'libreoffice' not in s]
subprocess.check_call(shlex.split(
    "gsettings set com.canonical.Unity.Launcher favorites \"%s\"" % l
))
EOF
elif uname | grep -q Darwin; then
    if [ ! -e "~/Library/Fonts/Menlo for Powerline.ttf" ]; then
        cp Menlo-for-Powerline/*.ttf ~/Library/Fonts/
    fi

    if ! defaults read com.apple.Terminal "Window Settings" | \
            grep -q "Solarized Dark xterm-256color"; then
        echo "Setting up Solarized profile."
        open "solarized/osx-terminal.app-colors-solarized/xterm-256color/Solarized Dark xterm-256color.terminal"
        defaults write com.apple.Terminal "Startup Window Settings" "Solarized Dark xterm-256color"
        defaults write com.apple.Terminal "Default Window Settings" "Solarized Dark xterm-256color"
    fi
fi

if uname | grep -q Linux; then
    if [ -f /etc/sudoers ] && ! sudo grep -q env_keep /etc/sudoers; then
        echo "Adding env_keep line to sudoers..."
        sudo EDITOR='sed -f sudoers.sed -i' visudo
    fi
fi
