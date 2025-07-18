#!/bin/bash

# =============================================================================
# SCRIPT DE DEBUG DES LOGS - ANALYSE DES ERREURS
# =============================================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$PROJECT_DIR/logs"
WORKSPACE_DIR="$PROJECT_DIR/apps"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}🔍 ANALYSE DES LOGS D'ERREUR${NC}"
echo -e "${BLUE}============================${NC}"
echo ""

# Analyser les logs de test
for app in math4kids unitflip budgetcron ai4kids multiai; do
    log_file="$LOG_DIR/${app}_test.log"
    
    echo -e "${CYAN}📋 Analyse de $app:${NC}"
    
    if [ -f "$log_file" ]; then
        echo -e "${YELLOW}Contenu du log:${NC}"
        cat "$log_file"
        echo ""
        
        # Extraire les erreurs spécifiques
        if grep -q "npm ERR" "$log_file"; then
            echo -e "${RED}❌ Erreurs npm détectées${NC}"
        fi
        
        if grep -q "ENOENT" "$log_file"; then
            echo -e "${RED}❌ Fichier ou répertoire manquant${NC}"
        fi
        
        if grep -q "Module not found" "$log_file"; then
            echo -e "${RED}❌ Module manquant${NC}"
        fi
        
        if grep -q "Cannot resolve" "$log_file"; then
            echo -e "${RED}❌ Problème de résolution de module${NC}"
        fi
        
        if grep -q "SyntaxError" "$log_file"; then
            echo -e "${RED}❌ Erreur de syntaxe${NC}"
        fi
        
        if grep -q "EADDRINUSE" "$log_file"; then
            echo -e "${RED}❌ Port déjà utilisé${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ Aucun log trouvé${NC}"
    fi
    
    echo -e "${CYAN}─────────────────────────────────────${NC}"
    echo ""
done

echo ""
echo -e "${BLUE}🔍 VÉRIFICATION DES STRUCTURES D'APPLICATIONS${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Vérifier la structure de chaque application
for app in math4kids unitflip budgetcron ai4kids multiai digital4kids; do
    app_dir="$WORKSPACE_DIR/$app"
    
    echo -e "${CYAN}📁 Structure de $app:${NC}"
    
    if [ -d "$app_dir" ]; then
        cd "$app_dir"
        
        echo -e "   📦 package.json: $([ -f package.json ] && echo "✅ Présent" || echo "❌ Manquant")"
        
        if [ -f package.json ]; then
            # Vérifier les scripts
            echo -e "   🔧 Scripts disponibles:"
            cat package.json | grep -A 10 '"scripts"' | grep -E '(start|serve|dev|build)' || echo "   ❌ Aucun script trouvé"
            
            # Vérifier les dépendances principales
            echo -e "   📚 Dépendances principales:"
            cat package.json | grep -E '"(react|vue|next|@vue)"' || echo "   ⚠️ Aucune dépendance framework détectée"
        fi
        
        echo -e "   📁 node_modules: $([ -d node_modules ] && echo "✅ Présent" || echo "❌ Manquant")"
        echo -e "   📁 src: $([ -d src ] && echo "✅ Présent" || echo "❌ Manquant")"
        echo -e "   📁 public: $([ -d public ] && echo "✅ Présent" || echo "❌ Manquant")"
        
        if [ -d src ]; then
            echo -e "   📄 src/index.js: $([ -f src/index.js ] && echo "✅" || echo "❌")"
            echo -e "   📄 src/App.js: $([ -f src/App.js ] && echo "✅" || echo "❌")"
            echo -e "   📄 src/main.js: $([ -f src/main.js ] && echo "✅" || echo "❌")"
            echo -e "   📄 src/App.vue: $([ -f src/App.vue ] && echo "✅" || echo "❌")"
        fi
        
        if [ -d pages ]; then
            echo -e "   📄 pages/index.js: $([ -f pages/index.js ] && echo "✅" || echo "❌")"
        fi
        
        if [ -d public ]; then
            echo -e "   📄 public/index.html: $([ -f public/index.html ] && echo "✅" || echo "❌")"
        fi
        
    else
        echo -e "   ${RED}❌ Répertoire manquant: $app_dir${NC}"
    fi
    
    echo ""
done

echo ""
echo -e "${BLUE}🔧 RECOMMANDATIONS${NC}"
echo -e "${BLUE}=================${NC}"
echo ""

echo -e "${YELLOW}Basé sur l'analyse, voici les actions recommandées:${NC}"
echo ""
echo -e "1. ${GREEN}Vérifier les logs ci-dessus${NC} pour identifier les erreurs spécifiques"
echo -e "2. ${GREEN}Recréer les applications problématiques${NC} avec une structure propre"
echo -e "3. ${GREEN}Installer les bonnes versions des dépendances${NC}"
echo -e "4. ${GREEN}Vérifier que tous les fichiers essentiels sont présents${NC}"
echo ""

echo -e "${CYAN}Pour recréer une application spécifique:${NC}"
echo -e "  ${YELLOW}./diagnostic_fix_script.sh reset${NC} (pour toutes)"
echo ""
echo -e "${CYAN}Pour installer manuellement une application:${NC}"
echo -e "  ${YELLOW}cd apps/[nom_app] && npm install --legacy-peer-deps${NC}"
echo ""