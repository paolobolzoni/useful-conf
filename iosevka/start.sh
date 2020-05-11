#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


cd /home/build/Iosevka
git pull
git reset --hard HEAD


cd /home/build/external
if [ -f settings ] ;then
  . settings
else
    echo "WARNING, settings file absent!"
fi


if [ -f private-build-plans.toml ] ;then
  private=yes
  cp private-build-plans.toml /home/build/Iosevka
fi


cd /home/build/Iosevka
if [ ! -z ${commandline+x} ] ;then
    sh -c $commandline
else
    if [ ! -z ${private+x} ] ;then
        echo "Private file present, but no commandline settting. Aborting."
        exit 1
    fi

    echo "No commandline and no private file"
    echo "building everything with 'npm run build -- contents::iosevka'"
    npm run build -- contents::iosevka
fi

cp -r dist/* /home/build/external
