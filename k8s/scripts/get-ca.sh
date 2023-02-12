#!/usr/bin/env bash

set -e

if [ "$__DS_PATH__" == "" ]; then
    exit 0
fi

cat "$1/pki""$__DS_PATH__"
