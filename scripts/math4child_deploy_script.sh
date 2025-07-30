    log "SUCCESS" "✅ Configuration des variables d'environnement et sécurité créée"
}

# Déploiement avancé
deploy() {
    local environment=${1:-$DEFAULT_ENV}
    local skip_tests=${2:-false}
    
    log "INFO" "🚀 Déploiement de Math4Child en environnement: $environment"
    
    # Validation de l'environnement
    if [[ ! " ${ENVIRONMENTS[@]} " =~ " ${environment} " ]]; then
        log "ERROR" "Environnement non valide: $environment"
        log "INFO" "Environnements disponibles: ${ENVIRONMENTS[*]}"
        exit 1
    fi
    
    # Banner de déploiement
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                           🚀 DÉPLOIEMENT MATH4CHILD                         ║
║                          Processus de déploiement avancé                    ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # Vérifications pré-déploiement
    log "INFO" "🔍 Vérifications pré-déploiement..."
    
    # Vérifier l'état Git
    if [ -d ".git" ]; then
        if ! git diff --quiet; then
            log "WARN" "Des modifications non commitées sont présentes"
            if [[ "$environment" == "production" ]]; then
                read -p "Continuer malgré les modifications non commitées? (yes/no): " confirm
                if [[ $confirm != "yes" ]]; then
                    log "INFO" "Déploiement annulé"
                    exit 0
                fi
            fi
        fi
        
        local current_branch=$(git branch --show-current)
        log "INFO" "Branche actuelle: $current_branch"
    fi
    
    # Vérifications des fichiers critiques
    local critical_files=(
        "package.json"
        "apps/math4child/package.json"
        "tests/package.json"
        "docker-compose.yml"
        "Dockerfile"
    )
    
    for file in "${critical_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log "ERROR" "Fichier critique manquant: $file"
            exit 1
        fi
    done
    
    # Vérification de l'environnement
    local env_file=".env"
    if [[ "$environment" != "development" ]]; then
        env_file=".env.${environment}"
    fi
    
    if [[ ! -f "$env_file" ]]; then
        log "ERROR" "Fichier d'environnement manquant: $env_file"
        log "INFO" "Créez le fichier à partir de .env.example"
        exit 1
    fi
    
    # Validation du fichier .env
    if ! ./scripts/generate-secrets.sh validate "$env_file"; then
        log "ERROR" "Configuration d'environnement invalide"
        exit 1
    fi
    
    # Installation des dépendances
    log "INFO" "📦 Installation des dépendances..."
    npm run install:all || {
        log "ERROR" "Échec de l'installation des dépendances"
        exit 1
    }
    
    # Tests (sauf si skip_tests=true)
    if [[ "$skip_tests" != "true" && "$environment" != "development" ]]; then
        log "INFO" "🧪 Exécution des tests..."
        
        # Tests unitaires
        log "INFO" "Tests unitaires..."
        npm run test --workspace=apps/math4child || {
            log "ERROR" "Les tests unitaires ont échoué"
            exit 1
        }
        
        # Tests E2E (seulement pour staging et production)
        if [[ "$environment" == "staging" || "$environment" == "production" ]]; then
            log "INFO" "Tests E2E..."
            npm run test:smoke --workspace=tests || {
                log "ERROR" "Les tests E2E ont échoué"
                exit 1
            }
        fi
    fi
    
    # Type checking
    log "INFO" "🔍 Vérification des types TypeScript..."
    npm run typecheck --workspace=apps/math4child || {
        log "ERROR" "Erreurs de types TypeScript détectées"
        exit 1
    }
    
    # Linting
    log "INFO" "🔍 Vérification du code..."
    npm run lint --workspace=apps/math4child || {
        log "ERROR" "Erreurs de linting détectées"
        exit 1
    }
    
    # Build de l'application
    log "INFO" "🔨 Construction de l'application..."
    npm run build --workspace=apps/math4child || {
        log "ERROR" "La construction a échoué"
        exit 1
    }
    
    # Déploiement selon l'environnement
    case $environment in
        "development")
            deploy_development
            ;;
        "staging")
            deploy_staging
            ;;
        "production")
            deploy_production
            ;;
    esac
    
    log "SUCCESS" "✅ Déploiement terminé avec succès!"
    
    # Post-déploiement
    post_deployment_tasks "$environment"
}

# Déploiement développement
deploy_development() {
    log "INFO" "🏃 Déploiement en mode développement..."
    
    # Arrêter les services existants
    docker-compose down
    
    # Construire et démarrer
    docker-compose up --build -d
    
    # Attendre que les services soient prêts
    log "INFO" "⏳ Attente du démarrage des services..."
    sleep 30
    
    # Vérifications de santé
    local services=(
        "app:3000/api/health"
        "postgres:5432"
        "redis:6379"
    )
    
    for service in "${services[@]}"; do
        local name=${service%%:*}
        local endpoint="http://localhost:${service#*:}"
        
        if [[ "$name" == "postgres" || "$name" == "redis" ]]; then
            continue  # Skip HTTP check for DB services
        fi
        
        if curl -f "$endpoint" > /dev/null 2>&1; then
            log "SUCCESS" "✅ $name opérationnel"
        else
            log "ERROR" "❌ $name non accessible"
            exit 1
        fi
    done
    
    # Exécuter les migrations
    log "INFO" "🗄️ Application des migrations..."
    ./scripts/migrate.sh up
    
    log "SUCCESS" "✅ Environnement de développement prêt"
    log "INFO" "🌐 Application accessible sur: http://localhost:3000"
}

# Déploiement staging
deploy_staging() {
    log "INFO" "🚀 Déploiement vers l'environnement de staging..."
    
    # Sauvegarde de la base de données
    log "INFO" "💾 Sauvegarde de la base de données staging..."
    ./scripts/backup-database.sh full
    
    # Build de l'image Docker avec tag staging
    local staging_tag="${DOCKER_IMAGE}:staging-$(date +%Y%m%d-%H%M%S)"
    local latest_staging_tag="${DOCKER_IMAGE}:staging-latest"
    
    log "INFO" "🔨 Construction de l'image Docker..."
    docker build -t "$staging_tag" -t "$latest_staging_tag" --target production .
    
    # Push vers le registry si configuré
    if [[ -n "${DOCKER_REGISTRY:-}" ]]; then
        log "INFO" "📤 Push vers le registry Docker..."
        docker push "$staging_tag"
        docker push "$latest_staging_tag"
    fi
    
    # Déploiement via docker-compose staging
    log "INFO" "🚀 Déploiement des services..."
    
    # Créer le fichier docker-compose.staging.yml si nécessaire
    if [[ ! -f "docker-compose.staging.yml" ]]; then
        create_staging_compose
    fi
    
    # Déployer
    docker-compose -f docker-compose.staging.yml down
    docker-compose -f docker-compose.staging.yml up -d
    
    # Migrations
    sleep 30
    log "INFO" "🗄️ Application des migrations..."
    docker-compose -f docker-compose.staging.yml exec -T app ./scripts/migrate.sh up
    
    # Vérification de santé
    local staging_url="https://staging.math4child.com"
    wait_for_service "$staging_url/api/health" 300
    
    if curl -f "$staging_url/api/health" > /dev/null 2>&1; then
        log "SUCCESS" "✅ Staging déployé avec succès"
        log "INFO" "🌐 Staging accessible sur: $staging_url"
    else
        log "ERROR" "❌ Erreur lors du déploiement staging"
        rollback_deployment "staging"
        exit 1
    fi
}

# Déploiement production
deploy_production() {
    log "INFO" "🌟 Déploiement vers la PRODUCTION..."
    
    # Confirmation de sécurité renforcée
    echo -e "${RED}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                             ⚠️  AVERTISSEMENT ⚠️                             ║
║                                                                              ║
║                      VOUS VOUS APPRÊTEZ À DÉPLOYER EN                       ║
║                              >>> PRODUCTION <<<                             ║
║                                                                              ║
║  Cette action affectera directement les utilisateurs en production.         ║
║  Assurez-vous que tous les tests ont été exécutés avec succès.              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    read -p "⚠️  Confirmez-vous le déploiement en PRODUCTION? Tapez 'DEPLOY PRODUCTION': " confirm
    if [[ $confirm != "DEPLOY PRODUCTION" ]]; then
        log "INFO" "Déploiement en production annulé"
        exit 0
    fi
    
    # Vérifications supplémentaires pour la production
    log "INFO" "🔐 Vérifications de sécurité supplémentaires..."
    
    # Vérifier que nous sommes sur la branche main/master
    if [ -d ".git" ]; then
        local current_branch=$(git branch --show-current)
        if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
            log "ERROR" "Production doit être déployée depuis main/master, branche actuelle: $current_branch"
            exit 1
        fi
    fi
    
    # Sauvegarde complète de la production
    log "INFO" "💾 Sauvegarde complète de la production..."
    ./scripts/backup-database.sh full
    
    # Backup des fichiers statiques si applicable
    if [[ -d "public" ]]; then
        local backup_files="backups/files/static_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf "$backup_files" public/
        log "INFO" "📦 Fichiers statiques sauvegardés: $backup_files"
    fi
    
    # Build avec optimisations de production
    local prod_tag="${DOCKER_IMAGE}:v${PROJECT_VERSION}-$(date +%Y%m%d-%H%M%S)"
    local latest_tag="${DOCKER_IMAGE}:latest"
    
    log "INFO" "🔨 Construction de l'image de production..."
    docker build \
        -t "$prod_tag" \
        -t "$latest_tag" \
        --target production \
        --build-arg NODE_ENV=production \
        --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
        --build-arg VCS_REF="$(git rev-parse HEAD)" \
        .
    
    # Tests de sécurité de l'image
    log "INFO" "🔒 Scan de sécurité de l'image..."
    if command -v trivy &> /dev/null; then
        trivy image --exit-code 1 --severity HIGH,CRITICAL "$prod_tag" || {
            log "ERROR" "Vulnérabilités critiques détectées dans l'image"
            exit 1
        }
    else
        log "WARN" "Trivy non installé, scan de sécurité ignoré"
    fi
    
    # Push vers le registry
    if [[ -n "${DOCKER_REGISTRY:-}" ]]; then
        log "INFO" "📤 Push vers le registry de production..."
        docker push "$prod_tag"
        docker push "$latest_tag"
    fi
    
    # Déploiement Blue-Green ou Rolling update
    if [[ "${DEPLOYMENT_STRATEGY:-rolling}" == "blue-green" ]]; then
        deploy_blue_green_production "$prod_tag"
    else
        deploy_rolling_production "$prod_tag"
    fi
    
    # Vérification post-déploiement
    local prod_url="https://www.math4child.com"
    wait_for_service "$prod_url/api/health" 600
    
    if curl -f "$prod_url/api/health" > /dev/null 2>&1; then
        log "SUCCESS" "🎉 PRODUCTION DÉPLOYÉE AVEC SUCCÈS!"
        log "INFO" "🌐 Production accessible sur: $prod_url"
        
        # Tests de smoke en production
        run_production_smoke_tests "$prod_url"
        
        # Notification de succès
        send_deployment_notification "production" "success"
    else
        log "ERROR" "❌ ÉCHEC DU DÉPLOIEMENT PRODUCTION"
        rollback_deployment "production"
        send_deployment_notification "production" "failure"
        exit 1
    fi
}

# Déploiement Rolling pour la production
deploy_rolling_production() {
    local image_tag="$1"
    
    log "INFO" "🔄 Déploiement Rolling en production..."
    
    # Mise à jour progressive avec docker-compose
    export MATH4CHILD_IMAGE="$image_tag"
    
    # Scale up avec la nouvelle version
    docker-compose -f docker-compose.production.yml up -d --scale app=3
    
    # Attendre que les nouveaux containers soient prêts
    sleep 60
    
    # Vérifier que les nouveaux services répondent
    local health_checks=0
    for i in {1..30}; do
        if curl -f "https://www.math4child.com/api/health" > /dev/null 2>&1; then
            ((health_checks++))
            if [ $health_checks -ge 3 ]; then
                break
            fi
        fi
        sleep 10
    done
    
    if [ $health_checks -lt 3 ]; then
        log "ERROR" "Les nouveaux services ne répondent pas correctement"
        return 1
    fi
    
    # Arrêter les anciens containers
    docker-compose -f docker-compose.production.yml up -d --scale app=2
    sleep 30
    docker-compose -f docker-compose.production.yml up -d --scale app=1
    
    log "SUCCESS" "✅ Déploiement Rolling terminé"
}

# Utilitaires de déploiement
wait_for_service() {
    local url="$1"
    local timeout=${2:-300}
    local counter=0
    
    log "INFO" "⏳ Attente de la disponibilité de $url..."
    
    while [ $counter -lt $timeout ]; do
        if curl -f "$url" > /dev/null 2>&1; then
            log "SUCCESS" "✅ Service disponible après ${counter}s"
            return 0
        fi
        
        sleep 5
        counter=$((counter + 5))
        
        if [ $((counter % 30)) -eq 0 ]; then
            log "INFO" "Attente... ${counter}s/${timeout}s"
        fi
    done
    
    log "ERROR" "❌ Timeout: Service non disponible après ${timeout}s"
    return 1
}

# Tests de smoke en production
run_production_smoke_tests() {
    local base_url="$1"
    
    log "INFO" "🔥 Exécution des tests de smoke en production..."
    
    local tests=(
        "$base_url/"
        "$base_url/api/health"
        "$base_url/api/status"
    )
    
    local failed_tests=0
    
    for test_url in "${tests[@]}"; do
        if curl -f "$test_url" > /dev/null 2>&1; then
            log "SUCCESS" "✅ Test smoke réussi: $test_url"
        else
            log "ERROR" "❌ Test smoke échoué: $test_url"
            ((failed_tests++))
        fi
    done
    
    if [ $failed_tests -eq 0 ]; then
        log "SUCCESS" "✅ Tous les tests de smoke ont réussi"
    else
        log "ERROR" "❌ $failed_tests test(s) de smoke ont échoué"
        return 1
    fi
}

# Rollback de déploiement
rollback_deployment() {
    local environment="$1"
    
    log "INFO" "🔄 Rollback du déploiement $environment..."
    
    case $environment in
        "staging")
            rollback_staging
            ;;
        "production")
            rollback_production
            ;;
        *)
            log "ERROR" "Rollback non supporté pour l'environnement: $environment"
            return 1
            ;;
    esac
}

# Rollback staging
rollback_staging() {
    log "INFO" "🔄 Rollback staging en cours..."
    
    # Récupérer la dernière version stable
    local last_stable=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "staging" | head -2 | tail -1)
    
    if [[ -z "$last_stable" ]]; then
        log "ERROR" "Aucune version stable trouvée pour le rollback"
        return 1
    fi
    
    log "INFO" "📦 Rollback vers: $last_stable"
    
    # Redéployer la version précédente
    export MATH4CHILD_IMAGE="$last_stable"
    docker-compose -f docker-compose.staging.yml down
    docker-compose -f docker-compose.staging.yml up -d
    
    # Vérification
    sleep 30
    if curl -f "https://staging.math4child.com/api/health" > /dev/null 2>&1; then
        log "SUCCESS" "✅ Rollback staging terminé"
    else
        log "ERROR" "❌ Échec du rollback staging"
        return 1
    fi
}

# Rollback production
rollback_production() {
    log "INFO" "🔄 ROLLBACK PRODUCTION EN COURS..."
    
    echo -e "${YELLOW}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                          ⚠️  ROLLBACK PRODUCTION ⚠️                          ║
║                                                                              ║
║        Un rollback de production est en cours. Cela peut prendre            ║
║                    plusieurs minutes. Restez connecté.                      ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # Récupérer la version précédente stable
    local last_stable=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -E "v[0-9]+\.[0-9]+\.[0-9]+" | head -2 | tail -1)
    
    if [[ -z "$last_stable" ]]; then
        log "ERROR" "Aucune version stable trouvée pour le rollback"
        
        # Rollback vers la sauvegarde de base de données
        log "INFO" "🗄️ Restauration de la dernière sauvegarde..."
        local latest_backup=$(find backups/database -name "*.sql.gz" -type f | sort -r | head -1)
        if [[ -n "$latest_backup" ]]; then
            ./scripts/backup-database.sh restore "$latest_backup"
        fi
        return 1
    fi
    
    log "INFO" "📦 Rollback production vers: $last_stable"
    
    # Rollback rapide avec zero-downtime
    export MATH4CHILD_IMAGE="$last_stable"
    
    # Scale up avec l'ancienne version
    docker-compose -f docker-compose.production.yml up -d --scale app=2
    sleep 60
    
    # Vérifier que l'ancienne version fonctionne
    local rollback_success=false
    for i in {1..10}; do
        if curl -f "https://www.math4child.com/api/health" > /dev/null 2>&1; then
            rollback_success=true
            break
        fi
        sleep 10
    done
    
    if [ "$rollback_success" = true ]; then
        # Scale down la nouvelle version défaillante
        docker-compose -f docker-compose.production.yml up -d --scale app=1
        log "SUCCESS" "✅ ROLLBACK PRODUCTION TERMINÉ"
    else
        log "ERROR" "❌ ÉCHEC DU ROLLBACK PRODUCTION"
        return 1
    fi
}

# Tâches post-déploiement
post_deployment_tasks() {
    local environment="$1"
    
    log "INFO" "🔧 Exécution des tâches post-déploiement..."
    
    # Nettoyer les anciennes images Docker
    log "INFO" "🧹 Nettoyage des anciennes images..."
    docker image prune -f
    
    # Logs de déploiement
    local deployment_log="logs/deployment_${environment}_$(date +%Y%m%d_%H%M%S).log"
    echo "Déploiement $environment terminé le $(date)" >> "$deployment_log"
    echo "Version: $PROJECT_VERSION" >> "$deployment_log"
    echo "Commit: $(git rev-parse HEAD 2>/dev/null || echo 'N/A')" >> "$deployment_log"
    
    # Mise à jour des métriques si en production
    if [[ "$environment" == "production" ]]; then
        update_deployment_metrics
    fi
    
    # Démarrer le monitoring si pas déjà fait
    if [[ "$environment" != "development" ]]; then
        ./scripts/start-monitoring.sh start
    fi
    
    log "SUCCESS" "✅ Tâches post-déploiement terminées"
}

# Mise à jour des métriques de déploiement
update_deployment_metrics() {
    log "INFO" "📊 Mise à jour des métriques de déploiement..."
    
    # Exemple d'envoi de métrique à Prometheus
    if command -v curl &> /dev/null; then
        curl -X POST http://localhost:9091/metrics/job/math4child_deployment \
             -d "deployment_timestamp $(date +%s)" \
             -d "deployment_version{version=\"$PROJECT_VERSION\"} 1" \
             > /dev/null 2>&1 || true
    fi
}

