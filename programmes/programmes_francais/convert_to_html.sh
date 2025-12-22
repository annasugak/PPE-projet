#!/bin/bash

INPUT="urls-lumière-fr"
OUTPUT="tableau.html"

echo "<table border=\"1\">" > "$OUTPUT"
echo "<tr><th>Liens</th></tr>" >> "$OUTPUT"

while IFS= read -r url
do
    echo "<tr><td><a href=\"$url\">$url</a></td></tr>" >> "$OUTPUT"
done < "$INPUT"

echo "</table>" >> "$OUTPUT"

echo "Fichier HTML généré : $OUTPUT"
