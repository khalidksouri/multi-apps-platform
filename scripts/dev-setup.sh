#!/bin/bash
set -e
set -u

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Setup du Workspace Multi-Applications${NC}"

# Vérifications de base
if [ ! -f "package.json" ]; then
    echo "❌ Ce script doit être exécuté depuis la racine du projet"
    exit 1
fi

# Créer les dossiers
mkdir -p logs reports coverage test-results scripts

# Créer .env si inexistant
if [ ! -f ".env" ]; then
    cat > .env << 'ENVEOF'
NODE_ENV=development
DATABASE_URL=postgresql://postgres:password@localhost:5432/multiapps_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=generated-jwt-secret-$(date +%s)
POSTMATH_URL=http://localhost:3001
UNITFLIP_URL=http://localhost:3002
BUDGETCRON_URL=http://localhost:3003
AI4KIDS_URL=http://localhost:3004
MULTIAI_URL=http://localhost:3005
ENVEOF
    echo "✅ Fichier .env créé"
fi

# Créer docker-compose.yml si inexistant
if [ ! -f "docker-compose.yml" ]; then
    cat > docker-compose.yml << 'DOCKEREOF'
version: '3.8'
services:
  postgres:
    image: postgres:15-alpine
    container_name: multiapps_postgres
    environment:
      POSTGRES_DB: multiapps_dev
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    container_name: multiapps_redis
    ports:
      - "6379:6379"

volumes:
  postgres_data:
DOCKEREOF
    echo "✅ Fichier docker-compose.yml créé"
fi

echo -e "${GREEN}✅ Setup de base terminé !${NC}"
echo ""
echo "Prochaines étapes :"
echo "1. Démarrer Docker Desktop"
echo "2. docker-compose up -d"
echo "3. npm install"
echo "4. npm run dev"
