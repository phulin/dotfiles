#!/bin/bash

function link() {
    file="$(pwd)/$1"
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

cd $(dirname "$0")
link .tmux.conf
link .bashrc
link .gdbinit
link .gitconfig
link .dircolors

mkdir -p ~/.local/bin
link .local/bin/up
link .local/bin/doge

if [ ! -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
fi

git submodule init
git submodule update

if which lsb_release > /dev/null && ( lsb_release -d | grep -q Ubuntu ) && \
        dpkg-query -l ubuntu-desktop &> /dev/null; then
    # Ubuntu Desktop
    mkdir -p ~/.fonts.conf.d ~/.config/fontconfig/conf.d ~/.fonts/
    if [ ! -e ~/.fonts/PowerlineSymbols.otf ] || \
        [ ! -e ~/.fonts.conf.d/10-powerline-symbols.conf ] || \
        [ ! -e ~/.config/fontconfig/conf.d/10-powerline-symbols.conf ]; then
        echo "Linking in Powerline fonts & fontconfig information..."
        ln -s $(pwd)/powerline/font/PowerlineSymbols.otf ~/.fonts/
        ln -s $(pwd)/powerline/font/10-powerline-symbols.conf ~/.fonts.conf.d/
        ln -s $(pwd)/powerline/font/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
        fc-cache -vf ~/.fonts/
    fi

    apt_install dconf-cli

    echo "Setting up Gnome Terminal profile..."
    profile_id=$(dconf list /org/gnome/terminal/legacy/profiles:/ | head -n 1)
    dconf_color=/org/gnome/terminal/legacy/profiles:/"$profile_id"foreground-color
    if ! ( dconf read "$dconf_color" | grep -q 838394949696 ); then
        gnome-terminal-colors-solarized/set_dark.sh
    fi

    echo "Mapping Caps to Escape..."
    dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:escape']"

    echo "Removing icons from launcher..."
    apt_install libglib2.0-bin
    python - <<EOF
import subprocess, shlex
exec("l = " + subprocess.check_output(
    ['gsettings', 'get', 'com.canonical.Unity.Launcher', 'favorites']))
l = [s for s in l if 'amazon' not in s and 'libreoffice' not in s]
subprocess.check_call(
    ['gsettings', 'set', 'com.canonical.Unity.Launcher', 'favorites', str(l)])
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
