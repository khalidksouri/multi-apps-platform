#!/bin/bash

# =============================================================================
# Script de mise à jour du logo AI4KIDS
# =============================================================================

set -e  # Arrêt en cas d'erreur

echo "🎨 Mise à jour du logo AI4KIDS - Version 2.0"
echo "============================================="

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"

# Vérifications préalables
echo -e "${BLUE}📋 Vérifications préalables...${NC}"

if [ ! -d "$AI4KIDS_APP_DIR" ]; then
    echo -e "${RED}❌ Erreur: Le dossier apps/ai4kids n'existe pas${NC}"
    exit 1
fi

# Vérifier si Node.js est installé
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js n'est pas installé${NC}"
    exit 1
fi

# Vérifier si npm est installé
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm n'est pas installé${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Vérifications réussies${NC}"

# Fonction pour créer les dossiers nécessaires
create_directories() {
    echo -e "${BLUE}📁 Création des dossiers...${NC}"
    
    mkdir -p "$AI4KIDS_APP_DIR/src/components"
    mkdir -p "$AI4KIDS_APP_DIR/src/components/ui"
    mkdir -p "$AI4KIDS_APP_DIR/src/styles"
    mkdir -p "$AI4KIDS_APP_DIR/src/styles/components"
    mkdir -p "$AI4KIDS_APP_DIR/public"
    mkdir -p "$AI4KIDS_APP_DIR/public/icons"
    mkdir -p "$SCRIPTS_DIR/assets"
    
    echo -e "${GREEN}✅ Dossiers créés${NC}"
}

# Fonction pour sauvegarder les fichiers existants
backup_files() {
    echo -e "${BLUE}💾 Sauvegarde des fichiers existants...${NC}"
    
    BACKUP_DIR="$AI4KIDS_APP_DIR/backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Sauvegarder les fichiers principaux
    if [ -f "$AI4KIDS_APP_DIR/src/app/page.tsx" ]; then
        cp "$AI4KIDS_APP_DIR/src/app/page.tsx" "$BACKUP_DIR/"
    fi
    
    if [ -f "$AI4KIDS_APP_DIR/src/app/layout.tsx" ]; then
        cp "$AI4KIDS_APP_DIR/src/app/layout.tsx" "$BACKUP_DIR/"
    fi
    
    if [ -f "$AI4KIDS_APP_DIR/src/index.ts" ]; then
        cp "$AI4KIDS_APP_DIR/src/index.ts" "$BACKUP_DIR/"
    fi
    
    echo -e "${GREEN}✅ Sauvegarde terminée dans $BACKUP_DIR${NC}"
}

# Fonction pour exécuter les scripts auxiliaires
execute_scripts() {
    echo -e "${BLUE}🔧 Exécution des scripts auxiliaires...${NC}"
    
    # Rendre les scripts exécutables
    chmod +x "$SCRIPTS_DIR/create_components.sh"
    chmod +x "$SCRIPTS_DIR/create_assets.sh"
    chmod +x "$SCRIPTS_DIR/update_package.sh"
    
    # Exécuter les scripts
    "$SCRIPTS_DIR/create_components.sh"
    "$SCRIPTS_DIR/create_assets.sh"
    "$SCRIPTS_DIR/update_package.sh"
    
    echo -e "${GREEN}✅ Scripts exécutés avec succès${NC}"
}

# Fonction pour mettre à jour les traductions
update_translations() {
    echo -e "${BLUE}🌍 Mise à jour des traductions...${NC}"
    
    # Mettre à jour les fichiers de traduction existants
    for locale_dir in "$AI4KIDS_APP_DIR/src/i18n/locales"/*; do
        if [ -d "$locale_dir" ]; then
            locale_name=$(basename "$locale_dir")
            common_file="$locale_dir/common.json"
            
            if [ -f "$common_file" ]; then
                # Créer une sauvegarde
                cp "$common_file" "$common_file.bak"
                
                # Mise à jour du fichier JSON
                node -e "
                const fs = require('fs');
                const file = '$common_file';
                const data = JSON.parse(fs.readFileSync(file, 'utf8'));
                data.appName = 'AI4KIDS';
                data.appDescription = 'Intelligence Artificielle pour Enfants';
                data.logoAlt = 'Logo AI4KIDS avec personnages colorés';
                data.newFeatures = 'Nouvelles fonctionnalités';
                data.games = 'Jeux';
                data.stories = 'Histoires';
                data.aiDiscovery = 'Découverte IA';
                fs.writeFileSync(file, JSON.stringify(data, null, 2));
                "
            fi
        fi
    done
    
    echo -e "${GREEN}✅ Traductions mises à jour${NC}"
}

# Fonction pour installer les dépendances
install_dependencies() {
    echo -e "${BLUE}📦 Installation des dépendances...${NC}"
    
    cd "$AI4KIDS_APP_DIR"
    
    # Installer les dépendances de développement si nécessaire
    if [ ! -f "package.json" ]; then
        echo -e "${YELLOW}⚠️ package.json non trouvé, création...${NC}"
        npm init -y
    fi
    
    # Installer les dépendances
    npm install
    
    echo -e "${GREEN}✅ Dépendances installées${NC}"
}

# Fonction pour tester la compilation
test_build() {
    echo -e "${BLUE}🧪 Test de compilation...${NC}"
    
    cd "$AI4KIDS_APP_DIR"
    
    # Test de build
    if npm run build 2>/dev/null; then
        echo -e "${GREEN}✅ Build réussi${NC}"
    else
        echo -e "${YELLOW}⚠️ Erreur de build, vérifiez les logs${NC}"
    fi
}

# Fonction principale
main() {
    echo -e "${BLUE}🚀 Début de la mise à jour...${NC}"
    
    create_directories
    backup_files
    execute_scripts
    update_translations
    install_dependencies
    test_build
    
    echo ""
    echo -e "${GREEN}🎉 MISE À JOUR TERMINÉE AVEC SUCCÈS !${NC}"
    echo ""
    echo -e "${BLUE}📋 Prochaines étapes :${NC}"
    echo "1. Vérifiez les fichiers générés dans apps/ai4kids/"
    echo "2. Testez l'application avec: cd apps/ai4kids && npm run dev"
    echo "3. Consultez le README.md mis à jour pour plus d'informations"
    echo ""
    echo -e "${YELLOW}📁 Sauvegarde des anciens fichiers disponible dans:${NC}"
    echo "   $BACKUP_DIR"
    echo ""
}

# Gestion des erreurs
handle_error() {
    echo -e "${RED}❌ Erreur détectée à la ligne $1${NC}"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Lancement du script principal
main
