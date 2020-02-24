#!/bin/bash

lang=$1
lang2=$2

for i in $lang/*.LFL 
do
echo "traitement du fichier $i"
j=$(basename $i)
mkdir patch
diff -a $i $lang2/$j > "patch/$j.patch"
echo "creation du fichier $j.patch"
done
