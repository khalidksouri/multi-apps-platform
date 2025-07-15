#!/bin/bash

# =============================================
# 🔧 Script de correction rapide
# =============================================

echo "🔧 Correction rapide des problèmes détectés"
echo "==========================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 [1/4] Correction des tests PostMath${NC}"
echo "============================================"

# Remplacer le fichier de test PostMath
cat > tests/postmath.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('PostMath Application', () => {
  
  test('should load the homepage', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier le titre
    await expect(page).toHaveTitle(/PostMath/);
    
    // Vérifier les éléments principaux - utiliser des sélecteurs plus spécifiques
    await expect(page.getByRole('heading', { name: 'PostMath Pro' })).toBeVisible();
    await expect(page.getByRole('heading', { name: 'Calculateur d\'Expédition' })).toBeVisible();
    await expect(page.getByText('Calculez et comparez les frais d\'expédition')).toBeVisible();
  });

  test('should display shipping calculator form', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier que le formulaire est présent
    await expect(page.getByLabel('Ville de départ')).toBeVisible();
    await expect(page.getByLabel('Ville de destination')).toBeVisible();
    await expect(page.getByLabel('Poids (kg)')).toBeVisible();
    await expect(page.getByLabel('Dimensions (cm)')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Calculer les frais' })).toBeVisible();
  });

  test('should calculate shipping costs', async ({ page }) => {
    await page.goto('/');
    
    // Remplir le formulaire avec des sélecteurs plus robustes
    await page.getByLabel('Ville de départ').fill('Paris');
    await page.getByLabel('Ville de destination').fill('Lyon');
    await page.getByLabel('Poids (kg)').fill('2.5');
    await page.getByLabel('Dimensions (cm)').fill('30x20x15');
    
    // Cliquer sur calculer
    await page.getByRole('button', { name: 'Calculer les frais' }).click();
    
    // Attendre les résultats - augmenter le timeout pour le calcul
    await expect(page.getByText('Résultats du calcul')).toBeVisible({ timeout: 10000 });
    
    // Vérifier qu'au moins un transporteur est affiché
    const carriers = page.locator('[data-testid^="carrier-"]');
    await expect(carriers).toHaveCount(3); // Ajuster selon le nombre réel de transporteurs
    
    // Vérifier les éléments de transporteur
    await expect(page.getByText('Colissimo')).toBeVisible();
    await expect(page.getByText('Chronopost')).toBeVisible();
    
    // Vérifier qu'il y a des prix affichés
    await expect(page.locator('text=/\\d+[.,]\\d{2}€/')).toHaveCount(3);
  });

  test('should show validation errors for empty form', async ({ page }) => {
    await page.goto('/');
    
    // Cliquer sur calculer sans remplir
    await page.getByRole('button', { name: 'Calculer les frais' }).click();
    
    // Vérifier les messages d'erreur
    await expect(page.getByText('Ville de départ requise')).toBeVisible();
    await expect(page.getByText('Ville de destination requise')).toBeVisible();
    await expect(page.getByText('Poids requis')).toBeVisible();
    await expect(page.getByText('Dimensions requises')).toBeVisible();
  });

});
EOF

echo -e "${GREEN}✅ Tests PostMath corrigés${NC}"

echo ""
echo -e "${BLUE}🔄 [2/4] Correction de l'application MultiAI${NC}"
echo "=============================================="

# Vérifier et créer la route health manquante
mkdir -p apps/multiai/src/app/api/health

cat > apps/multiai/src/app/api/health/route.ts << 'EOF'
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    app: 'multiai',
    version: process.env.npm_package_version || '1.0.0',
  });
}
EOF

echo -e "${GREEN}✅ Route health MultiAI créée${NC}"

# Vérifier que le dossier api existe bien
if [ ! -d "apps/multiai/src/app/api" ]; then
    mkdir -p apps/multiai/src/app/api
    echo -e "${GREEN}✅ Dossier api créé${NC}"
fi

# Supprimer le fichier health.ts mal placé s'il existe
if [ -f "apps/multiai/src/app/health/route.ts" ]; then
    rm apps/multiai/src/app/health/route.ts
    rmdir apps/multiai/src/app/health 2>/dev/null || true
    echo -e "${GREEN}✅ Ancien fichier health supprimé${NC}"
fi

