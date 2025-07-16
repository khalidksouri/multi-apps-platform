#!/bin/bash
echo "📱 Préparation pour mobile..."
npm run build
npx cap sync
echo "Choisissez votre plateforme:"
echo "1. Android"
echo "2. iOS"
read -p "Votre choix (1 ou 2): " choice
case $choice in
    1) npx cap open android ;;
    2) npx cap open ios ;;
    *) echo "Choix invalide" ;;
esac
