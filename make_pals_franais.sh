#!/bin/bash

DOSSIER="$1"
NOM_BASE="$2"

> "pals/${NOM_BASE}.txt"

for fichier in "$DOSSIER"/*.txt
do
    LC_ALL=C tr -cs "[:alpha:]" "\n" < "$fichier" >> "pals/${NOM_BASE}.txt"
done

echo "Traitement terminé. Le fichier pals/${NOM_BASE}.txt est pr$
