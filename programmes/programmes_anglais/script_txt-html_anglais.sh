#!/bin/bash

FICHIER_URLS="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/URLs/urls_anglais.txt"
DOSSIER_DESTINATION="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/aspirations"

mkdir -p "$DOSSIER_DESTINATION"

compteur=1

while read -r url || [ -n "$url" ]; do

    if [ -n "$url" ]; then

        nom_fichier="anglais_${compteur}.html"
        echo "Téléchargement ($compteur): $url"

        wget -q -U "Mozilla/5.0" "$url" -O "$DOSSIER_DESTINATION/$nom_fichier.html"
        sleep 1
        
        compteur=$((compteur+1))
    fi
done < "$FICHIER_URLS"
