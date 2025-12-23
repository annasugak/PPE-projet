#!/bin/bash

DOSSIER_SOURCE="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/dumps-txt/dumps-txt-anglais"
DOSSIER_CIBLE="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/contextes/contextes_anglais"
MOTIF="[Ll]ight"

mkdir -p "$DOSSIER_CIBLE"

for fichier_txt in "$DOSSIER_SOURCE"/*.txt; do
    [ -e "$fichier_txt" ] || continue

    nom_fichier=$(basename "$fichier_txt" .txt)
    fichier_contextes="$DOSSIER_CIBLE/contextes_${nom_fichier}.txt"

    grep -Pio "(\S+\s+){0,15}$MOTIF(\S*)?(\s+\S+){0,15}" "$fichier_txt" | sed 's/$/\n\n/' > "$fichier_contextes"
done