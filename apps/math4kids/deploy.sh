#!/bin/bash
echo "📦 Math4Kids Enhanced - Déploiement"

# Build de production
echo "🏗️ Build de production..."
npm run build:prod

# Synchronisation Capacitor
echo "📱 Synchronisation mobile..."
npm run cap:sync

echo "✅ Déploiement terminé !"
echo ""
echo "📱 Plateformes disponibles :"
echo "• Web: npm run preview"
echo "• iOS: npm run build:ios"
echo "• Android: npm run build:android"
