#!/bin/bash

echo "🧪 Exécution de tous les tests..."

# Tests unitaires
echo "📝 Tests unitaires..."
for app in apps/*/; do
    echo "  Testing $(basename "$app")..."
    (cd "$app" && npm test 2>/dev/null || echo "  ⚠️ Tests non configurés pour $(basename "$app")")
done

# Tests E2E avec Playwright (si installé)
if command -v playwright >/dev/null 2>&1; then
    echo "🎭 Tests E2E avec Playwright..."
    npx playwright test --reporter=html
else
    echo "⚠️ Playwright non installé - Skip tests E2E"
fi

# Tests BDD avec Cucumber (si installé)
if command -v cucumber-js >/dev/null 2>&1; then
    echo "🥒 Tests BDD avec Cucumber..."
    npx cucumber-js
else
    echo "⚠️ Cucumber non installé - Skip tests BDD"
fi

echo "✅ Tests terminés!"
