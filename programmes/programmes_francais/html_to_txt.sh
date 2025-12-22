#!/bin/bash

INPUT="urls-lumière-fr"
OUTPUT_DIR="txt_pages"

# Crée un dossier pour stocker les fichiers txt
mkdir -p "$OUTPUT_DIR"

while IFS= read -r url
do
    # Génère un nom de fichier sûr
    filename=$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g').txt

    echo "Téléchargement de : $url"

    # Télécharger la page HTML
    html=$(curl -Ls "$url")

    # Extraire le texte brut
    echo "$html" | sed 's/<[^>]*>//g' > "$OUTPUT_DIR/$filename"

    echo "→ Enregistré : $OUTPUT_DIR/$filename"
done < "$INPUT"

echo "Conversion terminée !"
