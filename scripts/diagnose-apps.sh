#!/bin/bash

# Script de diagnostic avancé pour toutes les applications
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 DIAGNOSTIC AVANCÉ DU MULTI-APPS-PLATFORM${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Fonction de diagnostic détaillé
diagnose_app_detailed() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    echo -e "${YELLOW}🔍 Diagnostic détaillé de $app_name${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ ! -d "$app_dir" ]; then
        echo -e "❌ ${RED}Répertoire non trouvé: $app_dir${NC}"
        return 1
    fi
    
    cd "$app_dir"
    
    # 1. Vérifier la structure du projet
    echo -e "${BLUE}📂 Structure du projet:${NC}"
    if [ -f "package.json" ]; then
        echo -e "  ✅ package.json présent"
        local name=$(node -p "require('./package.json').name" 2>/dev/null || echo "N/A")
        local version=$(node -p "require('./package.json').version" 2>/dev/null || echo "N/A")
        echo -e "     Nom: $name, Version: $version"
    else
        echo -e "  ❌ package.json manquant"
    fi
    
    if [ -d "node_modules" ]; then
        local modules_size=$(du -sh node_modules 2>/dev/null | cut -f1 || echo "N/A")
        echo -e "  ✅ node_modules présent ($modules_size)"
    else
        echo -e "  ❌ node_modules manquant"
    fi
    
    if [ -d "src" ]; then
        echo -e "  ✅ Dossier src présent"
        local src_files=$(find src -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.vue" | wc -l | tr -d ' ')
        echo -e "     Fichiers source: $src_files"
    else
        echo -e "  ❌ Dossier src manquant"
    fi
    
    # 2. Vérifier les dépendances
    echo -e "${BLUE}📦 Dépendances:${NC}"
    if [ -f "package.json" ]; then
        local react_version=$(node -p "require('./package.json').dependencies?.react" 2>/dev/null || echo "N/A")
        local vue_version=$(node -p "require('./package.json').dependencies?.vue" 2>/dev/null || echo "N/A")
        local next_version=$(node -p "require('./package.json').dependencies?.next" 2>/dev/null || echo "N/A")
        local ts_version=$(node -p "require('./package.json').dependencies?.typescript || require('./package.json').devDependencies?.typescript" 2>/dev/null || echo "N/A")
        
        [ "$react_version" != "N/A" ] && echo -e "  ⚛️ React: $react_version"
        [ "$vue_version" != "N/A" ] && echo -e "  💚 Vue: $vue_version"
        [ "$next_version" != "N/A" ] && echo -e "  ▲ Next.js: $next_version"
        [ "$ts_version" != "N/A" ] && echo -e "  📘 TypeScript: $ts_version"
    fi
    
    # 3. Tester les scripts npm
    echo -e "${BLUE}📜 Scripts npm:${NC}"
    if [ -f "package.json" ]; then
        local scripts=$(node -p "Object.keys(require('./package.json').scripts || {}).join(', ')" 2>/dev/null || echo "Aucun")
        echo -e "  📋 Scripts disponibles: $scripts"
        
        # Tester le script start
        if npm run start --dry-run >/dev/null 2>&1; then
            echo -e "  ✅ Script 'start' valide"
        else
            echo -e "  ❌ Script 'start' invalide"
        fi
    fi
    
    # 4. Vérifier les fichiers de configuration
    echo -e "${BLUE}⚙️ Configuration:${NC}"
    [ -f "tsconfig.json" ] && echo -e "  ✅ tsconfig.json présent" || echo -e "  ⚠️ tsconfig.json manquant"
    [ -f "next.config.js" ] && echo -e "  ✅ next.config.js présent"
    [ -f "vue.config.js" ] && echo -e "  ✅ vue.config.js présent"
    [ -f ".npmrc" ] && echo -e "  ✅ .npmrc présent"
    
    # 5. Vérifier les logs d'erreur récents
    echo -e "${BLUE}📝 Logs récents:${NC}"
    local log_file="$WORKSPACE_DIR/logs/${app_name}.log"
    if [ -f "$log_file" ]; then
        local log_size=$(du -h "$log_file" | cut -f1)
        echo -e "  📄 Log disponible ($log_size)"
        
        # Vérifier les erreurs récentes
        local errors=$(tail -n 50 "$log_file" 2>/dev/null | grep -i "error\|failed\|exception" | wc -l | tr -d ' ')
        if [ "$errors" -gt 0 ]; then
            echo -e "  ⚠️ $errors erreurs récentes trouvées"
            echo -e "  🔍 Dernières erreurs:"
            tail -n 50 "$log_file" 2>/dev/null | grep -i "error\|failed\|exception" | tail -n 3 | sed 's/^/     /'
        else
            echo -e "  ✅ Aucune erreur récente"
        fi
    else
        echo -e "  ⚠️ Aucun log disponible"
    fi
    
    echo ""
    return 0
}

# Diagnostiquer toutes les applications
apps=("math4kids" "unitflip" "budgetcron" "ai4kids" "multiai")

for app in "${apps[@]}"; do
    diagnose_app_detailed "$app"
done

# Résumé des recommandations
echo -e "${BLUE}💡 RECOMMANDATIONS${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Pour les applications qui ne démarrent pas:${NC}"
echo "1. Vérifiez les logs: ls $WORKSPACE_DIR/logs/"
echo "2. Réinstallez les dépendances: cd app_dir && npm install --legacy-peer-deps"
echo "3. Vérifiez la configuration TypeScript"
echo "4. Testez le build: npm run build"
echo ""
echo -e "${YELLOW}Scripts disponibles:${NC}"
echo "🔧 ./fix-react-apps.sh  - Corriger les apps React"
echo "🚀 ./start-apps.sh      - Démarrer les applications"
echo "📊 ./status-apps.sh     - Vérifier le statut"
echo ""
