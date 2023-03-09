#!/bin/sh

set -e

cd $(dirname -- "$0")

packages="$(find . -mindepth 2 -maxdepth 2 -type f -name PKGBUILD | \
            xargs -I {} dirname {} | \
            xargs -I {} basename {})"

for package in $packages; do
    for i in $package/*; do
        if git check-ignore -q $i; then
            rm -rf $i
        fi
    done
done

