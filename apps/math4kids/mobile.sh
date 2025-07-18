#!/bin/bash
echo "📱 Math4Kids Enhanced - Configuration Mobile"
echo ""
echo "Choisissez une plateforme :"
echo "1. iOS"
echo "2. Android" 
echo "3. Les deux"
read -p "Votre choix (1-3): " choice

case $choice in
    1)
        echo "🍎 Configuration iOS..."
        npm run cap:add:ios
        npm run build:ios
        ;;
    2)
        echo "🤖 Configuration Android..."
        npm run cap:add:android
        npm run build:android
        ;;
    3)
        echo "📱 Configuration complète..."
        npm run cap:add:ios
        npm run cap:add:android
        npm run build:mobile
        echo "✅ Plateformes ajoutées !"
        ;;
    *)
        echo "Option invalide"
        ;;
esac
