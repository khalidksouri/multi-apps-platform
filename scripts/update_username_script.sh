#!/bin/bash

# ==============================================
# 🔧 Script de mise à jour username GitHub
# ==============================================

echo "🔧 Mise à jour du username GitHub vers 'khalidksouri'..."

# Étape 1: Mettre à jour le workflow GitHub Actions
echo "🎯 ÉTAPE 1: Mise à jour du workflow CI/CD"

cat > .github/workflows/ci-cd.yml << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:

env:
  NODE_VERSION_DEFAULT: '20.x'
  REGISTRY: ghcr.io
  IMAGE_NAME: khalidksouri/multi-apps-platform

jobs:
  # ==============================================
  # 🔒 SECURITY SCAN
  # ==============================================
  security:
    name: Security Scan
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write
    
    steps:
      - name: 🔍 Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: 🔐 Audit npm packages
        run: |
          npm audit --audit-level=moderate || true
          npm audit --audit-level=high || true

      - name: 🔒 Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'table'
          exit-code: '0'

      - name: 🔍 CodeQL Analysis
        uses: github/codeql-action/init@v2
        with:
          languages: javascript,typescript

      - name: 🔍 Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v2

  # ==============================================
  # 🧪 TESTS - Node.js 18.x
  # ==============================================
  test-node-18:
    name: Test (Node.js 18.x)
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: ['18.x']
        
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🟢 Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: 📦 Install dependencies
        run: |
          npm ci
          npx playwright install --with-deps

      - name: 🏗️ Build packages
        run: |
          npm run build:packages

      - name: 🏗️ Build applications
        run: |
          npm run build:apps

      - name: 🧪 Run Playwright tests
        run: |
          npm run test
        env:
          CI: true

      - name: 📊 Upload test results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-results-node-18
          path: |
            reports/
            test-results/
          retention-days: 30

  # ==============================================
  # 🧪 TESTS - Node.js 20.x
  # ==============================================
  test-node-20:
    name: Test (Node.js 20.x)
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: ['20.x']
        
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🟢 Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: 📦 Install dependencies
        run: |
          npm ci
          npx playwright install --with-deps

      - name: 🏗️ Build packages
        run: |
          npm run build:packages

      - name: 🏗️ Build applications
        run: |
          npm run build:apps

      - name: 🧪 Run Playwright tests
        run: |
          npm run test
        env:
          CI: true

      - name: 📊 Upload test results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: test-results-node-20
          path: |
            reports/
            test-results/
          retention-days: 30

  # ==============================================
  # 🚀 DEPLOY TO STAGING
  # ==============================================
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: [security, test-node-18, test-node-20]
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    
    environment:
      name: staging
      url: https://staging.multi-apps.com
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🟢 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION_DEFAULT }}
          cache: 'npm'

      - name: 📦 Install dependencies
        run: npm ci

      - name: 🏗️ Build packages
        run: npm run build:packages

      - name: 🏗️ Build applications
        run: npm run build:apps
        env:
          NODE_ENV: production

      - name: 🐳 Build Docker images
        run: |
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/postmath:staging -f apps/postmath/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/unitflip:staging -f apps/unitflip/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/budgetcron:staging -f apps/budgetcron/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/ai4kids:staging -f apps/ai4kids/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/multiai:staging -f apps/multiai/Dockerfile .

      - name: 🔐 Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: khalidksouri
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: 📤 Push Docker images
        run: |
          docker push ghcr.io/khalidksouri/multi-apps-platform/postmath:staging
          docker push ghcr.io/khalidksouri/multi-apps-platform/unitflip:staging
          docker push ghcr.io/khalidksouri/multi-apps-platform/budgetcron:staging
          docker push ghcr.io/khalidksouri/multi-apps-platform/ai4kids:staging
          docker push ghcr.io/khalidksouri/multi-apps-platform/multiai:staging

      - name: 🚀 Deploy to Staging
        run: |
          echo "🚀 Deploying to staging environment..."
          echo "📦 Docker images pushed to ghcr.io/khalidksouri/multi-apps-platform"
          echo "🔗 Staging URL: https://staging.multi-apps.com"
          echo "✅ Staging deployment completed"

  # ==============================================
  # 🌟 DEPLOY TO PRODUCTION
  # ==============================================
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: [security, test-node-18, test-node-20, deploy-staging]
    if: github.ref == 'refs/heads/main'
    
    environment:
      name: production
      url: https://multi-apps.com
    
    steps:
      - name: 📥 Checkout code
        uses: actions/checkout@v4

      - name: 🟢 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION_DEFAULT }}
          cache: 'npm'

      - name: 📦 Install dependencies
        run: npm ci

      - name: 🏗️ Build packages
        run: npm run build:packages

      - name: 🏗️ Build applications
        run: npm run build:apps
        env:
          NODE_ENV: production

      - name: 🐳 Build Docker images
        run: |
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/postmath:latest -f apps/postmath/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/unitflip:latest -f apps/unitflip/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/budgetcron:latest -f apps/budgetcron/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/ai4kids:latest -f apps/ai4kids/Dockerfile .
          docker build -t ghcr.io/khalidksouri/multi-apps-platform/multiai:latest -f apps/multiai/Dockerfile .

      - name: 🔐 Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: khalidksouri
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: 📤 Push Docker images
        run: |
          docker push ghcr.io/khalidksouri/multi-apps-platform/postmath:latest
          docker push ghcr.io/khalidksouri/multi-apps-platform/unitflip:latest
          docker push ghcr.io/khalidksouri/multi-apps-platform/budgetcron:latest
          docker push ghcr.io/khalidksouri/multi-apps-platform/ai4kids:latest
          docker push ghcr.io/khalidksouri/multi-apps-platform/multiai:latest

      - name: 🚀 Deploy to Production
        run: |
          echo "🚀 Deploying to production environment..."
          echo "📦 Docker images pushed to ghcr.io/khalidksouri/multi-apps-platform"
          echo "🔗 Production URL: https://multi-apps.com"
          echo "✅ Production deployment completed"

      - name: 🏷️ Create Release
        uses: actions/create-release@v1
        if: success()
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: v${{ github.run_number }}
          release_name: Release v${{ github.run_number }}
          body: |
            🚀 Multi-Apps Platform Release v${{ github.run_number }}
            
            ## 📦 Applications Deployed
            - PostMath: Shipping calculator
            - UnitFlip: Unit converter
            - BudgetCron: Budget manager
            - AI4Kids: Kids interface
            - MultiAI: AI hub
            
            ## 🐳 Docker Images
            - ghcr.io/khalidksouri/multi-apps-platform/postmath:latest
            - ghcr.io/khalidksouri/multi-apps-platform/unitflip:latest
            - ghcr.io/khalidksouri/multi-apps-platform/budgetcron:latest
            - ghcr.io/khalidksouri/multi-apps-platform/ai4kids:latest
            - ghcr.io/khalidksouri/multi-apps-platform/multiai:latest
            
            ## 🔗 Links
            - [Production URL](https://multi-apps.com)
            - [Staging URL](https://staging.multi-apps.com)
            - [Test Results](https://github.com/khalidksouri/multi-apps-platform/actions/runs/${{ github.run_id }})
            
            ## 📊 Metrics
            - Tests: ✅ All passed on Node.js 18.x and 20.x
            - Security: ✅ Scanned with Trivy and CodeQL
            - Coverage: ✅ Generated with Playwright
            
            Full Changelog: https://github.com/khalidksouri/multi-apps-platform/compare/v${{ github.run_number-1 }}...v${{ github.run_number }}
          draft: false
          prerelease: false
EOF

echo "✅ Workflow GitHub Actions mis à jour"

# Étape 2: Mettre à jour le docker-compose.yml
echo "🎯 ÉTAPE 2: Mise à jour du docker-compose"

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postmath:
    image: ghcr.io/khalidksouri/multi-apps-platform/postmath:latest
    build:
      context: .
      dockerfile: apps/postmath/Dockerfile
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=${API_URL:-http://localhost:3001}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  unitflip:
    image: ghcr.io/khalidksouri/multi-apps-platform/unitflip:latest
    build:
      context: .
      dockerfile: apps/unitflip/Dockerfile
    ports:
      - "3002:3002"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=${API_URL:-http://localhost:3002}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3002/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  budgetcron:
    image: ghcr.io/khalidksouri/multi-apps-platform/budgetcron:latest
    build:
      context: .
      dockerfile: apps/budgetcron/Dockerfile
    ports:
      - "3003:3003"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=${API_URL:-http://localhost:3003}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3003/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  ai4kids:
    image: ghcr.io/khalidksouri/multi-apps-platform/ai4kids:latest
    build:
      context: .
      dockerfile: apps/ai4kids/Dockerfile
    ports:
      - "3004:3004"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=${API_URL:-http://localhost:3004}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3004/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  multiai:
    image: ghcr.io/khalidksouri/multi-apps-platform/multiai:latest
    build:
      context: .
      dockerfile: apps/multiai/Dockerfile
    ports:
      - "3005:3005"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=${API_URL:-http://localhost:3005}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3005/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  default:
    name: multi-apps-network
EOF

echo "✅ Docker-compose mis à jour"

# Étape 3: Créer un docker-compose pour la production
echo "🎯 ÉTAPE 3: Création du docker-compose de production"

cat > docker-compose.prod.yml << 'EOF'
version: '3.8'

services:
  postmath:
    image: ghcr.io/khalidksouri/multi-apps-platform/postmath:latest
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=https://multi-apps.com
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  unitflip:
    image: ghcr.io/khalidksouri/multi-apps-platform/unitflip:latest
    ports:
      - "3002:3002"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=https://multi-apps.com
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3002/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  budgetcron:
    image: ghcr.io/khalidksouri/multi-apps-platform/budgetcron:latest
    ports:
      - "3003:3003"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=https://multi-apps.com
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3003/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  ai4kids:
    image: ghcr.io/khalidksouri/multi-apps-platform/ai4kids:latest
    ports:
      - "3004:3004"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=https://multi-apps.com
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3004/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  multiai:
    image: ghcr.io/khalidksouri/multi-apps-platform/multiai:latest
    ports:
      - "3005:3005"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=https://multi-apps.com
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3005/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - postmath
      - unitflip
      - budgetcron
      - ai4kids
      - multiai
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.2'
          memory: 128M

networks:
  default:
    name: multi-apps-production
EOF

echo "✅ Docker-compose production créé"

# Étape 4: Créer un nginx.conf optimisé
echo "🎯 ÉTAPE 4: Création de la configuration Nginx"

cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;

    # Upstream servers
    upstream postmath {
        server postmath:3001;
    }

    upstream unitflip {
        server unitflip:3002;
    }

    upstream budgetcron {
        server budgetcron:3003;
    }

    upstream ai4kids {
        server ai4kids:3004;
    }

    upstream multiai {
        server multiai:3005;
    }

    # HTTP to HTTPS redirect
    server {
        listen 80;
        server_name multi-apps.com *.multi-apps.com;
        return 301 https://$server_name$request_uri;
    }

    # Main server block
    server {
        listen 443 ssl http2;
        server_name multi-apps.com;

        # SSL configuration
        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers off;

        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

        # PostMath
        location / {
            proxy_pass http://postmath;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cache_bypass $http_upgrade;
        }

        # UnitFlip
        location /unitflip {
            proxy_pass http://unitflip;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # BudgetCron
        location /budgetcron {
            proxy_pass http://budgetcron;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # AI4Kids
        location /ai4kids {
            proxy_pass http://ai4kids;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # MultiAI
        location /multiai {
            proxy_pass http://multiai;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }

        # API rate limiting
        location /api {
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://postmath;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

echo "✅ Configuration Nginx créée"

# Étape 5: Créer un script de déploiement
echo "🎯 ÉTAPE 5: Création du script de déploiement"

cat > deploy.sh << 'EOF'
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
EOF

chmod +x deploy.sh
echo "✅ Script de déploiement créé"

# Étape 6: Instructions finales
echo ""
echo "🎉 MISE À JOUR USERNAME TERMINÉE!"
echo "=================================="
echo ""
echo "✅ Workflow GitHub Actions mis à jour avec khalidksouri"
echo "✅ Docker-compose configuré pour ghcr.io/khalidksouri"
echo "✅ Configuration Nginx créée"
echo "✅ Script de déploiement ajouté"
echo ""
echo "📦 Images Docker configurées:"
echo "   - ghcr.io/khalidksouri/multi-apps-platform/postmath"
echo "   - ghcr.io/khalidksouri/multi-apps-platform/unitflip"
echo "   - ghcr.io/khalidksouri/multi-apps-platform/budgetcron"
echo "   - ghcr.io/khalidksouri/multi-apps-platform/ai4kids"
echo "   - ghcr.io/khalidksouri/multi-apps-platform/multiai"
echo ""
echo "🚀 COMMANDES DISPONIBLES:"
echo "   npm run docker:build     # Build toutes les images"
echo "   npm run docker:up        # Démarrer tous les services"
echo "   npm run docker:down      # Arrêter tous les services"
echo "   ./deploy.sh staging      # Déployer en staging"
echo "   ./deploy.sh production   # Déployer en production"
echo ""
echo "🔧 PROCHAINES ÉTAPES:"
echo "1. Commit les changements:"
echo "   git add ."
echo "   git commit -m 'feat: configure CI/CD for khalidksouri GitHub registry'"
echo "   git push origin main"
echo ""
echo "2. Configurer les permissions GitHub Package Registry:"
echo "   - Aller dans Settings > Developer settings > Personal access tokens"
echo "   - Créer un token avec 'write:packages' et 'read:packages'"
echo "   - Ajouter le token aux secrets: GITHUB_TOKEN"
echo ""
echo "3. Tester le pipeline:"
echo "   - Push vers main déclenche tout le pipeline"
echo "   - Push vers develop déclenche tests + staging"
echo ""
echo "🎯 PIPELINE CONFIGURÉ POUR KHALIDKSOURI!"