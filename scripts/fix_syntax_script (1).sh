#!/bin/bash

# Script pour corriger les erreurs de syntaxe dans page.tsx

echo "🔧 Correction des erreurs de syntaxe..."

# Trouver le fichier de page
PAGE_FILE="apps/math4child/src/app/page.tsx"

if [[ ! -f "$PAGE_FILE" ]]; then
    echo "❌ Fichier $PAGE_FILE non trouvé"
    exit 1
fi

echo "📄 Correction du fichier: $PAGE_FILE"

# Créer une sauvegarde avant correction
BACKUP_FILE="${PAGE_FILE}.before_fix.$(date +%Y%m%d_%H%M%S)"
cp "$PAGE_FILE" "$BACKUP_FILE"
echo "💾 Sauvegarde créée: $BACKUP_FILE"

# Utiliser sed pour corriger les erreurs de syntaxe
echo "🔄 Correction des erreurs..."

# Correction 1: Fixer les chaînes non fermées et les caractères échappés
sed -i.tmp '
# Corriger les guillemets non fermés dans les features
s/✓ Suivi détaillé des 100 bonnes réponses/'\''Suivi détaillé des 100 bonnes réponses'\''/g
s/✓ Statistiques par opération/'\''Statistiques par opération'\''/g
s/✓ Rapports de progression/'\''Rapports de progression'\''/g
s/✓ Défis chronométrés/'\''Défis chronométrés'\''/g
s/✓ Analyse détaillée des erreurs/'\''Analyse détaillée des erreurs'\''/g
s/✓ Recommandations personnalisées/'\''Recommandations personnalisées'\''/g
s/✓ Tableau de bord enseignant/'\''Tableau de bord enseignant'\''/g
s/✓ Suivi collectif des validations/'\''Suivi collectif des validations'\''/g
s/✓ Attribution d'\''exercices ciblés/'\''Attribution d exercices ciblés'\''/g
s/✓ Rapports de classe détaillés/'\''Rapports de classe détaillés'\''/g
s/✓ Support pédagogique dédié/'\''Support pédagogique dédié'\''/g

# Corriger les lignes qui commencent par des caractères spéciaux
s/^        ✓/        '\''/g
s/^✓/'\''✓/g

# Assurer que toutes les lignes de features sont bien formatées
s/features: \[/features: [/g
' "$PAGE_FILE"

# Correction 2: Nettoyer et reformater le tableau des features
python3 << 'EOF'
import re

# Lire le fichier
with open('apps/math4child/src/app/page.tsx', 'r') as f:
    content = f.read()

# Patterns de correction pour les features mal formatées
fixes = [
    # Corriger les features du plan Famille
    (r"features: \[\s*'5 profils enfants',\s*'Tous les niveaux 1 → 5',\s*'Exercices illimités'\s*'Suivi détaillé des 100 bonnes réponses'\s*'Statistiques par opération'\s*'Rapports de progression'", 
     "features: ['5 profils enfants', 'Tous les niveaux 1 → 5', 'Exercices illimités', 'Suivi détaillé des 100 bonnes réponses', 'Statistiques par opération', 'Rapports de progression']"),
    
    # Corriger les features du plan Premium  
    (r"features: \[\s*'2 profils enfants',\s*'Tous les niveaux \+ exercices bonus',\s*'Mode révision niveaux validés'\s*'Défis chronométrés'\s*'Analyse détaillée des erreurs'\s*'Recommandations personnalisées'",
     "features: ['2 profils enfants', 'Tous les niveaux + exercices bonus', 'Mode révision niveaux validés', 'Défis chronométrés', 'Analyse détaillée des erreurs', 'Recommandations personnalisées']"),
    
    # Corriger les features du plan École
    (r"features: \[\s*'30 profils élèves',\s*'Gestion par niveaux \(1 à 5\)',\s*'Tableau de bord enseignant'\s*'Suivi collectif des validations'\s*'Attribution d exercices ciblés'\s*'Rapports de classe détaillés'\s*'Support pédagogique dédié'",
     "features: ['30 profils élèves', 'Gestion par niveaux (1 à 5)', 'Tableau de bord enseignant', 'Suivi collectif des validations', 'Attribution d exercices ciblés', 'Rapports de classe détaillés', 'Support pédagogique dédié']"),
]

# Appliquer les corrections
for pattern, replacement in fixes:
    content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)

# Corrections générales pour nettoyer la syntaxe
content = re.sub(r"'([^']*)'([^,\]]*)'([^']*)'", r"'\1', '\3'", content)  # Séparer les chaînes collées
content = re.sub(r"',\s*'", "', '", content)  # Normaliser les espaces
content = re.sub(r"'\s*✓\s*", "'", content)  # Supprimer les ✓ en début de chaîne

# Écrire le fichier corrigé
with open('apps/math4child/src/app/page.tsx', 'w') as f:
    f.write(content)

print("Corrections Python appliquées")
EOF

# Correction 3: Vérifications finales avec sed
sed -i.tmp2 '
# Assurer que toutes les features sont bien fermées par des virgules
s/\],$/],/g
s/\]$/],/g

# Corriger les apostrophes dans les chaînes
s/d'\''exercices/d exercices/g
s/'\'''/'"'"'/g

# Nettoyer les espaces en trop
s/  */ /g
s/, *,/,/g
' "$PAGE_FILE"

# Nettoyer les fichiers temporaires
rm -f "${PAGE_FILE}.tmp" "${PAGE_FILE}.tmp2"

echo "✅ Corrections appliquées!"
echo "🔄 Vérifiez que le serveur redémarre correctement"

# Vérifier la syntaxe avec Node.js si disponible
if command -v node &> /dev/null; then
    echo "🔍 Vérification de la syntaxe..."
    if node -c "$PAGE_FILE" 2>/dev/null; then
        echo "✅ Syntaxe correcte!"
    else
        echo "⚠️  Il peut encore y avoir des erreurs de syntaxe"
    fi
fi

echo "📁 Sauvegarde disponible: $BACKUP_FILE"