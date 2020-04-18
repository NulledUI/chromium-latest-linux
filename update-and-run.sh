#!/usr/bin/env sh
cd $(dirname $0)
./update.sh && ./run.sh $*
