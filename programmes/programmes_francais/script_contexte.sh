#!/bin/bash

DOSSIER_SOURCE="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/dumps-txt/dumps-txt-fra"
DOSSIER_CIBLE="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/contextes/contextes_fra"

MOTIF="[Ll]umi[eè]re"

mkdir -p "$DOSSIER_CIBLE"

for fichier_txt in "$DOSSIER_SOURCE"/*.txt; do
    [ -e "$fichier_txt" ] || continue

    nom_base=$(basename "$fichier_txt" .txt | cut -c1-50)
    fichier_contextes="$DOSSIER_CIBLE/contextes_${nom_base}.txt"

    grep -Eoi "(\S+\s+){0,15}$MOTIF(\S*){0,1}(\s+\S+){0,15}" "$fichier_txt" \
    | sed 's/$/\n----------------------------/' \
    > "$fichier_contextes"
done
