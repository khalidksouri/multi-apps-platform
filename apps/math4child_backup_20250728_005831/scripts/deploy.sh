#!/bin/bash

echo "🚀 Déploiement en production de Math4Child..."

# Build du frontend
echo "📦 Build du frontend..."
npm run build

# Tests avant déploiement
echo "🧪 Exécution des tests..."
npm test

# Déploiement Vercel (frontend)
echo "🌐 Déploiement frontend vers Vercel..."
vercel --prod

# Déploiement Railway (backend)
echo "🛠️ Déploiement backend vers Railway..."
cd backend
railway up

echo "✅ Déploiement terminé !"
