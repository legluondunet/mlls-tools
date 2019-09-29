#!/bin/bash

folder="$1"
case="$2"
cd "$folder"

if $case!=[0,1]
echo "la variable case n'est égale ni à 0 ni à 1"
exit
elif $case=0
#find .  -depth -type d,f -print0 | xargs -0n 1 bash -c 's=$(dirname "$0")/$(basename "$0"); d=$(dirname "$0")/$(basename "$0"|tr "[a-z]" "[A-Z]"); mv -f "$s" "$d"';
echo "la variable case est égale à " $case ", tout convertir en minuscule"
elif $case=1
#find .  -depth -type d -print0 | xargs -0n 1 bash -c 's=$(dirname "$0")/$(basename "$0"); d=$(dirname "$0")/$(basename "$0"|tr "[A-Z]" "[a-z]"); mv -f "$s" "$d"';
echo "la variable case est égale à " $case ", tout convertir en majuscule"
fi
