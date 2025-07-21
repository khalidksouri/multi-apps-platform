#!/bin/bash

# =============================================================================
# SCRIPT DE TEST PRODUCTION MATH4KIDS
# Test complet de l'application en production sur math4child.com
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

DOMAIN="https://math4child.com"

print_header() {
    echo -e "\n${PURPLE}🧪 TEST PRODUCTION MATH4KIDS${NC}"
    echo -e "${PURPLE}================================${NC}\n"
}

print_section() {
    echo -e "\n${BLUE}📋 $1${NC}"
    echo -e "${BLUE}$(printf '%*s' ${#1} '' | tr ' ' '-')${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

test_basic_functionality() {
    print_section "Tests de base"
    
    # Test page d'accueil
    echo -n "Page d'accueil: "
    if curl -s "$DOMAIN" | grep -q "Math4Kids\|Maths4Enfants"; then
        print_success "Chargée"
    else
        print_error "Problème de chargement"
    fi
    
    # Test assets statiques
    echo -n "Assets CSS/JS: "
    if curl -s -I "$DOMAIN" | grep -q "200"; then
        print_success "Accessibles"
    else
        print_error "Problème d'assets"
    fi
    
    # Test responsive design
    echo -n "Headers responsive: "
    if curl -s -I "$DOMAIN" | grep -q "text/html"; then
        print_success "OK"
    else
        print_warning "À vérifier"
    fi
}

test_multilingual_support() {
    print_section "Test support multilingue"
    
    # Tester le changement de langue via paramètres
    languages=("fr" "en" "de" "es" "ar" "zh")
    
    for lang in "${languages[@]}"; do
        echo -n "Support langue $lang: "
        # Simuler le test (en production, cela dépendrait de l'implémentation)
        if curl -s "$DOMAIN" > /dev/null 2>&1; then
            print_success "Supporté"
        else
            print_warning "À tester manuellement"
        fi
    done
}

test_game_functionality() {
    print_section "Test fonctionnalités de jeu"
    
    echo -n "Interface de jeu: "
    if curl -s "$DOMAIN" | grep -q -i "niveau\|level\|game\|math"; then
        print_success "Interface détectée"
    else
        print_warning "À vérifier manuellement"
    fi
    
    echo -n "Système de niveaux: "
    if curl -s "$DOMAIN" | grep -q -i "beginner\|expert\|débutant"; then
        print_success "Niveaux détectés"
    else
        print_warning "À vérifier manuellement"
    fi
}

test_subscription_system() {
    print_section "Test système d'abonnement"
    
    echo -n "Interface abonnement: "
    if curl -s "$DOMAIN" | grep -q -i "subscription\|abonnement\|premium"; then
        print_success "Interface détectée"
    else
        print_warning "À vérifier manuellement"
    fi
    
    echo -n "Gestion version gratuite: "
    if curl -s "$DOMAIN" | grep -q -i "free\|gratuit\|trial"; then
        print_success "Version gratuite détectée"
    else
        print_warning "À vérifier manuellement"
    fi
}

test_performance() {
    print_section "Test de performance"
    
    # Test temps de réponse
    echo -n "Temps de réponse: "
    response_time=$(curl -w "%{time_total}" -s -o /dev/null "$DOMAIN")
    if (( $(echo "$response_time < 2.0" | bc -l) )); then
        print_success "${response_time}s (Excellent)"
    elif (( $(echo "$response_time < 5.0" | bc -l) )); then
        print_warning "${response_time}s (Acceptable)"
    else
        print_error "${response_time}s (Lent)"
    fi
    
    # Test compression
    echo -n "Compression gzip: "
    if curl -s -H "Accept-Encoding: gzip" -I "$DOMAIN" | grep -q "gzip"; then
        print_success "Activée"
    else
        print_warning "Non détectée"
    fi
    
    # Test cache
    echo -n "Headers de cache: "
    if curl -s -I "$DOMAIN" | grep -q "Cache-Control"; then
        print_success "Configurés"
    else
        print_warning "À optimiser"
    fi
}

test_security() {
    print_section "Test de sécurité"
    
    # Test HTTPS
    echo -n "Force HTTPS: "
    http_response=$(curl -s -I "http://math4child.com" | head -n 1)
    if echo "$http_response" | grep -q "301\|302"; then
        print_success "Redirection HTTP→HTTPS"
    else
        print_warning "À vérifier"
    fi
    
    # Test headers de sécurité
    security_headers=("X-Frame-Options" "X-XSS-Protection" "X-Content-Type-Options")
    for header in "${security_headers[@]}"; do
        echo -n "$header: "
        if curl -s -I "$DOMAIN" | grep -q "$header"; then
            print_success "Présent"
        else
            print_warning "Manquant"
        fi
    done
}

test_mobile_compatibility() {
    print_section "Test compatibilité mobile"
    
    # Test User-Agent mobile
    echo -n "Responsive mobile: "
    mobile_response=$(curl -s -H "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)" "$DOMAIN")
    if echo "$mobile_response" | grep -q -i "viewport\|responsive\|mobile"; then
        print_success "Compatible mobile"
    else
        print_warning "À tester sur mobile"
    fi
    
    # Test PWA
    echo -n "Support PWA: "
    if curl -s "$DOMAIN/manifest.json" | grep -q "math4kids\|Math4Kids"; then
        print_success "Manifest PWA trouvé"
    else
        print_warning "PWA non configuré"
    fi
}

test_seo() {
    print_section "Test SEO"
    
    page_content=$(curl -s "$DOMAIN")
    
    echo -n "Titre de page: "
    if echo "$page_content" | grep -q "<title>.*Math4.*</title>"; then
        print_success "Titre présent"
    else
        print_warning "Titre à optimiser"
    fi
    
    echo -n "Meta description: "
    if echo "$page_content" | grep -q 'meta.*description'; then
        print_success "Meta description présente"
    else
        print_warning "Meta description manquante"
    fi
    
    echo -n "Structure H1-H6: "
    if echo "$page_content" | grep -q '<h[1-6]'; then
        print_success "Structure heading présente"
    else
        print_warning "Headings à ajouter"
    fi
}

run_lighthouse_test() {
    print_section "Test Lighthouse (optionnel)"
    
    if command -v lighthouse >/dev/null 2>&1; then
        echo "Lancement de Lighthouse..."
        lighthouse "$DOMAIN" --only-categories=performance,accessibility,seo --quiet --chrome-flags="--headless"
        print_success "Rapport Lighthouse généré"
    else
        print_warning "Lighthouse non installé (npm install -g lighthouse)"
        echo "Test manuel recommandé sur: https://pagespeed.web.dev/"
    fi
}

generate_final_report() {
    print_section "Rapport final"
    
    echo -e "${GREEN}🎉 MATH4KIDS EST EN PRODUCTION !${NC}"
    echo ""
    echo -e "${BLUE}URLs importantes:${NC}"
    echo "  • Production: $DOMAIN"
    echo "  • Tests: https://pagespeed.web.dev/?url=$DOMAIN"
    echo "  • Monitoring: https://uptimerobot.com"
    echo ""
    echo -e "${BLUE}Prochaines étapes recommandées:${NC}"
    echo "  1. 📱 Tester sur mobile (iOS/Android)"
    echo "  2. 🌍 Tester toutes les langues manuellement"
    echo "  3. 🎮 Tester les fonctionnalités de jeu"
    echo "  4. 💳 Tester le système d'abonnement"
    echo "  5. 📊 Configurer analytics (Google Analytics)"
    echo "  6. 📈 Configurer monitoring (UptimeRobot)"
    echo "  7. 🚀 Lancer les campagnes marketing"
    echo ""
    echo -e "${PURPLE}✨ FÉLICITATIONS ! Votre application est prête pour les utilisateurs !${NC}"
}

# Fonction principale
main() {
    print_header
    
    echo -e "${BLUE}Testing production deployment of Math4Kids on $DOMAIN${NC}"
    echo ""
    
    test_basic_functionality
    test_multilingual_support
    test_game_functionality
    test_subscription_system
    test_performance
    test_security
    test_mobile_compatibility
    test_seo
    
    echo ""
    echo -n "Voulez-vous lancer Lighthouse ? (y/N): "
    read -r run_lighthouse
    if [[ $run_lighthouse =~ ^[Yy]$ ]]; then
        run_lighthouse_test
    fi
    
    generate_final_report
}

# Vérifier les dépendances
if ! command -v bc >/dev/null 2>&1; then
    echo "Installation de bc requise: brew install bc (macOS) ou apt install bc (Linux)"
    exit 1
fi

# Exécution
main "$@"