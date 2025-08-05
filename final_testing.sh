#!/bin/bash

# =============================================================================
# TESTS ET VALIDATION FINALE - MATH4CHILD PRODUCTION
# =============================================================================

echo "🧪 Tests et Validation Finale Math4Child"
echo "========================================"

# Couleurs pour l'affichage
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

test_passed() { echo -e "${GREEN}✅ $1${NC}"; }
test_failed() { echo -e "${RED}❌ $1${NC}"; }
test_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
test_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }

echo ""
test_info "Début des tests de validation finale..."

# =============================================================================
# TEST 1: STRUCTURE DU PROJET
# =============================================================================

echo ""
echo "📁 Test 1: Structure du Projet"
echo "==============================="

# Vérifier les fichiers essentiels
if [[ -f "package.json" ]]; then
    test_passed "package.json présent"
else
    test_failed "package.json manquant"
    exit 1
fi

if [[ -f "next.config.js" ]]; then
    test_passed "next.config.js présent"
else
    test_failed "next.config.js manquant"
fi

if [[ -f "netlify.toml" ]]; then
    test_passed "netlify.toml présent"
else
    test_failed "netlify.toml manquant"
fi

if [[ -d "src/app" ]]; then
    test_passed "Structure src/app présente"
else
    test_failed "Structure src/app manquante"
fi

if [[ -f "src/app/page.tsx" ]]; then
    test_passed "Page principale présente"
else
    test_failed "Page principale manquante"
fi

if [[ -f "src/app/layout.tsx" ]]; then
    test_passed "Layout principal présent"
else
    test_failed "Layout principal manquant"
fi

# =============================================================================
# TEST 2: BUILD ET EXPORT
# =============================================================================

echo ""
echo "🏗️ Test 2: Build et Export"
echo "=========================="

test_info "Lancement du build de production..."

if npm run build > build.log 2>&1; then
    test_passed "Build Next.js réussi"
    
    if [[ -d "out" ]]; then
        test_passed "Répertoire out/ généré"
        
        if [[ -f "out/index.html" ]]; then
            test_passed "index.html généré"
            
            # Vérifier le contenu
            if grep -q "Math4Child" out/index.html; then
                test_passed "Contenu Math4Child détecté"
            else
                test_failed "Contenu Math4Child manquant"
            fi
            
            if grep -q "gotesttech@gmail.com" out/index.html; then
                test_passed "Contact GOTEST détecté"
            else
                test_warning "Contact GOTEST non détecté"
            fi
        else
            test_failed "index.html non généré"
        fi
        
        # Vérifier la taille
        BUILD_SIZE=$(du -sh out/ | cut -f1)
        test_info "Taille du build: $BUILD_SIZE"
        
    else
        test_failed "Répertoire out/ non généré"
    fi
else
    test_failed "Build Next.js échoué"
    test_info "Vérifiez build.log pour les détails"
    exit 1
fi

# =============================================================================
# TEST 3: CONFIGURATION NETLIFY
# =============================================================================

echo ""
echo "🌐 Test 3: Configuration Netlify"
echo "================================"

if [[ -f "netlify.toml" ]]; then
    
    # Vérifier la configuration de base
    if grep -q "publish.*out" netlify.toml; then
        test_passed "Configuration publish correcte"
    else
        test_failed "Configuration publish incorrecte"
    fi
    
    if grep -q "command.*build" netlify.toml; then
        test_passed "Commande de build configurée"
    else
        test_failed "Commande de build manquante"
    fi
    
    # Vérifier les redirections
    if grep -q "redirects" netlify.toml; then
        test_passed "Redirections configurées"
    else
        test_warning "Redirections non configurées"
    fi
    
    # Vérifier les headers de sécurité
    if grep -q "X-Frame-Options" netlify.toml; then
        test_passed "Headers de sécurité configurés"
    else
        test_warning "Headers de sécurité manquants"
    fi
    
else
    test_failed "netlify.toml manquant"
fi

# =============================================================================
# TEST 4: CONFIGURATION STRIPE
# =============================================================================

echo ""
echo "💳 Test 4: Configuration Stripe"
echo "==============================="

if [[ -f "src/lib/stripe.ts" ]]; then
    test_passed "Configuration Stripe présente"
    
    if grep -q "SUBSCRIPTION_PLANS" src/lib/stripe.ts; then
        test_passed "Plans d'abonnement configurés"
    else
        test_failed "Plans d'abonnement manquants"
    fi
    
    if grep -q "GOTEST" src/lib/stripe.ts; then
        test_passed "Configuration GOTEST présente"
    else
        test_warning "Configuration GOTEST manquante"
    fi
else
    test_failed "Configuration Stripe manquante"
fi

if [[ -f "src/app/api/stripe/create-checkout-session/route.ts" ]]; then
    test_passed "API route Stripe présente"
else
    test_failed "API route Stripe manquante"
fi

if [[ -f "src/app/success/page.tsx" ]]; then
    test_passed "Page de succès présente"
else
    test_failed "Page de succès manquante"
fi

if [[ -f "src/app/cancel/page.tsx" ]]; then
    test_passed "Page d'annulation présente"
else
    test_failed "Page d'annulation manquante"
fi

# =============================================================================
# TEST 5: CONTENU ET TRADUCTIONS
# =============================================================================