# Notifications de déploiement
send_deployment_notification() {
    local environment="$1"
    local status="$2"
    
    local emoji="🚀"
    local color="good"
    
    if [[ "$status" == "failure" ]]; then
        emoji="❌"
        color="danger"
    elif [[ "$status" == "success" ]]; then
        emoji="✅"
        color="good"
    fi
    
    local message="$emoji Déploiement Math4Child $environment: $status"
    
    # Slack webhook si configuré
    if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
        curl -X POST -H 'Content-type: application/json' \
             --data "{\"text\":\"$message\", \"color\":\"$color\"}" \
             "$SLACK_WEBHOOK_URL" > /dev/null 2>&1 || true
    fi
    
    # Discord webhook si configuré
    if [[ -n "${DISCORD_WEBHOOK_URL:-}" ]]; then
        curl -X POST -H 'Content-type: application/json' \
             --data "{\"content\":\"$message\"}" \
             "$DISCORD_WEBHOOK_URL" > /dev/null 2>&1 || true
    fi
    
    # Email si configuré
    if [[ -n "${NOTIFICATION_EMAIL:-}" ]] && command -v mail &> /dev/null; then
        echo "$message - Version: $PROJECT_VERSION - Date: $(date)" | \
        mail -s "Math4Child Deployment $environment" "$NOTIFICATION_EMAIL" || true
    fi
}

# Créer le docker-compose pour staging
create_staging_compose() {
    log "INFO" "📝 Création du fichier docker-compose.staging.yml..."
    
    cat > docker-compose.staging.yml << 'EOF'
version: '3.8'

services:
  app:
    image: ${MATH4CHILD_IMAGE:-math4child/app:staging-latest}
    container_name: math4child-staging-app
    restart: always
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=staging
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
      - NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
      - NEXTAUTH_URL=https://staging.math4child.com
    depends_on:
      - postgres
      - redis
    networks:
      - math4child-staging
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  postgres:
    image: postgres:16-alpine
    container_name: math4child-staging-postgres
    restart: always
    environment:
      POSTGRES_DB: ${DB_NAME:-math4child_staging}
      POSTGRES_USER: ${DB_USER:-math4child_user}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_staging_data:/var/lib/postgresql/data
    networks:
      - math4child-staging

  redis:
    image: redis:7-alpine
    container_name: math4child-staging-redis
    restart: always
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_staging_data:/data
    networks:
      - math4child-staging

  nginx:
    image: nginx:alpine
    container_name: math4child-staging-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./infrastructure/nginx/staging.conf:/etc/nginx/nginx.conf:ro
      - ./certificates:/etc/nginx/certificates:ro
    depends_on:
      - app
    networks:
      - math4child-staging

volumes:
  postgres_staging_data:
  redis_staging_data:

networks:
  math4child-staging:
    driver: bridge
EOF
}

# Script de santé système
check_system_health() {
    log "INFO" "🏥 Vérification de la santé du système..."
    
    local issues=0
    
    # Vérifier l'espace disque
    local disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 85 ]; then
        log "WARN" "⚠️ Espace disque faible: ${disk_usage}%"
        ((issues++))
    else
        log "SUCCESS" "✅ Espace disque OK: ${disk_usage}%"
    fi
    
    # Vérifier la mémoire
    local mem_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
    if [ "$mem_usage" -gt 90 ]; then
        log "WARN" "⚠️ Utilisation mémoire élevée: ${mem_usage}%"
        ((issues++))
    else
        log "SUCCESS" "✅ Mémoire OK: ${mem_usage}%"
    fi
    
    # Vérifier les services Docker
    local docker_services=(
        "math4child-app"
        "math4child-postgres"
        "math4child-redis"
    )
    
    for service in "${docker_services[@]}"; do
        if docker ps --filter "name=$service" --filter "status=running" | grep -q "$service"; then
            log "SUCCESS" "✅ Service $service opérationnel"
        else
            log "WARN" "⚠️ Service $service non opérationnel"
            ((issues++))
        fi
    done
    
    # Vérifier la connectivité réseau
    if ping -c 1 google.com > /dev/null 2>&1; then
        log "SUCCESS" "✅ Connectivité réseau OK"
    else
        log "WARN" "⚠️ Problème de connectivité réseau"
        ((issues++))
    fi
    
    # Résumé
    if [ $issues -eq 0 ]; then
        log "SUCCESS" "🎉 Système en parfaite santé!"
        return 0
    else
        log "WARN" "⚠️ $issues problème(s) détecté(s)"
        return 1
    fi
}

# Maintenance et nettoyage
maintenance() {
    log "INFO" "🔧 Démarrage de la maintenance système..."
    
    # Nettoyage Docker
    log "INFO" "🐳 Nettoyage Docker..."
    docker system prune -f
    docker volume prune -f
    
    # Nettoyage des logs anciens
    log "INFO" "📝 Nettoyage des logs anciens..."
    find logs/ -name "*.log" -mtime +30 -delete 2>/dev/null || true
    
    # Nettoyage des sauvegardes anciennes
    log "INFO" "💾 Nettoyage des anciennes sauvegardes..."
    ./scripts/backup-database.sh cleanup 30
    
    # Nettoyage des builds
    log "INFO" "🗑️ Nettoyage des builds..."
    npm run clean --workspace=apps/math4child 2>/dev/null || true
    npm run clean --workspace=tests 2>/dev/null || true
    
    # Mise à jour des dépendances de sécurité
    log "INFO" "🔒 Vérification des vulnérabilités..."
    npm audit fix --workspace=apps/math4child || true
    
    log "SUCCESS" "✅ Maintenance terminée"
}

# Menu principal et aide
show_help() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    📚 MATH4CHILD - AIDE DU SCRIPT DE DÉPLOIEMENT            ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "Usage: $0 [COMMANDE] [OPTIONS]"
    echo ""
    echo "🚀 COMMANDES PRINCIPALES:"
    echo "  setup                    Configuration initiale complète du projet"
    echo "  deploy [ENV]            Déploiement vers un environnement (dev/staging/prod)"
    echo "  rollback [ENV]          Rollback vers la version précédente"
    echo "  health                  Vérification de la santé du système"
    echo "  maintenance             Maintenance et nettoyage du système"
    echo ""
    echo "🔧 COMMANDES DE DÉVELOPPEMENT:"
    echo "  init                    Initialisation du projet seulement"
    echo "  deps                    Installation des dépendances"
    echo "  build                   Construction de l'application"
    echo "  test                    Exécution de tous les tests"
    echo "  start                   Démarrage en mode développement"
    echo "  stop                    Arrêt des services"
    echo ""
    echo "📊 COMMANDES D'INFRASTRUCTURE:"
    echo "  docker:build            Construction des images Docker"
    echo "  docker:push             Push des images vers le registry"
    echo "  monitoring:start        Démarrage du monitoring"
    echo "  monitoring:stop         Arrêt du monitoring"
    echo ""
    echo "🗄️ COMMANDES DE BASE DE DONNÉES:"
    echo "  db:migrate              Application des migrations"
    echo "  db:backup               Sauvegarde de la base de données"
    echo "  db:restore [FILE]       Restauration d'une sauvegarde"
    echo "  db:reset                Réinitialisation complète"
    echo ""
    echo "🔐 COMMANDES DE SÉCURITÉ:"
    echo "  secrets:generate        Génération de nouveaux secrets"
    echo "  secrets:validate        Validation des variables d'environnement"
    echo "  security:scan           Scan de sécurité complet"
    echo ""
    echo "📝 ENVIRONNEMENTS SUPPORTÉS:"
    echo "  development (dev)       Développement local"
    echo "  staging                 Environnement de test"
    echo "  production (prod)       Production"
    echo ""
    echo "💡 EXEMPLES D'UTILISATION:"
    echo "  $0 setup                          # Configuration initiale"
    echo "  $0 deploy development            # Déploiement local"
    echo "  $0 deploy staging                # Déploiement staging"
    echo "  $0 deploy production             # Déploiement production"
    echo "  $0 rollback production           # Rollback production"
    echo "  $0 db:backup                     # Sauvegarde BDD"
    echo "  $0 monitoring:start              # Démarrer monitoring"
    echo "  $0 health                        # Vérifier la santé"
    echo ""
    echo "🆘 AIDE ET SUPPORT:"
    echo "  $0 help                          # Afficher cette aide"
    echo "  $0 version                       # Version du script"
    echo "  $0 info                          # Informations système"
    echo ""
    echo "📖 Documentation complète: https://docs.math4child.com/deployment"
}

# Informations système
show_info() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                           ℹ️  INFORMATIONS SYSTÈME                           ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "📦 Projet: $PROJECT_NAME v$PROJECT_VERSION"
    echo "🌐 Domaine: $DOMAIN"
    echo "📅 Date: $(date)"
    echo "👤 Utilisateur: $(whoami)"
    echo "💻 Système: $(uname -s) $(uname -r)"
    echo "🏠 Répertoire: $PROJECT_ROOT"
    echo ""
    
    if command -v node &> /dev/null; then
        echo "🟢 Node.js: $(node --version)"
    else
        echo "🔴 Node.js: Non installé"
    fi
    
    if command -v npm &> /dev/null; then
        echo "🟢 npm: $(npm --version)"
    else
        echo "🔴 npm: Non installé"
    fi
    
    if command -v docker &> /dev/null; then
        echo "🟢 Docker: $(docker --version | cut -d' ' -f3 | tr -d ',')"
    else
        echo "🔴 Docker: Non installé"
    fi
    
    if command -v git &> /dev/null; then
        echo "🟢 Git: $(git --version | cut -d' ' -f3)"
        if [ -d ".git" ]; then
            echo "🌿 Branche: $(git branch --show-current)"
            echo "📝 Commit: $(git rev-parse --short HEAD)"
        fi
    else
        echo "🔴 Git: Non installé"
    fi
    echo ""
}

# Version du script
show_version() {
    echo "Math4Child Deployment Script v$PROJECT_VERSION"
    echo "Build date: $(date)"
    echo "Author: Math4Child Development Team"
}

#===============================================================================
# POINT D'ENTRÉE PRINCIPAL
#===============================================================================

main() {
    # Vérifier les arguments
    if [[ $# -eq 0 ]]; then
        show_banner
        show_help
        exit 0
    fi
    
    local command="$1"
    shift || true
    
    # Router les commandes
    case "$command" in
        # Commandes principales
        "setup")
            show_banner
            check_prerequisites
            create_directory_structure
            init_project
            setup_nextjs_app
            setup_playwright_tests
            setup_docker
            setup_database
            setup_monitoring
            setup_environment
            log "SUCCESS" "🎉 Setup complet de Math4Child terminé!"
            log "INFO" "📖 Consultez le README.md pour les prochaines étapes"
            ;;
        "deploy")
            deploy "$@"
            ;;
        "rollback")
            rollback_deployment "$1"
            ;;
        "health"|"check")
            check_system_health
            ;;
        "maintenance"|"clean")
            maintenance
            ;;
            
        # Commandes de développement
        "init")
            check_prerequisites
            create_directory_structure
            init_project
            ;;
        "deps"|"install")
            npm run install:all
            ;;
        "build")
            npm run build --workspace=apps/math4child
            ;;
        "test")
            npm run test --workspace=tests
            ;;
        "start"|"dev")
            docker-compose up -d
            ;;
        "stop")
            docker-compose down
            ;;
            
        # Commandes Docker
        "docker:build")
            docker build -t "$DOCKER_IMAGE:latest" .
            ;;
        "docker:push")
            docker push "$DOCKER_IMAGE:latest"
            ;;
            
        # Commandes de monitoring
        "monitoring:start")
            ./scripts/start-monitoring.sh start
            ;;
        "monitoring:stop")
            ./scripts/start-monitoring.sh stop
            ;;
            
        # Commandes de base de données
        "db:migrate")
            ./scripts/migrate.sh up
            ;;
        "db:backup")
            ./scripts/backup-database.sh full
            ;;
        "db:restore")
            ./scripts/backup-database.sh restore "$1"
            ;;
        "db:reset")
            ./scripts/migrate.sh reset
            ;;
            
        # Commandes de sécurité
        "secrets:generate")
            ./scripts/generate-secrets.sh generate
            ;;
        "secrets:validate")
            ./scripts/generate-secrets.sh validate "$1"
            ;;
        "security:scan")
            log "INFO" "🔒 Scan de sécurité en cours..."
            npm audit --workspace=apps/math4child
            ;;
            
        # Informations
        "help"|"-h"|"--help")
            show_help
            ;;
        "version"|"-v"|"--version")
            show_version
            ;;
        "info")
            show_info
            ;;
            
        # Commande inconnue
        *)
            log "ERROR" "Commande inconnue: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Gestion des signaux
trap 'log "WARN" "Script interrompu par l'\''utilisateur"; exit 130' INT
trap 'log "ERROR" "Script terminé de manière inattendue"; exit 1' ERR

# Exécution du script principal
main "$@"    
    # Script de migration de base de données
    cat > scripts/migrate.sh << 'EOF'
#!/bin/bash
# Script de migration de base de données pour Math4Child

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MIGRATIONS_DIR="$PROJECT_ROOT/database/migrations"
DB_CONTAINER="math4child-postgres"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARN: $1${NC}"
}

# Vérifier que Docker est en marche
check_docker() {
    if ! docker ps > /dev/null 2>&1; then
        error "Docker n'est pas accessible. Assurez-vous que Docker est démarré."
        exit 1
    fi
}

# Vérifier que le container PostgreSQL est en marche
check_postgres() {
    if ! docker ps --filter "name=$DB_CONTAINER" --filter "status=running" | grep -q "$DB_CONTAINER"; then
        error "Le container PostgreSQL '$DB_CONTAINER' n'est pas en marche."
        log "Démarrage du container PostgreSQL..."
        docker-compose up -d postgres
        sleep 10
    fi
}

# Exécuter une commande SQL
execute_sql() {
    local sql="$1"
    docker exec -i "$DB_CONTAINER" psql -U math4child_user -d math4child_db -c "$sql"
}

# Exécuter un fichier SQL
execute_sql_file() {
    local file="$1"
    docker exec -i "$DB_CONTAINER" psql -U math4child_user -d math4child_db < "$file"
}

# Obtenir la version actuelle de la base de données
get_current_version() {
    local version
    version=$(execute_sql "SELECT version FROM schema_migrations ORDER BY version DESC LIMIT 1;" 2>/dev/null | sed -n '3p' | tr -d ' ')
    echo "${version:-000}"
}

# Marquer une migration comme appliquée
mark_migration_applied() {
    local version="$1"
    execute_sql "INSERT INTO schema_migrations (version) VALUES ('$version') ON CONFLICT (version) DO NOTHING;"
}

# Supprimer une version de migration
remove_migration_version() {
    local version="$1"
    execute_sql "DELETE FROM schema_migrations WHERE version = '$version';"
}

# Lister les migrations disponibles
list_migrations() {
    log "Migrations disponibles:"
    if [ -d "$MIGRATIONS_DIR" ]; then
        find "$MIGRATIONS_DIR" -name "*.sql" -type f | sort | while read -r file; do
            basename="$(basename "$file" .sql)"
            version="${basename%_*}"
            name="${basename#*_}"
            echo "  $version - $name"
        done
    else
        warn "Aucun répertoire de migrations trouvé: $MIGRATIONS_DIR"
    fi
}

# Appliquer les migrations
migrate_up() {
    check_docker
    check_postgres
    
    log "🔄 Début des migrations vers le haut..."
    
    current_version=$(get_current_version)
    log "Version actuelle: $current_version"
    
    if [ ! -d "$MIGRATIONS_DIR" ]; then
        warn "Aucun répertoire de migrations trouvé. Création..."
        mkdir -p "$MIGRATIONS_DIR"
    fi
    
    applied_count=0
    
    # Appliquer toutes les migrations non appliquées
    find "$MIGRATIONS_DIR" -name "*.sql" -type f | sort | while read -r migration_file; do
        basename="$(basename "$migration_file" .sql)"
        version="${basename%_*}"
        name="${basename#*_}"
        
        if [[ "$version" > "$current_version" ]]; then
            log "📦 Application de la migration: $version - $name"
            
            if execute_sql_file "$migration_file"; then
                mark_migration_applied "$version"
                log "✅ Migration $version appliquée avec succès"
                ((applied_count++))
            else
                error "❌ Échec de la migration $version"
                exit 1
            fi
        fi
    done
    
    if [ $applied_count -eq 0 ]; then
        log "✅ Aucune nouvelle migration à appliquer"
    else
        log "✅ $applied_count migration(s) appliquée(s) avec succès"
    fi
}

# Annuler la dernière migration
migrate_down() {
    check_docker
    check_postgres
    
    log "🔄 Annulation de la dernière migration..."
    
    current_version=$(get_current_version)
    
    if [ "$current_version" = "000" ] || [ -z "$current_version" ]; then
        warn "Aucune migration à annuler"
        return 0
    fi
    
    log "Version actuelle: $current_version"
    
    # Chercher le fichier de rollback
    rollback_file="$MIGRATIONS_DIR/${current_version}_rollback.sql"
    
    if [ -f "$rollback_file" ]; then
        log "📦 Exécution du rollback: $current_version"
        
        if execute_sql_file "$rollback_file"; then
            remove_migration_version "$current_version"
            log "✅ Rollback $current_version effectué avec succès"
        else
            error "❌ Échec du rollback $current_version"
            exit 1
        fi
    else
        warn "Aucun fichier de rollback trouvé pour la version $current_version"
        warn "Suppression manuelle de la version de la table des migrations"
        remove_migration_version "$current_version"
    fi
}

# Réinitialiser complètement la base de données
migrate_reset() {
    check_docker
    check_postgres
    
    log "🔄 Réinitialisation complète de la base de données..."
    
    read -p "⚠️ Êtes-vous sûr de vouloir réinitialiser toute la base de données? (yes/no): " confirm
    if [[ $confirm != "yes" ]]; then
        log "Réinitialisation annulée"
        return 0
    fi
    
    # Supprimer et recréer la base de données
    execute_sql "DROP SCHEMA IF EXISTS math4child CASCADE;"
    execute_sql "DROP SCHEMA IF EXISTS public CASCADE;"
    execute_sql "CREATE SCHEMA public;"
    execute_sql "CREATE SCHEMA math4child;"
    
    # Réappliquer le script d'initialisation
    if [ -f "$PROJECT_ROOT/database/init.sql" ]; then
        log "📦 Réapplication du script d'initialisation"
        execute_sql_file "$PROJECT_ROOT/database/init.sql"
    fi
    
    log "✅ Base de données réinitialisée avec succès"
}

