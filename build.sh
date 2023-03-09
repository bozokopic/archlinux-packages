#!/bin/sh

set -e

cd $(dirname -- "$0")

package=$1

if [ ! -f "./$package/PKGBUILD" ]; then
    echo "invalid package" 1>&2
    exit 1
fi

cd $package

export PATH=/usr/bin:$PATH

makepkg -g
makepkg -C
