#!/bin/bash

echo "🚀 Démarrage de toutes les applications..."

# Vérifier que concurrently est installé
if ! command -v concurrently &> /dev/null; then
    echo "❌ concurrently n'est pas installé. Installation en cours..."
    npm install -g concurrently
fi

# Démarrer les apps en parallèle
concurrently \
  --prefix "[{name}]" \
  --names "ai4kids,budgetcron,postmath,unitflip,multiai" \
  --prefix-colors "cyan,magenta,yellow,green,blue" \
  "cd apps/ai4kids && npm run dev" \
  "cd apps/budgetcron && npm run dev" \
  "cd apps/postmath && npm run dev" \
  "cd apps/unitflip && npm run dev" \
  "cd apps/multiai && npm run dev"