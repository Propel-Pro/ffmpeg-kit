#!/usr/bin/env bash

export ANDROID_SDK_ROOT=$HOME/android-r35.0.2
export ANDROID_NDK_ROOT=$HOME/android-ndk-r25c
export ANDROID_HOME=$ANDROID_SDK_ROOT
export NDK_HOME=$ANDROID_NDK_ROOT
export ANDROID_NDK=$ANDROID_NDK_ROOT
export PATH=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH

get_sdk_name() {
    echo "iphoneos"
}


export IOS_MIN_VERSION=15.0
export SDK_PATH=$(echo "$(xcrun --sdk "$(get_sdk_name)" --show-sdk-path 2>>build.log)")
export SDK_NAME=$(get_sdk_name)

export CFLAGS="-I/usr/local/include $CFLAGS"

# For Apple Silicon Macs:
# export ACLOCAL_PATH="/opt/homebrew/share/aclocal"

# For Intel Macs:
export ACLOCAL_PATH="/usr/local/share/aclocal"

export ACLOCAL="aclocal -I $ACLOCAL_PATH"

export GETTEXT_MACRO_DIR=/usr/local/Cellar/gettext/0.25/share/gettext/m4

if [[ $(grep -c "/usr/local/opt/libiconv" $HOME/.bash_profile > /dev/null 2>&1) -eq 0 ]]
then
    echo 'export PATH="/usr/local/opt/libiconv/bin:$PATH"' >> $HOME/.bash_profile
fi
export PATH="/usr/local/opt/libiconv/bin:$PATH"

if [[ $(grep -c "/usr/local/opt/bison" $HOME/.bash_profile > /dev/null 2>&1) -eq 0 ]]
then
    echo 'export PATH="/usr/local/opt/bison/bin:$PATH"' >> $HOME/.bash_profile
fi
export PATH="/usr/local/opt/bison/bin:$PATH"

if [[ $(grep -c "/usr/local/Cellar/gtk-doc" $HOME/.bash_profile > /dev/null 2>&1) -eq 0 ]]
then
    echo 'export PATH="/usr/local/Cellar/gtk-doc/1.34.0/bin:$PATH"' >> $HOME/.bash_profile
fi
export PATH="/usr/local/Cellar/gtk-doc/1.34.0/bin:$PATH"

if [[ $(grep -c "/usr/local/Cellar/make" $HOME/.bash_profile > /dev/null 2>&1) -eq 0 ]]
then
    echo 'export PATH="/usr/local/Cellar/make/4.4.1/bin:$PATH"' >> $HOME/.bash_profile
fi
export PATH="/usr/local/Cellar/make/4.4.1/bin:$PATH"


# PKG_CONFIG        path to pkg-config utility
# PKG_CONFIG_PATH   directories to add to pkg-config's search path
# PKG_CONFIG_LIBDIR path overriding pkg-config's built-in search path
export PKG_CONFIG=$(which pkg-config)
# export PKG_CONFIG_PATH=$(which pkg-config)
# export PKG_CONFIG_LIBDIR=$(which pkg-config)
echo "PKG_CONFIG: $PKG_CONFIG"
# echo "PKG_CONFIG_PATH: $PKG_CONFIG_PATH"
# echo "PKG_CONFIG_LIBDIR: $PKG_CONFIG_LIBDIR"

export LDFLAGS="-L/usr/local/opt/libiconv/lib"
export CPPFLAGS="-I/usr/local/opt/libiconv/include"

# For Apple Silicon Macs:
# export ACLOCAL_PATH="/opt/homebrew/share/aclocal"

# For Intel Macs:
export ACLOCAL_PATH="/usr/local/share/aclocal"

export CFLAGS="-Wno-unknown-warning-option -Wno-incompatible-function-pointer-types -Wno-implicit-function-declaration $CFLAGS"
export CXXFLAGS="-Wno-unknown-warning-option -Wno-incompatible-function-pointer-types -Wno-implicit-function-declaration $CXXFLAGS"

# export PERL5LIB=$(which perl)
# export PERL5LIB=src/openssl/util/perl

# Run this to fix the SDL build script
fix_sdl_build()
{
    sed -i .bak -E 's/CFLAGS  = @BUILD_CFLAGS@$/\1 -Wno-incompatible-function-pointer-types/g' src/sdl/Makefile.in
    sed -i .bak -E 's/EXTRA_CFLAGS  = @EXTRA_CFLAGS@$/\1 -Wno-incompatible-function-pointer-types/g' src/sdl/Makefile.in
}

show_help()
{
    echo "Usage: $0 ..args.. platform"
    echo "\tplatform can be one of: Android, iOS"
}

