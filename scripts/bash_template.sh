#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPTNAME="`readlink -e "$0"`"
SCRIPTDIR="`dirname "$SCRIPTNAME"`"
STARTDIR="`dirname .`"

#set -x


on_exit_f=()

# function foo {}
# on_exit_f+=('foo')

# function bar {}
# on_exit_f+=('bar')

function on_exit {
    for i in "${!on_exit_f[@]}"; do
        ${on_exit_f[$i]}
    done
}
trap on_exit EXIT INT TERM

