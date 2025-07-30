#!/bin/bash

# =====================================
# Script de correction RAPIDE et DIRECT
# Ajout immédiat de la section manquante
# =====================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

echo -e "${BLUE}"
echo "======================================================="
echo "🚀 CORRECTION RAPIDE - AJOUT SECTION MANQUANTE"
echo "======================================================="
echo -e "${NC}"

cd apps/math4child

# Vérification du fichier actuel
print_step "Vérification du contenu actuel..."
echo -e "${YELLOW}📄 Dernières lignes du fichier :${NC}"
tail -10 src/app/page.tsx

# Ajout direct de la section manquante à la fin du fichier
print_step "Ajout direct de la section d'informations..."

# Sauvegarder l'original
cp src/app/page.tsx src/app/page.tsx.before-quick-fix

# Trouver la ligne de fermeture et ajouter le contenu avant
cat > temp_addition.txt << 'EOF'

            {/* Section d'informations sur la langue sélectionnée - AJOUT RAPIDE */}
            <div className="mt-12 p-6 bg-white rounded-lg shadow-sm">
              <h3 className="text-lg font-semibold mb-4">
                {selectedLanguage.code === 'ar-PS' && 'اللغة المختارة'}
                {selectedLanguage.code === 'ar-MA' && 'اللغة المختارة'}  
                {!selectedLanguage.code.startsWith('ar') && 'Langue sélectionnée'}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div>
                  <span className="font-medium">Langue:</span> {selectedLanguage.name}
                </div>
                <div>
                  <span className="font-medium">Continent:</span> {selectedLanguage.continent}
                </div>
                <div>
                  <span className="font-medium">Devise:</span> {selectedLanguage.currency}
                </div>
              </div>
              
              {/* Support RTL */}
              {selectedLanguage.rtl && (
                <div className="mt-2 text-sm text-indigo-600">
                  ✨ Support RTL activé pour cette langue
                </div>
              )}
              
              {/* Informations spéciales pour Palestine et Maroc */}
              {selectedLanguage.code === 'ar-PS' && (
                <div className="mt-2 text-sm text-green-600">
                  🇵🇸 Palestine ajoutée au Moyen-Orient avec support complet
                </div>
              )}
              {selectedLanguage.code === 'ar-MA' && (
                <div className="mt-2 text-sm text-green-600">
                  🇲🇦 Maroc en Afrique avec drapeau marocain maintenu
                </div>
              )}
            </div>
EOF

# Insérer le contenu avant les dernières lignes de fermeture
# Trouver la ligne avec </div> </main> </div> et insérer avant
awk '
/^          <\/div>$/ && getline next_line && next_line ~ /^        <\/main>$/ {
    # Lire le fichier d'\''addition
    while ((getline line < "temp_addition.txt") > 0) {
        print line
    }
    close("temp_addition.txt")
    print
    print next_line
    next
}
{ print }
' src/app/page.tsx > src/app/page.tsx.new

# Remplacer le fichier original
mv src/app/page.tsx.new src/app/page.tsx
rm temp_addition.txt

print_success "Section d'informations ajoutée"

# Vérification que l'ajout a fonctionné
print_step "Vérification de l'ajout..."
if grep -q "Section d'informations sur la langue sélectionnée - AJOUT RAPIDE" src/app/page.tsx; then
    print_success "✅ Section ajoutée avec succès"
else
    print_error "❌ Ajout échoué, méthode alternative..."
    
    # Méthode alternative : ajout manuel à la fin
    # Supprimer les 3 dernières lignes et ajouter le nouveau contenu
    head -n -3 src/app/page.tsx.before-quick-fix > temp_file.txt
    
    cat >> temp_file.txt << 'EOF'

            {/* Section d'informations sur la langue sélectionnée - AJOUT RAPIDE */}
            <div className="mt-12 p-6 bg-white rounded-lg shadow-sm">
              <h3 className="text-lg font-semibold mb-4">
                {selectedLanguage.code === 'ar-PS' && 'اللغة المختارة'}
                {selectedLanguage.code === 'ar-MA' && 'اللغة المختارة'}  
                {!selectedLanguage.code.startsWith('ar') && 'Langue sélectionnée'}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div>
                  <span className="font-medium">Langue:</span> {selectedLanguage.name}
                </div>
                <div>
                  <span className="font-medium">Continent:</span> {selectedLanguage.continent}
                </div>
                <div>
                  <span className="font-medium">Devise:</span> {selectedLanguage.currency}
                </div>
              </div>
              
              {/* Support RTL */}
              {selectedLanguage.rtl && (
                <div className="mt-2 text-sm text-indigo-600">
                  ✨ Support RTL activé pour cette langue
                </div>
              )}
              
              {/* Informations spéciales pour Palestine et Maroc */}
              {selectedLanguage.code === 'ar-PS' && (
                <div className="mt-2 text-sm text-green-600">
                  🇵🇸 Palestine ajoutée au Moyen-Orient avec support complet
                </div>
              )}
              {selectedLanguage.code === 'ar-MA' && (
                <div className="mt-2 text-sm text-green-600">
                  🇲🇦 Maroc en Afrique avec drapeau marocain maintenu
                </div>
              )}
            </div>
          </div>
        </main>
      </div>
    </div>
  );
}
EOF
    
    mv temp_file.txt src/app/page.tsx
    print_success "✅ Section ajoutée avec méthode alternative"
fi

# Test de compilation
print_step "Test de compilation..."
if npm run type-check --silent 2>/dev/null; then
    echo ""
    print_success "🎉 SECTION AJOUTÉE AVEC SUCCÈS !"
    echo ""
    echo -e "${GREEN}📄 CONTENU AJOUTÉ :${NC}"
    echo "✅ Section d'informations sur la langue sélectionnée"
    echo "✅ Affichage du nom, continent, devise"
    echo "✅ Message RTL pour langues arabes"
    echo "✅ Messages spéciaux Palestine 🇵🇸 et Maroc 🇲🇦"
    echo ""
    echo -e "${BLUE}🔄 ACTIONS À FAIRE :${NC}"
    echo "1. Rafraîchissez votre navigateur (Cmd+R ou F5)"
    echo "2. Testez en changeant de langue"
    echo "3. Vérifiez les messages pour ar-PS et ar-MA"
    echo ""
    echo -e "${GREEN}🚀 LA SECTION DEVRAIT MAINTENANT APPARAÎTRE !${NC}"
    
    return 0
else
    echo ""
    print_error "❌ Erreurs de compilation..."
    npm run type-check | head -10
    
    # Restaurer l'original en cas d'erreur
    mv src/app/page.tsx.before-quick-fix src/app/page.tsx
    print_step "Fichier original restauré"
    
    return 1
fi

cd ../..