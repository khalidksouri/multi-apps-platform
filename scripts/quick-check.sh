#!/bin/bash

echo "🔍 Vérification rapide Multi-Apps Platform"
echo "═══════════════════════════════════════════════════════════════"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

check_item() {
    if [ "$2" = "true" ]; then
        echo -e "✅ $1"
    else
        echo -e "⚠️  $1"
    fi
}

echo ""
echo "📁 Structure des dossiers:"
check_item "apps/math4child" "$([ -d "apps/math4child" ] && echo "true" || echo "false")"
check_item "apps/math4child/package.json" "$([ -f "apps/math4child/package.json" ] && echo "true" || echo "false")"
check_item "src/mobile/apps/" "$([ -d "src/mobile/apps" ] && echo "true" || echo "false")"
check_item "tests/" "$([ -d "tests" ] && echo "true" || echo "false")"
check_item "scripts/" "$([ -d "scripts" ] && echo "true" || echo "false")"

echo ""
echo "🛠️  Configuration:"
check_item "package.json" "$([ -f "package.json" ] && echo "true" || echo "false")"
check_item "tsconfig.json" "$([ -f "tsconfig.json" ] && echo "true" || echo "false")"
check_item "playwright.config.ts" "$([ -f "playwright.config.ts" ] && echo "true" || echo "false")"

echo ""
echo "📦 Dépendances:"
if command -v npm >/dev/null 2>&1; then
    if [ -d "node_modules" ]; then
        echo "✅ node_modules installé"
        
        # Vérifier quelques packages clés
        if [ -d "node_modules/@playwright" ]; then
            echo "✅ Playwright installé"
        else
            echo "⚠️  Playwright à installer"
        fi
        
        if [ -d "node_modules/next" ]; then
            echo "✅ Next.js installé"
        else
            echo "⚠️  Next.js à installer"
        fi
    else
        echo "⚠️  node_modules manquant - Lancez: npm install"
    fi
else
    echo "❌ npm non trouvé"
fi

echo ""
echo "🧪 Tests disponibles:"
if grep -q "test:translation:quick" package.json 2>/dev/null; then
    echo "✅ npm run test:translation:quick"
else
    echo "⚠️  Script test:translation:quick manquant"
fi

if grep -q "test:math4child:quick" package.json 2>/dev/null; then
    echo "✅ npm run test:math4child:quick"
else
    echo "⚠️  Script test:math4child:quick manquant"
fi

echo ""
echo "🚀 Scripts disponibles:"
ls -la scripts/*.sh 2>/dev/null | while read -r line; do
    script=$(echo "$line" | awk '{print $NF}' | xargs basename)
    echo "  • $script"
done

echo ""
echo "💡 Commandes recommandées:"
echo "  npm run test:translation:quick    # Votre script recherché"
echo "  ./scripts/start-math4child.sh     # Lancer Math4Child"
echo "  npm run dev                       # Serveur de développement"
echo ""