# Afficher le statut des migrations
migrate_status() {
    check_docker
    check_postgres
    
    log "📊 Statut des migrations:"
    
    current_version=$(get_current_version)
    log "Version actuelle: $current_version"
    
    # Afficher les migrations appliquées
    log "\nMigrations appliquées:"
    execute_sql "SELECT version, applied_at FROM schema_migrations ORDER BY version;" | tail -n +3 | head -n -2
    
    # Afficher les migrations en attente
    log "\nMigrations en attente:"
    if [ -d "$MIGRATIONS_DIR" ]; then
        find "$MIGRATIONS_DIR" -name "*.sql" -type f | sort | while read -r migration_file; do
            basename="$(basename "$migration_file" .sql)"
            version="${basename%_*}"
            name="${basename#*_}"
            
            if [[ "$version" > "$current_version" ]]; then
                echo "  $version - $name"
            fi
        done
    fi
}

# Générer une nouvelle migration
generate_migration() {
    local migration_name="$1"
    
    if [ -z "$migration_name" ]; then
        error "Nom de la migration requis"
        echo "Usage: $0 generate <nom_de_la_migration>"
        exit 1
    fi
    
    # Générer un numéro de version
    local timestamp=$(date +%Y%m%d%H%M%S)
    local version="${timestamp}"
    local filename="${version}_${migration_name}.sql"
    local filepath="$MIGRATIONS_DIR/$filename"
    
    mkdir -p "$MIGRATIONS_DIR"
    
    # Créer le fichier de migration
    cat > "$filepath" << EOF
-- Migration: $migration_name
-- Version: $version
-- Date: $(date '+%Y-%m-%d %H:%M:%S')

BEGIN;

-- Ajoutez vos changements de schéma ici


-- Enregistrer la version
INSERT INTO schema_migrations (version) VALUES ('$version');

COMMIT;
EOF
    
    # Créer le fichier de rollback
    local rollback_filepath="$MIGRATIONS_DIR/${version}_rollback.sql"
    cat > "$rollback_filepath" << EOF
-- Rollback pour: $migration_name
-- Version: $version
-- Date: $(date '+%Y-%m-%d %H:%M:%S')

BEGIN;

-- Ajoutez vos changements de rollback ici


COMMIT;
EOF
    
    log "✅ Migration générée: $filepath"
    log "✅ Rollback généré: $rollback_filepath"
}

# Menu principal
case "${1:-}" in
    "up"|"migrate")
        migrate_up
        ;;
    "down"|"rollback")
        migrate_down
        ;;
    "reset")
        migrate_reset
        ;;
    "status")
        migrate_status
        ;;
    "list")
        list_migrations
        ;;
    "generate")
        generate_migration "$2"
        ;;
    *)
        echo "Usage: $0 {up|down|reset|status|list|generate}"
        echo ""
        echo "Commandes:"
        echo "  up        Appliquer toutes les migrations en attente"
        echo "  down      Annuler la dernière migration"
        echo "  reset     Réinitialiser complètement la base de données"
        echo "  status    Afficher le statut des migrations"
        echo "  list      Lister toutes les migrations disponibles"
        echo "  generate  Générer une nouvelle migration"
        echo ""
        echo "Exemples:"
        echo "  $0 up"
        echo "  $0 generate add_user_preferences"
        echo "  $0 status"
        exit 1
        ;;
esac
EOF
    
    chmod +x scripts/migrate.sh
    
    # Exemple de migration
    mkdir -p database/migrations
    cat > database/migrations/002_add_user_preferences.sql << 'EOF'
-- Migration: Ajouter les préférences utilisateur étendues
-- Version: 002
-- Date: 2024-01-15 10:00:00

BEGIN;

-- Ajouter des colonnes de préférences étendues à la table users
ALTER TABLE users ADD COLUMN IF NOT EXISTS theme_preference VARCHAR(20) DEFAULT 'light' CHECK (theme_preference IN ('light', 'dark', 'auto'));
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_email BOOLEAN DEFAULT true;
ALTER TABLE users ADD COLUMN IF NOT EXISTS notification_push BOOLEAN DEFAULT false;
ALTER TABLE users ADD COLUMN IF NOT EXISTS privacy_analytics BOOLEAN DEFAULT true;

-- Ajouter des colonnes de configuration pour les profils enfants
ALTER TABLE child_profiles ADD COLUMN IF NOT EXISTS daily_goal_minutes INTEGER DEFAULT 15 CHECK (daily_goal_minutes >= 5 AND daily_goal_minutes <= 120);
ALTER TABLE child_profiles ADD COLUMN IF NOT EXISTS sound_enabled BOOLEAN DEFAULT true;
ALTER TABLE child_profiles ADD COLUMN IF NOT EXISTS animation_enabled BOOLEAN DEFAULT true;
ALTER TABLE child_profiles ADD COLUMN IF NOT EXISTS difficulty_auto_adjust BOOLEAN DEFAULT true;

-- Index pour les nouvelles colonnes
CREATE INDEX IF NOT EXISTS idx_users_theme ON users(theme_preference);
CREATE INDEX IF NOT EXISTS idx_child_profiles_daily_goal ON child_profiles(daily_goal_minutes);

-- Enregistrer la version
INSERT INTO schema_migrations (version) VALUES ('002');

COMMIT;
EOF
    
    cat > database/migrations/002_rollback.sql << 'EOF'
-- Rollback pour: Ajouter les préférences utilisateur étendues
-- Version: 002
-- Date: 2024-01-15 10:00:00

BEGIN;

-- Supprimer les colonnes ajoutées
ALTER TABLE users DROP COLUMN IF EXISTS theme_preference;
ALTER TABLE users DROP COLUMN IF EXISTS notification_email;
ALTER TABLE users DROP COLUMN IF EXISTS notification_push;
ALTER TABLE users DROP COLUMN IF EXISTS privacy_analytics;

ALTER TABLE child_profiles DROP COLUMN IF EXISTS daily_goal_minutes;
ALTER TABLE child_profiles DROP COLUMN IF EXISTS sound_enabled;
ALTER TABLE child_profiles DROP COLUMN IF EXISTS animation_enabled;
ALTER TABLE child_profiles DROP COLUMN IF EXISTS difficulty_auto_adjust;

-- Supprimer les index
DROP INDEX IF EXISTS idx_users_theme;
DROP INDEX IF EXISTS idx_child_profiles_daily_goal;

COMMIT;
EOF
    
    # Script de sauvegarde avancé
    cat > scripts/backup-database.sh << 'EOF'
#!/bin/bash
# Script de sauvegarde avancé pour Math4Child

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_ROOT/backups/database"
DB_CONTAINER="math4child-postgres"
DB_NAME="math4child_db"
DB_USER="math4child_user"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARN: $1${NC}"
}

# Vérifier les prérequis
check_prerequisites() {
    if ! docker ps --filter "name=$DB_CONTAINER" --filter "status=running" | grep -q "$DB_CONTAINER"; then
        error "Le container PostgreSQL '$DB_CONTAINER' n'est pas en marche."
        exit 1
    fi
    
    mkdir -p "$BACKUP_DIR"
}

# Sauvegarde complète
backup_full() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/full_backup_${timestamp}.sql"
    local backup_file_gz="${backup_file}.gz"
    
    log "🔄 Début de la sauvegarde complète..."
    
    # Créer la sauvegarde
    if docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" --verbose > "$backup_file"; then
        log "📦 Sauvegarde créée: $backup_file"
        
        # Compresser
        gzip "$backup_file"
        log "🗜️ Sauvegarde compressée: $backup_file_gz"
        
        # Calculer la taille
        local size=$(du -h "$backup_file_gz" | cut -f1)
        log "📊 Taille de la sauvegarde: $size"
        
        # Tester l'intégrité
        if gunzip -t "$backup_file_gz"; then
            log "✅ Sauvegarde vérifiée avec succès"
        else
            error "❌ Erreur d'intégrité de la sauvegarde"
            exit 1
        fi
        
    else
        error "❌ Échec de la création de la sauvegarde"
        exit 1
    fi
}

# Sauvegarde des données uniquement
backup_data_only() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/data_backup_${timestamp}.sql"
    local backup_file_gz="${backup_file}.gz"
    
    log "🔄 Début de la sauvegarde des données..."
    
    if docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" --data-only --verbose > "$backup_file"; then
        gzip "$backup_file"
        log "✅ Sauvegarde des données créée: $backup_file_gz"
    else
        error "❌ Échec de la sauvegarde des données"
        exit 1
    fi
}

# Sauvegarde du schéma uniquement
backup_schema_only() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$BACKUP_DIR/schema_backup_${timestamp}.sql"
    local backup_file_gz="${backup_file}.gz"
    
    log "🔄 Début de la sauvegarde du schéma..."
    
    if docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" -d "$DB_NAME" --schema-only --verbose > "$backup_file"; then
        gzip "$backup_file"
        log "✅ Sauvegarde du schéma créée: $backup_file_gz"
    else
        error "❌ Échec de la sauvegarde du schéma"
        exit 1
    fi
}

# Restaurer une sauvegarde
restore_backup() {
    local backup_file="$1"
    
    if [ -z "$backup_file" ]; then
        error "Fichier de sauvegarde requis"
        echo "Usage: $0 restore <fichier_de_sauvegarde>"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        error "Fichier de sauvegarde non trouvé: $backup_file"
        exit 1
    fi
    
    log "🔄 Début de la restauration..."
    warn "⚠️ Cette opération va écraser toutes les données existantes"
    
    read -p "Êtes-vous sûr de vouloir continuer? (yes/no): " confirm
    if [[ $confirm != "yes" ]]; then
        log "Restauration annulée"
        return 0
    fi
    
    # Décompresser si nécessaire
    local sql_file="$backup_file"
    if [[ "$backup_file" == *.gz ]]; then
        sql_file="${backup_file%.gz}"
        if [ ! -f "$sql_file" ]; then
            log "📦 Décompression de la sauvegarde..."
            gunzip -k "$backup_file"
        fi
    fi
    
    # Restaurer
    if docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$sql_file"; then
        log "✅ Restauration terminée avec succès"
    else
        error "❌ Échec de la restauration"
        exit 1
    fi
}

# Lister les sauvegardes
list_backups() {
    log "📋 Sauvegardes disponibles:"
    
    if [ -d "$BACKUP_DIR" ]; then
        find "$BACKUP_DIR" -name "*.sql.gz" -type f -printf "%T@ %p\n" | sort -nr | head -20 | while read -r timestamp file; do
            local date_str=$(date -d "@$timestamp" '+%Y-%m-%d %H:%M:%S')
            local size=$(du -h "$file" | cut -f1)
            local basename=$(basename "$file")
            echo "  $date_str - $basename ($size)"
        done
    else
        warn "Aucun répertoire de sauvegardes trouvé"
    fi
}

# Nettoyer les anciennes sauvegardes
cleanup_old_backups() {
    local keep_days=${1:-7}
    
    log "🧹 Nettoyage des sauvegardes de plus de $keep_days jours..."
    
    if [ -d "$BACKUP_DIR" ]; then
        local deleted_count=0
        find "$BACKUP_DIR" -name "*.sql.gz" -type f -mtime +$keep_days | while read -r file; do
            rm -f "$file"
            log "🗑️ Supprimé: $(basename "$file")"
            ((deleted_count++))
        done
        
        log "✅ Nettoyage terminé"
    fi
}

# Statistiques de la base de données
show_stats() {
    log "📊 Statistiques de la base de données:"
    
    # Taille de la base de données
    local db_size=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT pg_size_pretty(pg_database_size('$DB_NAME'));" | tr -d ' ')
    echo "  Taille de la base: $db_size"
    
    # Nombre de tables
    local table_count=$(docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'math4child';" | tr -d ' ')
    echo "  Nombre de tables: $table_count"
    
    # Statistiques des principales tables
    echo ""
    echo "  Statistiques des tables principales:"
    docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -c "
        SELECT 
            schemaname,
            tablename,
            n_tup_ins as insertions,
            n_tup_upd as updates,
            n_tup_del as deletions,
            n_live_tup as rows
        FROM pg_stat_user_tables 
        ORDER BY n_live_tup DESC;
    "
}

# Menu principal
case "${1:-full}" in
    "full")
        check_prerequisites
        backup_full
        ;;
    "data")
        check_prerequisites
        backup_data_only
        ;;
    "schema")
        check_prerequisites
        backup_schema_only
        ;;
    "restore")
        check_prerequisites
        restore_backup "$2"
        ;;
    "list")
        list_backups
        ;;
    "cleanup")
        cleanup_old_backups "$2"
        ;;
    "stats")
        check_prerequisites
        show_stats
        ;;
    *)
        echo "Usage: $0 {full|data|schema|restore|list|cleanup|stats}"
        echo ""
        echo "Commandes:"
        echo "  full           Sauvegarde complète (par défaut)"
        echo "  data           Sauvegarde des données uniquement"
        echo "  schema         Sauvegarde du schéma uniquement"
        echo "  restore <file> Restaurer une sauvegarde"
        echo "  list           Lister les sauvegardes"
        echo "  cleanup [days] Nettoyer les anciennes sauvegardes (défaut: 7 jours)"
        echo "  stats          Afficher les statistiques de la base"
        echo ""
        echo "Exemples:"
        echo "  $0 full"
        echo "  $0 restore backups/database/full_backup_20240115_100000.sql.gz"
        echo "  $0 cleanup 30"
        exit 1
        ;;
esac
EOF
    
    chmod +x scripts/backup-database.sh
    
    log "SUCCESS" "✅ Configuration de la base de données avec migrations créée"
}

# Configuration du monitoring et observabilité
setup_monitoring() {
    log "INFO" "📊 Configuration du monitoring et observabilité avancé..."
    
    # Configuration Prometheus avancée
    mkdir -p monitoring/prometheus/rules
    cat > monitoring/prometheus/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    monitor: 'math4child'
    environment: 'production'

rule_files:
  - "rules/*.yml"

scrape_configs:
  # Application Math4Child
  - job_name: 'math4child-app'
    static_configs:
      - targets: ['app:3000']
    metrics_path: '/api/metrics'
    scrape_interval: 30s
    scrape_timeout: 10s
    honor_labels: true

  # PostgreSQL
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']
    scrape_interval: 30s

  # Redis
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']
    scrape_interval: 30s

  # Nginx
  - job_name: 'nginx'
    static_configs:
      - targets: ['nginx-exporter:9113']
    scrape_interval: 30s

  # Node Exporter (metrics système)
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
    scrape_interval: 30s

  # cAdvisor (metrics containers)
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
    scrape_interval: 30s

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

# Storage configuration
storage:
  tsdb:
    path: /prometheus
    retention.time: 30d
    retention.size: 10GB
EOF
    
    # Règles d'alerte Prometheus
    cat > monitoring/prometheus/rules/math4child-alerts.yml << 'EOF'
groups:
  - name: math4child.rules
    rules:
      # Alertes applicatives
      - alert: HighErrorRate
        expr: |
          (
            rate(http_requests_total{status=~"5.."}[5m])
            /
            rate(http_requests_total[5m])
          ) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Taux d'erreur élevé détecté"
          description: "Le taux d'erreur est de {{ $value | humanizePercentage }} sur les 5 dernières minutes."

      - alert: HighResponseTime
        expr: |
          histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Temps de réponse élevé"
          description: "Le 95e percentile des temps de réponse est de {{ $value }}s."

      - alert: LowUserActivity
        expr: |
          rate(user_sessions_total[1h]) < 10
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Activité utilisateur faible"
          description: "Moins de 10 nouvelles sessions par heure détectées."

      # Alertes infrastructure
      - alert: HighMemoryUsage
        expr: |
          (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes > 0.9
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Utilisation mémoire élevée"
          description: "L'utilisation mémoire est à {{ $value | humanizePercentage }}."

      - alert: HighCPUUsage
        expr: |
          100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Utilisation CPU élevée"
          description: "L'utilisation CPU est à {{ $value }}%."

      - alert: DatabaseConnectionsHigh
        expr: |
          pg_stat_database_numbackends > 150
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Nombre élevé de connexions à la base de données"
          description: "{{ $value }} connexions actives à la base de données."

      - alert: DiskSpaceLow
        expr: |
          (node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes > 0.9
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Espace disque faible"
          description: "L'espace disque utilisé est à {{ $value | humanizePercentage }}."

      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service indisponible"
          description: "Le service {{ $labels.job }} est indisponible."
EOF
    
    # Configuration Grafana avec provisioning
    mkdir -p monitoring/grafana/provisioning/{dashboards,datasources,notifiers}
    
    cat > monitoring/grafana/provisioning/datasources/prometheus.yml << 'EOF'
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
    jsonData:
      httpMethod: POST
      timeInterval: "5s"
EOF
    
    cat > monitoring/grafana/provisioning/dashboards/dashboard.yml << 'EOF'
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 10
    allowUiUpdates: true
    options:
      path: /var/lib/grafana/dashboards
EOF
    
    # Dashboard Grafana pour Math4Child
    mkdir -p monitoring/grafana/dashboards
    cat > monitoring/grafana/dashboards/math4child-overview.json << 'EOF'
{
  "dashboard": {
    "id": null,
    "title": "Math4Child - Vue d'ensemble",
    "tags": ["math4child", "overview"],
    "style": "dark",
    "timezone": "browser",
    "editable": true,
    "gnetId": null,
    "graphTooltip": 0,
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "timepicker": {},
    "refresh": "30s",
    "schemaVersion": 30,
    "version": 1,
    "panels": [
      {
        "id": 1,
        "title": "👥 Utilisateurs Actifs",
        "type": "stat",
        "gridPos": {
          "h": 8,
          "w": 6,
          "x": 0,
          "y": 0
        },
        "targets": [
          {
            "expr": "active_users_total",
            "refId": "A"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "thresholds"
            },
            "thresholds": {
              "steps": [
                {"color": "red", "value": 0},
                {"color": "yellow", "value": 50},
                {"color": "green", "value": 100}
              ]
            },
            "unit": "short"
          }
        }
      },
      {
        "id": 2,
        "title": "📚 Exercices Complétés (par heure)",
        "type": "graph",
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 6,
          "y": 0
        },
        "targets": [
          {
            "expr": "rate(exercises_completed_total[1h]) * 3600",
            "refId": "A",
            "legendFormat": "Exercices/heure"
          }
        ],
        "yAxes": [
          {
            "label": "Exercices",
            "min": 0
          },
          {}
        ],
        "xAxis": {
          "show": true
        },
        "legend": {
          "show": true
        }
      },
      {
        "id": 3,
        "title": "⚡ Temps de Réponse API",
        "type": "graph",
        "gridPos": {
          "h": 8,
          "w": 18,
          "x": 0,
          "y": 8
        },
        "targets": [
          {
            "expr": "histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))",
            "refId": "A",
            "legendFormat": "p50"
          },
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "refId": "B",
            "legendFormat": "p95"
          },
          {
            "expr": "histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))",
            "refId": "C",
            "legendFormat": "p99"
          }
        ],
        "yAxes": [
          {
            "label": "Temps (s)",
            "min": 0
          },
          {}
        ]
      },
      {
        "id": 4,
        "title": "💾 Utilisation Mémoire",
        "type": "graph",
        "gridPos": {
          "h": 8,
          "w": 9,
          "x": 0,
          "y": 16
        },
        "targets": [
          {
            "expr": "(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / 1024 / 1024 / 1024",
            "refId": "A",
            "legendFormat": "Utilisée"
          },
          {
            "expr": "node_memory_MemTotal_bytes / 1024 / 1024 / 1024",
            "refId": "B",
            "legendFormat": "Total"
          }
        ],
        "yAxes": [
          {
            "label": "GB",
            "min": 0
          },
          {}
        ]
      },
      {
        "id": 5,
        "title": "🖥️ Utilisation CPU",
        "type": "graph",
        "gridPos": {
          "h": 8,
          "w": 9,
          "x": 9,
          "y": 16
        },
        "targets": [
          {
            "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "refId": "A",
            "legendFormat": "CPU %"
          }
        ],
        "yAxes": [
          {
            "label": "Pourcentage",
            "min": 0,
            "max": 100
          },
          {}
        ]
      },
      {
        "id": 6,
        "title": "🎯 Taux de Réussite par Opération",
        "type": "piechart",
        "gridPos": {
          "h": 8,
          "w": 12,
          "x": 0,
          "y": 24
        },
        "targets": [
          {
            "expr": "avg by (operation) (exercise_success_rate)",
            "refId": "A"
          }
        ]
      },
      {
        "id": 7,
        "title": "🌍 Utilisateurs par Pays",
        "type": "worldmap",
        "gridPos": {
          "h": 8,
          "w": 6,
          "x": 12,
          "y": 24
        },
        "targets": [
          {
            "expr": "sum by (country) (user_sessions_by_country)",
            "refId": "A"
          }
        ]
      }
    ]
  }
}
EOF
    
    # Scripts de monitoring
    cat > scripts/start-monitoring.sh << 'EOF'
