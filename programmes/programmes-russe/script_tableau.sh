#!/bin/bash

URL_FILE="/home/annasugak/Bureau/projet/PPE-projet/URLs/urls_russe.txt"
DIR_ASP="/home/annasugak/Bureau/projet/PPE-projet/aspirations"
DIR_DUMP="/home/annasugak/Bureau/projet/PPE-projet/dumps-txt/dumps-txt-russe"
DIR_CONCORD="/home/annasugak/Bureau/projet/PPE-projet/concordances/concordances_russe"
DIR_CONTEXT="/home/annasugak/Bureau/projet/PPE-projet/contextes/contextes_russe"
TABLEAU="/home/annasugak/Bureau/projet/PPE-projet/tableaux/tableau_russe.html"

mkdir -p "$DIR_ASP" "$DIR_DUMP" "$DIR_CONCORD" "$DIR_CONTEXT" "$(dirname "$TABLEAU")"

MOTIF="[Сс]вет"

echo "<!DOCTYPE html>
<html lang=\"fr\">
<head>
    <meta charset=\"UTF-8\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    <title>Tableau des URLs - Russe</title>
</head>
<body>
    <section class=\"section\">
        <h1 class=\"title\">Résultats des analyses d'URLS</h1>
        <table class=\"table is-bordered is-striped is-narrow is-hoverable is-fullwidth\">
            <thead>
                <tr>
                    <th>ID</th><th>Code HTTP</th><th>URL</th><th>Encodage</th>
                    <th>Aspiration</th><th>Dump</th><th>Occurences</th>
                    <th>Contextes</th><th>Concordances</th>
                </tr>
            </thead>
            <tbody>" > "$TABLEAU"

ID=1
while IFS= read -r URL || [[ -n "$URL" ]]; do
    [[ -z "$URL" ]] && continue

    echo "Traitement de l'URL $ID : $URL"


    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    ASP_FILE="russe_${ID}.html"
    curl -s "$URL" > "$DIR_ASP/$ASP_FILE"

    ENCODING=$(curl -sI "$URL" | grep -i "charset" | cut -d "=" -f2 | tr -d '\r\n')
    [[ -z "$ENCODING" ]] && ENCODING="UTF-8"


    DUMP_FILE="russe_${ID}.txt"
    lynx -dump -nolist -display_charset=utf-8 "$DIR_ASP/$ASP_FILE" > "$DIR_DUMP/$DUMP_FILE"

    NB_OCC=$(grep -ioP "$MOTIF" "$DIR_DUMP/$DUMP_FILE" | wc -l)

    CONTEXT_FILE="contextes_russe_${ID}.txt"
    grep -Pio "(\S+\s+){0,10}$MOTIF(\S*){0,1}(\s+\S+){0,10}" "$DIR_DUMP/$DUMP_FILE" | sed 's/$/\n----------------/' > "$DIR_CONTEXT/$CONTEXT_FILE"

    CONCORD_FILE="concordance_russe_${ID}.html"
    echo "<html><head><meta charset=\"utf-8\"><link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\"></head><body><table class=\"table\">" > "$DIR_CONCORD/$CONCORD_FILE"
    grep -Pio ".{0,70}$MOTIF.{0,70}" "$DIR_DUMP/$DUMP_FILE" | while read -r line; do
        echo "$line" | perl -C -pe "use utf8; s/^(.*?)($MOTIF)(.*)$/<tr><td>\$1<\/td><td class=\"has-text-danger\">\$2<\/td><td>\$3<\/td><\/tr>/" >> "$DIR_CONCORD/$CONCORD_FILE"
    done
    echo "</table></body></html>" >> "$DIR_CONCORD/$CONCORD_FILE"

    echo "<tr>
        <td>$ID</td>
        <td>$HTTP_CODE</td>
        <td><a href=\"$URL\">Lien</a></td>
        <td>$ENCODING</td>
        <td><a href=\"../aspirations/$ASP_FILE\">html</a></td>
        <td><a href=\"../dumps-txt/dumps-txt-russe/$DUMP_FILE\">text</a></td>
        <td>$NB_OCC</td>
        <td><a href=\"../contextes/contextes_russe/$CONTEXT_FILE\">contextes</a></td>
        <td><a href=\"../concordances/concordances_russe/$CONCORD_FILE\">concordance</a></td>
    </tr>" >> "$TABLEAU"

    ((ID++))
done < "$URL_FILE"

echo "</tbody></table></section></body></html>" >> "$TABLEAU"
