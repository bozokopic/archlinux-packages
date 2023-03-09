#!/bin/sh

set -e

cd $(dirname -- "$0")

packages="$(find . -mindepth 2 -maxdepth 2 -type f -name PKGBUILD | \
            xargs -I {} dirname {} | \
            xargs -I {} basename {})"

mkdir -p aur

for package in $packages; do

    echo -n "$package... "

    if [ -d aur/$package ]; then
        git -C aur/$package pull -q
    else
        git -C aur clone -q ssh://aur@aur.archlinux.org/$package.git
    fi

    for src in $(find $package -type f -a -not -name .gitignore); do
        if ! git check-ignore -q $src; then
            cp $src aur/$src
        fi
    done

    (cd aur/$package; makepkg --printsrcinfo > .SRCINFO)

    if git -C aur/$package diff --quiet; then
        echo "OK"
    else
        echo "CHANGED"
    fi

done
