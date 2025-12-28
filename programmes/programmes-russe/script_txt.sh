#!/bin/bash

URL_FILE="/home/annasugak/Bureau/projet/PPE-projet/URLs/urls_russe.txt"
OUTPUT_DIR="//home/annasugak/Bureau/projet/PPE-projet/dumps-txt/dumps-txt-russe"
TEMP_FILE="/tmp/temp_html_content.html"

if [ ! -f "$URL_FILE" ]; then
    echo "Erreur : Le fichier d'URLs est introuvable"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

COUNTER=1

while IFS= read -r url || [[ -n "$url" ]]; do

    if [[ -n "$url" && ! "$url" =~ ^[[:space:]]*# ]]; then

        echo "[$COUNTER] Traitement de : $url"

        OUTPUT_PATH="$OUTPUT_DIR/russe_${COUNTER}.txt"

        wget -q --tries=1 --timeout=15 -O "$TEMP_FILE" "$url"

        if [ $? -eq 0 ]; then

            cat "$TEMP_FILE" | \
            sed 's/<script[^>]*>.*<\/script>//gI;s/<style[^>]*>.*<\/style>//gI' | \
            lynx -stdin -dump -nolist -display_charset=utf-8 | \
            iconv -f UTF-8 -t UTF-8 -c > "$OUTPUT_PATH"

            if [ $? -eq 0 ]; then
                echo "    -> Sauvegardé : $OUTPUT_PATH"
            else
                echo "    -> ERREUR de conversion"
            fi

        else
            echo "    -> ERREUR de téléchargement"
            > "$TEMP_FILE"
        fi

        COUNTER=$((COUNTER + 1))
    fi
done < "$URL_FILE"

rm -f "$TEMP_FILE"
