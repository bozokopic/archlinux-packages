#!/bin/sh

set -e

PACKAGES="hat-syslog
          opcut
          python-hat-aio
          python-hat-doit
          python-hat-json
          python-hat-juggler
          python-hat-util"

cd $(dirname -- "$0")

mkdir -p aur

for PACKAGE in $PACKAGES; do

    echo -n "$PACKAGE... "

    if [ -d aur/$PACKAGE ]; then
        git -C aur/$PACKAGE pull -q
    else
        git -C aur clone -q ssh://aur@aur.archlinux.org/$PACKAGE.git
    fi

    for SRC in $(find $PACKAGE -type f -a -not -name .gitignore); do
        if ! git check-ignore -q $SRC; then
            cp $SRC aur/$SRC
        fi
    done

    (cd aur/$PACKAGE; makepkg --printsrcinfo > .SRCINFO)

    if git -C aur/$PACKAGE diff --quiet; then
        echo "OK"
    else
        echo "CHANGED"
    fi

done
