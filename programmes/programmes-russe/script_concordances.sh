#!/usr/bin/bash

DOSSIER_TXT="/home/annasugak/Bureau/projet/PPE-projet/dumps-txt"
DOSSIER_CONCORDANCES="/home/annasugak/Bureau/projet/PPE-projet/concordances"
MOTIF_RECHERCHE="[Сс]вет(а|у|ом|е|ы|ов|ам|ами|ах)?"
LARGEUR_CONTEXTE=80

mkdir -p "$DOSSIER_CONCORDANCES"

for FICHIER_SOURCE in "$DOSSIER_TXT"/*.txt; do

    if [[ -f "$FICHIER_SOURCE" ]]; then

        NOM_FICHIER=$(basename "$FICHIER_SOURCE" .txt)
        FICHIER_SORTIE="$DOSSIER_CONCORDANCES/concordance_$NOM_FICHIER.html"

        echo "
            <html>
            <html lang=\"ru\">
            <head>
                <meta charset=\"utf-8\" />
                <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
                <title>Concordance - $NOM_FICHIER</title>
            </head>
            <body>
                <h1 class=\"title\">Concordance du mot \"свет\" dans $NOM_FICHIER</h1>
                <table class=\"table is-bordered is-striped is-narrow is-hoverable is-fullwidth\">
                    <thead>
                    <tr>
                    <th class=\"has-text-right\">Contexte gauche</th>
                    <th class=\"has-text-centered\">Cible</th>
                    <th class=\"has-text-left\">Contexte droit</th>
                    </tr>
                    </thead>
                    " > "$FICHIER_SORTIE"

        TEXTE_NORMALISE=$(cat "$FICHIER_SOURCE" | tr '\n' ' ' | tr -s ' ')

        perl -Mutf8 -CS -e '
            my $content = shift;
            my $largeur_contexte = 80;
            my $regex_flexionnel = q|'$MOTIF_RECHERCHE'|;

            my $regex = qr/(.{$largeur_contexte})($regex_flexionnel)(.{$largeur_contexte})/;

            while ($content =~ /\$regex/g) {
                my $gauche = $1;
                my $cible = $2;
                my $droite = $3;

                $gauche =~ s/^\s+|\s+$//g;
                $droite =~ s/^\s+|\s+$//g;

                print "<tr><td class=\"has-text-right\">$gauche</td><td class=\"has-text-danger has-text-centered\">$cible</td><td class=\"has-text-left\">$droite</td></tr>\n";
            }
        ' "$TEXTE_NORMALISE" >> "$FICHIER_SORTIE"

        echo "
                </table>
            </body>
        </html>" >> "$FICHIER_SORTIE"
    fi
done
