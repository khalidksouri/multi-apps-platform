#!/bin/bash

# =============================================================================
# SCRIPT COMPLET DE CONFIGURATION DOMAINE MATH4KIDS
# =============================================================================
# Ce script automatise:
# 1. Configuration Netlify via API
# 2. Génération des fichiers de configuration
# 3. Vérification DNS complète
# 4. Instructions DNS personnalisées par registrar
#
# Usage: ./setup-math4kids-domain.sh
# Prérequis: NETLIFY_AUTH_TOKEN défini en variable d'environnement
# =============================================================================

set -e  # Arrêter en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
DOMAIN="math4child.com"
WWW_DOMAIN="www.math4child.com"
NETLIFY_SITE_NAME="math4kids-enhanced"
NETLIFY_TEMP_URL="687c49209cf9ccff4c3d191c--math4kids-enhanced.netlify.app"
PROJECT_DIR="apps/math4kids"

# =============================================================================
# FONCTIONS UTILITAIRES
# =============================================================================

print_header() {
    echo -e "\n${WHITE}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}🚀 CONFIGURATION DOMAINE MATH4KIDS - $1${NC}"
    echo -e "${WHITE}════════════════════════════════════════════════════════════════════════════════${NC}\n"
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

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

check_dependencies() {
    local missing_deps=()
    
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
    command -v nslookup >/dev/null 2>&1 || missing_deps+=("nslookup")
    command -v openssl >/dev/null 2>&1 || missing_deps+=("openssl")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Dépendances manquantes: ${missing_deps[*]}"
        echo -e "${YELLOW}Installation:${NC}"
        echo "  macOS: brew install curl jq bind openssl"
        echo "  Ubuntu/Debian: sudo apt install curl jq dnsutils openssl"
        echo "  CentOS/RHEL: sudo yum install curl jq bind-utils openssl"
        exit 1
    fi
}

# =============================================================================
# CONFIGURATION NETLIFY VIA API
# =============================================================================

setup_netlify_domain() {
    print_section "Configuration Netlify via API"
    
    if [ -z "$NETLIFY_AUTH_TOKEN" ]; then
        print_warning "NETLIFY_AUTH_TOKEN non défini"
        echo -e "${YELLOW}Pour obtenir votre token:${NC}"
        echo "1. Allez sur https://app.netlify.com/user/applications#personal-access-tokens"
        echo "2. Générez un nouveau token"
        echo "3. Exportez-le: export NETLIFY_AUTH_TOKEN=your_token_here"
        echo ""
        echo -e "${CYAN}Configuration manuelle requise:${NC}"
        echo "1. Allez sur https://app.netlify.com → votre site Math4Kids"
        echo "2. Site Settings → Domain management → Custom domains"
        echo "3. Add custom domain → $DOMAIN"
        echo "4. Add custom domain → $WWW_DOMAIN"
        return 1
    fi
    
    # Récupérer l'ID du site
    print_info "Recherche du site Netlify..."
    SITE_ID=$(curl -s -H "Authorization: Bearer $NETLIFY_AUTH_TOKEN" \
        "https://api.netlify.com/api/v1/sites" | \
        jq -r ".[] | select(.name == \"$NETLIFY_SITE_NAME\" or .url == \"https://$NETLIFY_TEMP_URL\") | .id" | head -1)
    
    if [ -z "$SITE_ID" ] || [ "$SITE_ID" = "null" ]; then
        print_error "Site Netlify non trouvé"
        echo "Vérifiez le nom du site: $NETLIFY_SITE_NAME"
        return 1
    fi
    
    print_success "Site trouvé: $SITE_ID"
    
    # Ajouter le domaine principal
    print_info "Ajout du domaine $DOMAIN..."
    response=$(curl -s -X POST \
        -H "Authorization: Bearer $NETLIFY_AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"domain_name\": \"$DOMAIN\"}" \
        "https://api.netlify.com/api/v1/sites/$SITE_ID/domains")
    
    if echo "$response" | jq -e '.domain_name' >/dev/null 2>&1; then
        print_success "Domaine $DOMAIN ajouté"
    else
        print_warning "Domaine $DOMAIN peut-être déjà configuré"
    fi
    
    # Ajouter le sous-domaine www
    print_info "Ajout du domaine $WWW_DOMAIN..."
    response=$(curl -s -X POST \
        -H "Authorization: Bearer $NETLIFY_AUTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"domain_name\": \"$WWW_DOMAIN\"}" \
        "https://api.netlify.com/api/v1/sites/$SITE_ID/domains")
    
    if echo "$response" | jq -e '.domain_name' >/dev/null 2>&1; then
        print_success "Domaine $WWW_DOMAIN ajouté"
    else
        print_warning "Domaine $WWW_DOMAIN peut-être déjà configuré"
    fi
    
    # Activer HTTPS automatique
    print_info "Activation HTTPS automatique..."
    curl -s -X POST \
        -H "Authorization: Bearer $NETLIFY_AUTH_TOKEN" \
        "https://api.netlify.com/api/v1/sites/$SITE_ID/ssl" >/dev/null
    
    print_success "Configuration Netlify terminée"
}

# =============================================================================
# GÉNÉRATION DES FICHIERS DE CONFIGURATION
# =============================================================================

create_netlify_config() {
    print_section "Génération du fichier netlify.toml"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Répertoire $PROJECT_DIR non trouvé"
        return 1
    fi
    
    cat > "$PROJECT_DIR/netlify.toml" << 'EOF'
# Netlify Configuration for Math4Kids
# Auto-généré par setup-math4kids-domain.sh

[build]
  publish = "out"
  command = "npm run build"

[build.environment]
  NODE_VERSION = "18"
  NPM_VERSION = "9"
  NODE_ENV = "production"

# Redirections pour domaine personnalisé
[[redirects]]
  from = "https://687c49209cf9ccff4c3d191c--math4kids-enhanced.netlify.app/*"
  to = "https://math4child.com/:splat"
  status = 301
  force = true

[[redirects]]
  from = "https://www.math4child.com/*"
  to = "https://math4child.com/:splat"
  status = 301
  force = true

# Redirection HTTP vers HTTPS
[[redirects]]
  from = "http://math4child.com/*"
  to = "https://math4child.com/:splat"
  status = 301
  force = true

# SPA Fallback pour React/Next.js
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Headers de sécurité
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Content-Security-Policy = "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline' fonts.googleapis.com; font-src 'self' fonts.gstatic.com; img-src 'self' data: blob:; connect-src 'self' https:; frame-ancestors 'none';"
    Permissions-Policy = "camera=(), microphone=(), geolocation=(), payment=()"

# Cache optimisé pour assets
[[headers]]
  for = "/_next/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

# Headers pour PWA
[[headers]]
  for = "/manifest.json"
  [headers.values]
    Content-Type = "application/manifest+json"
    Cache-Control = "public, max-age=3600"

[[headers]]
  for = "/sw.js"
  [headers.values]
    Cache-Control = "public, max-age=0, must-revalidate"

# Context-specific settings
[context.production.environment]
  NODE_ENV = "production"
  NEXT_PUBLIC_SITE_URL = "https://math4child.com"

[context.deploy-preview.environment]
  NODE_ENV = "development"

[context.branch-deploy.environment]
  NODE_ENV = "development"
EOF
    
    print_success "Fichier netlify.toml créé dans $PROJECT_DIR/"
}

create_redirects_file() {
    print_section "Génération du fichier _redirects"
    
    mkdir -p "$PROJECT_DIR/public"
    
    cat > "$PROJECT_DIR/public/_redirects" << 'EOF'
# Redirections Math4Kids Enhanced
# Auto-généré par setup-math4kids-domain.sh

# Redirection de l'ancien domaine Netlify vers le nouveau
https://687c49209cf9ccff4c3d191c--math4kids-enhanced.netlify.app/* https://math4child.com/:splat 301!

# Redirection www vers non-www
https://www.math4child.com/* https://math4child.com/:splat 301!

# Redirections HTTP vers HTTPS
http://math4child.com/* https://math4child.com/:splat 301!
http://www.math4child.com/* https://math4child.com/:splat 301!

# Redirections pour compatibilité
/index.html / 301
/home / 301

# SPA fallback (important pour React)
/* /index.html 200
EOF
    
    print_success "Fichier _redirects créé dans $PROJECT_DIR/public/"
}

create_dns_instructions() {
    print_section "Génération des instructions DNS"
    
    mkdir -p "$PROJECT_DIR/dns-config"
    
    cat > "$PROJECT_DIR/dns-config/dns-records.txt" << EOF
# =============================================================================
# ENREGISTREMENTS DNS POUR MATH4CHILD.COM
# Auto-généré le $(date)
# =============================================================================

# CONFIGURATION RECOMMANDÉE (CNAME)
# -----------------------------------
Type: CNAME
Name: @ (ou laisser vide pour le domaine racine)
Value: $NETLIFY_TEMP_URL
TTL: 3600

Type: CNAME
Name: www
Value: $NETLIFY_TEMP_URL
TTL: 3600

# CONFIGURATION ALTERNATIVE (A Records)
# --------------------------------------
Type: A
Name: @ (ou laisser vide)
Value: 75.2.60.5
TTL: 3600

Type: CNAME
Name: www
Value: $DOMAIN
TTL: 3600

# Note: Les IP de Netlify peuvent changer, CNAME est préférable
EOF
    
    # Instructions par registrar
    cat > "$PROJECT_DIR/dns-config/registrar-instructions.md" << 'EOF'
# 🌐 INSTRUCTIONS PAR REGISTRAR

## 🏢 GODADDY
1. Connectez-vous sur godaddy.com → Mon compte
2. Mes produits → Domaines → math4child.com → Gérer
3. Cliquez sur "Gérer DNS"
4. Ajouter les enregistrements CNAME ci-dessus
5. Sauvegarder les modifications

## 🌐 NAMECHEAP
1. Connectez-vous sur namecheap.com → Account → Domain List
2. Cliquez "Manage" à côté de math4child.com
3. Onglet "Advanced DNS"
4. Ajouter les enregistrements
5. Sauvegarder

## ☁️ CLOUDFLARE
1. Connectez-vous sur cloudflare.com → Tableau de bord
2. Sélectionner math4child.com
3. Onglet DNS
4. Ajouter les enregistrements (IMPORTANT: Proxy OFF pour CNAME)
5. Sauvegarder

## 🏗️ OVH
1. Espace client OVH → Domaines → math4child.com
2. Zone DNS
3. Ajouter les enregistrements
4. Valider les modifications

## 📋 GANDI
1. Connectez-vous sur gandi.net → Domaines
2. math4child.com → Enregistrements DNS
3. Ajouter les enregistrements
4. Sauvegarder

## 🌍 1&1 IONOS
1. Espace client IONOS → Domaines & SSL
2. math4child.com → Gérer les sous-domaines
3. Paramètres DNS → Ajouter les enregistrements
4. Sauvegarder

## ⚡ AUTRES REGISTRARS
Pour tous les autres fournisseurs :
1. Chercher "Zone DNS", "DNS Management" ou "Gérer DNS"
2. Ajouter les enregistrements CNAME mentionnés
3. Sauvegarder les modifications
4. Attendre la propagation (2-48h)
EOF
    
    print_success "Instructions DNS créées dans $PROJECT_DIR/dns-config/"
}

# =============================================================================
# VÉRIFICATION DNS COMPLÈTE
# =============================================================================

check_dns_resolution() {
    print_section "Vérification de la résolution DNS"
    
    # Test DNS principal
    echo -n "Résolution $DOMAIN: "
    if nslookup $DOMAIN > /dev/null 2>&1; then
        print_success "OK"
        ip=$(nslookup $DOMAIN 2>/dev/null | awk '/^Address: / { print $2 }' | tail -1)
        echo "   IP: $ip"
    else
        print_error "ÉCHEC - DNS non configuré"
        return 1
    fi
    
    # Test DNS www
    echo -n "Résolution $WWW_DOMAIN: "
    if nslookup $WWW_DOMAIN > /dev/null 2>&1; then
        print_success "OK"
        ip=$(nslookup $WWW_DOMAIN 2>/dev/null | awk '/^Address: / { print $2 }' | tail -1)
        echo "   IP: $ip"
    else
        print_error "ÉCHEC - DNS www non configuré"
    fi
}

check_http_connectivity() {
    print_section "Test de connectivité HTTP/HTTPS"
    
    # Test HTTPS principal
    echo -n "HTTPS $DOMAIN: "
    if curl -s -I "https://$DOMAIN" > /dev/null 2>&1; then
        status=$(curl -s -I "https://$DOMAIN" | head -n 1 | cut -d' ' -f2)
        print_success "Status $status"
    else
        print_error "ÉCHEC - Site non accessible"
    fi
    
    # Test HTTPS www
    echo -n "HTTPS $WWW_DOMAIN: "
    if curl -s -I "https://$WWW_DOMAIN" > /dev/null 2>&1; then
        status=$(curl -s -I "https://$WWW_DOMAIN" | head -n 1 | cut -d' ' -f2)
        print_success "Status $status"
    else
        print_error "ÉCHEC - www non accessible"
    fi
    
    # Test URL temporaire Netlify
    echo -n "URL Netlify temporaire: "
    if curl -s -I "https://$NETLIFY_TEMP_URL" > /dev/null 2>&1; then
        status=$(curl -s -I "https://$NETLIFY_TEMP_URL" | head -n 1 | cut -d' ' -f2)
        print_success "Status $status"
        echo "   URL: https://$NETLIFY_TEMP_URL"
    else
        print_error "ÉCHEC - URL Netlify inaccessible"
    fi
}

check_ssl_certificate() {
    print_section "Vérification des certificats SSL"
    
    echo -n "Certificat SSL $DOMAIN: "
    if echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates > /dev/null 2>&1; then
        print_success "OK"
        expiry=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
        echo "   Expiration: $expiry"
    else
        print_warning "Certificat en cours de provisioning (normal dans les 24h)"
    fi
}

check_redirections() {
    print_section "Test des redirections"
    
    # Test redirection www vers non-www
    echo -n "Redirection www → non-www: "
    if curl -s -I "https://$WWW_DOMAIN" > /dev/null 2>&1; then
        redirect_location=$(curl -s -I "https://$WWW_DOMAIN" | grep -i location | cut -d' ' -f2 | tr -d '\r')
        if [[ "$redirect_location" == "https://$DOMAIN"* ]]; then
            print_success "OK"
        else
            print_warning "Redirection à vérifier: $redirect_location"
        fi
    else
        print_warning "Impossible de tester la redirection"
    fi
    
    # Test redirection HTTP vers HTTPS
    echo -n "Redirection HTTP → HTTPS: "
    if curl -s -I "http://$DOMAIN" > /dev/null 2>&1; then
        redirect_location=$(curl -s -I "http://$DOMAIN" | grep -i location | cut -d' ' -f2 | tr -d '\r')
        if [[ "$redirect_location" == "https://$DOMAIN"* ]]; then
            print_success "OK"
        else
            print_warning "Redirection HTTP à vérifier"
        fi
    else
        print_warning "Impossible de tester la redirection HTTP"
    fi
}

check_global_propagation() {
    print_section "Vérification de la propagation DNS globale"
    
    dns_servers=("8.8.8.8" "1.1.1.1" "208.67.222.222" "9.9.9.9")
    for dns in "${dns_servers[@]}"; do
        echo -n "DNS $dns: "
        if nslookup $DOMAIN $dns > /dev/null 2>&1; then
            ip=$(nslookup $DOMAIN $dns 2>/dev/null | awk '/^Address: / { print $2 }' | tail -1)
            print_success "$ip"
        else
            print_error "Non résolu"
        fi
    done
}

# =============================================================================
# RECOMMANDATIONS ET ACTIONS
# =============================================================================

provide_recommendations() {
    print_section "Recommandations et prochaines étapes"
    
    dns_configured=false
    site_accessible=false
    
    # Vérifier si DNS est configuré
    if nslookup $DOMAIN > /dev/null 2>&1; then
        dns_configured=true
    fi
    
    # Vérifier si le site est accessible
    if curl -s -I "https://$DOMAIN" > /dev/null 2>&1; then
        site_accessible=true
    fi
    
    if [ "$dns_configured" = false ]; then
        print_warning "DNS non configuré - Actions requises:"
        echo "   1. Configurer les enregistrements DNS (voir $PROJECT_DIR/dns-config/)"
        echo "   2. Attendre la propagation (2-48h)"
        echo ""
        echo -e "${CYAN}Enregistrements à ajouter:${NC}"
        echo "   CNAME @ → $NETLIFY_TEMP_URL"
        echo "   CNAME www → $NETLIFY_TEMP_URL"
    else
        print_success "DNS configuré correctement"
    fi
    
    if [ "$site_accessible" = false ] && [ "$dns_configured" = true ]; then
        print_warning "Site non encore accessible - Attendre:"
        echo "   1. Provisioning SSL automatique (jusqu'à 24h)"
        echo "   2. Mise à jour des caches DNS"
    elif [ "$site_accessible" = true ]; then
        print_success "Site accessible sur https://$DOMAIN"
    fi
    
    echo ""
    print_info "URLs de test:"
    echo "   Production: https://$DOMAIN"
    echo "   Temporaire: https://$NETLIFY_TEMP_URL"
    echo "   Vérification DNS: https://dnschecker.org"
    echo ""
    print_info "Fichiers générés:"
    echo "   Configuration: $PROJECT_DIR/netlify.toml"
    echo "   Redirections: $PROJECT_DIR/public/_redirects"
    echo "   Instructions DNS: $PROJECT_DIR/dns-config/"
}

deploy_to_netlify() {
    print_section "Déploiement vers Netlify"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Répertoire $PROJECT_DIR non trouvé"
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    if [ ! -f "package.json" ]; then
        print_error "package.json non trouvé dans $PROJECT_DIR"
        return 1
    fi
    
    print_info "Installation des dépendances..."
    npm install
    
    print_info "Build de l'application..."
    npm run build
    
    print_info "Déploiement..."
    if command -v netlify >/dev/null 2>&1; then
        netlify deploy --prod --dir=out
        print_success "Déployé via Netlify CLI"
    else
        print_warning "Netlify CLI non installé - Déployement manuel requis"
        echo "   npm install -g netlify-cli"
        echo "   netlify deploy --prod --dir=out"
    fi
    
    cd - > /dev/null
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================

main() {
    clear
    print_header "CONFIGURATION AUTOMATIQUE"
    
    # Vérification des dépendances
    check_dependencies
    
    # Menu interactif
    echo -e "${CYAN}Choisissez une option:${NC}"
    echo "1. Configuration complète (recommandé)"
    echo "2. Configuration Netlify uniquement"
    echo "3. Génération des fichiers de configuration"
    echo "4. Vérification DNS uniquement"
    echo "5. Déploiement vers Netlify"
    echo "6. Tout sauf configuration Netlify"
    echo -n "Votre choix (1-6): "
    read -r choice
    
    case $choice in
        1)
            print_header "CONFIGURATION COMPLÈTE"
            setup_netlify_domain
            create_netlify_config
            create_redirects_file
            create_dns_instructions
            echo -e "\n${YELLOW}⏳ Attendez 5 minutes puis relancez avec option 4 pour vérifier${NC}"
            ;;
        2)
            print_header "CONFIGURATION NETLIFY"
            setup_netlify_domain
            ;;
        3)
            print_header "GÉNÉRATION DES FICHIERS"
            create_netlify_config
            create_redirects_file
            create_dns_instructions
            ;;
        4)
            print_header "VÉRIFICATION DNS"
            check_dns_resolution
            check_http_connectivity
            check_ssl_certificate
            check_redirections
            check_global_propagation
            provide_recommendations
            ;;
        5)
            print_header "DÉPLOIEMENT NETLIFY"
            deploy_to_netlify
            ;;
        6)
            print_header "CONFIGURATION LOCALE"
            create_netlify_config
            create_redirects_file
            create_dns_instructions
            check_dns_resolution
            check_http_connectivity
            provide_recommendations
            ;;
        *)
            print_error "Option invalide"
            exit 1
            ;;
    esac
    
    echo ""
    print_success "Script terminé avec succès!"
    echo -e "${CYAN}💡 Conseil: Exécutez ce script régulièrement pour vérifier le statut${NC}"
}

# =============================================================================
# EXÉCUTION
# =============================================================================

# Vérifier si le script est exécuté directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi