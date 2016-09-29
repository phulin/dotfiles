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
    ln -s "$file" ~
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
if [ ! -d ~/.spf13-vim-3 ]; then
    pushd spf13-vim
    ./bootstrap.sh
    popd
    rm ~/.vimrc.before.local ~/.vimrc.local ~/.vimrc.bundles.local
fi
link .vimrc.before.local
link .vimrc.local
link .vimrc.bundles.local

mkdir -p ~/.vim/syntax
link .vim/syntax/llvm.vim