echo ""
echo -e "${BLUE}🔄 [3/4] Correction des erreurs de script${NC}"
echo "=========================================="

# Corriger le script de démarrage pour éviter l'erreur "cd: OLDPWD not set"
cat > start_apps_fixed.sh << 'EOF'
#!/bin/bash

# =============================================
# 🚀 Script de démarrage corrigé
# =============================================

echo "🚀 Démarrage des applications MultiApps"
echo "======================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour démarrer une application
start_app() {
    local app_name=$1
    local port=$2
    local base_dir=$(pwd)
    
    echo "🚀 Démarrage de $app_name sur le port $port..."
    
    # Aller dans le dossier de l'application
    cd "$base_dir/apps/$app_name"
    
    # Démarrer l'application en arrière-plan
    npm run dev > "/tmp/$app_name.log" 2>&1 &
    local app_pid=$!
    
    # Revenir au dossier de base
    cd "$base_dir"
    
    # Sauvegarder le PID
    echo $app_pid > "/tmp/$app_name.pid"
    
    # Attendre que l'application soit prête
    echo "⏳ Attente de $app_name..."
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $app_name: Prêt sur http://localhost:$port${NC}"
            return 0
        fi
        
        sleep 2
        attempt=$((attempt + 1))
        echo -n "."
    done
    
    echo -e "${RED}❌ $app_name: Timeout après ${max_attempts} tentatives${NC}"
    return 1
}

# Démarrer toutes les applications
echo "🌟 Démarrage des 5 applications..."
start_app "postmath" 3001
start_app "unitflip" 3002
start_app "budgetcron" 3003
start_app "ai4kids" 3004
start_app "multiai" 3005

echo ""
echo "📊 Statut final des applications :"
echo "=================================="
apps=("postmath:3001" "unitflip:3002" "budgetcron:3003" "ai4kids:3004" "multiai:3005")
ready_count=0

for app_port in "${apps[@]}"; do
    IFS=':' read -r app port <<< "$app_port"
    if curl -f -s "http://localhost:$port/api/health" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $app: http://localhost:$port${NC}"
        ready_count=$((ready_count + 1))
    else
        echo -e "${RED}❌ $app: Non disponible${NC}"
    fi
done

echo ""
echo "🎯 Applications prêtes: $ready_count/5"

if [ $ready_count -eq 5 ]; then
    echo -e "${GREEN}🎉 Toutes les applications sont prêtes !${NC}"
    echo ""
    echo "🧪 Lancement des tests..."
    npm run test
else
    echo -e "${YELLOW}⚠️ Certaines applications ne sont pas prêtes${NC}"
fi
EOF

chmod +x start_apps_fixed.sh
echo -e "${GREEN}✅ Script de démarrage corrigé créé${NC}"

echo ""
echo -e "${BLUE}🔄 [4/4] Réinstallation des dépendances MultiAI${NC}"
echo "==============================================="

# Nettoyer et réinstaller MultiAI
if [ -d "apps/multiai" ]; then
    cd apps/multiai
    
    # Supprimer les anciens fichiers
    rm -rf node_modules package-lock.json
    
    # Réinstaller
    npm install
    
    # Tester le build
    if npm run build > /tmp/multiai_build_test.log 2>&1; then
        echo -e "${GREEN}✅ Build MultiAI: Réussi${NC}"
    else
        echo -e "${RED}❌ Build MultiAI: Échoué${NC}"
        echo "📋 Erreurs:"
        cat /tmp/multiai_build_test.log
    fi
    
    cd - > /dev/null
else
    echo -e "${RED}❌ Dossier MultiAI introuvable${NC}"
fi

echo ""
echo -e "${GREEN}🎉 CORRECTIONS TERMINÉES !${NC}"
echo "========================="
echo ""
echo "📋 Résumé des corrections :"
echo "✅ Tests PostMath corrigés"
echo "✅ Route health MultiAI créée"
echo "✅ Script de démarrage corrigé"
echo "✅ Dépendances MultiAI réinstallées"
echo ""
echo "🚀 PROCHAINES ÉTAPES :"
echo "====================="
echo "1. Tester le nouveau script: ./start_apps_fixed.sh"
echo "2. Ou démarrer manuellement: cd apps/multiai && npm run dev"
echo "3. Vérifier MultiAI: curl http://localhost:3005/api/health"
echo "4. Relancer les tests: npm run test"
