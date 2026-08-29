#!/bin/bash
set -e

if [ $# -ne 1 ]; then
echo "Usage : $0 <répertoire_du_jeu>"
exit 1
fi

GAME_DIR="$1"

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
PATCH_DIR="$BASE_DIR/patch"
FILES_NEW_DIR="$BASE_DIR/files_new"

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

if [ ! -d "$GAME_DIR" ]; then
echo "Erreur : répertoire du jeu introuvable : $GAME_DIR"
exit 1
fi

if [ ! -d "$PATCH_DIR" ]; then
echo "Erreur : répertoire patch introuvable : $PATCH_DIR"
exit 1
fi

declare -a PATCHED_FILES
declare -a COPIED_NEW_FILES

# Application des patchs xdelta

while IFS= read -r -d '' patchfile
do
rel="${patchfile#$PATCH_DIR/}"
rel="${rel%.xdelta}"

```
source="$GAME_DIR/$rel"
temp="$source.tmp"

echo "Application : $rel"

if [ ! -f "$source" ]; then
    echo "Erreur : fichier source absent : $source"
    exit 1
fi

"$XDELTA3" -f -d \
    -s "$source" \
    "$patchfile" \
    "$temp"

mv "$temp" "$source"

PATCHED_FILES+=("$rel")
```

done < <(find "$PATCH_DIR" -type f -name "*.xdelta" -print0)

# Copie des nouveaux fichiers

if [ -d "$FILES_NEW_DIR" ]; then
echo
echo "Copie des nouveaux fichiers..."

```
while IFS= read -r -d '' file
do
    rel="${file#$FILES_NEW_DIR/}"

    echo "Copie : $rel"

    mkdir -p "$GAME_DIR/$(dirname "$rel")"
    cp -f "$file" "$GAME_DIR/$rel"

    COPIED_NEW_FILES+=("$rel")

done < <(find "$FILES_NEW_DIR" -type f -print0)
```

else
echo
echo "Aucun répertoire files_new trouvé."
fi

echo
echo "================ Résumé ================"

echo
echo "Fichiers patchés :"

if [ ${#PATCHED_FILES[@]} -eq 0 ]; then
echo "  Aucun"
else
printf '  %s\n' "${PATCHED_FILES[@]}"
fi

echo
echo "Nouveaux fichiers copiés depuis files_new :"

if [ ${#COPIED_NEW_FILES[@]} -eq 0 ]; then
echo "  Aucun"
else
printf '  %s\n' "${COPIED_NEW_FILES[@]}"
fi

echo
echo "Patch terminé avec succès."

