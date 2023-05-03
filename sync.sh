#!/bin/sh

set -e

. "$(dirname -- "$0")/env.sh"

mkdir -p "$aur_dir"

for package in $packages; do
    echo ">>" $package

    if [ -d "$aur_dir/$package" ]; then
        git -C "$aur_dir/$package" pull -q
    else
        git -C aur clone -q ssh://aur@aur.archlinux.org/$package.git
    fi

    cp -p -r -t "$aur_dir/$package" "$root_dir/$package/"*

    (cd "$aur_dir/$package"; makepkg --printsrcinfo > .SRCINFO)

    if git -C "$aur_dir/$package" diff --quiet; then
        echo "OK"
    else
        echo "CHANGED"
    fi
done
