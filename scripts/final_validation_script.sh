#!/bin/bash

# =============================================
# ✅ Script de validation finale
# =============================================

echo "✅ Validation finale du workspace MultiApps"
echo "==========================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 [1/4] Vérification des applications${NC}"
echo "========================================"

# Configuration des applications
declare -A apps=(
    ["postmath"]="3001"
    ["unitflip"]="3002"
    ["budgetcron"]="3003"
    ["ai4kids"]="3004"
    ["multiai"]="3005"
)

echo "🚀 Démarrage de toutes les applications..."

# Démarrer toutes les applications en parallèle
for app_name in "${!apps[@]}"; do
    port=${apps[$app_name]}
    echo "🔄 Démarrage de $app_name sur le port $port..."
    
    cd "apps/$app_name"
    npm run dev > "/tmp/${app_name}_final.log" 2>&1 &
    echo $! > "/tmp/${app_name}_final.pid"
    cd - > /dev/null
done

echo "⏳ Attente du démarrage de toutes les applications..."
sleep 15

# Vérifier le statut
echo ""
echo "📊 Statut des applications :"
echo "============================"
ready_count=0

for app_name in "${!apps[@]}"; do
    port=${apps[$app_name]}
    
    if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $app_name: Prêt (http://localhost:$port)${NC}"
        ready_count=$((ready_count + 1))
    else
        echo -e "${RED}❌ $app_name: Non prêt${NC}"
        # Afficher les dernières lignes du log
        echo "   📋 Dernières lignes du log:"
        tail -3 "/tmp/${app_name}_final.log" 2>/dev/null | sed 's/^/   /'
    fi
done

echo ""
echo "🎯 Applications prêtes: $ready_count/5"

if [ $ready_count -eq 5 ]; then
    echo -e "${GREEN}🎉 Toutes les applications sont prêtes !${NC}"
else
    echo -e "${YELLOW}⚠️ Certaines applications ne sont pas prêtes${NC}"
fi

echo ""
echo -e "${BLUE}🔄 [2/4] Tests des endpoints${NC}"
echo "==============================="

# Tester tous les endpoints
for app_name in "${!apps[@]}"; do
    port=${apps[$app_name]}
    echo "🧪 Test de $app_name..."
    
    # Test health
    health_response=$(curl -s "http://localhost:$port/api/health")
    if echo "$health_response" | grep -q "healthy"; then
        echo -e "   ${GREEN}✅ Health check: OK${NC}"
    else
        echo -e "   ${RED}❌ Health check: Échec${NC}"
    fi
    
    # Test page d'accueil
    if curl -f -s "http://localhost:$port" > /dev/null 2>&1; then
        echo -e "   ${GREEN}✅ Page d'accueil: Accessible${NC}"
    else
        echo -e "   ${RED}❌ Page d'accueil: Non accessible${NC}"
    fi
done

echo ""
echo -e "${BLUE}🔄 [3/4] Exécution des tests Playwright${NC}"
echo "========================================="

echo "🧪 Lancement des tests de validation..."
if npm run test > /tmp/final_test_results.log 2>&1; then
    echo -e "${GREEN}✅ Tests Playwright: Tous réussis${NC}"
    
    # Afficher un résumé des résultats
    echo ""
    echo "📊 Résumé des tests :"
    grep -E "(passed|failed|skipped)" /tmp/final_test_results.log | tail -1
    
else
    echo -e "${YELLOW}⚠️ Tests Playwright: Certains échecs${NC}"
    
    # Afficher les échecs
    echo ""
    echo "📋 Résultats des tests :"
    grep -E "(failed|passed)" /tmp/final_test_results.log | tail -5
fi

echo ""
echo -e "${BLUE}🔄 [4/4] Génération du rapport final${NC}"
echo "====================================="

# Créer un rapport final
cat > final_validation_report.md << EOF
# 📊 Rapport de Validation Finale - MultiApps Platform

**Date**: $(date)
**Environnement**: Développement local

## 🏗️ Applications

| Application | Port | Statut | Health Check | Page d'accueil |
|-------------|------|--------|--------------|----------------|
EOF

# Ajouter les résultats au rapport
for app_name in "${!apps[@]}"; do
    port=${apps[$app_name]}
    
    # Vérifier le statut
    if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
        health_status="✅ OK"
    else
        health_status="❌ Échec"
    fi
    
    if curl -f -s "http://localhost:$port" > /dev/null 2>&1; then
        page_status="✅ OK"
    else
        page_status="❌ Échec"
    fi
    
    # Ajouter la ligne au rapport
    echo "| $app_name | $port | ✅ Actif | $health_status | $page_status |" >> final_validation_report.md
done

# Ajouter les résultats des tests
cat >> final_validation_report.md << EOF

## 🧪 Tests Playwright

\`\`\`
$(cat /tmp/final_test_results.log | tail -20)
\`\`\`

## 🌐 URLs des applications

- **PostMath**: http://localhost:3001
- **UnitFlip**: http://localhost:3002
- **BudgetCron**: http://localhost:3003
- **AI4Kids**: http://localhost:3004
- **MultiAI**: http://localhost:3005

## 📋 Commandes utiles

\`\`\`bash
# Voir les rapports de test
npm run test:report

# Tests avec interface graphique
npm run test:ui

# Arrêter toutes les applications
./stop_apps.sh

# Redémarrer toutes les applications
./start_apps_fixed.sh
\`\`\`

## 🎯 Résumé

**Applications prêtes**: $ready_count/5
**Tests**: $(grep -o "passed\|failed" /tmp/final_test_results.log | wc -l | tr -d ' ') exécutés
**Statut global**: $([ $ready_count -eq 5 ] && echo "✅ SUCCÈS" || echo "⚠️ PARTIELLEMENT PRÊT")

---
*Généré automatiquement par le script de validation finale*
EOF

echo -e "${GREEN}✅ Rapport généré: final_validation_report.md${NC}"

# Afficher les URLs finales
echo ""
echo -e "${GREEN}🌐 URLs DES APPLICATIONS${NC}"
echo "========================"
for app_name in "${!apps[@]}"; do
    port=${apps[$app_name]}
    echo "🔗 $app_name: http://localhost:$port"
done

echo ""
echo -e "${GREEN}📊 COMMANDES UTILES${NC}"
echo "==================="
echo "📄 Voir le rapport: cat final_validation_report.md"
echo "🎭 Tests avec UI: npm run test:ui"
echo "📈 Rapport de tests: npm run test:report"
echo "🛑 Arrêter les apps: ./stop_apps.sh"
echo "🚀 Redémarrer: ./start_apps_fixed.sh"

echo ""
echo -e "${GREEN}🎉 VALIDATION TERMINÉE !${NC}"
echo "========================"

if [ $ready_count -eq 5 ]; then
    echo -e "${GREEN}✅ Toutes les applications sont opérationnelles !${NC}"
    echo -e "${GREEN}🚀 Votre workspace MultiApps est prêt pour le développement !${NC}"
else
    echo -e "${YELLOW}⚠️ Certaines applications nécessitent une attention${NC}"
    echo -e "${YELLOW}🔍 Consultez les logs dans /tmp/*_final.log${NC}"
fi

echo ""
echo "📁 Fichiers générés :"
echo "- final_validation_report.md"
echo "- /tmp/final_test_results.log"
echo "- /tmp/*_final.log (logs des applications)"
