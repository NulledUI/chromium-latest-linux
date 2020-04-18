#!/usr/bin/env sh

BASEDIR=$(dirname $(realpath $0))

export CHROME_DEVEL_SANDBOX="$BASEDIR/latest/chrome_sandbox"
$BASEDIR/latest/chrome --user-data-dir="$BASEDIR/user-data-dir" $* &> /dev/null &