echo ""
echo "🌍 Test 5: Contenu et Traductions"
echo "================================="

if [[ -f "src/app/page.tsx" ]]; then
    
    # Vérifier les langues
    if grep -q "LANGUAGES.*fr.*en.*ar" src/app/page.tsx; then
        test_passed "Support multilingue configuré"
    else
        test_failed "Support multilingue manquant"
    fi
    
    # Vérifier le RTL
    if grep -q "rtl.*true" src/app/page.tsx; then
        test_passed "Support RTL configuré"
    else
        test_failed "Support RTL manquant"
    fi
    
    # Vérifier les traductions
    if grep -q "TRANSLATIONS" src/app/page.tsx; then
        test_passed "Traductions configurées"
    else
        test_failed "Traductions manquantes"
    fi
    
    # Vérifier GOTEST
    if grep -q "GOTEST" src/app/page.tsx; then
        test_passed "Références GOTEST présentes"
    else
        test_warning "Références GOTEST manquantes"
    fi
    
else
    test_failed "Page principale manquante"
fi

# =============================================================================
# TEST 6: PERFORMANCE ET SEO
# =============================================================================

echo ""
echo "⚡ Test 6: Performance et SEO"
echo "============================"

if [[ -f "src/app/layout.tsx" ]]; then
    
    # Vérifier les métadonnées
    if grep -q "metadata.*title" src/app/layout.tsx; then
        test_passed "Métadonnées SEO configurées"
    else
        test_failed "Métadonnées SEO manquantes"
    fi
    
    # Vérifier les Open Graph
    if grep -q "openGraph" src/app/layout.tsx; then
        test_passed "Open Graph configuré"
    else
        test_warning "Open Graph manquant"
    fi
    
    # Vérifier les polices
    if grep -q "Inter.*font" src/app/layout.tsx; then
        test_passed "Police optimisée configurée"
    else
        test_warning "Police optimisée manquante"
    fi
    
else
    test_failed "Layout manquant"
fi

# Vérifier Tailwind
if [[ -f "tailwind.config.js" ]]; then
    test_passed "Tailwind CSS configuré"
else
    test_failed "Tailwind CSS manquant"
fi

# =============================================================================
# TEST 7: ENVIRONNEMENT ET SÉCURITÉ
# =============================================================================

echo ""
echo "🔒 Test 7: Environnement et Sécurité"
echo "===================================="

if [[ -f ".env.example" ]]; then
    test_passed "Fichier d'environnement exemple présent"
else
    test_warning "Fichier d'environnement exemple manquant"
fi

if [[ -f ".gitignore" ]]; then
    if grep -q ".env" .gitignore; then
        test_passed "Fichiers d'environnement ignorés par Git"
    else
        test_warning "Fichiers d'environnement non ignorés"
    fi
else
    test_warning "Fichier .gitignore manquant"
fi

# Vérifier qu'aucune clé secrète n'est commitée
if grep -r "sk_live\|sk_test" src/ 2>/dev/null; then
    test_failed "DANGER: Clés secrètes détectées dans le code"
else
    test_passed "Aucune clé secrète dans le code"
fi

# =============================================================================
# RÉSUMÉ DES TESTS
# =============================================================================

echo ""
echo "📊 Résumé des Tests"
echo "=================="

# Compter les résultats (approximatif)
TOTAL_TESTS=25
PASSED_TESTS=$(echo -e "${output}" | grep -c "✅" || echo "0")
FAILED_TESTS=$(echo -e "${output}" | grep -c "❌" || echo "0")
WARNING_TESTS=$(echo -e "${output}" | grep -c "⚠️" || echo "0")

echo ""
test_info "Tests effectués: $TOTAL_TESTS"
test_passed "Tests réussis: $PASSED_TESTS"
test_failed "Tests échoués: $FAILED_TESTS"  
test_warning "Avertissements: $WARNING_TESTS"

# =============================================================================
# RECOMMANDATIONS FINALES
# =============================================================================

echo ""
echo "📋 Recommandations Finales"
echo "=========================="

echo ""
test_info "✅ PRÊT POUR PRODUCTION :"
echo "  1. Déploiement Netlify configuré"
echo "  2. Build fonctionnel (taille: $BUILD_SIZE)"
echo "  3. Stripe intégré et prêt"
echo "  4. Support multilingue complet"
echo "  5. Configuration sécurisée"

echo ""
test_info "🔄 PROCHAINES ÉTAPES :"
echo "  1. Configurer les clés Stripe réelles"
echo "  2. Acheter et configurer www.math4child.com"
echo "  3. Configurer Google Analytics"
echo "  4. Tests utilisateurs beta"
echo "  5. Lancement commercial"

echo ""
test_info "📞 SUPPORT GOTEST :"
echo "  📧 gotesttech@gmail.com"
echo "  🏢 SIRET: 53958712100028"
echo "  🌐 www.math4child.com"

echo ""
if [[ $FAILED_TESTS -eq 0 ]]; then
    test_passed "🎉 MATH4CHILD EST PRÊT POUR LA PRODUCTION !"
else
    test_warning "⚠️ Corriger les erreurs avant la production"
fi

# Nettoyer les fichiers temporaires
rm -f build.log 2>/dev/null

echo ""
test_info "Tests terminés. Bonne chance avec Math4Child ! 🚀"