#!/bin/bash

COMPILER=$1
SRC=$2
CFG=$3

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