#!/bin/bash
# Script de démarrage du monitoring Math4Child

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARN: $1${NC}"
}

info() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1${NC}"
}

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                         📊 MONITORING MATH4CHILD                            ║
║                       Démarrage de la stack complète                        ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

check_docker() {
    if ! docker ps > /dev/null 2>&1; then
        error "Docker n'est pas accessible. Assurez-vous que Docker est démarré."
        exit 1
    fi
}

start_monitoring_stack() {
    log "🚀 Démarrage de la stack de monitoring..."
    
    cd "$PROJECT_ROOT"
    
    # Démarrer les services de monitoring
    docker-compose up -d prometheus grafana
    
    # Attendre que les services soient prêts
    log "⏳ Attente du démarrage des services..."
    
    # Vérifier Prometheus
    local prometheus_ready=false
    for i in {1..30}; do
        if curl -s http://localhost:9090/-/healthy > /dev/null 2>&1; then
            prometheus_ready=true
            break
        fi
        sleep 2
    done
    
    if [ "$prometheus_ready" = true ]; then
        log "✅ Prometheus démarré avec succès"
        info "🌐 Prometheus accessible sur: http://localhost:9090"
    else
        error "❌ Timeout: Prometheus non accessible après 60s"
        return 1
    fi
    
    # Vérifier Grafana
    local grafana_ready=false
    for i in {1..30}; do
        if curl -s http://localhost:3001/api/health > /dev/null 2>&1; then
            grafana_ready=true
            break
        fi
        sleep 2
    done
    
    if [ "$grafana_ready" = true ]; then
        log "✅ Grafana démarré avec succès"
        info "🌐 Grafana accessible sur: http://localhost:3001"
        info "👤 Identifiants par défaut: admin / admin123"
    else
        error "❌ Timeout: Grafana non accessible après 60s"
        return 1
    fi
}

install_exporters() {
    log "📦 Installation des exporters additionnels..."
    
    cd "$PROJECT_ROOT"
    
    # Ajouter les exporters au docker-compose
    cat >> docker-compose.yml << 'EOF'

  # PostgreSQL Exporter
  postgres-exporter:
    image: quay.io/prometheuscommunity/postgres-exporter
    container_name: math4child-postgres-exporter
    restart: always
    environment:
      DATA_SOURCE_NAME: "postgresql://math4child_user:math4child_secure_pass@postgres:5432/math4child_db?sslmode=disable"
    ports:
      - "9187:9187"
    depends_on:
      - postgres
    networks:
      - math4child-network

  # Redis Exporter
  redis-exporter:
    image: oliver006/redis_exporter
    container_name: math4child-redis-exporter
    restart: always
    environment:
      REDIS_ADDR: "redis://redis:6379"
      REDIS_PASSWORD: "math4child_redis_pass"
    ports:
      - "9121:9121"
    depends_on:
      - redis
    networks:
      - math4child-network

  # Node Exporter
  node-exporter:
    image: prom/node-exporter:latest
    container_name: math4child-node-exporter
    restart: always
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($|/)'
    networks:
      - math4child-network

  # cAdvisor
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: math4child-cadvisor
    restart: always
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks:
      - math4child-network
EOF
    
    # Redémarrer avec les nouveaux services
    docker-compose up -d postgres-exporter redis-exporter node-exporter cadvisor
    
    log "✅ Exporters installés et démarrés"
}

show_monitoring_info() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                           🎯 SERVICES DISPONIBLES                           ║
╠══════════════════════════════════════════════════════════════════════════════╣
║  📊 Prometheus         http://localhost:9090                                ║
║  📈 Grafana           http://localhost:3001   (admin/admin123)              ║
║  🖥️  Node Exporter     http://localhost:9100                                ║
║  🐳 cAdvisor          http://localhost:8080                                 ║
║  🗄️  Postgres Exporter http://localhost:9187                                ║
║  🔴 Redis Exporter    http://localhost:9121                                 ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                           📋 DASHBOARDS GRAFANA                             ║
║  • Math4Child Overview - Vue d'ensemble de l'application                    ║
║  • Infrastructure - Métriques système et containers                         ║
║  • Database - Performances PostgreSQL                                       ║
║  • User Analytics - Comportement utilisateur                                ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                              🔔 ALERTES                                     ║
║  • Temps de réponse élevé                                                   ║
║  • Taux d'erreur élevé                                                      ║
║  • Utilisation ressources                                                   ║
║  • Services indisponibles                                                   ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

check_monitoring_health() {
    log "🏥 Vérification de l'état du monitoring..."
    
    local services=(
        "prometheus:9090/-/healthy"
        "grafana:3001/api/health"
        "node-exporter:9100/metrics"
        "cadvisor:8080/healthz"
        "postgres-exporter:9187/metrics"
        "redis-exporter:9121/metrics"
    )
    
    local healthy_count=0
    local total_count=${#services[@]}
    
    for service in "${services[@]}"; do
        local name=${service%%:*}
        local endpoint="http://localhost:${service#*:}"
        
        if curl -s "$endpoint" > /dev/null 2>&1; then
            log "✅ $name est opérationnel"
            ((healthy_count++))
        else
            warn "⚠️ $name n'est pas accessible"
        fi
    done
    
    echo ""
    log "📊 État du monitoring: $healthy_count/$total_count services opérationnels"
    
    if [ $healthy_count -eq $total_count ]; then
        log "🎉 Tous les services de monitoring sont opérationnels!"
        return 0
    else
        warn "⚠️ Certains services ne sont pas accessibles"
        return 1
    fi
}

# Menu principal
case "${1:-start}" in
    "start")
        show_banner
        check_docker
        start_monitoring_stack
        install_exporters
        sleep 5
        check_monitoring_health
        show_monitoring_info
        ;;
    "stop")
        log "🛑 Arrêt de la stack de monitoring..."
        cd "$PROJECT_ROOT"
        docker-compose stop prometheus grafana postgres-exporter redis-exporter node-exporter cadvisor
        log "✅ Stack de monitoring arrêtée"
        ;;
    "restart")
        "$0" stop
        sleep 2
        "$0" start
        ;;
    "status")
        check_monitoring_health
        ;;
    "logs")
        cd "$PROJECT_ROOT"
        docker-compose logs -f prometheus grafana
        ;;
    "info")
        show_monitoring_info
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|info}"
        echo ""
        echo "Commandes:"
        echo "  start    Démarrer la stack de monitoring (par défaut)"
        echo "  stop     Arrêter la stack de monitoring"
        echo "  restart  Redémarrer la stack de monitoring"
        echo "  status   Vérifier l'état des services"
        echo "  logs     Afficher les logs en temps réel"
        echo "  info     Afficher les informations de connexion"
        exit 1
        ;;
esac
EOF
    
    chmod +x scripts/start-monitoring.sh
    
    log "SUCCESS" "✅ Configuration du monitoring avancé créée"
}

# Configuration des variables d'environnement
setup_environment() {
    log "INFO" "🔐 Configuration des variables d'environnement et sécurité..."
    
    # Fichier .env.example complet
    cat > .env.example << 'EOF'
#===============================================================================
# CONFIGURATION MATH4CHILD - VARIABLES D'ENVIRONNEMENT
# Version: 4.0.0
# ⚠️ IMPORTANT: Copiez ce fichier vers .env et remplissez vos valeurs
#===============================================================================

#===============================================================================
# ENVIRONNEMENT
#===============================================================================
NODE_ENV=development
APP_ENV=development
APP_VERSION=4.0.0
DEBUG=math4child:*

#===============================================================================
# APPLICATION
#===============================================================================
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3000/api
NEXT_PUBLIC_WS_URL=ws://localhost:3000
PORT=3000
HOST=0.0.0.0

#===============================================================================
# BASE DE DONNÉES
#===============================================================================
DATABASE_URL=postgresql://math4child_user:math4child_secure_pass@localhost:5432/math4child_db
DATABASE_URL_TEST=postgresql://math4child_user:math4child_secure_pass@localhost:5432/math4child_test_db
DB_HOST=localhost
DB_PORT=5432
DB_NAME=math4child_db
DB_USER=math4child_user
DB_PASSWORD=math4child_secure_pass
DB_SSL=false
DB_POOL_MIN=2
DB_POOL_MAX=20
DB_TIMEOUT=30000

#===============================================================================
# REDIS (CACHE & SESSIONS)
#===============================================================================
REDIS_URL=redis://localhost:6379
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=math4child_redis_pass
REDIS_DB=0
REDIS_TTL=3600

#===============================================================================
# AUTHENTIFICATION & SÉCURITÉ
#===============================================================================
NEXTAUTH_SECRET=your-super-secret-nextauth-key-change-in-production-minimum-32-chars
NEXTAUTH_URL=http://localhost:3000
JWT_SECRET=your-jwt-secret-key-change-in-production
ENCRYPTION_KEY=your-32-character-encryption-key-here
SESSION_SECRET=your-session-secret-key-change-in-production
BCRYPT_ROUNDS=12
PASSWORD_MIN_LENGTH=8
MAX_LOGIN_ATTEMPTS=5
ACCOUNT_LOCKOUT_TIME=900000

#===============================================================================
# STRIPE (PAIEMENTS)
#===============================================================================
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret
STRIPE_CURRENCY=EUR
STRIPE_SUCCESS_URL=http://localhost:3000/payment/success
STRIPE_CANCEL_URL=http://localhost:3000/payment/cancel

#===============================================================================
# EMAIL (SENDGRID)
#===============================================================================
SENDGRID_API_KEY=your_sendgrid_api_key
SENDGRID_FROM_EMAIL=noreply@math4child.com
SENDGRID_FROM_NAME=Math4Child
EMAIL_VERIFICATION_TEMPLATE_ID=d-your_template_id
PASSWORD_RESET_TEMPLATE_ID=d-your_template_id

#===============================================================================
# ANALYTICS & TRACKING
#===============================================================================
GOOGLE_ANALYTICS_ID=GA_MEASUREMENT_ID
GOOGLE_TAG_MANAGER_ID=GTM-XXXXXXX
MIXPANEL_TOKEN=your_mixpanel_token
HOTJAR_ID=your_hotjar_id
FACEBOOK_PIXEL_ID=your_facebook_pixel_id

#===============================================================================
# MONITORING & ERREURS
#===============================================================================
SENTRY_DSN=your_sentry_dsn
SENTRY_ORG=your_sentry_org
SENTRY_PROJECT=math4child
SENTRY_ENVIRONMENT=development
LOG_LEVEL=info
LOG_FORMAT=json
ENABLE_REQUEST_LOGGING=true

#===============================================================================
# STOCKAGE & CDN
#===============================================================================
# AWS S3
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=eu-west-1
AWS_S3_BUCKET=math4child-assets
AWS_CLOUDFRONT_DOMAIN=your_cloudfront_domain

# Cloudflare
CLOUDFLARE_ZONE_ID=your_cloudflare_zone_id
CLOUDFLARE_API_TOKEN=your_cloudflare_token
CLOUDFLARE_ACCOUNT_ID=your_cloudflare_account_id

#===============================================================================
# IA & SERVICES EXTERNES
#===============================================================================
OPENAI_API_KEY=your_openai_api_key
OPENAI_ORG_ID=your_openai_org_id
OPENAI_MODEL=gpt-4
AZURE_SPEECH_KEY=your_azure_speech_key
AZURE_SPEECH_REGION=westeurope

#===============================================================================
# RATE LIMITING & SÉCURITÉ
#===============================================================================
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
RATE_LIMIT_API_WINDOW_MS=60000
RATE_LIMIT_API_MAX_REQUESTS=1000
CORS_ORIGIN=http://localhost:3000
HELMET_CSP_ENABLED=true
TRUST_PROXY=false

#===============================================================================
# MONITORING
#===============================================================================
PROMETHEUS_ENABLED=true
PROMETHEUS_PORT=9090
GRAFANA_ADMIN_PASSWORD=admin123
METRICS_ENABLED=true
HEALTH_CHECK_ENABLED=true

#===============================================================================
# FEATURE FLAGS
#===============================================================================
FEATURE_MULTIPLAYER=true
FEATURE_AR_MODE=false
FEATURE_VOICE_COMMANDS=true
FEATURE_AI_TUTOR=true
FEATURE_OFFLINE_MODE=false
FEATURE_GAMIFICATION=true
FEATURE_LEADERBOARDS=true
FEATURE_ACHIEVEMENTS=true
FEATURE_SOCIAL_LOGIN=true
FEATURE_DARK_MODE=true

#===============================================================================
# LOCALISATION
#===============================================================================
DEFAULT_LANGUAGE=fr
SUPPORTED_LANGUAGES=fr,en,es,de,ar,zh,ja,ko,hi,pt,ru,it,nl,pl,tr,sv,da,no
DEFAULT_TIMEZONE=Europe/Paris
DEFAULT_CURRENCY=EUR
DEFAULT_DATE_FORMAT=DD/MM/YYYY

#===============================================================================
# DÉVELOPPEMENT
#===============================================================================
NEXT_TELEMETRY_DISABLED=1
ANALYZE=false
BUNDLE_ANALYZE=false
VERBOSE_LOGGING=false
HOT_RELOAD=true
SOURCE_MAPS=true

#===============================================================================
# PRODUCTION
#===============================================================================
# Uncomment for production
# NODE_ENV=production
# APP_ENV=production
# NEXT_PUBLIC_APP_URL=https://www.math4child.com
# NEXT_PUBLIC_API_URL=https://www.math4child.com/api
# DATABASE_URL=postgresql://production_user:production_pass@production_host:5432/math4child_prod
# REDIS_URL=redis://production_redis:6379
# LOG_LEVEL=warn
# TRUST_PROXY=true

#===============================================================================
# TESTS
#===============================================================================
TEST_DATABASE_URL=postgresql://math4child_user:math4child_secure_pass@localhost:5432/math4child_test_db
PLAYWRIGHT_BASE_URL=http://localhost:3000
CI=false
EOF
    
    # Script de génération des secrets
    cat > scripts/generate-secrets.sh << 'EOF'
#!/bin/bash
# Script de génération des secrets pour Math4Child

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARN: $1${NC}"
}

info() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1${NC}"
}

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                       🔐 GÉNÉRATEUR DE SECRETS MATH4CHILD                   ║
║                         Génération sécurisée des clés                       ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Vérifier la disponibilité d'openssl
check_openssl() {
    if ! command -v openssl &> /dev/null; then
        echo "❌ OpenSSL n'est pas installé. Installation requise pour générer les secrets."
        exit 1
    fi
}

# Générer un secret aléatoire
generate_secret() {
    local length=${1:-32}
    openssl rand -hex "$length"
}

# Générer un secret base64
generate_base64_secret() {
    local length=${1:-32}
    openssl rand -base64 "$length" | tr -d '\n='
}

# Générer un UUID
generate_uuid() {
    if command -v uuidgen &> /dev/null; then
        uuidgen | tr '[:upper:]' '[:lower:]'
    else
        # Fallback si uuidgen n'est pas disponible
        openssl rand -hex 16 | sed 's/\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)/\1\2\3\4-\5\6-\7\8-\9\10-\11\12\13\14\15\16/'
    fi
}

# Générer un mot de passe fort
generate_password() {
    local length=${1:-16}
    openssl rand -base64 $((length * 3 / 4)) | tr -d '\n+/' | head -c "$length"
}

# Générer tous les secrets
generate_all_secrets() {
    log "🔑 Génération des secrets pour Math4Child..."
    
    echo ""
    echo "# ================================"
    echo "# SECRETS GÉNÉRÉS - $(date)"
    echo "# ================================"
    echo ""
    
    echo "# Authentification"
    echo "NEXTAUTH_SECRET=$(generate_base64_secret 64)"
    echo "JWT_SECRET=$(generate_base64_secret 48)"
    echo "ENCRYPTION_KEY=$(generate_secret 32)"
    echo "SESSION_SECRET=$(generate_base64_secret 32)"
    echo ""
    
    echo "# Base de données"
    echo "DB_PASSWORD=$(generate_password 24)"
    echo "REDIS_PASSWORD=$(generate_password 20)"
    echo ""
    
    echo "# IDs et tokens"
    echo "APP_SECRET=$(generate_secret 32)"
    echo "API_KEY=$(generate_uuid)"
    echo "WEBHOOK_SECRET=$(generate_base64_secret 32)"
    echo ""
    
    echo "# Monitoring"
    echo "GRAFANA_ADMIN_PASSWORD=$(generate_password 16)"
    echo "PROMETHEUS_SECRET=$(generate_secret 24)"
    echo ""
    
    echo "# ================================"
    echo "# INSTRUCTIONS D'UTILISATION"
    echo "# ================================"
    echo "# 1. Copiez ces valeurs dans votre fichier .env"
    echo "# 2. Remplacez les valeurs placeholder dans .env.example"
    echo "# 3. NE JAMAIS commiter ces secrets dans Git!"
    echo "# 4. Utilisez des valeurs différentes pour chaque environnement"
    echo ""
    
    warn "⚠️  IMPORTANT: Sauvegardez ces secrets de manière sécurisée!"
    warn "⚠️  Ces secrets ne seront pas régénérés automatiquement!"
}

