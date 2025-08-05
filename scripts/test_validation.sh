#!/bin/bash

echo "🧪 Tests de Validation Math4Child"
echo "================================="

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

test_passed() { echo -e "${GREEN}✅ $1${NC}"; }
test_failed() { echo -e "${RED}❌ $1${NC}"; }
test_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }

echo ""
test_info "Début des tests de validation..."

# Test 1: Structure du projet
echo ""
echo "📁 Test 1: Structure du Projet"
if [[ -f "package.json" && -f "next.config.js" && -d "src/app" ]]; then
    test_passed "Structure du projet valide"
else
    test_failed "Structure du projet incomplète"
fi

# Test 2: Build
echo ""
echo "🏗️ Test 2: Build de Production"
if npm run build > build.log 2>&1; then
    test_passed "Build Next.js réussi"
    if [[ -d "out" && -f "out/index.html" ]]; then
        test_passed "Export statique généré"
        BUILD_SIZE=$(du -sh out/ | cut -f1)
        test_info "Taille du build: $BUILD_SIZE"
    else
        test_failed "Export statique non généré"
    fi
else
    test_failed "Build Next.js échoué"
    test_info "Vérifiez build.log pour les détails"
fi

# Test 3: Configuration Stripe
echo ""
echo "💳 Test 3: Configuration Stripe"
if [[ -f "src/lib/stripe.ts" ]]; then
    test_passed "Configuration Stripe présente"
    if grep -q "gotesttech@gmail.com" src/lib/stripe.ts; then
        test_passed "Contact GOTEST configuré"
    fi
else
    test_failed "Configuration Stripe manquante"
fi

# Test 4: API Routes
echo ""
echo "📡 Test 4: API Routes"
if [[ -f "src/app/api/stripe/create-checkout-session/route.ts" ]]; then
    test_passed "API route Stripe présente"
else
    test_failed "API route Stripe manquante"
fi

# Test 5: Pages de paiement
echo ""
echo "📄 Test 5: Pages de Paiement"
if [[ -f "src/app/success/page.tsx" && -f "src/app/cancel/page.tsx" ]]; then
    test_passed "Pages de succès et d'annulation présentes"
else
    test_failed "Pages de paiement manquantes"
fi

# Test 6: Configuration Netlify
echo ""
echo "🌐 Test 6: Configuration Netlify"
if [[ -f "netlify.toml" ]]; then
    test_passed "Configuration Netlify présente"
    if grep -q "publish.*out" netlify.toml; then
        test_passed "Configuration publish correcte"
    fi
else
    test_failed "Configuration Netlify manquante"
fi

# Test 7: Contenu Math4Child
echo ""
echo "🧮 Test 7: Contenu Math4Child"
if [[ -f "src/app/page.tsx" ]]; then
    if grep -q "Math4Child\|GOTEST\|195.*langues" src/app/page.tsx; then
        test_passed "Contenu Math4Child détecté"
    else
        test_failed "Contenu Math4Child manquant"
    fi
else
    test_failed "Page principale manquante"
fi

echo ""
test_info "Tests de validation terminés"
echo ""

# Nettoyer
rm -f build.log 2>/dev/null
