#!/bin/bash

cdname=$1

cddev=$(mount |grep -i $cdname |cut -d " " -f 1)

echo "les variables --> cdname:$cdname cddev:$cddev"

LD_LIBRARY_PATH=libs cdparanoia -BE -d $cddev

find . -name '*cdda' -exec bash -c ' mv $0 ${0/\cdda./}' {} \;

LD_LIBRARY_PATH=libs cdparanoia -BE -d $cddev

for i in *.wav; do flac -s --best --delete-input-file $i ; done
