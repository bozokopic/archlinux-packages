#!/bin/sh

set -e

ROOT_DIR=$(dirname "$(realpath "$0")")
. $ROOT_DIR/env.sh

mkdir -p "$AUR_DIR"

for package in $(get_packages "$@"); do
    echo ">>" $package

    if [ -d "$AUR_DIR/$package" ]; then
        git -C "$AUR_DIR/$package" pull -q
    else
        git -C aur clone -q ssh://aur@aur.archlinux.org/$package.git
    fi

    cp -p -r -t "$AUR_DIR/$package" "$ROOT_DIR/$package/"*

    (cd "$AUR_DIR/$package"; makepkg --printsrcinfo > .SRCINFO)

    if git -C "$AUR_DIR/$package" diff --quiet; then
        echo "OK"
    else
        echo "CHANGED"
    fi
done
