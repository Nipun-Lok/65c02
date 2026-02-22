#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: Missing compile method"
    echo "Usage: ./build.sh <vasm|cc65> source.s [config.cfg]"
    exit 1
fi

COMPILER=$1
SRC=""
CFG=""

if [ "$COMPILER" != "vasm" ] && [ "$COMPILER" != "cc65" ]; then
    echo "Error: Missing compile method"
    echo "Usage: ./build.sh <vasm|cc65> source.s [config.cfg]"
    exit 1
fi

shift

for arg in "$@"; do
    case "$arg" in
        *.s)
            if [ -z "$SRC" ]; then
                SRC="$arg"
            elif [ "$COMPILER" = "vasm" ]; then
                echo "Error: Too many arguments"
                echo "Usage: ./build vasm source.s"
                exit 1
            else
                SRC="$SRC $arg"
            fi
            ;;
        *.cfg)
            if [ "$COMPILER" = "vasm" ]; then
                echo "Error: Invalid input"
                echo "Usage: ./build vasm source.s"
                exit 1
            else
                CFG="$arg"
            fi
            ;;
        *)
            echo "Error: Unrecognised file"
            exit 1
            ;;
    esac
done


if [ -z "$COMPILER" ]; then
    echo "Error: Missing compile method"
    echo "Usage: ./build.sh <vasm|cc65> source.s [config.cfg]"
    exit 1
elif [ -z "$SRC" ]; then
    echo "Error: Missing assembly source"
    echo "Usage: ./build.sh <vasm|cc65> source.s [config.cfg]"
    exit 1
elif [ "$COMPILER" = "cc65" ] && [ -z "$CFG" ]; then
    echo "Error: Missing linker config"
    echo "Usage: ./build.sh <vasm|cc65> source.s [config.cfg]"
    exit 1
fi

make "$COMPILER" SRC="$SRC" CFG="$CFG"