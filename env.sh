root_dir="$(cd "$(dirname -- "$0")"; pwd)"
build_dir="$root_dir/build"
aur_dir="$root_dir/aur"

if [ $# -gt 0 ]; then
    packages="$*"
else
    packages="$(find "$root_dir" -mindepth 2 -maxdepth 2 -type f -name PKGBUILD | \
                xargs -I {} dirname {} | \
                xargs -I {} basename {})"
fi

for package in $packages; do
    if [ ! -f "$root_dir/$package/PKGBUILD" ]; then
        echo "invalid package $package" 1>&2
        exit 1
    fi
done

export PATH="/usr/bin:$PATH"


set_makepkg_envs() {
    package=$1
    export PKGDEST="$build_dir/$package"
    export SRCDEST="$build_dir/$package"
    export SRCPKGDEST="$build_dir"
    export LOGDEST="$build_dir"
    export BUILDDIR="$build_dir"
}
