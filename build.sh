#!/usr/bin/env bash

export ANDROID_SDK_ROOT=$HOME/android-r35.0.2
export ANDROID_NDK_ROOT=$HOME/android-ndk-r26d

if [[ $# -lt 1 ]]
then
    echo "Usage: $0 platform ..args.."
    echo "\tplatform can be one of: Android, iOS"
    exit -1
fi

platform="$1"
shift 1
args=(--full)

rm -rf build.log
case "${platform}" in
   android|Android)
        ./android.sh "${args[@]}"
        ;;
    iOS|ios)
        ./ios.sh "${args[@]}"
        ;;
    clean)
        cd tools
        ./clean.sh
        cd ..
        ;;
    *)
        echo "Error: platform unknown. Aborting..."
        exit -1
        ;;
esac
