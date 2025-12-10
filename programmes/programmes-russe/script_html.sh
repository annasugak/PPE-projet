#!/bin/bash

# Fichier contenant la liste des URL
FICHIER_URLS="/home/annasugak/Bureau/projet/PPE-projet/URLs/urls_russe.txt"

# Dossier de destination pour les fichiers HTML
DOSSIER_DESTINATION="/home/annasugak/Bureau/projet/PPE-projet/aspirations"

# Crée le dossier de destination s'il n'existe pas
mkdir -p "$DOSSIER_DESTINATION"

# Boucle à travers chaque URL dans le fichier
while IFS= read -r url; do
    # Vérifie si la ligne n'est pas vide
    if [[ -n "$url" ]]; then
        # Crée un nom de fichier simple à partir de l'URL
        # On utilise echo, sed et tr pour nettoyer l'URL et créer un nom de fichier sûr
        NOM_FICHIER=$(echo "$url" | sed -e 's|^http[s]*://||' -e 's|[/]*$||' | tr -c '[:alnum:]\n' '_' | head -c 100)

        # Si le nom de fichier est vide, utilise "index"
        if [[ -z "$NOM_FICHIER" ]]; then
            NOM_FICHIER="index"
        fi

        NOM_FICHIER_COMPLET="$DOSSIER_DESTINATION/$NOM_FICHIER.html"

        # Télécharge l'URL dans le fichier de destination.
        # -O : enregistre sous le nom de fichier spécifié
        # -q : mode silencieux
        # --user-agent : pour imiter un navigateur et éviter le blocage par certains serveurs
        wget -q -O "$NOM_FICHIER_COMPLET" "$url" --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

    fi
done < "$FICHIER_URLS"
