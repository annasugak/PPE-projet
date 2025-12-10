#!/bin/bash

URL_FILE="/home/annasugak/Bureau/projet/PPE-projet/URLs/urls_russe.txt"
OUTPUT_DIR="/home/annasugak/Bureau/projet/PPE-projet/dumps-txt"
TEMP_FILE="/tmp/temp_html_content.html"

if [ ! -f "$URL_FILE" ]; then
    echo "Erreur : Le fichier d'URLs est introuvable à l'adresse : $URL_FILE"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Erreur : Impossible de créer ou d'accéder au répertoire : $OUTPUT_DIR"
    exit 1
fi

echo "--- Début du traitement des URLs ---"

COUNTER=1

while IFS= read -r url || [[ -n "$url" ]]; do

    if [[ -n "$url" && ! "$url" =~ ^[[:space:]]*# ]]; then

        echo "[$COUNTER] Traitement de : $url"

        FILENAME=$(echo "$url" | sed -e 's/https\?:\/\///' -e 's/^www\.//' | tr -dc '[:alnum:]_.-' | cut -c -30).txt
        OUTPUT_PATH="$OUTPUT_DIR/${COUNTER}_${FILENAME}"

        wget -q --tries=1 --timeout=15 -O "$TEMP_FILE" "$url"

        if [ $? -eq 0 ]; then

            cat "$TEMP_FILE" | \
            sed 's/<script[^>]*>.*<\/script>//gI;s/<style[^>]*>.*<\/style>//gI' | \
            lynx -stdin -dump -nolist -display_charset=utf-8 | \
            iconv -f UTF-8 -t UTF-8 -c > "$OUTPUT_PATH"

            if [ $? -eq 0 ]; then
                echo "    -> Sauvegardé avec succès sous : $OUTPUT_PATH"
            else
                echo "    -> ERREUR de conversion/nettoyage du texte (iconv/lynx) pour $url. Fichier potentiellement incomplet."
            fi

        else
            echo "    -> ERREUR de téléchargement (code d'erreur $?) ou timeout pour $url. Ignoré."
            > "$TEMP_FILE"
        fi

        COUNTER=$((COUNTER + 1))
    fi
done < "$URL_FILE"

rm -f "$TEMP_FILE"

echo "--- Traitement terminé. Tous les fichiers texte sont dans : $OUTPUT_DIR ---"
