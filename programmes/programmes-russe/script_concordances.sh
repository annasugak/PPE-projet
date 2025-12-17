#!/bin/bash

DOSSIER_SOURCE="/home/annasugak/Bureau/projet/PPE-projet/dumps-txt/dumps-txt-russe"
DOSSIER_CIBLE="/home/annasugak/Bureau/projet/PPE-projet/concordances/concordances_russe"
MOTIF="[Сс]вет"

mkdir -p "$DOSSIER_CIBLE"

for fichier_txt in "$DOSSIER_SOURCE"/*.txt; do
    [ -e "$fichier_txt" ] || continue

    nom_base=$(basename "$fichier_txt" .txt)
    fichier_html="$DOSSIER_CIBLE/concordance_${nom_base}.html"

    echo "<html>
<html lang=\"ru\">
<head>
    <meta charset=\"utf-8\" />
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <title>Concordance - $nom_base</title>
</head>
<body>
    <h1 class=\"title\">Concordance : $nom_base</h1>
    <table class=\"table is-bordered is-striped is-narrow is-hoverable is-fullwidth\">
        <thead>
            <tr>
                <th class=\"has-text-right\">Contexte gauche</th>
                <th class=\"has-text-centered\">Cible</th>
                <th class=\"has-text-left\">Contexte droit</th>
            </tr>
        </thead>
        <tbody>" > "$fichier_html"

    grep -Pio ".{0,80}$MOTIF.{0,80}" "$fichier_txt" | while read -r line; do

        echo "$line" | perl -C -pe "use utf8; s/^(.*?)($MOTIF)(.*)$/<tr><td class=\"has-text-right\">\$1<\/td><td class=\"has-text-danger has-text-centered\">\$2<\/td><td class=\"has-text-left\">\$3<\/td><\/tr>/" >> "$fichier_html"
    done

    echo "        </tbody>
    </table>
</body>
</html>" >> "$fichier_html"
done
