#!/bin/bash

CONFS=$HOME/confs
DOTCONFIG=$HOME/.config

cd $CONFS

if [ "$1" = "install" ]; then
    read -p "It will overwrite all overlaping configs. Are you sure want to install configuration onto this system? [y/N]" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    rm -rf $DOTCONFIG/i3 $DOTCONFIG/i3status $DOTCONFIG/nvim $HOME/.Xresources

    cp -rv i3 i3status nvim $DOTCONFIG
    cp -v .Xresources $HOME

    echo "Done"
elif [ "$1" = "write" ]; then
    rm -rf i3 i3status nvim .Xresources

    cp -rv $DOTCONFIG/i3 $DOTCONFIG/i3status $DOTCONFIG/nvim $HOME/.Xresources .
    git diff
else
    echo "  COMMANDS"
    echo "    install"
    echo "      install configuration from repo onto system"
    echo "    write"
    echo "      write configs from system to this repo"
fi
