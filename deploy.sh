#!/bin/bash

# ==============================================
# 🚀 Script de déploiement Multi-Apps Platform
# ==============================================

set -e

ENVIRONMENT=${1:-staging}
REGISTRY="ghcr.io/khalidksouri/multi-apps-platform"

echo "🚀 Déployement Multi-Apps Platform - Environment: $ENVIRONMENT"

# Vérifier les prérequis
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker-compose n'est pas installé"
    exit 1
fi

# Login au registry
echo "🔐 Connexion au registry GitHub..."
echo "$GITHUB_TOKEN" | docker login ghcr.io -u khalidksouri --password-stdin

# Pull des images
echo "📥 Pull des images Docker..."
docker-compose pull

# Démarrage des services
echo "🚀 Démarrage des services..."
if [ "$ENVIRONMENT" = "production" ]; then
    docker-compose -f docker-compose.prod.yml up -d
else
    docker-compose up -d
fi

# Attendre que les services soient prêts
echo "⏳ Attente que les services soient prêts..."
sleep 30

# Health check
echo "🏥 Vérification de l'état des services..."
SERVICES=("postmath:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")

for service in "${SERVICES[@]}"; do
    IFS=':' read -r name port <<< "$service"
    if curl -f "http://localhost:$port/api/health" &> /dev/null; then
        echo "✅ $name: healthy"
    else
        echo "❌ $name: unhealthy"
    fi
done

# Nettoyage
echo "🧹 Nettoyage des images inutiles..."
docker system prune -f

echo "🎉 Déploiement terminé!"
echo "🔗 Applications disponibles:"
echo "   - PostMath: http://localhost:3001"
echo "   - UnitFlip: http://localhost:3002"
echo "   - BudgetCron: http://localhost:3003"
echo "   - AI4Kids: http://localhost:3004"
echo "   - MultiAI: http://localhost:3005"
