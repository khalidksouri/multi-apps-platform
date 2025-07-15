#!/bin/bash

echo "🎯 Test complet de toutes les applications"

# Vérifier que les applications tournent
echo "🔍 Vérification des applications..."
APPS=("3001:Postmath" "3002:UnitFlip" "3003:BudgetCron" "3004:AI4Kids" "3005:MultiAI")

for app in "${APPS[@]}"; do
    PORT=$(echo $app | cut -d: -f1)
    NAME=$(echo $app | cut -d: -f2)
    
    if curl -s "http://localhost:$PORT/health" > /dev/null 2>&1; then
        echo "  ✅ $NAME (port $PORT): Disponible"
    else
        echo "  ❌ $NAME (port $PORT): Non disponible"
        echo "     Démarrez avec: npm run dev"
        exit 1
    fi
done

echo ""
echo "🥒 Lancement des tests Cucumber BDD..."

# Tests par ordre de priorité
echo "📋 1. Tests de smoke (critique)"
npm run test:bdd:smoke

echo ""
echo "📋 2. Test complet de toutes les applications"
TS_NODE_PROJECT=tsconfig.cucumber.json npx cucumber-js tests/features/all-apps-smoke.feature --require "tests/steps/**/*.ts" --require "tests/support/**/*.ts" --require-module ts-node/register --format progress-bar

echo ""
echo "🎉 Tests terminés avec succès !"
echo "📊 Consultez les captures d'écran dans test-results/screenshots/"
echo "📋 Rapports disponibles dans reports/"
