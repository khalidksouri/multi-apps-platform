#!/bin/bash
set -e

echo "🧪 Test Navigation Math4Child"
echo "============================="

if ! curl -s http://localhost:3000 > /dev/null; then
    echo "❌ Serveur non démarré. Lancez 'npm run dev' d'abord."
    exit 1
fi

echo "✅ Serveur détecté"
npx playwright test tests/navigation.spec.ts --project=chromium
echo "🎉 Tests terminés !"
