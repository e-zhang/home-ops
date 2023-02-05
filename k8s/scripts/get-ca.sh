#!/usr/bin/env bash

set -e

if [ "$__DS_PATH__" == "" ]; then
    exit 0
fi

ns=$(dirname "${__DS_PATH__#/}")
name=$(basename $__DS_PATH__)


s=$(kubectl -n $ns get secret $name --no-headers --ignore-not-found -o jsonpath="{.data.ca\.crt}")
if [ "$s" != "" ]; then 
    echo "$s"
    exit 0
fi

sbootstrap=$(kubectl -n $ns get secret $name-bootstrap --no-headers --ignore-not-found -o jsonpath="{.data.ca\.crt}")
if [ "$sbootstrap" != "" ]; then 
    echo "$sbootstrap"
    exit 0
fi
