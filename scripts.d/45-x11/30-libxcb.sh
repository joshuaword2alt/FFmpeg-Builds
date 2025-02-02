#!/bin/bash

LIBXCB_REPO="https://gitlab.freedesktop.org/xorg/lib/libxcb.git"
LIBXCB_COMMIT="a503167f751ba77e6819df568b7f5042d2baa9c9"

ffbuild_enabled() {
    [[ $TARGET != linux* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$LIBXCB_REPO" "$LIBXCB_COMMIT" libxcb
    cd libxcb

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
        --disable-devel-docs
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libxcb
}

ffbuild_unconfigure() {
    echo --disable-libxcb
}
