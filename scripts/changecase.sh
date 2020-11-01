#!/bin/bash

folder="$1"
case="$2"


if cd "$folder"
then
    	echo "le répertoire $folder existe"
	chmod -R +w .
	ls -l
else
	echo "répertoire non trouvé, arrêt du script"
	ls -l
	exit
fi

if [ $case != 0 ] && [ $case != 1 ]
then
	echo "la variable case n'est égale ni à 0 ni à 1, arret du script"
	exit
elif [ $case = 0 ]
then
find .  -depth -type d,f -print0 | xargs -0n 1 bash -c 's=$(dirname "$0")/$(basename "$0"); d=$(dirname "$0")/$(basename "$0"|tr "[A-Z]" "[a-z]"); mv -f "$s" "$d"';
	echo "la variable case est égale à " $case ", convertir le répertoire " $folder " en minuscule"
elif [ $case = 1 ]
then
find .  -depth -type d,f -print0 | xargs -0n 1 bash -c 's=$(dirname "$0")/$(basename "$0"); d=$(dirname "$0")/$(basename "$0"|tr "[a-z]" "[A-Z]"); mv -f "$s" "$d"';
	echo "la variable case est égale à " $case ", convertir le répertoire " $folder "  en majuscule"
fi


