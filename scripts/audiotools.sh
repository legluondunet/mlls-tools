#!/bin/bash

cdname=$1
chemin=$2

if [ ! -d "$chemin" ] 
then
echo création du chemin $chemin
mkdir -p "$chemin"
fi

cd "$chemin"
wget https://github.com/legluondunet/mlls-tools/raw/master/audiotools/audiotools.tar.xz
tar xfv audiotools.tar.xz

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
./flac -s -f --best --delete-input-file $final
((n++))
done
mv *.flac "$chemin"

rm -f -r cdparanoia flac metaflac libs audiotools.sh about_audiotools.txt audiotools.tar.xz

