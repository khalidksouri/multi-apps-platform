#!/bin/bash

# Script simple pour remplacer les plans d'abonnement

echo "🚀 Mise à jour des plans Math4Child..."

# Trouver le fichier de page
PAGE_FILE=""
if [[ -f "apps/math4child/src/app/page.tsx" ]]; then
    PAGE_FILE="apps/math4child/src/app/page.tsx"
elif [[ -f "apps/math4child/src/pages/index.tsx" ]]; then
    PAGE_FILE="apps/math4child/src/pages/index.tsx"
elif [[ -f "apps/math4child/src/components/HomePage.tsx" ]]; then
    PAGE_FILE="apps/math4child/src/components/HomePage.tsx"
elif [[ -f "apps/math4child/src/components/ImprovedHomePage.tsx" ]]; then
    PAGE_FILE="apps/math4child/src/components/ImprovedHomePage.tsx"
else
    echo "❌ Aucun fichier de page trouvé"
    exit 1
fi

echo "📄 Page trouvée: $PAGE_FILE"

# Créer une sauvegarde
BACKUP_FILE="${PAGE_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$PAGE_FILE" "$BACKUP_FILE"
echo "💾 Sauvegarde créée: $BACKUP_FILE"

# Remplacer les prix dans le fichier
echo "🔄 Mise à jour des prix..."

# Famille: 9.99€ -> 6.99€
sed -i.bak 's/9\.99€/6.99€/g' "$PAGE_FILE"

# Premium: 14.99€ -> 4.99€  
sed -i.bak 's/14\.99€/4.99€/g' "$PAGE_FILE"

# École: 49.99€ -> 24.99€
sed -i.bak 's/49\.99€/24.99€/g' "$PAGE_FILE"

# Mettre à jour les nombres de profils
sed -i.bak 's/3 profils/5 profils/g' "$PAGE_FILE"
sed -i.bak 's/5 profils enfants/5 profils enfants/g' "$PAGE_FILE"

# Mettre à jour les fonctionnalités du plan Famille
sed -i.bak 's/3 enfants max/5 profils enfants/g' "$PAGE_FILE"
sed -i.bak 's/Suivi basique/Tous les niveaux 1 → 5/g' "$PAGE_FILE"
sed -i.bak 's/Support email/Exercices illimités/g' "$PAGE_FILE"

# Ajouter les nouvelles fonctionnalités
sed -i.bak 's/Exercices illimités/Exercices illimités\n        ✓ Suivi détaillé des 100 bonnes réponses\n        ✓ Statistiques par opération\n        ✓ Rapports de progression/g' "$PAGE_FILE"

# Mettre à jour Premium
sed -i.bak 's/Enfants illimités/2 profils enfants/g' "$PAGE_FILE"
sed -i.bak 's/Suivi avancé/Tous les niveaux + exercices bonus/g' "$PAGE_FILE"
sed -i.bak 's/Support prioritaire/Mode révision niveaux validés/g' "$PAGE_FILE"
sed -i.bak 's/Rapports PDF/Défis chronométrés\n        ✓ Analyse détaillée des erreurs\n        ✓ Recommandations personnalisées/g' "$PAGE_FILE"

# Mettre à jour École
sed -i.bak 's/Classes multiples/30 profils élèves/g' "$PAGE_FILE"
sed -i.bak 's/Dashboard enseignant/Gestion par niveaux (1 à 5)/g' "$PAGE_FILE"
sed -i.bak 's/API intégration/Tableau de bord enseignant\n        ✓ Suivi collectif des validations\n        ✓ Attribution d'\''exercices ciblés\n        ✓ Rapports de classe détaillés\n        ✓ Support pédagogique dédié/g' "$PAGE_FILE"

# Nettoyer les fichiers temporaires
rm -f "${PAGE_FILE}.bak"

echo "✅ Mise à jour terminée!"
echo "🔄 Rechargez votre page (F5) pour voir les changements"
echo "📁 Sauvegarde disponible: $BACKUP_FILE"