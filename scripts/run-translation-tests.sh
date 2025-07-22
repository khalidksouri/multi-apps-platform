#!/bin/bash

echo "🌍 Lancement des tests de traduction Math4Child"
echo "================================================="

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

rm -rf playwright-report-translation test-results/translation-*

echo "🧪 Exécution des tests de traduction..."
npx playwright test --config=playwright.config.translation.ts --reporter=line

echo "📊 Génération du rapport..."
npx playwright test --config=playwright.config.translation.ts --reporter=html

echo ""
echo "📈 Tests de traduction terminés!"
echo "📂 Rapport: playwright-report-translation/index.html"
