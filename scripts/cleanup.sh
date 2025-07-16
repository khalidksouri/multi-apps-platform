#!/bin/bash

# Script de nettoyage AI4KIDS
echo "🧹 Nettoyage des fichiers temporaires..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Nettoyer les logs anciens (> 7 jours)
find "$SCRIPT_DIR" -name "deployment_*.log" -type f -mtime +7 -delete

# Nettoyer les sauvegardes anciennes (> 30 jours)
find "$PROJECT_ROOT" -name "backup_*" -type d -mtime +30 -exec rm -rf {} + 2>/dev/null || true

# Nettoyer les node_modules si nécessaire
if [ "$1" == "--deep" ]; then
    echo "🧹 Nettoyage approfondi..."
    rm -rf "$PROJECT_ROOT/apps/ai4kids/node_modules"
    rm -rf "$PROJECT_ROOT/apps/ai4kids/.next"
    rm -rf "$PROJECT_ROOT/apps/ai4kids/dist"
fi

echo "✅ Nettoyage terminé"
