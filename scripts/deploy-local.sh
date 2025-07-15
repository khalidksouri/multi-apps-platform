#!/bin/bash

# ==============================================
# 🚀 Script de déploiement local
# ==============================================

set -e

ENVIRONMENT=${1:-development}
REGISTRY="ghcr.io/khalidksouri/multi-apps-platform"

echo "🚀 Déploiement local Multi-Apps Platform - Environment: $ENVIRONMENT"

# Build des applications
echo "🏗️ Build des applications..."
npm run build:packages
npm run build:apps

# Build des images Docker
echo "🐳 Build des images Docker..."
docker build -t $REGISTRY/postmath:$ENVIRONMENT -f apps/postmath/Dockerfile .
docker build -t $REGISTRY/unitflip:$ENVIRONMENT -f apps/unitflip/Dockerfile .
docker build -t $REGISTRY/budgetcron:$ENVIRONMENT -f apps/budgetcron/Dockerfile .
docker build -t $REGISTRY/ai4kids:$ENVIRONMENT -f apps/ai4kids/Dockerfile .
docker build -t $REGISTRY/multiai:$ENVIRONMENT -f apps/multiai/Dockerfile .

# Démarrage avec docker-compose
echo "🚀 Démarrage des services..."
docker-compose up -d

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

echo ""
echo "🎉 Déploiement local terminé!"
echo "🔗 Applications disponibles:"
echo "   - PostMath: http://localhost:3001"
echo "   - UnitFlip: http://localhost:3002"
echo "   - BudgetCron: http://localhost:3003"
echo "   - AI4Kids: http://localhost:3004"
echo "   - MultiAI: http://localhost:3005"
echo ""
echo "📊 Commandes utiles:"
echo "   docker-compose logs -f     # Voir les logs"
echo "   docker-compose down        # Arrêter les services"
echo "   docker-compose ps          # Voir l'état des services"
