#!/bin/bash

INPUT="urls-lumière-fr"
OUTPUT_DIR="dumps-html"

# Création du dossier de sortie
mkdir -p "$OUTPUT_DIR"

while IFS= read -r url
do
    # Nom de fichier safe (remplace / ? &= etc.)
    filename=$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').html

    echo "Aspirer : $url"

    # Télécharger et sauvegarder le HTML brut
    curl -Ls "$url" -o "$OUTPUT_DIR/$filename"

    echo "→ Enregistré dans : $OUTPUT_DIR/$filename"
done < "$INPUT"

echo "Aspiration terminée !
