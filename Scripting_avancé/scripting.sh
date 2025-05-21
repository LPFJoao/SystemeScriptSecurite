#!/bin/bash

DOSSIER_SOURCE="$HOME/path/to/directory/source"

DOSSIER_BACKUP="$HOME/path/to/directory/backup"
mkdir -p "$DOSSIER_BACKUP"

DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE="$DOSSIER_BACKUP/Plateforme_backup_$DATE.tar.gz"

if [ -d "$DOSSIER_SOURCE" ]; then
    echo "Sauvegarde en cours de $DOSSIER_SOURCE..."
    find "$DOSSIER_BACKUP" -name "Plateforme_backup_*.tar.gz" -type f -mtime +7 -exec rm {} \;
    tar -czf "$ARCHIVE" -C "$(dirname "$DOSSIER_SOURCE")" "$(basename "$DOSSIER_SOURCE")"
    echo "Sauvegarde terminée : $ARCHIVE"
else
    echo "❌ Erreur : le dossier $DOSSIER_SOURCE n'existe pas."
fi
