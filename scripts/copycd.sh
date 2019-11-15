#!/bin/bash

cdname=$1

cddev=$(mount |grep -i $cdname |cut -d " " -f 1)

#if [[ $cddev1 == *"/dev/sr"* ]] && ![ "-" ]; then
#cddev=$(./lsscsi -g |grep $cddev1 | tail -c -10)
#else
#cddev=$cddev1
#fi

echo "les variables --> cdname:$cdname cddev:$cddev"

udisksctl unmount -b $cddev

rm -f -r $cdname.*

echo "./cdrdao read-cd --datafile $cdname.bin --driver generic-mmc:0x00020000 --device $cddev $cdname.toc"
./cdrdao read-cd --datafile $cdname.bin --driver generic-mmc:0x00020000 --device $cddev $cdname.toc

./toc2cue $cdname.toc $cdname.cue
#rm -f -r $cdname.toc versions.txt toc2cue cdrdao lsscsi
