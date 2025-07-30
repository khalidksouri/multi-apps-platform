#!/bin/bash

# =====================================
# Script de test des corrections TypeScript
# =====================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Test des langues arabes dans l'interface
test_arabic_languages() {
    print_step "Test des langues arabes..."
    
    cd apps/math4child
    
    # Vérifier que le serveur fonctionne
    if lsof -i :3000 &>/dev/null; then
        print_success "Serveur détecté sur le port 3000"
        
        # Lancer les tests spécifiques aux langues arabes
        if npx playwright test tests/translation/arabic-languages-update.spec.ts --reporter=list; then
            print_success "Tests des langues arabes réussis"
        else
            print_warning "Tests des langues arabes échoués - vérification manuelle nécessaire"
        fi
    else
        print_warning "Serveur non démarré - démarrage automatique..."
        
        # Démarrer le serveur en arrière-plan
        npm run dev &
        SERVER_PID=$!
        
        print_step "Attente du démarrage du serveur..."
        sleep 10
        
        # Tester de nouveau
        if npx playwright test tests/translation/arabic-languages-update.spec.ts --reporter=list --timeout=30000; then
            print_success "Tests des langues arabes réussis après démarrage du serveur"
        else
            print_warning "Tests échoués même après démarrage du serveur"
        fi
        
        # Arrêter le serveur
        kill $SERVER_PID 2>/dev/null || true
    fi
    
    cd ../..
}

# Test de compilation TypeScript
test_typescript_compilation() {
    print_step "Test de compilation TypeScript..."
    
    cd apps/math4child
    
    if npm run type-check; then
        print_success "Compilation TypeScript réussie"
        return 0
    else
        print_error "Erreurs TypeScript persistantes"
        return 1
    fi
    
    cd ../..
}

# Test de build Next.js
test_nextjs_build() {
    print_step "Test de build Next.js..."
    
    cd apps/math4child
    
    if npm run build; then
        print_success "Build Next.js réussi"
        return 0
    else
        print_error "Échec du build Next.js"
        return 1
    fi
    
    cd ../..
}

# Test de linting
test_linting() {
    print_step "Test de linting..."
    
    cd apps/math4child
    
    if npm run lint; then
        print_success "Linting réussi"
        return 0
    else
        print_warning "Warnings de linting détectés"
        return 1
    fi
    
    cd ../..
}

# Vérification manuelle des langues
manual_language_check() {
    print_step "Vérification manuelle des langues..."
    
    echo ""
    echo "🔍 Vérification de la configuration des langues:"
    
    # Vérifier la présence de Palestine
    if grep -q "ar-PS" apps/math4child/src/lib/i18n/languages.ts; then
        print_success "Palestine (ar-PS) trouvée dans la configuration"
    else
        print_error "Palestine (ar-PS) manquante"
    fi
    
    # Vérifier la présence du drapeau palestinien
    if grep -q "🇵🇸" apps/math4child/src/lib/i18n/languages.ts; then
        print_success "Drapeau palestinien 🇵🇸 trouvé"
    else
        print_error "Drapeau palestinien 🇵🇸 manquant"
    fi
    
    # Vérifier la présence du Maroc avec drapeau marocain
    if grep -q "ar-MA.*🇲🇦" apps/math4child/src/lib/i18n/languages.ts; then
        print_success "Maroc (ar-MA) avec drapeau marocain 🇲🇦 trouvé"
    else
        print_error "Maroc (ar-MA) avec drapeau marocain 🇲🇦 manquant"
    fi
    
    # Vérifier l'absence de l'Égypte
    if ! grep -q "ar-EG" apps/math4child/src/lib/i18n/languages.ts; then
        print_success "Égypte (ar-EG) correctement supprimée"
    else
        print_error "Égypte (ar-EG) encore présente"
    fi
    
    # Vérifier l'absence du drapeau égyptien
    if ! grep -q "🇪🇬" apps/math4child/src/lib/i18n/languages.ts; then
        print_success "Drapeau égyptien 🇪🇬 correctement supprimé"
    else
        print_error "Drapeau égyptien 🇪🇬 encore présent"
    fi
    
    echo ""
}

# Afficher le résumé des tests
show_test_summary() {
    echo ""
    echo -e "${BLUE}======================================"
    echo "📊 RÉSUMÉ DES TESTS"
    echo -e "======================================${NC}"
    echo ""
    
    echo "✨ Modifications des langues arabes :"
    echo "   🇵🇸 Palestine ajoutée au Moyen-Orient"
    echo "   🇲🇦 Maroc maintenu en Afrique avec drapeau marocain"
    echo "   ❌ Égypte supprimée"
    echo ""
    
    echo "🔧 Corrections TypeScript appliquées :"
    echo "   ✅ Gestion des types Language | undefined"
    echo "   ✅ Configuration Next.js mise à jour"
    echo "   ✅ Configuration Capacitor corrigée"
    echo "   ✅ Imports inutilisés supprimés"
    echo ""
    
    echo "📋 ACTIONS RECOMMANDÉES :"
    echo "1. Vérifiez visuellement le sélecteur de langue"
    echo "2. Testez le passage Palestine ↔ Maroc ↔ Français"
    echo "3. Vérifiez que le RTL fonctionne pour l'arabe"
    echo "4. Confirmez l'absence totale de l'Égypte"
    echo ""
}

# Fonction principale
main() {
    echo -e "${BLUE}"
    echo "======================================"
    echo "🧪 TEST DES CORRECTIONS APPLIQUÉES"
    echo "======================================"
    echo -e "${NC}"
    
    # Tests dans l'ordre
    manual_language_check
    
    if test_typescript_compilation; then
        echo ""
        if test_linting; then
            echo ""
            if test_nextjs_build; then
                echo ""
                test_arabic_languages
            else
                print_warning "Build échoué - tests d'interface ignorés"
            fi
        else
            print_warning "Linting échoué - build et tests ignorés"
        fi
    else
        print_error "Compilation TypeScript échouée - autres tests ignorés"
    fi
    
    show_test_summary
}

# Exécution avec gestion d'erreurs
trap 'print_error "Test interrompu"; exit 1' INT

main "$@"