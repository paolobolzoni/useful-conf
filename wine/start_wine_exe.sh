#!/bin/bash

# Activate the Wine bottle in the current directory
# Meant to be used after creating the wine bottle with with init_wine.sh

# Copy this file in where you executed init_wine.sh and possibly change the
# last lines to start your program


# MSCOREE and MSHTML are disabled by default!

set -e
set -u

SCRIPTNAME="`readlink -e "$0"`"
SCRIPTDIR="`dirname "$SCRIPTNAME"`"

export WINEPREFIX="$SCRIPTDIR"/wine
export WINEDLLOVERRIDES="mscoree,mshtml="
export XDG_CONFIG_HOME="$WINEPREFIX"/xdg_conf
export XDG_DATA_HOME="$WINEPREFIX"/xdg_home
export XDG_CACHE_HOME="$WINEPREFIX"/xdg_cache
export WINEARCH=win32
export LC_ALL=C

# Helps to display Wine fonts better in some scenarios
# xrdb -query | grep -vE 'Xft\.(anti|hint|rgba)' | xrdb
cd "$WINEPREFIX"/drive_c
bash
