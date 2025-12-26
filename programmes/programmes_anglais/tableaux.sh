#!/bin/bash

FICHIER_URL="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/URLs/urls_anglais.txt"
DOSSIER_ASPIRATION="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/aspirations/aspiration_anglais"
DOSSIER_DUMP="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/dumps-txt/dumps-txt-anglais"
DOSSIER_CONCORDANCES="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/concordances/concordances_anglais"
DOSSIER_CONTEXTES="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/contextes/contextes_anglais"
TABLEAU="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/tableaux/tableau_anglais.html"

mkdir -p "$DOSSIER_ASPIRATION" "$DOSSIER_DUMP" "$DOSSIER_CONCORDANCES" "$DOSSIER_CONTEXTES" "$(dirname "$TABLEAU")"

MOTIF="[Ll]ight"

echo "<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
    <title>Tableau des URLs - Anglais</title>
</head>
<body>²
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


COMPTEUR=1
while IFS= read -r URL; do
    [[ -z "$URL" ]] && continue
    
    echo "Traitement de l'URL $COMPTEUR : $URL"


    NOM_BASE="anglais_$COMPTEUR"

    CODE_HTTP=$(curl -s -o /dev/null -w "%{http_code}" "$URL")


    curl -s "$URL" > "$DOSSIER_ASPIRATION/$NOM_BASE.html"

 
    encodage=$(lynx -source "$URL" 2>/dev/null | grep -iPo "charset=[\"']?\K[\w-]+" | head -1)
    [[ -z "$encodage" ]] && encodage="UTF-8"
    
    lynx -dump -nolist -display_charset=$encodage "$URL" > "$DOSSIER_DUMP/$NOM_BASE.txt"


    OCCURENCES=$(grep -ioP "$MOTIF" "$DOSSIER_DUMP/$NOM_BASE.txt" | wc -l)
    
    grep -P -A 2 -B 2 "$MOTIF" "$DOSSIER_DUMP/$NOM_BASE.txt" > "$DOSSIER_CONTEXTES/contextes_$NOM_BASE.txt"


    echo "<tr>
    <td>$COMPTEUR</td>
    <td>$CODE_HTTP</td>
    <td><a href=\"$URL\">Lien</a></td>
    <td>$encodage</td>
    <td><a href=\"../aspirations/aspiration_anglais/$NOM_BASE.html\">HTML</a></td>
    <td><a href=\"../dumps-txt/dumps-txt-anglais/$NOM_BASE.txt\">Text</a></td>
    <td>$OCCURENCES</td>
    <td><a href=\"../contextes/contextes_anglais/contextes_$NOM_BASE.txt\">Contextes</a></td>
    <td><a href=\"../concordances/concordances_anglais/concordance_$NOM_BASE.html\">Concordance</a></td>
    </tr>" >> "$TABLEAU"

    ((COMPTEUR++))
done < "$FICHIER_URL"

echo "</tbody></table></section></body></html>" >> "$TABLEAU"
