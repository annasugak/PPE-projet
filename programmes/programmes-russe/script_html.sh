#!/bin/bash

FICHIER_LIENS="/home/annasugak/Bureau/projet/PPE-projet/URLs/urls_russe.txt"
DOSSIER_RESULTATS="/home/annasugak/Bureau/projet/PPE-projet/aspirations/aspiration_russe"

mkdir -p "$DOSSIER_RESULTATS"

compteur=1

while read -r line || [ -n "$line" ]; do

    if [ -n "$line" ]; then

        nom_fichier="russe_${compteur}.html"

        echo "Téléchargement ($compteur): $line"

        wget -q --show-progress -O "$DOSSIER_RESULTATS/$nom_fichier" "$line"

        compteur=$((compteur+1))

        sleep 1
    fi
done < "$FICHIER_LIENS"