# Générer des secrets pour un environnement spécifique
generate_env_secrets() {
    local env=${1:-development}
    local output_file=".env.${env}.secrets"
    
    log "🔑 Génération des secrets pour l'environnement: $env"
    
    {
        echo "# Secrets générés pour l'environnement: $env"
        echo "# Date: $(date)"
        echo "# Version: 4.0.0"
        echo ""
        
        case $env in
            "production")
                echo "# Production - Secrets haute sécurité"
                echo "NEXTAUTH_SECRET=$(generate_base64_secret 96)"
                echo "JWT_SECRET=$(generate_base64_secret 64)"
                echo "ENCRYPTION_KEY=$(generate_secret 64)"
                echo "SESSION_SECRET=$(generate_base64_secret 48)"
                echo "DB_PASSWORD=$(generate_password 32)"
                echo "REDIS_PASSWORD=$(generate_password 28)"
                ;;
            "staging")
                echo "# Staging - Secrets moyens"
                echo "NEXTAUTH_SECRET=$(generate_base64_secret 64)"
                echo "JWT_SECRET=$(generate_base64_secret 48)"
                echo "ENCRYPTION_KEY=$(generate_secret 48)"
                echo "SESSION_SECRET=$(generate_base64_secret 32)"
                echo "DB_PASSWORD=$(generate_password 24)"
                echo "REDIS_PASSWORD=$(generate_password 20)"
                ;;
            *)
                echo "# Development - Secrets de base"
                echo "NEXTAUTH_SECRET=$(generate_base64_secret 48)"
                echo "JWT_SECRET=$(generate_base64_secret 32)"
                echo "ENCRYPTION_KEY=$(generate_secret 32)"
                echo "SESSION_SECRET=$(generate_base64_secret 24)"
                echo "DB_PASSWORD=$(generate_password 16)"
                echo "REDIS_PASSWORD=$(generate_password 16)"
                ;;
        esac
        
        echo ""
        echo "# Communs à tous les environnements"
        echo "GRAFANA_ADMIN_PASSWORD=$(generate_password 16)"
        echo "API_KEY=$(generate_uuid)"
        echo "WEBHOOK_SECRET=$(generate_base64_secret 32)"
    } > "$output_file"
    
    chmod 600 "$output_file"
    log "✅ Secrets sauvegardés dans: $output_file"
    info "📄 Fichier protégé avec permissions 600 (lecture propriétaire uniquement)"
}

# Valider un fichier .env
validate_env_file() {
    local env_file=${1:-.env}
    
    if [ ! -f "$env_file" ]; then
        warn "⚠️ Fichier $env_file non trouvé"
        return 1
    fi
    
    log "🔍 Validation du fichier: $env_file"
    
    local issues=0
    
    # Vérifier les variables critiques
    local critical_vars=(
        "NEXTAUTH_SECRET"
        "JWT_SECRET"
        "ENCRYPTION_KEY"
        "DATABASE_URL"
    )
    
    for var in "${critical_vars[@]}"; do
        if ! grep -q "^${var}=" "$env_file"; then
            warn "❌ Variable manquante: $var"
            ((issues++))
        elif grep "^${var}=your_" "$env_file" > /dev/null; then
            warn "❌ Variable non configurée: $var (valeur placeholder détectée)"
            ((issues++))
        elif grep "^${var}=$" "$env_file" > /dev/null; then
            warn "❌ Variable vide: $var"
            ((issues++))
        fi
    done
    
    # Vérifier la longueur des secrets
    local nextauth_secret=$(grep "^NEXTAUTH_SECRET=" "$env_file" | cut -d'=' -f2)
    if [ ${#nextauth_secret} -lt 32 ]; then
        warn "❌ NEXTAUTH_SECRET trop court (minimum 32 caractères)"
        ((issues++))
    fi
    
    if [ $issues -eq 0 ]; then
        log "✅ Validation réussie: aucun problème détecté"
        return 0
    else
        warn "⚠️ $issues problème(s) détecté(s) dans $env_file"
        return 1
    fi
}

# Menu principal
case "${1:-help}" in
    "generate"|"gen")
        show_banner
        check_openssl
        generate_all_secrets
        ;;
    "env")
        show_banner
        check_openssl
        generate_env_secrets "$2"
        ;;
    "validate"|"check")
        validate_env_file "$2"
        ;;
    "help"|*)
        echo "Usage: $0 {generate|env|validate}"
        echo ""
        echo "Commandes:"
        echo "  generate        Générer tous les secrets (sortie console)"
        echo "  env [ENV]      Générer les secrets pour un environnement spécifique"
        echo "  validate [FILE] Valider un fichier .env"
        echo ""
        echo "Exemples:"
        echo "  $0 generate"
        echo "  $0 env production"
        echo "  $0 env staging"
        echo "  $0 validate .env"
        echo ""
        echo "Environnements supportés: development, staging, production"
        exit 1
        ;;
esac
EOF
    
    chmod +x scripts/generate-secrets.sh
    
    # Configuration Git avancée
    cat > .gitignore << 'EOF'
# ================================
# GITIGNORE MATH4CHILD
# ================================

# Dependencies
node_modules/
.pnp
.pnp.js

# Production builds
.next/
out/
build/
dist/

# Environment variables - CRITICAL: Never commit these!
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.env.*.secrets
*.env

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov
.nyc_output

# Test results
test-results/
playwright-report/
.playwright/

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# Next.js build output
.next
out

# Nuxt.js build / generate output
.nuxt

# Vuepress build output
.vuepress/dist

# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Database
*.sqlite
*.db
*.sql

# Docker
.docker/
docker-compose.override.yml

# Backups - Keep structure but not the actual backup files
backups/**/*.sql*
backups/**/*.dump*
backups/**/*.tar.gz
!backups/.gitkeep

# Certificates and keys
certificates/*.pem
certificates/*.key
certificates/*.crt
certificates/*.p12
ssl/

# Temporary files
tmp/
temp/
.tmp/

# Monitoring data
monitoring/prometheus/data/
monitoring/grafana/data/

# Local Netlify folder
.netlify

# Vercel
.vercel

# Terraform
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Sentry
.sentryclirc

# Storybook build outputs
storybook-static

# Temporary folders
node_modules/
.cache/

# Mac
.DS_Store

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini

# Linux
*~

# Archives
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

# Security
.env.production
.env.staging
.htpasswd
auth.json
secrets/

# Analytics and tracking
.mixpanel
.amplitude

# Performance
.webpack-bundle-analyzer/
bundle-analyzer-report.html

# Mobile
*.mobileprovision
*.p12

# Editor directories and files
.vscode/
!.vscode/extensions.json
.idea
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

# Custom exclusions for Math4Child
math4child-*.tar.gz
deployment-*.log
migration-*.sql
EOF
    
    # Créer les fichiers .gitkeep pour préserver la structure
    touch backups/.gitkeep
    touch logs/.gitkeep
    touch certificates/.gitkeep
    
    log "SUCCESS" "✅ Configuration des variables d'environnement et sécurité créée"
}#!/bin/bash

#===============================================================================
# MATH4CHILD - SCRIPT DE DÉPLOIEMENT COMPLET
# Version: 4.0.0
# Description: Script automatisé pour le setup, développement et déploiement
# Auteur: Math4Child Development Team  
# Date: $(date +%Y-%m-%d)
# Domaine: www.math4child.com
# Tech Stack: Next.js + TypeScript + Playwright + PostgreSQL + Docker
#===============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

#===============================================================================
# CONFIGURATION GLOBALE
#===============================================================================

# Couleurs pour l'output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Configuration du projet
readonly PROJECT_NAME="math4child"
readonly PROJECT_VERSION="4.0.0"
readonly DOMAIN="www.math4child.com"
readonly REPO_URL="https://github.com/your-org/math4child.git"
readonly NODE_VERSION="20.10.0"
readonly DOCKER_IMAGE="math4child/app"

# Répertoires
readonly PROJECT_ROOT="$(pwd)"
readonly SCRIPTS_DIR="${PROJECT_ROOT}/scripts"
readonly LOGS_DIR="${PROJECT_ROOT}/logs"
readonly BACKUP_DIR="${PROJECT_ROOT}/backups"
readonly BUILD_DIR="${PROJECT_ROOT}/build"
readonly DIST_DIR="${PROJECT_ROOT}/dist"
readonly APPS_DIR="${PROJECT_ROOT}/apps"
readonly TESTS_DIR="${PROJECT_ROOT}/tests"

# Environnements
readonly ENVIRONMENTS=("development" "staging" "production")
readonly DEFAULT_ENV="development"

# Bases de données
readonly DB_NAME="math4child_db"
readonly DB_USER="math4child_user"
readonly TEST_DB_NAME="math4child_test_db"

# Services externes
readonly STRIPE_API_URL="https://api.stripe.com"
readonly ANALYTICS_API="https://analytics.math4child.com"

#===============================================================================
# FONCTIONS UTILITAIRES
#===============================================================================

# Affichage de bannière
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ███╗   ███╗ █████╗ ████████╗██╗  ██╗██╗  ██╗ ██████╗██╗  ██╗██╗██╗     ██╗║
║    ████╗ ████║██╔══██╗╚══██╔══╝██║  ██║██║  ██║██╔════╝██║  ██║██║██║     ██║║
║    ██╔████╔██║███████║   ██║   ███████║███████║██║     ███████║██║██║     ██║║
║    ██║╚██╔╝██║██╔══██║   ██║   ██╔══██║╚════██║██║     ██╔══██║██║██║     ██║║
║    ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║     ██║╚██████╗██║  ██║██║███████╗██║║
║    ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝║
║                                                                              ║
║                    🚀 SCRIPT DE DÉPLOIEMENT COMPLET v4.0.0                  ║
║                    📚 Application éducative révolutionnaire                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Logging avec couleurs et timestamps
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "INFO")  echo -e "${GREEN}[${timestamp}] ℹ️  INFO: ${message}${NC}" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] ⚠️  WARN: ${message}${NC}" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ❌ ERROR: ${message}${NC}" ;;
        "DEBUG") echo -e "${BLUE}[${timestamp}] 🔍 DEBUG: ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[${timestamp}] ✅ SUCCESS: ${message}${NC}" ;;
    esac
    
    # Log vers fichier
    mkdir -p "${LOGS_DIR}"
    echo "[${timestamp}] ${level}: ${message}" >> "${LOGS_DIR}/math4child.log"
}

# Vérification des prérequis
check_prerequisites() {
    log "INFO" "🔍 Vérification des prérequis système..."
    
    local missing_deps=()
    
    # Vérification Node.js
    if ! command -v node &> /dev/null; then
        missing_deps+=("node")
    else
        local node_version=$(node --version | sed 's/v//')
        if [[ $(echo "$node_version $NODE_VERSION" | tr " " "\n" | sort -V | head -n1) != "$NODE_VERSION" ]]; then
            log "WARN" "Node.js version $node_version détectée, $NODE_VERSION recommandée"
        fi
    fi
    
    # Vérification des outils essentiels
    local tools=("npm" "git" "docker" "docker-compose" "curl" "jq" "zip" "unzip" "psql")
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_deps+=("$tool")
        fi
    done
    
    # Vérification TypeScript
    if ! npm list -g typescript &> /dev/null; then
        log "WARN" "TypeScript global non installé - installation recommandée"
    fi
    
    # Vérification Playwright
    if ! npm list -g @playwright/test &> /dev/null; then
        log "WARN" "Playwright non installé globalement"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log "ERROR" "Dépendances manquantes: ${missing_deps[*]}"
        log "INFO" "Installez les dépendances manquantes et relancez le script"
        exit 1
    fi
    
    log "SUCCESS" "✅ Tous les prérequis sont satisfaits"
}

# Création de la structure de répertoires
create_directory_structure() {
    log "INFO" "📁 Création de la structure de répertoires Math4Child..."
    
    local dirs=(
        "apps/math4child/src"
        "apps/math4child/src/app"
        "apps/math4child/src/components"
        "apps/math4child/src/hooks"
        "apps/math4child/src/utils"
        "apps/math4child/src/stores"
        "apps/math4child/src/types"
        "apps/math4child/src/styles"
        "apps/math4child/public"
        "apps/math4child/public/icons"
        "apps/math4child/public/sounds"
        "apps/math4child/public/images"
        "tests"
        "tests/specs"
        "tests/utils"
        "tests/fixtures"
        "scripts"
        "scripts/deployment"
        "scripts/database"
        "scripts/monitoring"
        "scripts/backup"
        "docs"
        "docs/api"
        "docs/deployment"
        "docs/testing"
        "logs"
        "backups"
        "backups/database"
        "backups/files"
        "build"
        "dist"
        "infrastructure"
        "infrastructure/docker"
        "infrastructure/k8s"
        "infrastructure/terraform"
        "infrastructure/nginx"
        "monitoring"
        "monitoring/grafana"
        "monitoring/prometheus"
        "database"
        "database/migrations"
        "database/seeds"
        "assets"
        "assets/images"
        "assets/sounds"
        "assets/videos"
        "locales"
        "certificates"
        "cypress"
        "cypress/e2e"
        "cypress/fixtures"
        "cypress/support"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir"
        log "DEBUG" "Créé: $dir"
    done
    
    log "SUCCESS" "✅ Structure de répertoires créée"
}

# Initialisation du projet
init_project() {
    log "INFO" "🚀 Initialisation du projet Math4Child..."
    
    # Package.json racine (monorepo)
    if [[ ! -f "package.json" ]]; then
        log "INFO" "Création du package.json racine..."
        cat > package.json << 'EOF'
{
  "name": "math4child-monorepo",
  "version": "4.0.0",
  "description": "Math4Child - Application éducative révolutionnaire pour l'apprentissage des mathématiques",
  "private": true,
  "workspaces": [
    "apps/*",
    "tests"
  ],
  "type": "module",
  "scripts": {
    "dev": "npm run dev --workspace=apps/math4child",
    "dev:all": "concurrently \"npm run dev --workspace=apps/math4child\" \"npm run test:ui --workspace=tests\"",
    "build": "npm run build --workspace=apps/math4child",
    "build:all": "npm run build --workspace=apps/math4child",
    "start": "npm run start --workspace=apps/math4child",
    "test": "npm run test --workspace=tests",
    "test:headed": "npm run test:headed --workspace=tests",
    "test:ui": "npm run test:ui --workspace=tests",
    "test:mobile": "npm run test:mobile --workspace=tests",
    "test:i18n": "npm run test:i18n --workspace=tests",
    "test:performance": "npm run test:performance --workspace=tests",
    "test:accessibility": "npm run test:accessibility --workspace=tests",
    "test:smoke": "npm run test:smoke --workspace=tests",
    "test:regression": "npm run test:regression --workspace=tests",
    "lint": "npm run lint --workspace=apps/math4child",
    "format": "prettier --write \"**/*.{js,jsx,ts,tsx,json,css,md}\"",
    "typecheck": "npm run typecheck --workspace=apps/math4child",
    "clean": "npm run clean --workspace=apps/math4child && npm run clean --workspace=tests",
    "setup": "./scripts/setup.sh",
    "deploy:dev": "./scripts/deploy.sh development",
    "deploy:staging": "./scripts/deploy.sh staging",
    "deploy:prod": "./scripts/deploy.sh production",
    "backup:db": "./scripts/backup-database.sh",
    "migrate:up": "./scripts/migrate.sh up",
    "migrate:down": "./scripts/migrate.sh down",
    "seed:dev": "./scripts/seed-data.sh development",
    "monitor": "./scripts/start-monitoring.sh",
    "security:scan": "./scripts/security-scan.sh",
    "analytics": "./scripts/analytics-report.sh",
    "docker:up": "docker-compose up -d",
    "docker:down": "docker-compose down",
    "docker:logs": "docker-compose logs -f",
    "k8s:deploy": "kubectl apply -f infrastructure/k8s/",
    "cert:renew": "./scripts/renew-certificates.sh",
    "install:all": "npm install && npm install --workspace=apps/math4child && npm install --workspace=tests"
  },
  "devDependencies": {
    "prettier": "^3.1.0",
    "concurrently": "^8.2.0",
    "rimraf": "^5.0.0"
  },
  "engines": {
    "node": ">=20.0.0",
    "npm": ">=10.0.0"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/your-org/math4child.git"
  },
  "keywords": [
    "education",
    "mathematics",
    "children",
    "learning",
    "multilingual",
    "adaptive",
    "gamification",
    "typescript",
    "nextjs",
    "playwright"
  ],
  "author": "Math4Child Team",
  "license": "MIT"
}
EOF
        
        log "SUCCESS" "✅ Package.json racine créé"
    fi
    
    # Initialisation Git si nécessaire
    if [[ ! -d ".git" ]]; then
        git init
        log "SUCCESS" "✅ Repository Git initialisé"
    fi
}

