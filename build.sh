#!/bin/sh

set -e

cd $(dirname -- "$0")

PACKAGE=$1

if [ -z "$PACKAGE" -o ! -d "$PACKAGE" ]; then
    echo "invalid package" 1>&2
    exit 1
fi

cd $PACKAGE

export PATH=/usr/bin:$PATH

makepkg -g
makepkg -C
