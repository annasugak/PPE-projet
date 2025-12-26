#!/bin/bash

DOSSIER_SOURCE="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/dumps-txt/dumps-txt-anglais"
DOSSIER_CIBLE="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/concordances/concordances_anglais"
MOTIF="[Ll]ight"

mkdir -p "$DOSSIER_CIBLE"

for fichier_txt in "$DOSSIER_SOURCE"/*.txt; do

    [ -e "$fichier_txt" ] || continue

    nom_fichier=$(basename "$fichier_txt" .txt)
    fichier_html="$DOSSIER_CIBLE/concordance_${nom_fichier}.html"
    

    echo "<!DOCTYPE html>" > "$fichier_html"
    echo "<html lang=\"en\">" >> "$fichier_html"
    echo "<head>" >> "$fichier_html"
    echo "    <meta charset=\"UTF-8\">" >> "$fichier_html"
    echo "    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">" >> "$fichier_html"
    echo "    <title>Concordance - $nom_fichier</title>" >> "$fichier_html"
    echo "</head>" >> "$fichier_html"
    echo "<body>" >> "$fichier_html"
    echo "    <div class=\"container\">" >> "$fichier_html"
    echo "        <h1 class=\"title mt-5\">Concordance : $nom_fichier</h1>" >> "$fichier_html"
    echo "        <table class=\"table is-bordered is-striped is-narrow is-hoverable is-fullwidth\">" >> "$fichier_html"
    echo "            <thead>" >> "$fichier_html"
    echo "                <tr>" >> "$fichier_html"
    echo "                    <th class=\"has-text-right\" style=\"width:45%\">Contexte gauche</th>" >> "$fichier_html"
    echo "                    <th class=\"has-text-centered has-text-danger\">Mot</th>" >> "$fichier_html"
    echo "                    <th class=\"has-text-left\" style=\"width:45%\">Contexte droit</th>" >> "$fichier_html"
    echo "                </tr>" >> "$fichier_html"
    echo "            </thead>" >> "$fichier_html"
    echo "            <tbody>" >> "$fichier_html"


    grep -h -E -o ".{0,30}${MOTIF}.{0,30}" "$fichier_txt" | \
    sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' | \
    sed -E "s/(.*)($MOTIF)(.*)/<tr><td class=\"has-text-right\">\1<\/td><td class=\"has-text-centered has-text-danger\"><strong>\2<\/strong><\/td><td class=\"has-text-left\">\3<\/td><\/tr>/" >> "$fichier_html"

    echo "            </tbody>" >> "$fichier_html"
    echo "        </table>" >> "$fichier_html"
    echo "    </div>" >> "$fichier_html"
    echo "</body>" >> "$fichier_html"
    echo "</html>" >> "$fichier_html"

done