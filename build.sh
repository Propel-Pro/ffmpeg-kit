#!/usr/bin/env bash

export ANDROID_SDK_ROOT=$HOME/android-r35.0.2
export ANDROID_NDK_ROOT=$HOME/android-ndk-r26d

show_help()
{
    echo "Usage: $0 platform ..args.."
    echo "\tplatform can be one of: Android, iOS"
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

platform="$1"
shift 1
args=()

rm -rf build.log
case "${platform}" in
   android|Android)
        ./android.sh "${args[@]}"
        ;;
    iOS|ios)
        ./ios.sh "${args[@]}"
        ;;
    --full)
        args+=(--full)
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
        echo "Error: platform unknown. Aborting..."
        exit -1
        ;;
esac
