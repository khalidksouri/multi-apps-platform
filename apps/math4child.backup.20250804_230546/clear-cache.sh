#!/bin/bash

echo "🔄 NETTOYAGE CACHE MATH4CHILD"
echo "=============================="

# Arrêter tous les processus Next.js
pkill -f "next dev" 2>/dev/null || true
pkill -f "node.*dev" 2>/dev/null || true

# Nettoyer tous les caches
rm -rf .next
rm -rf node_modules/.cache
rm -rf out
rm -rf dist
rm -rf .swc

# Libérer les ports 3000-3010
for port in {3000..3010}; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        kill -9 $(lsof -Pi :$port -sTCP:LISTEN -t) 2>/dev/null || true
    fi
done

# Choisir un port aléatoire
NEW_PORT=$(shuf -i 3000-3010 -n 1)

echo ""
echo "✅ Cache nettoyé avec succès"
echo "🚀 Démarrage sur port $NEW_PORT..."
echo "🌐 Ouvrir: http://localhost:$NEW_PORT"
echo ""

# Redémarrer
npm run dev -- -p $NEW_PORT
