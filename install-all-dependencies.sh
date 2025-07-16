#!/bin/bash

# 📦 Script d'installation optimisé des dépendances
echo "🚀 Installation des dépendances pour toutes les applications I18n..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
FAILED_APPS=()

for app in "${APPS[@]}"; do
    if [ -d "apps/$app" ]; then
        echo -e "${BLUE}📦 Installation des dépendances pour $app...${NC}"
        cd "apps/$app"
        
        # Nettoyer le cache si nécessaire
        if [ -d "node_modules" ]; then
            echo "🧹 Nettoyage du cache existant..."
            rm -rf node_modules package-lock.json
        fi
        
        # Installer les dépendances
        if npm install --silent; then
            echo -e "${GREEN}✅ Dépendances installées pour $app${NC}"
        else
            echo -e "${RED}❌ Erreur lors de l'installation pour $app${NC}"
            FAILED_APPS+=("$app")
        fi
        
        cd ../..
    else
        echo -e "${RED}❌ Application $app non trouvée${NC}"
        FAILED_APPS+=("$app")
    fi
done

echo ""
if [ ${#FAILED_APPS[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 Toutes les dépendances ont été installées avec succès!${NC}"
    echo ""
    echo -e "${BLUE}Prochaines étapes:${NC}"
    echo "1. Exécutez: ./start-all-apps.sh"
    echo "2. Testez les applications dans votre navigateur"
    echo "3. Changez la langue avec le sélecteur en haut à droite"
else
    echo -e "${YELLOW}⚠️  Certaines applications ont échoué:${NC}"
    for failed_app in "${FAILED_APPS[@]}"; do
        echo "  - $failed_app"
    done
    echo ""
    echo -e "${BLUE}💡 Solutions possibles:${NC}"
    echo "1. Vérifiez votre connexion internet"
    echo "2. Nettoyez le cache npm: npm cache clean --force"
    echo "3. Réessayez l'installation individuellement"
fi
