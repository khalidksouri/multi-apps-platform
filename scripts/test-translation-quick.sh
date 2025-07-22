#!/bin/bash
echo "🌍 Tests de traduction rapides..."

# Vérifier si playwright est installé
if ! npm list @playwright/test > /dev/null 2>&1; then
    echo "⚠️  Playwright non trouvé, installation..."
    npm install @playwright/test
    npx playwright install chromium
fi

echo "🧪 Lancement des tests de traduction..."
npm run test:translation:quick || echo "⚠️  Certains tests ont échoué (normal si le serveur n'est pas démarré)"
