#!/bin/bash

SRC=""

for arg in "$@"; do
    case "$arg" in
        *.s)
            if [ -z "$SRC" ]; then
                SRC="$arg"
            else
                echo "Error: Too many arguments"
                exit 1
                ;;
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
    echo "Usage: ./vasm.sh source.s"
    exit 1
fi

make vasm $SRC
