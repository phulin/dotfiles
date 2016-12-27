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