# Configuration de l'application Next.js avec TypeScript
setup_nextjs_app() {
    log "INFO" "⚛️ Configuration de l'application Next.js Math4Child avec TypeScript..."
    
    cd "${APPS_DIR}/math4child"
    
    # Package.json pour l'app Math4Child
    cat > package.json << 'EOF'
{
  "name": "math4child-app",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "analyze": "ANALYZE=true next build",
    "clean": "rm -rf .next dist coverage node_modules"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.3.0",
    "@types/node": "^20.10.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "tailwindcss": "^3.4.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "lucide-react": "^0.300.0",
    "framer-motion": "^10.16.0",
    "zustand": "^4.4.0",
    "@tanstack/react-query": "^5.0.0",
    "axios": "^1.6.0",
    "zod": "^3.22.0",
    "react-hook-form": "^7.48.0",
    "@hookform/resolvers": "^3.3.0",
    "recharts": "^2.8.0",
    "react-confetti": "^6.1.0",
    "howler": "^2.2.0",
    "@types/howler": "^2.2.0",
    "@stripe/stripe-js": "^2.1.0",
    "i18next": "^23.7.0",
    "react-i18next": "^13.5.0",
    "i18next-browser-languagedetector": "^7.2.0",
    "jose": "^5.1.0",
    "bcryptjs": "^2.4.0",
    "@types/bcryptjs": "^2.4.0",
    "prisma": "^5.7.0",
    "@prisma/client": "^5.7.0",
    "clsx": "^2.0.0",
    "class-variance-authority": "^0.7.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "eslint": "^8.55.0",
    "eslint-config-next": "^14.0.0",
    "@typescript-eslint/eslint-plugin": "^6.13.0",
    "@typescript-eslint/parser": "^6.13.0",
    "@testing-library/react": "^14.1.0",
    "@testing-library/jest-dom": "^6.1.0",
    "jest": "^29.7.0",
    "jest-environment-jsdom": "^29.7.0",
    "@next/bundle-analyzer": "^14.0.0",
    "@types/jest": "^29.5.0"
  }
}
EOF
    
    # Configuration Next.js optimisée
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    typedRoutes: true,
  },
  typescript: {
    tsconfigPath: './tsconfig.json',
  },
  images: {
    domains: ['cdn.math4child.com', 'assets.math4child.com'],
    formats: ['image/webp', 'image/avif'],
    minimumCacheTTL: 60,
  },
  i18n: {
    locales: ['fr', 'en', 'es', 'de', 'ar', 'zh', 'ja', 'ko', 'hi', 'pt', 'ru', 'it', 'nl', 'pl'],
    defaultLocale: 'fr',
    localeDetection: true,
  },
  async rewrites() {
    return [
      {
        source: '/api/analytics/:path*',
        destination: 'https://analytics.math4child.com/:path*',
      },
    ];
  },
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=31536000; includeSubDomains',
          },
        ],
      },
    ];
  },
  webpack: (config, { isServer, dev }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
      };
    }
    
    // Optimisations pour la production
    if (!dev) {
      config.optimization.splitChunks = {
        chunks: 'all',
        cacheGroups: {
          default: false,
          vendors: false,
          vendor: {
            chunks: 'all',
            test: /node_modules/,
            name: 'vendor',
          },
          common: {
            minChunks: 2,
            chunks: 'all',
            name: 'common',
          },
        },
      };
    }
    
    return config;
  },
  output: 'standalone',
  poweredByHeader: false,
  compress: true,
};

const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});

module.exports = withBundleAnalyzer(nextConfig);
EOF
    
    # Configuration TypeScript stricte
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "ES2022"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/stores/*": ["./src/stores/*"],
      "@/types/*": ["./src/types/*"],
      "@/styles/*": ["./src/styles/*"]
    },
    "forceConsistentCasingInFileNames": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
    
    # Configuration Tailwind CSS avancée
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
          950: '#172554',
        },
        secondary: {
          50: '#faf5ff',
          100: '#f3e8ff',
          200: '#e9d5ff',
          300: '#d8b4fe',
          400: '#c084fc',
          500: '#a855f7',
          600: '#9333ea',
          700: '#7c3aed',
          800: '#6b21a8',
          900: '#581c87',
          950: '#3b0764',
        },
        success: {
          50: '#f0fdf4',
          500: '#22c55e',
          600: '#16a34a',
        },
        warning: {
          50: '#fffbeb',
          500: '#f59e0b',
          600: '#d97706',
        },
        error: {
          50: '#fef2f2',
          500: '#ef4444',
          600: '#dc2626',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Poppins', 'system-ui', 'sans-serif'],
        mono: ['Fira Code', 'monospace'],
      },
      animation: {
        'bounce-slow': 'bounce 2s infinite',
        'pulse-slow': 'pulse 3s infinite',
        'spin-slow': 'spin 3s linear infinite',
        'fade-in': 'fadeIn 0.5s ease-in-out',
        'slide-up': 'slideUp 0.3s ease-out',
        'scale-in': 'scaleIn 0.2s ease-out',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        scaleIn: {
          '0%': { transform: 'scale(0.95)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
      },
      screens: {
        'xs': '475px',
        '3xl': '1600px',
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
        '128': '32rem',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
};
EOF
    
    # Configuration PostCSS
    cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
EOF
    
    # Configuration Jest pour TypeScript
    cat > jest.config.js << 'EOF'
const nextJest = require('next/jest');

const createJestConfig = nextJest({
  dir: './',
});

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  testEnvironment: 'jest-environment-jsdom',
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
    '!src/app/layout.tsx',
    '!src/app/globals.css',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  testMatch: [
    '<rootDir>/src/**/__tests__/**/*.{js,jsx,ts,tsx}',
    '<rootDir>/src/**/*.(test|spec).{js,jsx,ts,tsx}',
  ],
};

module.exports = createJestConfig(customJestConfig);
EOF
    
    # Jest setup
    cat > jest.setup.js << 'EOF'
import '@testing-library/jest-dom';

// Mock des APIs du navigateur
global.ResizeObserver = jest.fn().mockImplementation(() => ({
  observe: jest.fn(),
  unobserve: jest.fn(),
  disconnect: jest.fn(),
}));

global.IntersectionObserver = jest.fn().mockImplementation(() => ({
  observe: jest.fn(),
  unobserve: jest.fn(),
  disconnect: jest.fn(),
}));

// Mock localStorage
const localStorageMock = {
  getItem: jest.fn(),
  setItem: jest.fn(),
  removeItem: jest.fn(),
  clear: jest.fn(),
};
global.localStorage = localStorageMock;

// Mock sessionStorage
global.sessionStorage = localStorageMock;

// Mock Audio API
global.Audio = jest.fn().mockImplementation(() => ({
  play: jest.fn(),
  pause: jest.fn(),
  load: jest.fn(),
  addEventListener: jest.fn(),
  removeEventListener: jest.fn(),
}));

// Mock fetch
global.fetch = jest.fn();

// Mock matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(),
    removeListener: jest.fn(),
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});
EOF
    
    # Configuration ESLint stricte
    cat > .eslintrc.json << 'EOF'
{
  "extends": [
    "next/core-web-vitals",
    "@typescript-eslint/recommended",
    "@typescript-eslint/recommended-requiring-type-checking"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "project": "./tsconfig.json"
  },
  "plugins": ["@typescript-eslint"],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/prefer-nullish-coalescing": "error",
    "@typescript-eslint/prefer-optional-chain": "error",
    "@typescript-eslint/no-unnecessary-condition": "error",
    "@typescript-eslint/no-non-null-assertion": "error",
    "prefer-const": "error",
    "no-var": "error",
    "object-shorthand": "error",
    "prefer-template": "error"
  },
  "ignorePatterns": ["next.config.js", "tailwind.config.js", "postcss.config.js"]
}
EOF
    
    cd ../..
    log "SUCCESS" "✅ Application Next.js configurée avec TypeScript"
}

# Configuration Playwright pour les tests
setup_playwright_tests() {
    log "INFO" "🎭 Configuration de Playwright pour les tests Math4Child..."
    
    cd "${TESTS_DIR}"
    
    # Package.json pour les tests
    cat > package.json << 'EOF'
{
  "name": "math4child-tests",
  "version": "4.0.0",
  "description": "Suite de tests E2E Playwright pour Math4Child",
  "private": true,
  "type": "module",
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:ui": "playwright test --ui",
    "test:chrome": "playwright test --project=chromium-desktop",
    "test:firefox": "playwright test --project=firefox-desktop",
    "test:safari": "playwright test --project=webkit-desktop",
    "test:mobile": "playwright test --project=mobile-android --project=mobile-ios",
    "test:tablet": "playwright test --project=tablet-ipad",
    "test:i18n": "playwright test --project=french-locale --project=spanish-locale --project=arabic-rtl",
    "test:performance": "playwright test --project=performance-chrome performance.spec.ts",
    "test:accessibility": "playwright test --project=accessibility-chrome a11y.spec.ts",
    "test:smoke": "playwright test --grep @smoke",
    "test:regression": "playwright test --grep @regression",
    "test:critical": "playwright test --grep @critical",
    "test:report": "playwright show-report",
    "test:install": "playwright install --with-deps",
    "clean": "rimraf test-results playwright-report coverage"
  },
  "devDependencies": {
    "@playwright/test": "^1.41.0",
    "@types/node": "^20.10.0",
    "typescript": "^5.3.0",
    "rimraf": "^5.0.0",
    "@axe-core/playwright": "^4.8.0"
  }
}
EOF
    
    # Configuration Playwright avancée
    cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './specs',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  timeout: 30000,
  expect: {
    timeout: 10000,
  },
  reporter: [
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['line'],
    ['./utils/custom-reporter.ts']
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10000,
    navigationTimeout: 15000,
  },
  globalSetup: './utils/global-setup.ts',
  globalTeardown: './utils/global-teardown.ts',
  projects: [
    // Setup projects
    { name: 'setup', testMatch: '**/setup/*.setup.ts' },
    
    // Desktop browsers
    {
      name: 'chromium-desktop',
      use: { ...devices['Desktop Chrome'] },
      dependencies: ['setup'],
    },
    {
      name: 'firefox-desktop',
      use: { ...devices['Desktop Firefox'] },
      dependencies: ['setup'],
    },
    {
      name: 'webkit-desktop',
      use: { ...devices['Desktop Safari'] },
      dependencies: ['setup'],
    },
    
    // Mobile devices
    {
      name: 'mobile-android',
      use: { ...devices['Pixel 5'] },
      dependencies: ['setup'],
    },
    {
      name: 'mobile-ios',
      use: { ...devices['iPhone 12'] },
      dependencies: ['setup'],
    },
    
    // Tablet
    {
      name: 'tablet-ipad',
      use: { ...devices['iPad Pro'] },
      dependencies: ['setup'],
    },
    
    // Locales spécifiques
    {
      name: 'french-locale',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'fr-FR',
        timezoneId: 'Europe/Paris',
      },
      dependencies: ['setup'],
    },
    {
      name: 'spanish-locale',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'es-ES',
        timezoneId: 'Europe/Madrid',
      },
      dependencies: ['setup'],
    },
    {
      name: 'arabic-rtl',
      use: { 
        ...devices['Desktop Chrome'],
        locale: 'ar-SA',
        timezoneId: 'Asia/Riyadh',
      },
      dependencies: ['setup'],
    },
    
    // Tests de performance
    {
      name: 'performance-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        // Désactiver les images pour les tests de perf
        extraHTTPHeaders: {
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      },
      dependencies: ['setup'],
    },
    
    // Tests d'accessibilité
    {
      name: 'accessibility-chrome',
      use: { 
        ...devices['Desktop Chrome'],
        colorScheme: 'dark',
      },
      dependencies: ['setup'],
    },
  ],
  webServer: {
    command: 'cd ../apps/math4child && npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
EOF
    
    # Utilitaires de test TypeScript
    mkdir -p utils
    cat > utils/test-helpers.ts << 'EOF'
import { Page, Locator, expect } from '@playwright/test';

export class Math4ChildTestHelper {
  constructor(private page: Page) {}

  // Navigation
  async goToHomePage() {
    await this.page.goto('/');
    await this.waitForPageLoad();
  }

  async goToGamePage(level: string = 'beginner') {
    await this.page.goto(`/game/${level}`);
    await this.waitForPageLoad();
  }

  // Attendre le chargement de la page
  async waitForPageLoad() {
    await this.page.waitForLoadState('networkidle');
    await this.page.waitForSelector('[data-testid="page-loaded"]', { timeout: 10000 });
  }

  // Sélecteur de langue
  async selectLanguage(languageCode: string) {
    await this.page.click('[data-testid="language-selector"]');
    await this.page.click(`[data-testid="language-${languageCode}"]`);
    await this.page.waitForTimeout(500); // Attendre l'animation
  }

  // Tests d'authentification
  async loginWithDemoAccount(accountType: 'decouverte' | 'explorateur' | 'aventurier' | 'maitre') {
    await this.page.click('[data-testid="demo-accounts-button"]');
    await this.page.click(`[data-testid="demo-${accountType}"]`);
    await this.waitForAuthentication();
  }

  async waitForAuthentication() {
    await this.page.waitForSelector('[data-testid="user-authenticated"]', { timeout: 10000 });
  }

  // Jeu de mathématiques
  async startMathGame(operation: 'addition' | 'subtraction' | 'multiplication' | 'division', difficulty: number = 1) {
    await this.page.click(`[data-testid="operation-${operation}"]`);
    await this.page.click(`[data-testid="difficulty-${difficulty}"]`);
    await this.page.click('[data-testid="start-game"]');
    await this.waitForGameStart();
  }

  async waitForGameStart() {
    await this.page.waitForSelector('[data-testid="math-problem"]', { timeout: 15000 });
  }

  async solveMathProblem(): Promise<boolean> {
    const problemText = await this.page.textContent('[data-testid="math-problem"]');
    if (!problemText) return false;

    // Parser le problème mathématique simple
    const match = problemText.match(/(\d+)\s*([+\-×÷])\s*(\d+)/);
    if (!match) return false;

    const [, num1, operator, num2] = match;
    let result: number;

    switch (operator) {
      case '+':
        result = parseInt(num1) + parseInt(num2);
        break;
      case '-':
        result = parseInt(num1) - parseInt(num2);
        break;
      case '×':
        result = parseInt(num1) * parseInt(num2);
        break;
      case '÷':
        result = parseInt(num1) / parseInt(num2);
        break;
      default:
        return false;
    }

    // Saisir la réponse
    await this.page.fill('[data-testid="answer-input"]', result.toString());
    await this.page.click('[data-testid="submit-answer"]');

    // Vérifier si la réponse est correcte
    const feedbackLocator = this.page.locator('[data-testid="answer-feedback"]');
    await feedbackLocator.waitFor({ timeout: 5000 });
    
    const feedbackText = await feedbackLocator.textContent();
    return feedbackText?.includes('Correct') || feedbackText?.includes('Bravo') || false;
  }

  // Tests de responsive
  async testResponsiveDesign() {
    const viewports = [
      { width: 375, height: 667, name: 'iPhone SE' },
      { width: 414, height: 896, name: 'iPhone XR' },
      { width: 768, height: 1024, name: 'iPad' },
      { width: 1920, height: 1080, name: 'Desktop' },
    ];

    for (const viewport of viewports) {
      await this.page.setViewportSize(viewport);
      await this.page.waitForTimeout(500);
      
      // Vérifier que les éléments principaux sont visibles
      await expect(this.page.locator('[data-testid="main-navigation"]')).toBeVisible();
      await expect(this.page.locator('[data-testid="main-content"]')).toBeVisible();
    }
  }

  // Tests d'accessibilité
  async checkAccessibility() {
    // Vérifier les attributs ARIA
    const buttons = this.page.locator('button');
    const buttonCount = await buttons.count();
    
    for (let i = 0; i < buttonCount; i++) {
      const button = buttons.nth(i);
      const hasAriaLabel = await button.getAttribute('aria-label');
      const hasText = await button.textContent();
      
      if (!hasAriaLabel && !hasText?.trim()) {
        throw new Error(`Button ${i} n'a ni aria-label ni texte visible`);
      }
    }

    // Vérifier la navigation au clavier
    await this.page.keyboard.press('Tab');
    const focusedElement = this.page.locator(':focus');
    await expect(focusedElement).toBeVisible();
  }

  // Utilitaires
  async takeScreenshotWithName(name: string) {
    await this.page.screenshot({ 
      path: `test-results/screenshots/${name}-${Date.now()}.png`,
      fullPage: true 
    });
  }

  async waitForAnimation() {
    await this.page.waitForTimeout(300);
  }

  async clearLocalStorage() {
    await this.page.evaluate(() => {
      localStorage.clear();
      sessionStorage.clear();
    });
  }
}

// Données de test
export const TEST_DATA = {
  DEMO_ACCOUNTS: {
    decouverte: {
      email: 'demo-decouverte@math4child.com',
      features: ['basic_exercises'],
    },
    explorateur: {
      email: 'demo-explorateur@math4child.com',
      features: ['basic_exercises', 'progress_tracking'],
    },
    aventurier: {
      email: 'demo-aventurier@math4child.com',
      features: ['basic_exercises', 'progress_tracking', 'multiplayer'],
    },
    maitre: {
      email: 'demo-maitre@math4child.com',
      features: ['all_features'],
    },
  },
  
  LANGUAGES: [
    { code: 'fr', name: 'Français', flag: '🇫🇷' },
    { code: 'en', name: 'English', flag: '🇺🇸' },
    { code: 'es', name: 'Español', flag: '🇪🇸' },
    { code: 'ar', name: 'العربية', flag: '🇲🇦' },
    { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
    { code: 'zh', name: '中文', flag: '🇨🇳' },
  ],
  
  MATH_OPERATIONS: ['addition', 'subtraction', 'multiplication', 'division'],
  DIFFICULTY_LEVELS: [1, 2, 3, 4, 5],
};
EOF
    
    # Setup global
    cat > utils/global-setup.ts << 'EOF'
import { chromium, FullConfig } from '@playwright/test';

async function globalSetup(config: FullConfig) {
  console.log('🚀 Démarrage du setup global Math4Child...');
  
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  try {
    // Vérifier que l'application est accessible
    await page.goto(process.env.BASE_URL || 'http://localhost:3000');
    await page.waitForSelector('[data-testid="page-loaded"]', { timeout: 30000 });
    
    console.log('✅ Application Math4Child accessible');
    
    // Nettoyer les données de test précédentes si nécessaire
    await page.evaluate(() => {
      localStorage.clear();
      sessionStorage.clear();
    });
    
    console.log('🧹 Nettoyage des données de test effectué');
    
  } catch (error) {
    console.error('❌ Erreur lors du setup global:', error);
    throw error;
  } finally {
    await browser.close();
  }
}

export default globalSetup;
EOF
    
    # Teardown global
    cat > utils/global-teardown.ts << 'EOF'
async function globalTeardown() {
  console.log('🧹 Nettoyage global des tests Math4Child...');
  
  // Ici vous pouvez ajouter des tâches de nettoyage
  // comme la suppression de fichiers temporaires,
  // la fermeture de connexions base de données, etc.
  
  console.log('✅ Nettoyage terminé');
}

export default globalTeardown;
EOF
    
    # Tests de base
    mkdir -p specs
    cat > specs/math4child-basic.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper, TEST_DATA } from '../utils/test-helpers';

test.describe('Math4Child - Tests de base @smoke', () => {
  let helper: Math4ChildTestHelper;

  test.beforeEach(async ({ page }) => {
    helper = new Math4ChildTestHelper(page);
    await helper.goToHomePage();
  });

  test('Page d\'accueil se charge correctement @critical', async ({ page }) => {
    // Vérifier le titre
    await expect(page).toHaveTitle(/Math4Child/);
    
    // Vérifier les éléments principaux
    await expect(page.locator('h1')).toContainText('Math4Child');
    await expect(page.locator('[data-testid="start-free-button"]')).toBeVisible();
    await expect(page.locator('[data-testid="premium-features-button"]')).toBeVisible();
  });

  test('Navigation principale fonctionne', async ({ page }) => {
    // Tester les liens de navigation
    const navLinks = [
      { selector: '[data-testid="nav-exercises"]', expectedUrl: '/exercises' },
      { selector: '[data-testid="nav-progress"]', expectedUrl: '/progress' },
      { selector: '[data-testid="nav-about"]', expectedUrl: '/about' },
    ];

    for (const link of navLinks) {
      await page.click(link.selector);
      await expect(page).toHaveURL(new RegExp(link.expectedUrl));
      await helper.goToHomePage();
    }
  });

  test('Sélecteur de langues fonctionne @critical', async ({ page }) => {
    // Tester quelques langues principales
    const testLanguages = TEST_DATA.LANGUAGES.slice(0, 3);
    
    for (const lang of testLanguages) {
      await helper.selectLanguage(lang.code);
      
      // Vérifier que la langue a changé (présence du drapeau)
      await expect(page.locator(`text=${lang.flag}`)).toBeVisible();
      
      // Vérifier que l'attribut lang est mis à jour
      const htmlLang = await page.getAttribute('html', 'lang');
      expect(htmlLang).toBe(lang.code);
    }
  });

  test('Comptes démo sont accessibles', async ({ page }) => {
    await page.click('[data-testid="demo-accounts-button"]');
    
    // Vérifier que la modal s'ouvre
    await expect(page.locator('[data-testid="demo-accounts-modal"]')).toBeVisible();
    
    // Tester chaque compte démo
    for (const [accountType, accountData] of Object.entries(TEST_DATA.DEMO_ACCOUNTS)) {
      const accountButton = page.locator(`[data-testid="demo-${accountType}"]`);
      await expect(accountButton).toBeVisible();
      await expect(accountButton).toContainText(accountData.email);
    }
  });

  test('Connexion avec compte démo Découverte', async ({ page }) => {
    await helper.loginWithDemoAccount('decouverte');
    
    // Vérifier que l'utilisateur est connecté
    await expect(page.locator('[data-testid="user-menu"]')).toBeVisible();
    await expect(page.locator('[data-testid="user-email"]')).toContainText('demo-decouverte@math4child.com');
  });
});
EOF
    
    # Tests multilingues
    cat > specs/i18n.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper, TEST_DATA } from '../utils/test-helpers';

