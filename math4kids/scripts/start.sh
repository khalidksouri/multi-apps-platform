#!/bin/bash
echo "🚀 Démarrage de Math4Kids..."

if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install --legacy-peer-deps
fi

echo "🌐 Ouverture sur http://localhost:3001"
npm run dev
