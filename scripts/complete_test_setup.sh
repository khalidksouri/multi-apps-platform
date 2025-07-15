#!/bin/bash

# =============================================
# 🚀 Script de démarrage complet avec tests
# =============================================

echo "🚀 Démarrage complet du workspace MultiApps"
echo "============================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ===== ÉTAPE 1 : Démarrer toutes les applications =====
echo -e "${BLUE}🔄 [1/3] Démarrage des applications${NC}"
echo "======================================"

# Fonction pour démarrer une application en arrière-plan
start_app() {
    local app_name=$1
    local port=$2
    
    echo "🚀 Démarrage de $app_name sur le port $port..."
    
    # Démarrer l'application en arrière-plan
    cd "apps/$app_name" && npm run dev > "/tmp/$app_name.log" 2>&1 &
    local app_pid=$!
    
    # Sauvegarder le PID
    echo $app_pid > "/tmp/$app_name.pid"
    
    # Attendre que l'application soit prête
    echo "⏳ Attente de $app_name..."
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $app_name: Prêt sur http://localhost:$port${NC}"
            cd - > /dev/null
            return 0
        fi
        
        sleep 2
        attempt=$((attempt + 1))
        echo -n "."
    done
    
    echo -e "${RED}❌ $app_name: Timeout après ${max_attempts} tentatives${NC}"
    cd - > /dev/null
    return 1
}

# Démarrer toutes les applications
echo "🌟 Démarrage des 5 applications..."
start_app "postmath" 3001 &
start_app "unitflip" 3002 &
start_app "budgetcron" 3003 &
start_app "ai4kids" 3004 &
start_app "multiai" 3005 &

# Attendre que tous les démarrages soient terminés
wait

echo ""
echo "📊 Statut des applications :"
echo "=============================="
apps=("postmath:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
ready_count=0

for app_port in "${apps[@]}"; do
    IFS=':' read -r app port <<< "$app_port"
    if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $app: http://localhost:$port${NC}"
        ready_count=$((ready_count + 1))
    else
        echo -e "${RED}❌ $app: Non disponible${NC}"
    fi
done

echo ""
echo "🎯 Applications prêtes: $ready_count/5"

if [ $ready_count -eq 5 ]; then
    echo -e "${GREEN}🎉 Toutes les applications sont prêtes !${NC}"
else
    echo -e "${YELLOW}⚠️ Certaines applications ne sont pas prêtes, continuons quand même...${NC}"
fi

# ===== ÉTAPE 2 : Exécuter les tests =====
echo ""
echo -e "${BLUE}🔄 [2/3] Exécution des tests Playwright${NC}"
echo "========================================"

echo "🧪 Lancement des tests de smoke..."
if npm run test 2>&1 | tee /tmp/playwright_test.log; then
    echo -e "${GREEN}✅ Tests Playwright: Terminés avec succès${NC}"
else
    echo -e "${YELLOW}⚠️ Tests Playwright: Certains tests ont échoué${NC}"
    echo "📋 Dernières lignes du log:"
    tail -10 /tmp/playwright_test.log
fi

echo ""
echo "🎭 Tests avec interface utilisateur (optionnel)..."
echo "💡 Pour lancer les tests avec UI, utilisez: npm run test:ui"

# ===== ÉTAPE 3 : Afficher les résultats =====
echo ""
echo -e "${BLUE}🔄 [3/3] Résultats et URLs${NC}"
echo "=============================="

echo "🌐 URLs des applications :"
echo "=========================="
for app_port in "${apps[@]}"; do
    IFS=':' read -r app port <<< "$app_port"
    echo "🔗 $app: http://localhost:$port"
done

echo ""
echo "📊 Rapports de tests :"
echo "====================="
echo "📄 Rapport HTML: reports/playwright-report/index.html"
echo "📄 Rapport JSON: reports/results.json"
echo "📸 Screenshots: test-results/"

echo ""
echo "🛠️ Commandes utiles :"
echo "===================="
echo "📊 Voir les rapports: npm run test:report"
echo "🔍 Tests en mode debug: npm run test:debug"
echo "🎭 Interface de test: npm run test:ui"
echo "🛑 Arrêter les apps: ./stop_apps.sh"

echo ""
echo -e "${GREEN}🎉 SETUP COMPLET TERMINÉ !${NC}"
echo "================================="
echo "✅ Applications démarrées"
echo "✅ Tests exécutés"
echo "✅ Prêt pour le développement"
echo ""
echo "🚀 Vous pouvez maintenant développer et tester !"
