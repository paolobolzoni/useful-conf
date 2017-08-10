#!/bin/bash

# Creates a self-contained Wine configuration (Wine bottle) in the current
# directory

# Meant to be used with start_wine_exe.sh, copy start_wine_exe.sh in the
# directory after executing

# No need to copy this file unless you have to change some configurations


# MSCOREE and MSHTML are disabled by default!

set -e
set -x

STARTPWD="`readlink -e "$PWD"`"
# winetricks cache directory is shared
if [ x"$XDG_CACHE_HOME" = x ] ;then
    XDG_CACHE_HOME_BAK="$HOME"/.cache
else
    XDG_CACHE_HOME_BAK="$XDG_CACHE_HOME"
fi

set -u
export WINEPREFIX="$STARTPWD"/wine
export WINEDLLOVERRIDES="mscoree,mshtml="
export XDG_CONFIG_HOME="$WINEPREFIX"/xdg_conf
export XDG_DATA_HOME="$WINEPREFIX"/xdg_home
export XDG_CACHE_HOME="$WINEPREFIX"/xdg_cache
export WINEARCH=win32
export LC_ALL=C

wineboot -u

mkdir -p "$WINEPREFIX"/xdg_cache
mkdir -p "$XDG_CACHE_HOME_BAK"/winetricks

ln -s "$XDG_CACHE_HOME_BAK"/winetricks "$WINEPREFIX"/xdg_cache/winetricks
winetricks sandbox

