#!/bin/bash

# ==============================================
# 🚀 Script de déploiement local Multi-Apps Platform
# ==============================================

set -e

# Configuration
ENVIRONMENT=${1:-development}
REGISTRY="ghcr.io/khalidksouri/multi-apps-platform"
APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
PORTS=(3001 3002 3003 3004 3005)

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Fonction pour afficher le statut
show_status() {
    local status=$1
    local message=$2
    
    case $status in
        "success") echo -e "${GREEN}✅ $message${NC}" ;;
        "warning") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "error") echo -e "${RED}❌ $message${NC}" ;;
        "info") echo -e "${BLUE}ℹ️  $message${NC}" ;;
        *) echo -e "${PURPLE}🔄 $message${NC}" ;;
    esac
}

# Fonction pour vérifier les prérequis
check_prerequisites() {
    echo -e "${BLUE}🔍 Vérification des prérequis...${NC}"
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        show_status "error" "Node.js n'est pas installé"
        exit 1
    fi
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        show_status "error" "npm n'est pas installé"
        exit 1
    fi
    
    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        show_status "error" "Docker n'est pas installé"
        exit 1
    fi
    
    # Vérifier docker-compose
    if ! command -v docker-compose &> /dev/null; then
        show_status "error" "docker-compose n'est pas installé"
        exit 1
    fi
    
    # Vérifier que Docker est en cours d'exécution
    if ! docker info &> /dev/null; then
        show_status "error" "Docker n'est pas en cours d'exécution"
        exit 1
    fi
    
    show_status "success" "Tous les prérequis sont satisfaits"
}

# Fonction pour nettoyer les anciennes images/containers
cleanup() {
    echo -e "${BLUE}🧹 Nettoyage des anciennes images et containers...${NC}"
    
    # Arrêter les containers existants
    docker-compose down --remove-orphans 2>/dev/null || true
    
    # Supprimer les images de développement précédentes
    for app in "${APPS[@]}"; do
        docker rmi "$REGISTRY/$app:$ENVIRONMENT" 2>/dev/null || true
    done
    
    # Nettoyer les images et containers orphelins
    docker system prune -f &> /dev/null || true
    
    show_status "success" "Nettoyage terminé"
}

# Fonction pour installer les dépendances
install_dependencies() {
    echo -e "${BLUE}📦 Installation des dépendances...${NC}"
    
    if npm ci > /tmp/install.log 2>&1; then
        show_status "success" "Dépendances installées"
    else
        show_status "error" "Erreur lors de l'installation des dépendances"
        cat /tmp/install.log
        exit 1
    fi
}

# Fonction pour builder les packages
build_packages() {
    echo -e "${BLUE}🏗️ Build des packages partagés...${NC}"
    
    if npm run build:packages > /tmp/build-packages.log 2>&1; then
        show_status "success" "Packages shared et ui construits"
    else
        show_status "error" "Erreur lors du build des packages"
        cat /tmp/build-packages.log
        exit 1
    fi
}

