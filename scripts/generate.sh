#!/bin/bash
set -e

if [ $# -ne 3 ]; then
    echo "Usage : $0 <ancien_répertoire> <nouveau_répertoire> <répertoire_patch>"
    exit 1
fi

OLD="$1"
NEW="$2"
OUT="$3"

if [ ! -d "$OLD" ]; then
    echo "Erreur : répertoire introuvable : $OLD"
    exit 1
fi

if [ ! -d "$NEW" ]; then
    echo "Erreur : répertoire introuvable : $NEW"
    exit 1
fi

mkdir -p "$OUT"

# Répertoires de fichiers complets, au même niveau que patch/
FILES_NEW_DIR="$(dirname "$OUT")/files_new"
FILES_MODIFIED_DIR="$(dirname "$OUT")/files_modified"

mkdir -p "$FILES_NEW_DIR"
mkdir -p "$FILES_MODIFIED_DIR"

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Recherche de xdelta3
if command -v xdelta3 >/dev/null 2>&1; then
    XDELTA3="$(command -v xdelta3)"
elif [ -x "$BASE_DIR/xdelta3" ]; then
    XDELTA3="$BASE_DIR/xdelta3"
else
    echo "Erreur : xdelta3 est introuvable."
    echo "Installez xdelta3 ou placez un binaire nommé 'xdelta3' dans :"
    echo "  $BASE_DIR"
    exit 1
fi

declare -a NEW_FILES
declare -a PATCHED_FILES
declare -a COPIED_NEW_FILES
declare -a COPIED_MODIFIED_FILES

while IFS= read -r -d '' newfile
do
    rel="${newfile#$NEW/}"
    oldfile="$OLD/$rel"

    # Fichier absent de l'ancienne version
    if [ ! -f "$oldfile" ]; then
        echo "Nouveau fichier : $rel"

        NEW_FILES+=("$rel")

        copyfile="$FILES_NEW_DIR/$rel"
        mkdir -p "$(dirname "$copyfile")"
        cp -f "$newfile" "$copyfile"

        COPIED_NEW_FILES+=("$rel")

        continue
    fi

    # Fichier identique
    if cmp -s "$oldfile" "$newfile"; then
        continue
    fi

    # Fichier modifié : création du patch xdelta
    mkdir -p "$OUT/$(dirname "$rel")"

    echo "Création du patch : $rel"

    "$XDELTA3" -f -e \
        -s "$oldfile" \
        "$newfile" \
        "$OUT/$rel.xdelta"

    PATCHED_FILES+=("$rel")

    # Copie complète du fichier modifié
    copyfile="$FILES_MODIFIED_DIR/$rel"
    mkdir -p "$(dirname "$copyfile")"
    cp -f "$newfile" "$copyfile"

    COPIED_MODIFIED_FILES+=("$rel")

done < <(find "$NEW" -type f -print0)

echo
echo "================ Résumé ================"

echo
echo "Fichiers nouveaux dans $NEW :"
if [ ${#NEW_FILES[@]} -eq 0 ]; then
    echo "  Aucun"
else
    printf '  %s\n' "${NEW_FILES[@]}"
fi

echo
echo "Fichiers modifiés et patchés :"
if [ ${#PATCHED_FILES[@]} -eq 0 ]; then
    echo "  Aucun"
else
    printf '  %s\n' "${PATCHED_FILES[@]}"
fi

echo
echo "Fichiers complets copiés dans files_new :"
if [ ${#COPIED_NEW_FILES[@]} -eq 0 ]; then
    echo "  Aucun"
else
    printf '  %s\n' "${COPIED_NEW_FILES[@]}"
fi

echo
echo "Fichiers complets copiés dans files_modified :"
if [ ${#COPIED_MODIFIED_FILES[@]} -eq 0 ]; then
    echo "  Aucun"
else
    printf '  %s\n' "${COPIED_MODIFIED_FILES[@]}"
fi

echo
echo "Génération des patchs terminée."
