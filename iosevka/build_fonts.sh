#!/bin/bash
set -euo pipefail

SCRIPTNAME="`readlink -e "$0"`"
SCRIPTDIR="`dirname "$SCRIPTNAME"`"
cd "$SCRIPTDIR"

docker run --rm -v "`readlink -e inout`":/home/build/external -ti iosevka /start.sh
