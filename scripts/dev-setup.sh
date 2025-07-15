#!/bin/bash

echo "🚀 Configuration de l'environnement de développement..."

# Vérifier les prérequis
check_requirements() {
    echo "🔍 Vérification des prérequis..."
    
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js non installé"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        echo "❌ npm non installé"
        exit 1
    fi
    
    echo "✅ Node.js: $(node --version)"
    echo "✅ npm: $(npm --version)"
}

# Démarrer les services Docker
start_services() {
    if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
        echo "🐳 Démarrage des services Docker..."
        docker-compose up -d postgres redis
        
        echo "⏳ Attente de la disponibilité des services..."
        sleep 15
        
        # Vérifier PostgreSQL
        if docker-compose exec postgres pg_isready -U multiapps > /dev/null 2>&1; then
            echo "✅ PostgreSQL prêt"
        else
            echo "⚠️ PostgreSQL non disponible, continuons..."
        fi
        
        # Vérifier Redis
        if docker-compose exec redis redis-cli ping > /dev/null 2>&1; then
            echo "✅ Redis prêt"
        else
            echo "⚠️ Redis non disponible, continuons..."
        fi
    else
        echo "⚠️ Docker non disponible, services externes requis"
    fi
}

# Installer les dépendances
install_dependencies() {
    echo "📦 Installation des dépendances..."
    
    # Nettoyer le cache
    npm cache clean --force
    
    # Installer les dépendances root
    npm install --no-audit --no-fund
    
    # Construire les packages partagés
    echo "🏗️ Construction des packages partagés..."
    npm run build:packages || echo "⚠️ Build packages échoué, continuons..."
}

# Configurer Prisma
setup_prisma() {
    echo "🔧 Configuration Prisma..."
    
    # Générer le client Prisma
    npx prisma generate
    
    # Pousser le schéma (en développement)
    if [[ "$NODE_ENV" != "production" ]]; then
        npx prisma db push --skip-generate || echo "⚠️ Push DB échoué, continuons..."
    fi
}

# Vérifier la configuration
verify_setup() {
    echo "🔍 Vérification de la configuration..."
    
    # Vérifier les fichiers essentiels
    files_to_check=(
        ".env"
        "prisma/schema.prisma"
        "packages/shared/src/validation/index.ts"
        "packages/shared/src/utils/logger.ts"
    )
    
    for file in "${files_to_check[@]}"; do
        if [[ -f "$file" ]]; then
            echo "✅ $file présent"
        else
            echo "❌ $file manquant"
        fi
    done
}

# Afficher les informations de démarrage
show_startup_info() {
    echo ""
    echo "🎉 Configuration terminée !"
    echo "=============================================="
    echo "🌐 Applications disponibles :"
    echo "   • PostMath:    http://localhost:3001"
    echo "   • UnitFlip:    http://localhost:3002"
    echo "   • BudgetCron:  http://localhost:3003"
    echo "   • AI4Kids:     http://localhost:3004"
    echo "   • MultiAI:     http://localhost:3005"
    echo ""
    echo "📊 Services :"
    echo "   • PostgreSQL: localhost:5432"
    echo "   • Redis:      localhost:6379"
    echo ""
    echo "🚀 Commandes suivantes :"
    echo "   npm run dev              # Démarrer toutes les apps"
    echo "   npm run test:security    # Tests de sécurité"
    echo "   npm run db:studio        # Interface Prisma"
    echo "=============================================="
}

# Exécution principale
main() {
    check_requirements
    start_services
    install_dependencies
    setup_prisma
    verify_setup
    show_startup_info
}

# Gestion des erreurs
handle_error() {
    echo "❌ Erreur durant la configuration"
    echo "💡 Vérifiez les logs ci-dessus et réessayez"
    exit 1
}

trap handle_error ERR

main "$@"
