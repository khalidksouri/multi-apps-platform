#!/bin/bash
echo "🚀 Math4Kids Enhanced - Développement"
echo "🌐 URL: http://localhost:3001"
echo ""

# Ouvrir VSCode si disponible
if command -v code >/dev/null 2>&1; then
    echo "💻 Ouverture de VSCode..."
    code .
fi

# Démarrer le serveur
npm run dev
