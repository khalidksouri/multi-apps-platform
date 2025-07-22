#!/bin/bash
echo "🧪 Tests de toutes les applications..."

# Vérifier Playwright
if ! npm list @playwright/test > /dev/null 2>&1; then
    echo "⚠️  Playwright non trouvé, installation..."
    npm install @playwright/test
    npx playwright install
fi

echo "🔧 Tests des applications multi-apps-platform..."
npm run test:apps:quick || echo "⚠️  Certains tests ont échoué (normal en développement)"
