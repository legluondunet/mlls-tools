#!/bin/bash

if ! [ -x "$(command -v cdrdao)" ]; then
  echo 'Error: cdrdao is not installed.'
exit
elif 
 ! [ -x "$(command -v toc2cue)" ]; then
  echo 'Error: toc2cue is not installed.'
exit
fi

cdname=$1

cddev1=$(mount |grep /$cdname |cut -d " " -f 1)

if [[ $cddev1 == *"/dev/sr"* ]]; then
cddev=$(./lsscsi -g |grep $cddev1 | tail -c -10)
else
cddev=$cddev1
fi

echo "les variables --> cdname:$cdname cddev1:$cddev1 cddev:$cddev"

rm -f -r $cdname.*

echo "cdrdao read-cd --datafile $cdname.bin --driver generic-mmc:0x00020000 --device $cddev $cdname.toc"
cdrdao read-cd --datafile $cdname.bin --driver generic-mmc:0x00020000 --device $cddev $cdname.toc

toc2cue $cdname.toc $cdname.cue
rm -f -r $cdname.toc lsscsi
