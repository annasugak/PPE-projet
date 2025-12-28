#!/bin/bash


mkdir -p bigrammes

for fichier in contextes/contextes_anglais/*.txt
do

    nom_base=$(basename "$fichier" .txt)

    fichier_sortie="bigrammes/bigrammes-${nom_base}.html"

    echo "Traitement de $nom_base vers $fichier_sortie ..."

    echo "<html><head><meta charset='UTF-8'></head><body>" > "$fichier_sortie"
    echo "<h2 style='text-align: center;'>Bigrammes pour : $nom_base</h2>" >> "$fichier_sortie"
    echo "<table border='1' style='width: 100%; text-align: center; border-collapse: collapse;'>" >> "$fichier_sortie"
    echo "<tr style='background-color: #f2f2f2;'><th>Fréquence</th><th>Bigramme</th></tr>" >> "$fichier_sortie"


    tr -cs "[:alpha:]" "\n" < "$fichier" > contexte_au_propre.txt


    paste -d " " contexte_au_propre.txt <(tail -n +2 contexte_au_propre.txt) | \
    sort | uniq -c | sort -nr | head -n 20 | \
    awk '{print "<tr><td>" $1 "</td><td>" $2 " " $3 "</td></tr>"}' >> "$fichier_sortie"

    echo "</table>" >> "$fichier_sortie"
    echo "</body></html>" >> "$fichier_sortie"

done

rm contexte_au_propre.txt

echo "Terminé ! Voir le dossier 'bigrammes'."