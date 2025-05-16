#!/usr/bin/env bash

export ANDROID_SDK_ROOT=$HOME/android-r35.0.2
export ANDROID_NDK_ROOT=$HOME/android-ndk-r26d
export ANDROID_HOME=$ANDROID_SDK_ROOT

show_help()
{
    echo "Usage: $0 ..args.. platform"
    echo "\tplatform can be one of: Android, iOS"
}

install_dependencies()
{
    os=$(uname)
    echo "Installing dependencies..."
    if [[ "$os" == "Linux" ]]
    then
        sudo apt-get install -y autoconf automake libtool pkg-config groff
    elif [[ "$os" == "Darwin" ]]
    then
        brew install autoconf automake libtool pkg-config groff
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

args=()

rm -rf build.log
while [[ $# -gt 0 ]]
do
    case "$1" in
    android|Android)
            PATH=$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH \
                ./android.sh "${args[@]}"
            ;;
        iOS|ios)
            ./ios.sh "${args[@]}"
            ;;
        --full)
            args+=(--full)
            ;;
        --api-level=*)
            API_LEVEL=$(echo $1 | sed -e 's/^--[A-Za-z]*-[A-Za-z]*=//g')
            args+=(--api-level="${API_LEVEL}")
            ;;
        # -l | --lts) ;;
        # -f | --force)
        #     export BUILD_FORCE="1"
        #     ;;
        # --reconf-*)
        #     CONF_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')

        #     reconf_library "${CONF_LIBRARY}"
        #     ;;
        # --rebuild-*)
        #     BUILD_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')
        #     rebuild_library "${BUILD_LIBRARY}"
        #     ;;
        # --redownload-*)
        #     DOWNLOAD_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')
        #     redownload_library "${DOWNLOAD_LIBRARY}"
        #     ;;
        # --full)
        #     BUILD_FULL="1"
        #     ;;
        # --enable-gpl)
        #     export GPL_ENABLED="yes"
        #     ;;
        # --enable-custom-library-*)
        #     CUSTOM_LIBRARY_OPTION_KEY=$(echo $1 | sed -e 's/^--enable-custom-//g;s/=.*$//g')
        #     CUSTOM_LIBRARY_OPTION_VALUE=$(echo $1 | sed -e 's/^--enable-custom-.*=//g')

        #     echo -e "INFO: Custom library options detected: ${CUSTOM_LIBRARY_OPTION_KEY} ${CUSTOM_LIBRARY_OPTION_VALUE}\n" 1>>"${BASEDIR}"/build.log 2>&1

        #     generate_custom_library_environment_variables "${CUSTOM_LIBRARY_OPTION_KEY}" "${CUSTOM_LIBRARY_OPTION_VALUE}"
        #     ;;
        # --enable-*)
        #     ENABLED_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')

        #     enable_library "${ENABLED_LIBRARY}"
        #     ;;
        --rebuild)
            args+=(--rebuild)
            ;;
        # --build)
        #     ;;
        -v | --version)
            args+=(--version)
            ;;
        # --skip-*)
        #     SKIP_LIBRARY=$(echo "$1" | sed -e 's/^--[A-Za-z]*-//g')

        #     skip_library "${SKIP_LIBRARY}"
        #     ;;
        # --no-bitcode)
        #     export NO_BITCODE="1"
        #     ;;
        # --no-framework)
        #     NO_FRAMEWORK="1"
        #     ;;
        # --no-output-redirection)
        #     no_output_redirection
        #     ;;
        # --no-workspace-cleanup-*)
        #     NO_WORKSPACE_CLEANUP_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-[A-Za-z]*-[A-Za-z]*-//g')

        #     no_workspace_cleanup_library "${NO_WORKSPACE_CLEANUP_LIBRARY}"
        #     ;;
        # -d | --debug)
        #     enable_debug
        #     ;;
        # -s | --speed)
        #     optimize_for_speed
        #     ;;
        # -l | --lts) ;;
        # -x | --xcframework)
        #     FFMPEG_KIT_XCF_BUILD="1"
        #     ;;
        # -f | --force)
        #     export BUILD_FORCE="1"
        #     ;;
        # --reconf-*)
        #     CONF_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')

        #     reconf_library "${CONF_LIBRARY}"
        #     ;;
        # --rebuild-*)
        #     BUILD_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')

        #     rebuild_library "${BUILD_LIBRARY}"
        #     ;;
        # --redownload-*)
        #     DOWNLOAD_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')

        #     redownload_library "${DOWNLOAD_LIBRARY}"
        #     ;;
        # --full)
        #     BUILD_FULL="1"
        #     ;;
        # --enable-gpl)
        #     export GPL_ENABLED="yes"
        #     ;;
        # --enable-custom-library-*)
        #     CUSTOM_LIBRARY_OPTION_KEY=$(echo $1 | sed -e 's/^--enable-custom-//g;s/=.*$//g')
        #     CUSTOM_LIBRARY_OPTION_VALUE=$(echo $1 | sed -e 's/^--enable-custom-.*=//g')

        #     echo -e "INFO: Custom library options detected: ${CUSTOM_LIBRARY_OPTION_KEY} ${CUSTOM_LIBRARY_OPTION_VALUE}\n" 1>>"${BASEDIR}"/build.log 2>&1

        #     generate_custom_library_environment_variables "${CUSTOM_LIBRARY_OPTION_KEY}" "${CUSTOM_LIBRARY_OPTION_VALUE}"
        #     ;;
        # --enable-*)
        #     ENABLED_LIBRARY=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')

        #     enable_library "${ENABLED_LIBRARY}"
        #     ;;
        # --disable-lib-*)
        #     DISABLED_LIB=$(echo $1 | sed -e 's/^--[A-Za-z]*-[A-Za-z]*-//g')

        #     disabled_libraries+=("${DISABLED_LIB}")
        #     ;;
        # --disable-*)
        #     DISABLED_ARCH=$(echo $1 | sed -e 's/^--[A-Za-z]*-//g')

        #     disable_arch "${DISABLED_ARCH}"
        #     ;;
        # --target=*)
        #     TARGET=$(echo $1 | sed -e 's/^--[A-Za-z]*=//g')

        #     export IOS_MIN_VERSION=${TARGET}
        #     ;;
        # --mac-catalyst-target=*)
        #     TARGET=$(echo $1 | sed -e 's/^--[A-Za-z]*-[A-Za-z]*-[A-Za-z]*=//g')

        #     export MAC_CATALYST_MIN_VERSION=${TARGET}
        #     ;;
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

