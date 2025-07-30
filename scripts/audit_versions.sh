#!/bin/bash

echo "🔍 AUDIT COMPLET DES VERSIONS MATH4CHILD"

# Analyser les backups disponibles
echo "📁 BACKUPS DISPONIBLES :"
ls -la apps/math4child/src/app/page.tsx* | head -10

# Version de production (si accessible)
echo "🌐 VERSION PRODUCTION :"
curl -s https://math4child.com | grep -o '<title>.*</title>' || echo "Non accessible"

# Taille des fichiers pour identifier la version la plus complète
echo "📊 TAILLES DES FICHIERS :"
du -h apps/math4child/src/app/page.tsx*

# Rechercher la version la plus stable (ultimate-backup)
echo "✅ VERSION RECOMMANDÉE :"
if [[ -f "apps/math4child/src/app/page.tsx.ultimate-backup-1753369970" ]]; then
    echo "✅ Ultimate backup trouvé - VERSION STABLE IDENTIFIÉE"
    head -20 apps/math4child/src/app/page.tsx.ultimate-backup-1753369970
else
    echo "❌ Ultimate backup non trouvé"
fi
