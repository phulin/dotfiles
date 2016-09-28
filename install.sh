#!/bin/bash

cd $(dirname $0)
ln -s .tmux.conf .bashrc .gdbinit .gitconfig .tmux.conf .dircolors ~/
pushd spf13-vim
./bootstrap.sh
popd
ln -s .vimrc.before.local .vimrc.local .vimrc.bundles.local ..