# Fonction pour builder les applications
build_applications() {
    echo -e "${BLUE}🏗️ Build des applications...${NC}"
    
    local success_count=0
    
    for app in "${APPS[@]}"; do
        echo "   🔨 Build de $app..."
        if (cd "apps/$app" && npm run build) > /tmp/build-$app.log 2>&1; then
            show_status "success" "$app construit avec succès"
            success_count=$((success_count + 1))
        else
            show_status "error" "Erreur lors du build de $app"
            echo "📋 Erreurs pour $app:"
            cat /tmp/build-$app.log | head -10
        fi
    done
    
    echo "📊 Résumé: $success_count/${#APPS[@]} applications construites"
    
    if [ $success_count -lt ${#APPS[@]} ]; then
        show_status "warning" "Certaines applications ont échoué, mais on continue..."
    fi
}

# Fonction pour builder les images Docker
build_docker_images() {
    echo -e "${BLUE}🐳 Build des images Docker...${NC}"
    
    local success_count=0
    
    for app in "${APPS[@]}"; do
        echo "   🐳 Build de l'image $app..."
        if docker build -t "$REGISTRY/$app:$ENVIRONMENT" -f "apps/$app/Dockerfile" . > /tmp/docker-$app.log 2>&1; then
            show_status "success" "Image $app construite"
            success_count=$((success_count + 1))
        else
            show_status "error" "Erreur lors du build Docker de $app"
            echo "📋 Erreurs Docker pour $app:"
            cat /tmp/docker-$app.log | tail -10
        fi
    done
    
    echo "🐳 Résumé Docker: $success_count/${#APPS[@]} images construites"
}

# Fonction pour créer le docker-compose.yml dynamique
create_docker_compose() {
    echo -e "${BLUE}📋 Création du docker-compose.yml...${NC}"
    
    cat > docker-compose.override.yml << EOF
version: '3.8'

services:
EOF

    for i in "${!APPS[@]}"; do
        local app="${APPS[$i]}"
        local port="${PORTS[$i]}"
        
        cat >> docker-compose.override.yml << EOF
  $app:
    image: $REGISTRY/$app:$ENVIRONMENT
    build:
      context: .
      dockerfile: apps/$app/Dockerfile
    ports:
      - "$port:$port"
    environment:
      - NODE_ENV=$ENVIRONMENT
      - NEXT_PUBLIC_API_URL=http://localhost:$port
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:$port/api/health"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 40s

EOF
    done
    
    show_status "success" "docker-compose.override.yml créé"
}

# Fonction pour démarrer les services
start_services() {
    echo -e "${BLUE}🚀 Démarrage des services...${NC}"
    
    # Démarrer avec docker-compose
    if docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d > /tmp/docker-up.log 2>&1; then
        show_status "success" "Services démarrés"
    else
        show_status "error" "Erreur lors du démarrage des services"
        cat /tmp/docker-up.log
        exit 1
    fi
}

# Fonction pour attendre que les services soient prêts
wait_for_services() {
    echo -e "${BLUE}⏳ Attente que les services soient prêts...${NC}"
    
    local max_wait=120
    local wait_time=0
    
    while [ $wait_time -lt $max_wait ]; do
        sleep 5
        wait_time=$((wait_time + 5))
        
        echo "   ⏳ Attente... (${wait_time}s/${max_wait}s)"
        
        # Vérifier si au moins un service répond
        local ready_count=0
        for i in "${!APPS[@]}"; do
            local port="${PORTS[$i]}"
            if curl -f "http://localhost:$port/api/health" &> /dev/null; then
                ready_count=$((ready_count + 1))
            fi
        done
        
        if [ $ready_count -gt 0 ]; then
            show_status "success" "$ready_count services prêts"
            break
        fi
    done
    
    if [ $wait_time -ge $max_wait ]; then
        show_status "warning" "Timeout atteint, mais on continue avec le health check"
    fi
}

# Fonction pour effectuer le health check
health_check() {
    echo -e "${BLUE}🏥 Vérification de l'état des services...${NC}"
    
    local healthy_count=0
    
    for i in "${!APPS[@]}"; do
        local app="${APPS[$i]}"
        local port="${PORTS[$i]}"
        
        echo "   🏥 Test de $app sur le port $port..."
        
        if curl -f "http://localhost:$port/api/health" &> /dev/null; then
            show_status "success" "$app: healthy (http://localhost:$port)"
            healthy_count=$((healthy_count + 1))
        else
            show_status "error" "$app: unhealthy (http://localhost:$port)"
            
            # Afficher les logs du container pour debug
            echo "📋 Logs pour $app:"
            docker logs "$(docker-compose ps -q $app 2>/dev/null)" 2>/dev/null | tail -5 || echo "   Pas de logs disponibles"
        fi
    done
    
    echo "🏥 Résumé health check: $healthy_count/${#APPS[@]} services healthy"
}

# Fonction pour afficher les informations finales
show_final_info() {
    echo ""
    echo -e "${GREEN}🎉 DÉPLOIEMENT LOCAL TERMINÉ!${NC}"
    echo "=================================="
    echo ""
    echo "🔗 Applications disponibles:"
    for i in "${!APPS[@]}"; do
        local app="${APPS[$i]}"
        local port="${PORTS[$i]}"
        echo "   - $app: http://localhost:$port"
    done
    echo ""
    echo "📊 Commandes utiles:"
    echo "   docker-compose logs -f              # Voir les logs de tous les services"
    echo "   docker-compose logs -f postmath     # Voir les logs de PostMath"
    echo "   docker-compose ps                   # Voir l'état des services"
    echo "   docker-compose down                 # Arrêter tous les services"
    echo "   docker-compose restart postmath     # Redémarrer PostMath"
    echo ""
    echo "🐳 Images Docker créées:"
    for app in "${APPS[@]}"; do
        echo "   - $REGISTRY/$app:$ENVIRONMENT"
    done
    echo ""
    echo "🔧 Debug:"
    echo "   docker-compose logs -f [service]    # Logs d'un service"
    echo "   docker exec -it [container] /bin/sh # Entrer dans un container"
    echo ""
    echo -e "${PURPLE}📱 Testez vos applications maintenant!${NC}"
}

# Fonction principale
main() {
    echo -e "${PURPLE}🚀 Déploiement Multi-Apps Platform${NC}"
    echo "=================================="
    echo "📊 Environment: $ENVIRONMENT"
    echo "📦 Registry: $REGISTRY"
    echo "🎯 Applications: ${APPS[*]}"
    echo ""
    
    check_prerequisites
    cleanup
    install_dependencies
    build_packages
    build_applications
    build_docker_images
    create_docker_compose
    start_services
    wait_for_services
    health_check
    show_final_info
    
    # Nettoyage des fichiers temporaires
    rm -f /tmp/install.log /tmp/build-*.log /tmp/docker-*.log /tmp/docker-up.log
    
    echo -e "${GREEN}✅ Déploiement local réussi!${NC}"
}

# Gestion des signaux pour un arrêt propre
trap 'echo -e "\n${RED}🛑 Arrêt du déploiement...${NC}"; docker-compose down 2>/dev/null || true; exit 1' INT TERM

# Exécution du script principal
main "$@"