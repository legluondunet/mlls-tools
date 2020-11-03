#!/bin/bash

cdname=$1

cddev=$(mount |grep -i $cdname |cut -d " " -f 1)

echo "les variables --> cdname:$cdname cddev:$cddev"

LD_LIBRARY_PATH=libs ./cdparanoia -BE -d $cddev


n=1
for f in *.wav 
do
final=$(printf "track%02d".wav $n)
echo "mv "$f" "$final""
mv "$f" "$final"
echo convert $final to flac
./flac -s --best --delete-input-file $final
((n++))
done

rm -f -r lame cdparanoia flac metaflac libs audiotracks2flac.sh about_audiotools.txt

