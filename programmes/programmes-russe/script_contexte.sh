#!/bin/bash

DOSSIER_SOURCE="/home/annasugak/Bureau/projet/PPE-projet/dumps-txt/dumps-txt-russe"
DOSSIER_CIBLE="/home/annasugak/Bureau/projet/PPE-projet/contextes/contextes_russe"
MOTIF="[Сс]вет"

mkdir -p "$DOSSIER_CIBLE"

for fichier_txt in "$DOSSIER_SOURCE"/*.txt; do
    [ -e "$fichier_txt" ] || continue

    nom_base=$(basename "$fichier_txt" .txt)
    fichier_contextes="$DOSSIER_CIBLE/contextes_${nom_base}.txt"

    grep -Pio "(\S+\s+){0,15}$MOTIF(\S*){0,1}(\s+\S+){0,15}" "$fichier_txt" | sed 's/$/\n----------------------------/' > "$fichier_contextes"
done
