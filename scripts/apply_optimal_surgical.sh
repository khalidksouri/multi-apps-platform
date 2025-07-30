#!/bin/bash

echo "🎯 APPLICATION CHIRURGICALE DES PLANS OPTIMAUX"

PAGE_FILE="apps/math4child/src/app/page.tsx"
BACKUP_SURGICAL="apps/math4child/src/app/page.tsx.before_surgical_$(date +%H%M%S)"

# Sauvegarde avant modifications chirurgicales
cp "$PAGE_FILE" "$BACKUP_SURGICAL"
echo "💾 Sauvegarde chirurgicale : $BACKUP_SURGICAL"

echo "💰 MODIFICATION PRIX (lignes identifiées 132, 134, 151, 171, 173)"
# Prix mensuels optimaux
sed -i.tmp 's/monthlyPrice: 9\.99/monthlyPrice: 6.99/g' "$PAGE_FILE"
sed -i.tmp 's/monthlyPrice: 14\.99/monthlyPrice: 4.99/g' "$PAGE_FILE"  
sed -i.tmp 's/monthlyPrice: 49\.99/monthlyPrice: 24.99/g' "$PAGE_FILE"

# Prix annuels optimaux
sed -i.tmp 's/annualPrice: 89\.99/annualPrice: 58.32/g' "$PAGE_FILE"
sed -i.tmp 's/annualPrice: 449\.99/annualPrice: 209.93/g' "$PAGE_FILE"

echo "📚 MODIFICATION NIVEAUX (lignes 40, 54, 68, 82)"
# Niveaux scolaires → numériques (seulement dans les noms affichés)
sed -i.tmp "s/name: 'CP'/name: 'Niveau 1'/g" "$PAGE_FILE"
sed -i.tmp "s/name: 'CE1'/name: 'Niveau 2'/g" "$PAGE_FILE"
sed -i.tmp "s/name: 'CE2'/name: 'Niveau 3'/g" "$PAGE_FILE"
sed -i.tmp "s/name: 'CM1'/name: 'Niveau 4'/g" "$PAGE_FILE"
sed -i.tmp "s/name: 'CM2'/name: 'Niveau 5'/g" "$PAGE_FILE"

# Commentaire de configuration
sed -i.tmp 's/CP → CM2/Niveau 1 → Niveau 5/g' "$PAGE_FILE"

echo "👥 MODIFICATION PROFILS (plan famille)"
# Augmenter les profils famille de 3 à 5
sed -i.tmp 's/maxProfiles: 3/maxProfiles: 5/g' "$PAGE_FILE"
sed -i.tmp 's/profiles: 3/profiles: 5/g' "$PAGE_FILE"

# Nettoyer fichiers temporaires
rm -f "${PAGE_FILE}.tmp"

echo "🔍 VÉRIFICATION DES MODIFICATIONS"
echo "💰 Nouveaux prix :"
grep -n "monthlyPrice\|annualPrice" "$PAGE_FILE" | head -5

echo "📚 Nouveaux niveaux :"
grep -n "name: 'Niveau" "$PAGE_FILE" | head -5

echo "✅ MODIFICATIONS CHIRURGICALES APPLIQUÉES"
echo "📁 Backup disponible : $BACKUP_SURGICAL"
