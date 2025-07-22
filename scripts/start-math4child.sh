#!/bin/bash
echo "🚀 Démarrage Math4Child..."

# Vérifier si le dossier existe
if [ ! -d "apps/math4child" ]; then
    echo "❌ Erreur: apps/math4child non trouvé"
    exit 1
fi

cd apps/math4child

# Vérifier si package.json existe
if [ ! -f "package.json" ]; then
    echo "❌ Erreur: package.json non trouvé dans apps/math4child"
    exit 1
fi

# Installer les dépendances si nécessaire
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm install
fi

echo "🌐 Démarrage du serveur de développement..."
npm run dev
