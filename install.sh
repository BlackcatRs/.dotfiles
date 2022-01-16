#!/usr/bin/env bash

function insall_stow() {
    is_exist=`stow -V`
    if [ $is_exist -ne 0 ]
    then
	pacman -S stow
    fi
}


function isRoot() {
    if [ "${EUID}" -ne 0 ]; then
	echo "You need to run this script as root"
	exit 1
    fi
}


is_exist=`stow -V`
if [ $is_exist -ne 0 ];
then
    pacman -S stow
fi
