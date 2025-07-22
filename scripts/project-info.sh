#!/bin/bash
echo "📊 Informations Multi-Apps Platform"
echo "═══════════════════════════════════════════════════════════════"

echo "📁 Structure des applications:"
if [ -d "apps/math4child" ]; then
    echo "  ✅ Math4Child (apps/math4child) - Port 3000"
else
    echo "  ❌ Math4Child non trouvé"
fi

for app in unitflip budgetcron ai4kids multiai; do
    if [ -d "src/mobile/apps/$app" ]; then
        echo "  ✅ ${app^} (src/mobile/apps/$app)"
    else
        echo "  ❌ ${app^} non trouvé"
    fi
done

echo ""
echo "🛠️  Commandes disponibles:"
echo "  npm run test:translation:quick    # Tests traduction rapides"
echo "  npm run test:math4child:quick     # Tests Math4Child"
echo "  npm run apps:math4child           # Lancer Math4Child"
echo "  ./scripts/start-math4child.sh     # Script démarrage"
echo ""

echo "📦 Package.json: $([ -f "package.json" ] && echo "✅ Présent" || echo "❌ Absent")"
echo "🧪 Playwright: $([ -f "playwright.config.ts" ] && echo "✅ Configuré" || echo "❌ Non configuré")"
