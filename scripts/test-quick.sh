#!/bin/bash

echo "🧪 Tests rapides Math4Child"
echo "=========================="

# Tests de fumée
echo "🔥 Tests de fumée..."
npx playwright test --project=smoke || echo "⚠️ Certains tests de fumée ont échoué"

# Tests de base
echo "📝 Tests de base..."
npx playwright test tests/specs/smoke.spec.ts || echo "⚠️ Tests de base partiellement échoués"

echo "✅ Tests rapides terminés"
echo "📊 Voir le rapport: make report"
