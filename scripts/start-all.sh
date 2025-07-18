#!/bin/bash

echo "🚀 Démarrage de toutes les applications..."

# Vérifier que toutes les dépendances sont installées
for app in apps/*/; do
    if [ ! -d "$app/node_modules" ]; then
        echo "📦 Installation des dépendances pour $(basename "$app")..."
        (cd "$app" && npm install --legacy-peer-deps --silent)
    fi
done

# Démarrer toutes les applications en parallèle
if command -v concurrently >/dev/null 2>&1; then
    concurrently \
        "cd apps/math4kids && npm start" \
        "cd apps/unitflip && npm start" \
        "cd apps/budgetcron && npm run serve" \
        "cd apps/ai4kids && npm start" \
        "cd apps/multiai && npm run dev" \
        "cd apps/digital4kids && npm start" \
        --names "math4kids,unitflip,budgetcron,ai4kids,multiai,digital4kids" \
        --prefix-colors "red,green,yellow,blue,magenta,cyan"
else
    echo "⚠️ Concurrently n'est pas installé. Installez-le avec: npm install -g concurrently"
    echo "Démarrage séquentiel..."
    
    # Démarrage en arrière-plan
    (cd apps/math4kids && npm start &)
    (cd apps/unitflip && npm start &)
    (cd apps/budgetcron && npm run serve &)
    (cd apps/ai4kids && npm start &)
    (cd apps/multiai && npm run dev &)
    (cd apps/digital4kids && npm start &)
    
    echo "✅ Toutes les applications sont en cours de démarrage..."
    echo "🌐 Visitez:"
    echo "   http://localhost:3001 - Math4Kids"
    echo "   http://localhost:3002 - UnitFlip"
    echo "   http://localhost:3003 - BudgetCron"
    echo "   http://localhost:3004 - AI4Kids"
    echo "   http://localhost:3005 - MultiAI"
    echo "   http://localhost:3006 - Digital4Kids"
fi
