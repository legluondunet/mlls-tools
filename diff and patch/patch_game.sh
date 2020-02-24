#!/bin/bash

lang=$1

for i in $lang/*.LFL
do
echo "traitement du fichier $i"
j=$(basename $i)
#diff -a $i fr/$j > "$j.patch"
patch < patch/$j.patch $i
echo "patch du fichier $i par le fichier $j.patch"
done
