#!/bin/sh

set -e

ROOT_DIR=$(dirname "$(realpath "$0")")
. $ROOT_DIR/env.sh

makepkg_opts="-C"

while getopts g flag; do
    case $flag in
        g) makepkg_opts="$makepkg_opts -g";;
        ?) ;;
    esac
done
shift $((OPTIND - 1))

for package in $(get_packages "$@"); do
    echo ">>" $package

    set_makepkg_envs $package
    (cd "$ROOT_DIR/$package"; makepkg $makepkg_opts)
done
