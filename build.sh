#!/bin/sh

set -e

makepkg_opts="-C"

while getopts g flag; do
    case $flag in
        g) makepkg_opts="$makepkg_opts -g";;
        ?) ;;
    esac
done
shift $((OPTIND - 1))

. "$(dirname -- "$0")/env.sh"

for package in $packages; do
    echo ">>" $package

    set_makepkg_envs $package
    (cd "$root_dir/$package"; makepkg $makepkg_opts)
done
