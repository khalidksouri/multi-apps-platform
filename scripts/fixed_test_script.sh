#!/bin/bash

#===============================================================================
# MATH4CHILD - TEST NAVIGATION (VERSION CORRIGÉE)
# Test la navigation sans conflit de port
#===============================================================================

set -e

echo "🧪 Test Navigation Math4Child (Corrigé)"
echo "======================================="

# Vérifier si le serveur tourne déjà
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Serveur détecté sur le port 3000"
    SERVER_RUNNING=true
else
    echo "❌ Aucun serveur détecté sur le port 3000"
    SERVER_RUNNING=false
fi

# Créer une configuration Playwright adaptée
cat > playwright.config.test.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  retries: 0,
  workers: 1,
  reporter: 'list',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  // Ne pas démarrer de serveur si un est déjà en cours
  webServer: process.env.SERVER_RUNNING === 'true' ? undefined : {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: true,
    timeout: 30000,
  },
})
EOF

# Exporter la variable d'environnement
export SERVER_RUNNING=$SERVER_RUNNING

echo "🎭 Configuration Playwright adaptée créée"
echo "🚀 Lancement des tests..."

# Lancer les tests avec la nouvelle configuration
if [ "$SERVER_RUNNING" = true ]; then
    echo "📡 Utilisation du serveur existant"
    npx playwright test tests/navigation.spec.ts --project=chromium --config=playwright.config.test.ts
else
    echo "🔄 Démarrage d'un nouveau serveur"
    npx playwright test tests/navigation.spec.ts --project=chromium --config=playwright.config.test.ts
fi

echo ""
echo "🎉 Tests terminés !"
echo "📊 Pour voir un rapport détaillé: npx playwright show-report"

# Nettoyer le fichier temporaire
rm -f playwright.config.test.ts