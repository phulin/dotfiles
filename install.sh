#!/bin/bash

function link() {
    ln -s "$dir/$1" ~
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
fi
rm ~/.vimrc.before.local ~/.vimrc.local ~/.vimrc.bundles.local
link .vimrc.before.local
link .vimrc.local
link .vimrc.bundles.local
