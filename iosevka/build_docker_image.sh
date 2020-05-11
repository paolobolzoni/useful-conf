#!/bin/bash
set -euo pipefail

SCRIPTNAME="`readlink -e "$0"`"
SCRIPTDIR="`dirname "$SCRIPTNAME"`"
cd "$SCRIPTDIR"

docker build -t iosevka .
