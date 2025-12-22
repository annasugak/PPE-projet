FICHIER_URLS="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/URLs/urls_anglais.txt"
DOSSIER_DESTINATION="/home/benoitcf/Documents/cours/PPE/projet_groupe_PPE/PPE-projet/dumps-txt"

mkdir -p "$DOSSIER_DESTINATION"

compteur=1

while read -r url || [ -n "$url" ]; do

    if [ -n "$url" ]; then

        echo "Traitement de l'URL $compteur: $url"
        lynx -dump "$url" > "$DOSSIER_DESTINATION/dump_${compteur}.txt" 2>/dev/null

    else
        echo "Erreur sur l'URL : $url"
        fi

        compteur=$((compteur + 1))

done < "$FICHIER_URLS"
