#!/bin/bash


URL_FILE="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/URLs/urls-lumière-fr"

DIR_ASP="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/aspirations"

DIR_DUMP="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/dumps-txt/dumps-txt-fra"

DIR_CONCORD="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/concordances/concordances_fra"

DIR_CONTEXT="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/contextes/contextes_fra"

TABLEAU="/Users/houssaynatou/Documents/M1-TAL/projet de programmation encadré/PPE1-2025/PPE-projet/tableaux/tableau_francais.html"


mkdir -p "$DIR_ASP" "$DIR_DUMP" "$DIR_CONCORD" "$DIR_CONTEXT" "$(dirname "$TABLEAU")"

MOTIF="[Ll]umi[eè]re"


echo "<!DOCTYPE html>
<html lang=\"fr\">
<head>
    <meta charset=\"UTF-8\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    <title>Tableau des URLs - Français</title>
</head>
<body>
<section class=\"section\">
<h1 class=\"title\">Résultats des analyses d'URLs (Français)</h1>

<table class=\"table is-bordered is-striped is-narrow is-hoverable is-fullwidth\">
<thead>
<tr>
    <th>ID</th>
    <th>Code HTTP</th>
    <th>URL</th>
    <th>Encodage</th>
    <th>Aspiration</th>
    <th>Dump</th>
    <th>Occurrences</th>
    <th>Contextes</th>
    <th>Concordances</th>
</tr>
</thead>
<tbody>" > "$TABLEAU"


ID=1
while IFS= read -r URL || [[ -n "$URL" ]]; do
    [[ -z "$URL" ]] && continue

    echo "Traitement URL $ID : $URL"

    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

    ASP_FILE="francais_${ID}.html"
    curl -s "$URL" > "$DIR_ASP/$ASP_FILE"

    ENCODING=$(curl -sI "$URL" | grep -i "charset" | cut -d "=" -f2 | tr -d '\r')
    [[ -z "$ENCODING" ]] && ENCODING="UTF-8"

    DUMP_FILE="francais_${ID}.txt"
    lynx -dump -nolist -display_charset=utf-8 "$DIR_ASP/$ASP_FILE" > "$DIR_DUMP/$DUMP_FILE"

    NB_OCC=$(grep -Eio "$MOTIF" "$DIR_DUMP/$DUMP_FILE" | wc -l)

    CONTEXT_FILE="contextes_francais_${ID}.txt"
    grep -Eio "(\S+\s+){0,10}$MOTIF(\S*){0,1}(\s+\S+){0,10}" "$DIR_DUMP/$DUMP_FILE" \
    | sed 's/$/\n----------------------------/' > "$DIR_CONTEXT/$CONTEXT_FILE"

    CONCORD_FILE="concordance_francais_${ID}.html"
    echo "<html><head><meta charset=\"utf-8\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    </head><body>
    <table class=\"table is-bordered\">" > "$DIR_CONCORD/$CONCORD_FILE"

    grep -Eio ".{0,70}$MOTIF.{0,70}" "$DIR_DUMP/$DUMP_FILE" | while read -r line; do
        echo "$line" | perl -C -pe "use utf8; s/^(.*?)($MOTIF)(.*)$/<tr><td>\$1<\/td><td class=\"has-text-danger\">\$2<\/td><td>\$3<\/td><\/tr>/" >> "$DIR_CONCORD/$CONCORD_FILE"
    done

    echo "</table></body></html>" >> "$DIR_CONCORD/$CONCORD_FILE"

    echo "<tr>
        <td>$ID</td>
        <td>$HTTP_CODE</td>
        <td><a href=\"$URL\">Lien</a></td>
        <td>$ENCODING</td>
        <td><a href=\"../aspirations/$ASP_FILE\">html</a></td>
        <td><a href=\"../dumps-txt/dumps-txt-fra/$DUMP_FILE\">texte</a></td>
        <td>$NB_OCC</td>
        <td><a href=\"../contextes/contextes_fra/$CONTEXT_FILE\">contextes</a></td>
        <td><a href=\"../concordances/concordances_fra/$CONCORD_FILE\">concordances</a></td>
    </tr>" >> "$TABLEAU"

    ((ID++))
done < "$URL_FILE"


echo "</tbody>
</table>
</section>
</body>
</html>" >> "$TABLEAU"
