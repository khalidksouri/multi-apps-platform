#!/bin/bash

echo "🥒 Démarrage des tests BDD Cucumber"

# Vérifier que ts-node est installé
if ! npm list ts-node > /dev/null 2>&1; then
    echo "Installation de ts-node..."
    npm install --save-dev ts-node
fi

# Créer les dossiers nécessaires
mkdir -p reports test-results/{screenshots,videos,traces}

# Exporter la configuration TypeScript
export TS_NODE_PROJECT=tsconfig.cucumber.json

# Lancer les tests
echo "Lancement des tests smoke..."
npx cucumber-js --config cucumber.config.js --profile smoke

echo "✅ Tests BDD terminés"