test.describe('Math4Child - Tests multilingues @i18n', () => {
  let helper: Math4ChildTestHelper;

  test.beforeEach(async ({ page }) => {
    helper = new Math4ChildTestHelper(page);
    await helper.goToHomePage();
  });

  for (const language of TEST_DATA.LANGUAGES) {
    test(`Interface en ${language.name}`, async ({ page }) => {
      await helper.selectLanguage(language.code);
      
      // Vérifier que la langue a changé
      await expect(page.locator(`text=${language.flag}`)).toBeVisible();
      
      // Vérifier l'attribut lang
      const htmlLang = await page.getAttribute('html', 'lang');
      expect(htmlLang).toBe(language.code);
      
      // Vérifier que les éléments principaux sont traduits
      await expect(page.locator('[data-testid="main-title"]')).toBeVisible();
      await expect(page.locator('[data-testid="start-free-button"]')).toBeVisible();
      
      // Test spécifique pour l'arabe (RTL)
      if (language.code === 'ar') {
        const direction = await page.getAttribute('html', 'dir');
        expect(direction).toBe('rtl');
      }
    });
  }

  test('Persistance de la langue', async ({ page }) => {
    // Changer de langue
    await helper.selectLanguage('es');
    
    // Recharger la page
    await page.reload();
    await helper.waitForPageLoad();
    
    // Vérifier que la langue est maintenue
    await expect(page.locator('text=🇪🇸')).toBeVisible();
    const htmlLang = await page.getAttribute('html', 'lang');
    expect(htmlLang).toBe('es');
  });

  test('Traduction du contenu dynamique', async ({ page }) => {
    // Tester avec le français
    await helper.selectLanguage('fr');
    await helper.loginWithDemoAccount('decouverte');
    
    // Naviguer vers les exercices
    await page.click('[data-testid="nav-exercises"]');
    
    // Vérifier que le contenu des exercices est en français
    await expect(page.locator('[data-testid="exercise-title"]')).toContainText(/[àâäéèêëïîôöùûüÿç]/i);
    
    // Changer en anglais
    await helper.selectLanguage('en');
    
    // Vérifier que le contenu change
    await expect(page.locator('[data-testid="exercise-title"]')).not.toContainText(/[àâäéèêëïîôöùûüÿç]/i);
  });
});
EOF
    
    # Tests du jeu
    cat > specs/game.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper, TEST_DATA } from '../utils/test-helpers';

test.describe('Math4Child - Tests du jeu mathématique @game', () => {
  let helper: Math4ChildTestHelper;

  test.beforeEach(async ({ page }) => {
    helper = new Math4ChildTestHelper(page);
    await helper.goToHomePage();
    await helper.loginWithDemoAccount('decouverte');
  });

  test('Démarrage d\'un jeu d\'addition @critical', async ({ page }) => {
    await helper.startMathGame('addition', 1);
    
    // Vérifier que le jeu a démarré
    await expect(page.locator('[data-testid="math-problem"]')).toBeVisible();
    await expect(page.locator('[data-testid="answer-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="submit-answer"]')).toBeVisible();
    
    // Vérifier le format du problème
    const problemText = await page.textContent('[data-testid="math-problem"]');
    expect(problemText).toMatch(/\d+\s*\+\s*\d+/);
  });

  test('Résolution d\'un problème mathématique', async ({ page }) => {
    await helper.startMathGame('addition', 1);
    
    // Résoudre le problème
    const isCorrect = await helper.solveMathProblem();
    expect(isCorrect).toBeTruthy();
    
    // Vérifier les feedbacks positifs
    await expect(page.locator('[data-testid="success-feedback"]')).toBeVisible();
    await expect(page.locator('[data-testid="next-problem-button"]')).toBeVisible();
  });

  test('Test de toutes les opérations', async ({ page }) => {
    for (const operation of TEST_DATA.MATH_OPERATIONS) {
      await helper.goToGamePage();
      await helper.startMathGame(operation as any, 1);
      
      // Vérifier que le problème correspond à l'opération
      const problemText = await page.textContent('[data-testid="math-problem"]');
      
      let expectedSymbol: string;
      switch (operation) {
        case 'addition': expectedSymbol = '+'; break;
        case 'subtraction': expectedSymbol = '-'; break;
        case 'multiplication': expectedSymbol = '×'; break;
        case 'division': expectedSymbol = '÷'; break;
        default: throw new Error(`Opération inconnue: ${operation}`);
      }
      
      expect(problemText).toContain(expectedSymbol);
    }
  });

  test('Progression du score', async ({ page }) => {
    await helper.startMathGame('addition', 1);
    
    // Score initial
    const initialScore = await page.textContent('[data-testid="current-score"]');
    const initialScoreValue = parseInt(initialScore || '0');
    
    // Résoudre un problème
    await helper.solveMathProblem();
    
    // Vérifier que le score a augmenté
    const newScore = await page.textContent('[data-testid="current-score"]');
    const newScoreValue = parseInt(newScore || '0');
    
    expect(newScoreValue).toBeGreaterThan(initialScoreValue);
  });

  test('Gestion des réponses incorrectes', async ({ page }) => {
    await helper.startMathGame('addition', 1);
    
    // Donner une réponse incorrecte
    await page.fill('[data-testid="answer-input"]', '999999');
    await page.click('[data-testid="submit-answer"]');
    
    // Vérifier le feedback d'erreur
    await expect(page.locator('[data-testid="error-feedback"]')).toBeVisible();
    await expect(page.locator('[data-testid="try-again-button"]')).toBeVisible();
  });

  test('Sons et animations', async ({ page }) => {
    await helper.startMathGame('addition', 1);
    
    // Mock de l'API Audio pour vérifier les sons
    const audioPlayPromise = page.waitForFunction(() => {
      return window.Audio && typeof window.Audio === 'function';
    });
    
    await helper.solveMathProblem();
    
    // Vérifier les animations de succès
    await expect(page.locator('[data-testid="success-animation"]')).toBeVisible();
    
    await audioPlayPromise;
  });
});
EOF
    
    # Tests de performance
    cat > specs/performance.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper } from '../utils/test-helpers';

test.describe('Math4Child - Tests de performance @performance', () => {
  let helper: Math4ChildTestHelper;

  test.beforeEach(async ({ page }) => {
    helper = new Math4ChildTestHelper(page);
  });

  test('Temps de chargement de la page d\'accueil', async ({ page }) => {
    const startTime = Date.now();
    
    await helper.goToHomePage();
    
    const loadTime = Date.now() - startTime;
    
    // La page doit se charger en moins de 3 secondes
    expect(loadTime).toBeLessThan(3000);
    
    console.log(`Temps de chargement: ${loadTime}ms`);
  });

  test('Performance du changement de langue', async ({ page }) => {
    await helper.goToHomePage();
    
    const startTime = Date.now();
    await helper.selectLanguage('es');
    const switchTime = Date.now() - startTime;
    
    // Le changement de langue doit être rapide
    expect(switchTime).toBeLessThan(1000);
    
    console.log(`Temps de changement de langue: ${switchTime}ms`);
  });

  test('Web Vitals', async ({ page }) => {
    await page.goto('/');
    
    // Mesurer les Core Web Vitals
    const vitals = await page.evaluate(() => {
      return new Promise((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries();
          const vitals: any = {};
          
          entries.forEach((entry) => {
            if (entry.name === 'first-contentful-paint') {
              vitals.fcp = entry.startTime;
            }
            if (entry.name === 'largest-contentful-paint') {
              vitals.lcp = entry.startTime;
            }
          });
          
          resolve(vitals);
        }).observe({ entryTypes: ['paint', 'largest-contentful-paint'] });
        
        // Timeout après 5 secondes
        setTimeout(() => resolve({}), 5000);
      });
    });
    
    console.log('Web Vitals:', vitals);
  });

  test('Taille des ressources', async ({ page }) => {
    let totalSize = 0;
    
    page.on('response', response => {
      const contentLength = response.headers()['content-length'];
      if (contentLength) {
        totalSize += parseInt(contentLength);
      }
    });
    
    await helper.goToHomePage();
    
    console.log(`Taille totale des ressources: ${(totalSize / 1024).toFixed(2)} KB`);
    
    // La page ne doit pas dépasser 2MB
    expect(totalSize).toBeLessThan(2 * 1024 * 1024);
  });
});
EOF
    
    cd ..
    log "SUCCESS" "✅ Configuration Playwright créée"
}