install_dependencies()
{
    # autoconf automake libtool pkg-config curl git doxygen nasm cmake gcc gperf texinfo yasm bison autogen wget autopoint meson ninja ragel groff gtk-doc-tools libtasn1

    os=$(uname)
    echo "Installing dependencies..."
    if [[ "$os" == "Linux" ]]
    then
        sudo apt update

        sudo apt install -y autoconf autogen automake bison curl doxygen gawk git \
            gettext gperf groff gtk-doc libtool meson pkg-config pkgconf \
            ragel
    elif [[ "$os" == "Darwin" ]]
    then
        brew install autoconf autogen automake bison curl doxygen gawk git \
            gettext gperf groff gtk-doc libtool meson openssl@3 pkg-config pkgconf \
            ragel
    else
        echo "Unsupported OS: $os"
        exit 1
    fi
}

if [[ $# -lt 1 ]]
then
    show_help
    exit -1
fi

if [[ ! -d "$ANDROID_SDK_ROOT" ]]
then
    echo "Error: ANDROID_SDK_ROOT not set or invalid. Aborting..."
    exit -1
fi

if [[ ! -d "$ANDROID_NDK_ROOT" ]]
then
    echo "Error: ANDROID_NDK_ROOT not set or invalid. Aborting..."
    exit -1
fi

# Ensure we've installed the dependencies needed for this script
install_dependencies

# Ensure directories exist
needs_m4_dirs=(giflib libogg expat/expat lame/lame libvorbis)
for dir in "${needs_m4_dirs[@]}"
do
    mkdir -p "src/$dir/m4"
done

args=()

# args+=("--enable-fribidi")
# args+=("--enable-gmp")

# args+=("--enable-fontconfig")
# args+=("--enable-freetype")
# args+=("--enable-gnutls")
# args+=("--enable-lame")
# args+=("--enable-libass")
# args+=("--reconf-libiconv")
# args+=("--enable-libiconv")
# args+=("--enable-libtheora")
# args+=("--enable-libvorbis")
# args+=("--enable-libvpx")
# args+=("--enable-libwebp")
# args+=("--enable-libxml2")
# args+=("--enable-opencore-amr")
# args+=("--enable-shine")
# args+=("--enable-speex")
# args+=("--enable-dav1d")
# args+=("--enable-kvazaar")
# args+=("--enable-x264")
# args+=("--enable-xvidcore")
# args+=("--enable-x265")
# args+=("--enable-libvidstab")
# args+=("--enable-rubberband")
# args+=("--enable-libilbc")
# args+=("--enable-opus")
# args+=("--enable-snappy")
# args+=("--enable-soxr")
# args+=("--enable-libaom")
# args+=("--enable-chromaprint")
# args+=("--enable-twolame")
# args+=("--enable-sdl")
# args+=("--enable-tesseract")
# args+=("--enable-openh264")
# args+=("--enable-vo-amrwbenc")
# args+=("--enable-zimg")
# args+=("--enable-openssl")
# args+=("--enable-srt")
# args+=("--enable-giflib")
# args+=("--enable-jpeg")
# args+=("--enable-libogg")
# args+=("--enable-libpng")
# args+=("--enable-libuuid")
# args+=("--enable-nettle")
# args+=("--enable-tiff")
# args+=("--enable-expat")
# args+=("--enable-libsndfile")
# args+=("--enable-leptonica")
# args+=("--enable-libsamplerate")
# args+=("--enable-harfbuzz")
# args+=("--enable-cpu-features")
#   50)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "android" ]]; then
#       echo "android-zlib"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "ios" ]]; then
#       echo "ios-zlib"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "linux" ]]; then
#       echo "linux-zlib"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-zlib"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "tvos" ]]; then
#       echo "tvos-zlib"
#     fi
#     ;;
# args+=("--enable-linux-alsa")
# args+=("--enable-android-media-codec")
#   53)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "ios" ]]; then
#       echo "ios-audiotoolbox"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-audiotoolbox"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "tvos" ]]; then
#       echo "tvos-audiotoolbox"
#     fi
#     ;;
#   54)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "ios" ]]; then
#       echo "ios-bzip2"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-bzip2"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "tvos" ]]; then
#       echo "tvos-bzip2"
#     fi
#     ;;
#   55)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "ios" ]]; then
#       echo "ios-videotoolbox"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-videotoolbox"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "tvos" ]]; then
#       echo "tvos-videotoolbox"
#     fi
#     ;;
#   56)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "ios" ]]; then
#       echo "ios-avfoundation"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-avfoundation"
#     fi
#     ;;
#   57)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "ios" ]]; then
#       echo "ios-libiconv"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-libiconv"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "tvos" ]]; then
#       echo "tvos-libiconv"
#     fi
#     ;;
#   58)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "ios" ]]; then
#       echo "ios-libuuid"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-libuuid"
#     elif [[ ${FFMPEG_KIT_BUILD_TYPE} == "tvos" ]]; then
#       echo "tvos-libuuid"
#     fi
#     ;;
#   59)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-coreimage"
#     fi
#     ;;
#   60)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-opencl"
#     fi
#     ;;
#   61)
#     if [[ ${FFMPEG_KIT_BUILD_TYPE} == "macos" ]]; then
#       echo "macos-opengl"
#     fi
#     ;;
# args+=("--enable-linux-fontconfig")
# args+=("--enable-linux-freetype")
# args+=("--enable-linux-fribidi")
# args+=("--enable-linux-gmp")
# args+=("--enable-linux-gnutls")
# args+=("--enable-linux-lame")
# args+=("--enable-linux-libass")
# args+=("--enable-linux-libiconv")
# args+=("--enable-linux-libtheora")
# args+=("--enable-linux-libvorbis")
# args+=("--enable-linux-libvpx")
# args+=("--enable-linux-libwebp")
# args+=("--enable-linux-libxml2")
# args+=("--enable-linux-opencore-amr")
# args+=("--enable-linux-shine")
# args+=("--enable-linux-speex")
# args+=("--enable-linux-opencl")
# args+=("--enable-linux-xvidcore")
# args+=("--enable-linux-x265")
# args+=("--enable-linux-libvidstab")
# args+=("--enable-linux-rubberband")
# args+=("--enable-linux-v4l2")
# args+=("--enable-linux-opus")
# args+=("--enable-linux-snappy")
# args+=("--enable-linux-soxr")
# args+=("--enable-linux-twolame")
# args+=("--enable-linux-sdl")
# args+=("--enable-linux-tesseract")
# args+=("--enable-linux-vaapi")
# args+=("--enable-linux-vo-amrwbenc")

rm -rf build.log
while [[ $# -gt 0 ]]
do
    case "$1" in
        android|Android)
            PATH=/usr/local/Cellar/gettext/0.25/bin:$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH \
                ./android.sh "${args[@]}"
            ;;
        iOS|ios)
            args+=(--target="${IOS_MIN_VERSION}")
            xcode_version=$(xcodebuild -version | grep -E '^Xcode ' | awk '{print $2}')
            echo "export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer" > ~/.xcode.for.ffmpeg.kit.sh
            chmod +x ~/.xcode.for.ffmpeg.kit.sh
            ./ios.sh "${args[@]}"
            ;;
        --full)
            args+=(--full)
            ;;
        --api-level=*)
            API_LEVEL=$(echo $1 | sed -e 's/^--[A-Za-z]*-[A-Za-z]*=//g')
            args+=(--api-level="${API_LEVEL}")
            ;;
        --enable-gpl)
            args+=(--enable-gpl)
            ;;
        --rebuild)
            args+=(--rebuild)
            ;;
        # --build)
        #     ;;
        -v | --version)
            args+=(--version)
            ;;
        --skip-*)
            args+=("$1")
            ;;
        --no-bitcode)
            args+=("$1")
            ;;
        --no-framework)
            args+=("$1")
            ;;
        --no-output-redirection)
            args+=("$1")
            ;;
        --no-workspace-cleanup-*)
            args+=("$1")
            ;;
        -d | --debug)
            args+=("$1")
            ;;
        -s | --speed)
            args+=("$1")
            ;;
        -l | --lts)
            args+=("$1")
            ;;
        -x | --xcframework)
            args+=("$1")
            ;;
        -f | --force)
            args+=("$1")
            ;;
        --reconf-*)
            args+=("$1")
            ;;
        --rebuild-*)
            args+=("$1")
            ;;
        --redownload-*)
            args+=("$1")
            ;;
        --enable-custom-library-*)
            args+=("$1")
            ;;
        --enable-*)
            args+=("$1")
            ;;
        --disable-lib-*)
            args+=("$1")
            ;;
        --disable-*)
            args+=("$1")
            ;;
        --target=*)
            TARGET=$(echo $1 | sed -e 's/^--[A-Za-z]*=//g')

            IOS_MIN_VERSION=${TARGET}
            ;;
        --mac-catalyst-target=*)
            args+=("$1")
            ;;
        --clean)
            cd tools
            ./clean.sh
            cd ..
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Unknown argument ($1). Aborting..."
            exit -1
            ;;
    esac
    shift 1
done

