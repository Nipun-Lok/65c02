#!/bin/bash

SRC=""
CFG=""

for arg in "$@"; do
    case "$arg" in
        *.s)
            if [ -z "$SRC" ]; then
                SRC="$arg"
            else
                SRC="$SRC $arg"
            fi
            ;;
        *.cfg)
            if [ -z "$CFG" ]; then
                CFG="$arg"
            else
                echo "Error: Invalid input"
                echo "Usage: ./cc65.sh source.s config.cfg"
                exit 1
            fi
            ;;
        *)
            echo "Error: Unrecognised file"
            exit 1
            ;;
    esac
done

if [ -z "$SRC" ]; then
    echo "Error: Missing assembly source"
    echo "Usage: ./cc65.sh source.s config.cfg"
    exit 1
elif [ -z "$CFG" ]; then
    echo "Error: Missing linker config"
    echo "Usage: ./cc65.sh source.s config.cfg"
    exit 1
fi

make cc65 "$SRC" "$CFG"
