#!/bin/bash

CONFS=$HOME/configs
DOTCONFIG=$HOME/.config

cd $CONFS

if [ "$1" = "install" ]; then
    read -p "It will overwrite all overlaping configs. Are you sure want to install configuration onto this system? [y/N]" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    cp -r i3 nvim $DOTCONFIG
    cp .Xresources $HOME
elif [ "$1" = "write" ]; then
    cp -r $DOTCONFIG/i3 $DOTCONFIG/nvim $HOME/.Xresources .
else
    echo "Only these commands are presented:"
    echo "  install"
    echo "      install configuration from repo onto system"
    echo "  write"
    echo "      write configs from system to this repo"