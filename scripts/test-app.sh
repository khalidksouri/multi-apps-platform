#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./scripts/test-app.sh [postmath|unitflip|budgetcron|ai4kids|multiai]"
    echo ""
    echo "Applications disponibles:"
    echo "  🧮 postmath   - Calculatrice (port 3001)"
    echo "  🔄 unitflip   - Convertisseur (port 3002)"
    echo "  💰 budgetcron - Budget (port 3003)"
    echo "  🎨 ai4kids    - Éducatif (port 3004)"
    echo "  🤖 multiai    - Recherche (port 3005)"
    exit 1
fi

app=$1
port_map=( ["postmath"]=3001 ["unitflip"]=3002 ["budgetcron"]=3003 ["ai4kids"]=3004 ["multiai"]=3005 )

if [ -d "apps/$app" ]; then
    echo "🚀 Démarrage de l'application $app..."
    cd "apps/$app"
    PORT=${port_map[$app]} npm run dev
else
    echo "❌ Application $app non trouvée"
fi