# Configuration Docker optimisée
setup_docker() {
    log "INFO" "🐳 Configuration Docker pour Math4Child..."
    
    # Dockerfile multi-stage optimisé
    cat > Dockerfile << 'EOF'
# Dockerfile multi-stage optimisé pour Math4Child
ARG NODE_VERSION=20.10.0

#===============================================================================
# Base stage avec Node.js et pnpm
#===============================================================================
FROM node:${NODE_VERSION}-alpine AS base
LABEL maintainer="Math4Child Team <dev@math4child.com>"
LABEL description="Math4Child - Application éducative de mathématiques"

# Installation des dépendances système
RUN apk add --no-cache \
    libc6-compat \
    curl \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/cache/apk/*

# Installation de pnpm pour de meilleures performances
RUN npm install -g pnpm@latest

# Création de l'utilisateur non-root
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

WORKDIR /app

#===============================================================================
# Dependencies stage - Installation des dépendances
#===============================================================================
FROM base AS deps

# Copie des fichiers de configuration
COPY package*.json pnpm-lock.yaml* ./
COPY apps/math4child/package*.json ./apps/math4child/

# Installation des dépendances avec cache
RUN --mount=type=cache,target=/root/.npm \
    pnpm install --frozen-lockfile --prefer-offline

#===============================================================================
# Development stage
#===============================================================================
FROM base AS development

# Copie des dépendances depuis deps
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/math4child/node_modules ./apps/math4child/node_modules

# Copie du code source
COPY . .

# Variables d'environnement de développement
ENV NODE_ENV=development
ENV NEXT_TELEMETRY_DISABLED=1

EXPOSE 3000

CMD ["pnpm", "dev"]

#===============================================================================
# Build stage - Construction de l'application
#===============================================================================
FROM base AS builder

# Copie des dépendances depuis deps
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/math4child/node_modules ./apps/math4child/node_modules

# Copie du code source
COPY . .

# Variables d'environnement de build
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Build de l'application
RUN --mount=type=cache,target=/app/.next/cache \
    pnpm build

#===============================================================================
# Production stage - Image finale optimisée
#===============================================================================
FROM base AS production

# Variables d'environnement de production
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Copie des fichiers nécessaires pour la production
COPY --from=builder --chown=nextjs:nodejs /app/apps/math4child/public ./apps/math4child/public
COPY --from=builder --chown=nextjs:nodejs /app/apps/math4child/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/math4child/.next/static ./apps/math4child/.next/static

# Ajout des scripts de santé
COPY --chown=nextjs:nodejs scripts/healthcheck.js ./

USER nextjs

EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

CMD ["node", "apps/math4child/server.js"]
EOF
    
    # Docker Compose pour développement complet
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  #===============================================================================
  # Application Math4Child
  #===============================================================================
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: development
    container_name: math4child-app
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://math4child_user:math4child_secure_pass@postgres:5432/math4child_db
      - REDIS_URL=redis://redis:6379
      - STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY:-sk_test_dummy}
      - NEXTAUTH_SECRET=${NEXTAUTH_SECRET:-development-secret-key}
      - NEXTAUTH_URL=http://localhost:3000
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - .:/app
      - /app/node_modules
      - /app/apps/math4child/node_modules
      - /app/apps/math4child/.next
    networks:
      - math4child-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  #===============================================================================
  # Base de données PostgreSQL
  #===============================================================================
  postgres:
    image: postgres:16-alpine
    container_name: math4child-postgres
    restart: always
    environment:
      POSTGRES_DB: math4child_db
      POSTGRES_USER: math4child_user
      POSTGRES_PASSWORD: math4child_secure_pass
      POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=fr_FR.UTF-8 --lc-ctype=fr_FR.UTF-8"
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/01-init.sql
      - ./database/migrations:/docker-entrypoint-initdb.d/migrations
      - ./backups/postgres:/backups
    networks:
      - math4child-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U math4child_user -d math4child_db"]
      interval: 10s
      timeout: 5s
      retries: 5
    command: >
      postgres
      -c max_connections=200
      -c shared_buffers=256MB
      -c effective_cache_size=1GB
      -c work_mem=4MB
      -c maintenance_work_mem=64MB
      -c random_page_cost=1.1
      -c temp_file_limit=2GB
      -c log_min_duration_statement=200ms
      -c log_statement=ddl
      -c log_checkpoints=on
      -c log_connections=on
      -c log_disconnections=on
      -c log_lock_waits=on

  #===============================================================================
  # Redis pour cache et sessions
  #===============================================================================
  redis:
    image: redis:7-alpine
    container_name: math4child-redis
    restart: always
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
      - ./infrastructure/redis/redis.conf:/etc/redis/redis.conf
    networks:
      - math4child-network
    command: redis-server /etc/redis/redis.conf
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  #===============================================================================
  # Nginx Reverse Proxy
  #===============================================================================
  nginx:
    image: nginx:alpine
    container_name: math4child-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./infrastructure/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./infrastructure/nginx/conf.d:/etc/nginx/conf.d:ro
      - ./certificates:/etc/nginx/certificates:ro
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - app
    networks:
      - math4child-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  #===============================================================================
  # Monitoring avec Prometheus
  #===============================================================================
  prometheus:
    image: prom/prometheus:latest
    container_name: math4child-prometheus
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - ./monitoring/prometheus/rules:/etc/prometheus/rules:ro
      - prometheus_data:/prometheus
    networks:
      - math4child-network
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'

  #===============================================================================
  # Grafana pour visualisation
  #===============================================================================
  grafana:
    image: grafana/grafana:latest
    container_name: math4child-grafana
    restart: always
    ports:
      - "3001:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_ADMIN_PASSWORD:-admin123}
      GF_USERS_ALLOW_SIGN_UP: false
      GF_SERVER_DOMAIN: grafana.math4child.com
      GF_SMTP_ENABLED: false
    volumes:
      - grafana_data:/var/lib/grafana
      - ./monitoring/grafana/provisioning:/etc/grafana/provisioning:ro
      - ./monitoring/grafana/dashboards:/var/lib/grafana/dashboards:ro
    networks:
      - math4child-network
    depends_on:
      - prometheus

  #===============================================================================
  # Tests Playwright (optionnel)
  #===============================================================================
  playwright:
    build:
      context: .
      dockerfile: tests/Dockerfile
    container_name: math4child-tests
    volumes:
      - ./tests:/tests
      - ./test-results:/test-results
    environment:
      - BASE_URL=http://app:3000
    depends_on:
      - app
    networks:
      - math4child-network
    profiles:
      - testing

  #===============================================================================
  # Backup automatique
  #===============================================================================
  backup:
    image: prodrigestivill/postgres-backup-local
    container_name: math4child-backup
    restart: always
    volumes:
      - ./backups/postgres:/backups
    environment:
      - POSTGRES_HOST=postgres
      - POSTGRES_DB=math4child_db
      - POSTGRES_USER=math4child_user
      - POSTGRES_PASSWORD=math4child_secure_pass
      - POSTGRES_EXTRA_OPTS=-Z6 --schema=public --blobs
      - SCHEDULE=0 2 * * *
      - BACKUP_KEEP_DAYS=7
      - BACKUP_KEEP_WEEKS=4
      - BACKUP_KEEP_MONTHS=6
    depends_on:
      - postgres
    networks:
      - math4child-network

#===============================================================================
# Volumes persistants
#===============================================================================
volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local
  prometheus_data:
    driver: local
  grafana_data:
    driver: local

#===============================================================================
# Réseau
#===============================================================================
networks:
  math4child-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
EOF
    
    # Configuration Nginx optimisée
    mkdir -p infrastructure/nginx/conf.d
    cat > infrastructure/nginx/nginx.conf << 'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /var/run/nginx.pid;

events {
    worker_connections 2048;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging format
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time"';

    access_log /var/log/nginx/access.log main;

    # Performance optimizations
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 4096;
    client_max_body_size 10M;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json
        image/svg+xml;

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=auth:10m rate=5r/m;
    limit_req_zone $binary_remote_addr zone=static:10m rate=50r/s;

    # Upstream configuration
    upstream math4child_app {
        server app:3000 max_fails=3 fail_timeout=30s;
        keepalive 32;
    }

    # Security headers
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;

    include /etc/nginx/conf.d/*.conf;
}
EOF
    
    cat > infrastructure/nginx/conf.d/math4child.conf << 'EOF'
server {
    listen 80;
    server_name math4child.com www.math4child.com;

    # Redirect to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name math4child.com www.math4child.com;

    # SSL configuration
    ssl_certificate /etc/nginx/certificates/fullchain.pem;
    ssl_certificate_key /etc/nginx/certificates/privkey.pem;
    ssl_session_cache shared:SSL:50m;
    ssl_session_timeout 1d;
    ssl_session_tickets off;

    # Modern SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # HSTS
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;

    # Security headers
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://js.stripe.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https://api.stripe.com; media-src 'self'; object-src 'none'; frame-src https://js.stripe.com;" always;

    # Root location
    location / {
        proxy_pass http://math4child_app;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_connect_timeout 5s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # API routes with rate limiting
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        proxy_pass http://math4child_app;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Authentication endpoints with stricter rate limiting
    location /api/auth/ {
        limit_req zone=auth burst=5 nodelay;
        proxy_pass http://math4child_app;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Static files with caching
    location /_next/static/ {
        limit_req zone=static burst=100 nodelay;
        proxy_pass http://math4child_app;
        proxy_cache_valid 200 1y;
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Images and media
    location ~* \.(jpg|jpeg|png|gif|ico|svg|webp|avif)$ {
        proxy_pass http://math4child_app;
        expires 30d;
        add_header Cache-Control "public, no-transform";
        access_log off;
    }

    # Fonts
    location ~* \.(woff|woff2|ttf|eot)$ {
        proxy_pass http://math4child_app;
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Health check
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }

    # Favicon
    location = /favicon.ico {
        proxy_pass http://math4child_app;
        expires 30d;
        access_log off;
    }

    # Robots.txt
    location = /robots.txt {
        proxy_pass http://math4child_app;
        expires 1d;
        access_log off;
    }
}
EOF
    
    # Configuration Redis optimisée
    mkdir -p infrastructure/redis
    cat > infrastructure/redis/redis.conf << 'EOF'
# Redis configuration pour Math4Child
port 6379
bind 0.0.0.0
protected-mode yes
requirepass math4child_redis_pass

# Memory management
maxmemory 256mb
maxmemory-policy allkeys-lru

# Persistence
save 900 1
save 300 10
save 60 10000

# Logging
loglevel notice
logfile ""

# Network
timeout 300
tcp-keepalive 300

# Clients
maxclients 1000

# Performance
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100

# Security
rename-command FLUSHDB ""
rename-command FLUSHALL ""
rename-command KEYS ""
rename-command CONFIG "CONFIG_b7d43c1c"
EOF
    
    # Script de healthcheck
    cat > scripts/healthcheck.js << 'EOF'
const http = require('http');

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/api/health',
  method: 'GET',
  timeout: 3000,
};

const req = http.request(options, (res) => {
  if (res.statusCode === 200) {
    process.exit(0);
  } else {
    console.error(`Health check failed: ${res.statusCode}`);
    process.exit(1);
  }
});

req.on('error', (err) => {
  console.error(`Health check error: ${err.message}`);
  process.exit(1);
});

req.on('timeout', () => {
  console.error('Health check timeout');
  req.destroy();
  process.exit(1);
});

req.end();
EOF
    
    chmod +x scripts/healthcheck.js
    
    log "SUCCESS" "✅ Configuration Docker avancée créée"
}

# Configuration de la base de données avec migrations
setup_database() {
    log "INFO" "🗄️ Configuration de la base de données PostgreSQL avec migrations..."
    
    # Script d'initialisation principal
    cat > database/init.sql << 'EOF'
-- Initialisation de la base de données Math4Child
-- Création des extensions nécessaires
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "btree_gin";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Configuration de la timezone
SET timezone = 'UTC';

-- Création du schéma principal
CREATE SCHEMA IF NOT EXISTS math4child;
SET search_path = math4child, public;

-- Table des versions de migration
CREATE TABLE IF NOT EXISTS schema_migrations (
    version VARCHAR(255) PRIMARY KEY,
    dirty BOOLEAN DEFAULT FALSE,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fonction pour les timestamps automatiques
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

-- Table des utilisateurs
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    subscription_plan VARCHAR(50) DEFAULT 'free' CHECK (subscription_plan IN ('free', 'monthly', 'quarterly', 'yearly', 'school')),
    subscription_status VARCHAR(20) DEFAULT 'active' CHECK (subscription_status IN ('active', 'canceled', 'expired', 'suspended')),
    subscription_start_date TIMESTAMP,
    subscription_end_date TIMESTAMP,
    language_preference VARCHAR(5) DEFAULT 'fr',
    timezone VARCHAR(50) DEFAULT 'UTC',
    date_format VARCHAR(20) DEFAULT 'DD/MM/YYYY',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    login_count INTEGER DEFAULT 0,
    email_verified BOOLEAN DEFAULT false,
    email_verification_token VARCHAR(255),
    password_reset_token VARCHAR(255),
    password_reset_expires TIMESTAMP,
    avatar_url TEXT,
    preferences JSONB DEFAULT '{}',
    metadata JSONB DEFAULT '{}'
);

-- Table des profils enfants
CREATE TABLE child_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    age INTEGER CHECK (age >= 4 AND age <= 18),
    grade_level INTEGER CHECK (grade_level >= 1 AND grade_level <= 12),
    birth_date DATE,
    avatar_url TEXT,
    avatar_type VARCHAR(50) DEFAULT 'default',
    language_preference VARCHAR(5) DEFAULT 'fr',
    difficulty_preference VARCHAR(20) DEFAULT 'adaptive',
    total_xp INTEGER DEFAULT 0,
    current_level INTEGER DEFAULT 1,
    current_streak INTEGER DEFAULT 0,
    best_streak INTEGER DEFAULT 0,
    total_sessions INTEGER DEFAULT 0,
    total_correct_answers INTEGER DEFAULT 0,
    total_questions_answered INTEGER DEFAULT 0,
    favorite_operation VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    parental_controls JSONB DEFAULT '{}',
    learning_preferences JSONB DEFAULT '{}',
    achievements_earned JSONB DEFAULT '[]'
);

-- Table des sessions d'exercices
CREATE TABLE exercise_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_profile_id UUID REFERENCES child_profiles(id) ON DELETE CASCADE,
    operation_type VARCHAR(20) NOT NULL CHECK (operation_type IN ('addition', 'subtraction', 'multiplication', 'division', 'mixed')),
    difficulty_level INTEGER NOT NULL CHECK (difficulty_level >= 1 AND difficulty_level <= 10),
    session_type VARCHAR(20) DEFAULT 'practice' CHECK (session_type IN ('practice', 'test', 'challenge', 'multiplayer')),
    questions_total INTEGER NOT NULL,
    questions_correct INTEGER NOT NULL,
    questions_incorrect INTEGER GENERATED ALWAYS AS (questions_total - questions_correct) STORED,
    accuracy_percentage DECIMAL(5,2) GENERATED ALWAYS AS (ROUND((questions_correct::DECIMAL / questions_total) * 100, 2)) STORED,
    time_spent_seconds INTEGER,
    average_time_per_question DECIMAL(8,2) GENERATED ALWAYS AS (ROUND(time_spent_seconds::DECIMAL / questions_total, 2)) STORED,
    xp_earned INTEGER DEFAULT 0,
    coins_earned INTEGER DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    device_type VARCHAR(20),
    browser_info VARCHAR(100),
    session_data JSONB DEFAULT '{}',
    hints_used INTEGER DEFAULT 0,
    power_ups_used JSONB DEFAULT '[]'
);

-- Table des questions et réponses détaillées
CREATE TABLE question_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES exercise_sessions(id) ON DELETE CASCADE,
    question_number INTEGER NOT NULL,
    operation_type VARCHAR(20) NOT NULL,
    operand_1 INTEGER NOT NULL,
    operand_2 INTEGER NOT NULL,
    operator VARCHAR(3) NOT NULL,
    correct_answer DECIMAL(10,4) NOT NULL,
    user_answer DECIMAL(10,4),
    is_correct BOOLEAN NOT NULL,
    time_taken_seconds DECIMAL(6,2),
    hints_used INTEGER DEFAULT 0,
    attempts_count INTEGER DEFAULT 1,
    difficulty_level INTEGER,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    question_metadata JSONB DEFAULT '{}'
);

-- Table des accomplissements/badges
CREATE TABLE achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_profile_id UUID REFERENCES child_profiles(id) ON DELETE CASCADE,
    achievement_type VARCHAR(50) NOT NULL,
    achievement_category VARCHAR(30) NOT NULL,
    achievement_name VARCHAR(100) NOT NULL,
    achievement_description TEXT,
    achievement_icon VARCHAR(100),
    points_value INTEGER DEFAULT 0,
    rarity_level VARCHAR(20) DEFAULT 'common' CHECK (rarity_level IN ('common', 'uncommon', 'rare', 'epic', 'legendary')),
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress_data JSONB DEFAULT '{}',
    is_showcased BOOLEAN DEFAULT FALSE
);

-- Table des paiements et abonnements
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    stripe_payment_intent_id VARCHAR(255) UNIQUE,
    stripe_customer_id VARCHAR(255),
    amount_cents INTEGER NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
    plan_type VARCHAR(50) NOT NULL,
    billing_period VARCHAR(20),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'succeeded', 'failed', 'canceled', 'refunded')),
    payment_method VARCHAR(50),
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    refunded_at TIMESTAMP,
    refund_amount_cents INTEGER,
    metadata JSONB DEFAULT '{}',
    invoice_url TEXT,
    receipt_url TEXT
);

-- Table des événements d'analytics
CREATE TABLE analytics_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    child_profile_id UUID REFERENCES child_profiles(id) ON DELETE SET NULL,
    session_id VARCHAR(100),
    event_type VARCHAR(50) NOT NULL,
    event_category VARCHAR(30) NOT NULL,
    event_action VARCHAR(100) NOT NULL,
    event_label VARCHAR(200),
    event_value INTEGER,
    page_url TEXT,
    referrer_url TEXT,
    user_agent TEXT,
    ip_address INET,
    country_code VARCHAR(2),
    city VARCHAR(100),
    device_type VARCHAR(20),
    browser_name VARCHAR(50),
    browser_version VARCHAR(20),
    os_name VARCHAR(50),
    os_version VARCHAR(20),
    screen_resolution VARCHAR(20),
    language VARCHAR(10),
    timezone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    event_data JSONB DEFAULT '{}'
);

-- Table des leaderboards/classements
CREATE TABLE leaderboards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    child_profile_id UUID REFERENCES child_profiles(id) ON DELETE CASCADE,
    leaderboard_type VARCHAR(30) NOT NULL CHECK (leaderboard_type IN ('weekly_xp', 'monthly_xp', 'streak', 'accuracy', 'speed')),
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    score INTEGER NOT NULL,
    rank_position INTEGER,
    percentile DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(child_profile_id, leaderboard_type, period_start)
);

-- Table des contenus éducatifs
CREATE TABLE educational_content (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    content_type VARCHAR(30) NOT NULL CHECK (content_type IN ('lesson', 'exercise', 'game', 'video', 'animation')),
    subject VARCHAR(50) NOT NULL,
    topic VARCHAR(100) NOT NULL,
    difficulty_level INTEGER CHECK (difficulty_level >= 1 AND difficulty_level <= 10),
    age_min INTEGER CHECK (age_min >= 4),
    age_max INTEGER CHECK (age_max <= 18),
    language VARCHAR(5) NOT NULL,
    content_url TEXT,
    thumbnail_url TEXT,
    duration_minutes INTEGER,
    is_premium BOOLEAN DEFAULT FALSE,
    is_published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB DEFAULT '{}'
);

-- Index pour les performances
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_subscription ON users(subscription_plan, subscription_status);
CREATE INDEX idx_users_created_at ON users(created_at);

CREATE INDEX idx_child_profiles_user_id ON child_profiles(user_id);
CREATE INDEX idx_child_profiles_active ON child_profiles(is_active) WHERE is_active = true;
CREATE INDEX idx_child_profiles_xp ON child_profiles(total_xp DESC);

CREATE INDEX idx_exercise_sessions_child_profile_id ON exercise_sessions(child_profile_id);
CREATE INDEX idx_exercise_sessions_completed_at ON exercise_sessions(completed_at DESC);
CREATE INDEX idx_exercise_sessions_operation_type ON exercise_sessions(operation_type);
CREATE INDEX idx_exercise_sessions_difficulty ON exercise_sessions(difficulty_level);

CREATE INDEX idx_question_responses_session_id ON question_responses(session_id);
CREATE INDEX idx_question_responses_is_correct ON question_responses(is_correct);
CREATE INDEX idx_question_responses_operation ON question_responses(operation_type);

CREATE INDEX idx_achievements_child_profile_id ON achievements(child_profile_id);
CREATE INDEX idx_achievements_type ON achievements(achievement_type);
CREATE INDEX idx_achievements_unlocked_at ON achievements(unlocked_at DESC);

CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_processed_at ON payments(processed_at DESC);

CREATE INDEX idx_analytics_events_created_at ON analytics_events(created_at);
CREATE INDEX idx_analytics_events_event_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_events_user_id ON analytics_events(user_id);
CREATE INDEX idx_analytics_events_child_profile_id ON analytics_events(child_profile_id);

CREATE INDEX idx_leaderboards_type_period ON leaderboards(leaderboard_type, period_start, period_end);
CREATE INDEX idx_leaderboards_score ON leaderboards(score DESC);

CREATE INDEX idx_educational_content_published ON educational_content(is_published) WHERE is_published = true;
CREATE INDEX idx_educational_content_difficulty ON educational_content(difficulty_level);
CREATE INDEX idx_educational_content_language ON educational_content(language);

-- Index de recherche full-text
CREATE INDEX idx_educational_content_search ON educational_content USING gin(to_tsvector('french', title || ' ' || description));

-- Triggers pour updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_child_profiles_updated_at BEFORE UPDATE ON child_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_educational_content_updated_at BEFORE UPDATE ON educational_content FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insertion de données de test
INSERT INTO users (email, password_hash, first_name, last_name, subscription_plan, email_verified) VALUES
('demo-decouverte@math4child.com', '$2b$12$dummy.hash.for.testing.only', 'Demo', 'Découverte', 'free', true),
('demo-explorateur@math4child.com', '$2b$12$dummy.hash.for.testing.only', 'Demo', 'Explorateur', 'monthly', true),
('demo-aventurier@math4child.com', '$2b$12$dummy.hash.for.testing.only', 'Demo', 'Aventurier', 'quarterly', true),
('demo-maitre@math4child.com', '$2b$12$dummy.hash.for.testing.only', 'Demo', 'Maître', 'yearly', true),
('demo-academie@math4child.com', '$2b$12$dummy.hash.for.testing.only', 'Demo', 'Académie', 'school', true);

-- Insertion de profils enfants de demo
INSERT INTO child_profiles (user_id, name, age, grade_level, total_xp, current_level) 
SELECT 
    u.id,
    CASE 
        WHEN u.first_name = 'Découverte' THEN 'Alice'
        WHEN u.first_name = 'Explorateur' THEN 'Bob'
        WHEN u.first_name = 'Aventurier' THEN 'Charlie'
        WHEN u.first_name = 'Maître' THEN 'Diana'
        ELSE 'Emma'
    END,
    CASE 
        WHEN u.first_name = 'Découverte' THEN 6
        WHEN u.first_name = 'Explorateur' THEN 8
        WHEN u.first_name = 'Aventurier' THEN 10
        WHEN u.first_name = 'Maître' THEN 12
        ELSE 7
    END,
    CASE 
        WHEN u.first_name = 'Découverte' THEN 1
        WHEN u.first_name = 'Explorateur' THEN 3
        WHEN u.first_name = 'Aventurier' THEN 5
        WHEN u.first_name = 'Maître' THEN 7
        ELSE 2
    END,
    CASE 
        WHEN u.first_name = 'Découverte' THEN 150
        WHEN u.first_name = 'Explorateur' THEN 850
        WHEN u.first_name = 'Aventurier' THEN 2400
        WHEN u.first_name = 'Maître' THEN 5800
        ELSE 300
    END,
    CASE 
        WHEN u.first_name = 'Découverte' THEN 1
        WHEN u.first_name = 'Explorateur' THEN 3
        WHEN u.first_name = 'Aventurier' THEN 7
        WHEN u.first_name = 'Maître' THEN 15
        ELSE 2
    END
FROM users u 
WHERE u.email LIKE 'demo-%@math4child.com';

-- Enregistrement de la version initiale
INSERT INTO schema_migrations (version) VALUES ('001_initial_schema');

-- Fonctions utilitaires
CREATE OR REPLACE FUNCTION calculate_user_stats(user_uuid UUID)
RETURNS TABLE(
    total_sessions INTEGER,
    total_questions INTEGER,
    total_correct INTEGER,
    average_accuracy DECIMAL(5,2),
    total_time_seconds INTEGER,
    current_streak INTEGER,
    best_streak INTEGER
) AS $
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(es.id)::INTEGER as total_sessions,
        SUM(es.questions_total)::INTEGER as total_questions,
        SUM(es.questions_correct)::INTEGER as total_correct,
        ROUND(AVG(es.accuracy_percentage), 2) as average_accuracy,
        SUM(es.time_spent_seconds)::INTEGER as total_time_seconds,
        cp.current_streak,
        cp.best_streak
    FROM exercise_sessions es
    JOIN child_profiles cp ON es.child_profile_id = cp.id
    WHERE cp.user_id = user_uuid
    GROUP BY cp.current_streak, cp.best_streak;
END;
$ LANGUAGE plpgsql;

-- Vue pour les statistiques globales
CREATE VIEW global_stats AS
SELECT 
    COUNT(DISTINCT u.id) as total_users,
    COUNT(DISTINCT cp.id) as total_child_profiles,
    COUNT(es.id) as total_sessions,
    SUM(es.questions_total) as total_questions,
    SUM(es.questions_correct) as total_correct_answers,
    ROUND(AVG(es.accuracy_percentage), 2) as global_accuracy,
    COUNT(DISTINCT a.id) as total_achievements
FROM users u
LEFT JOIN child_profiles cp ON u.id = cp.user_id
LEFT JOIN exercise_sessions es ON cp.id = es.child_profile_id
LEFT JOIN achievements a ON cp.id = a.child_profile_id;

COMMIT;
EOF