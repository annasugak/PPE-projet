#!/bin/bash

DOSSIER="$1"
NOM_BASE="$2"

> "pals/${NOM_BASE}.txt"

for fichier in "$DOSSIER"/*.txt
do
    perl -CSD -Mutf8 -pe 's/[^\p{L}\p{N}]+/\n/g' "$fichier" >> "pals/${NOM_BASE}.txt"
done

echo "Traitement terminé. Le fichier pals/${NOM_BASE}.txt est prêt."
