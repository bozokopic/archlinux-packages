: ${ROOT_DIR:?}

BUILD_DIR="$ROOT_DIR/build"
AUR_DIR="$ROOT_DIR/aur"

export PATH="/usr/bin:$PATH"


get_packages() (
    if [ $# -gt 0 ]; then
        for package in "$@"; do
            if [ ! -f "$ROOT_DIR/$package/PKGBUILD" ]; then
                echo "invalid package $package" 1>&2
                exit 1
            fi
            echo $package
        done
    else
        find "$ROOT_DIR" -mindepth 2 -maxdepth 2 -type f -name PKGBUILD | \
            xargs -I {} dirname {} | \
            xargs -I {} basename {}
    fi
)


set_makepkg_envs() {
    export PKGDEST="$BUILD_DIR/$1"
    export SRCDEST="$BUILD_DIR/$1"
    export SRCPKGDEST="$BUILD_DIR"
    export LOGDEST="$BUILD_DIR"
    export BUILDDIR="$BUILD_DIR"
}
