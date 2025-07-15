#!/bin/bash

# =============================================
# 🔧 Correction de la structure MultiAI
# =============================================

echo "🔧 Correction de la structure des dossiers MultiAI"
echo "=================================================="

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🔍 Diagnostic de la structure actuelle..."

# Vérifier la structure actuelle
if [ -d "apps/multiai" ]; then
    echo -e "${GREEN}✅ Dossier apps/multiai existe${NC}"
    
    echo "📋 Structure actuelle :"
    find apps/multiai -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | head -20
    
    echo ""
    echo "📋 Contenu du dossier app :"
    ls -la apps/multiai/src/app/ 2>/dev/null || echo "Dossier app introuvable"
    
else
    echo -e "${RED}❌ Dossier apps/multiai n'existe pas${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}🔄 [1/3] Nettoyage de la structure${NC}"
echo "=================================="

cd apps/multiai

# Supprimer les fichiers/dossiers problématiques
echo "🧹 Nettoyage des fichiers problématiques..."

# Supprimer le fichier api s'il existe
if [ -f "src/app/api" ]; then
    rm -f src/app/api
    echo -e "${GREEN}✅ Fichier api supprimé${NC}"
fi

# Supprimer le dossier health mal placé
if [ -d "src/app/health" ]; then
    rm -rf src/app/health
    echo -e "${GREEN}✅ Dossier health mal placé supprimé${NC}"
fi

echo ""
echo -e "${BLUE}🔄 [2/3] Recréation de la structure correcte${NC}"
echo "============================================"

# Créer la structure correcte
mkdir -p src/app/api/health

echo -e "${GREEN}✅ Structure de dossiers créée${NC}"

# Créer la route health
cat > src/app/api/health/route.ts << 'EOF'
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

echo -e "${GREEN}✅ Route health créée${NC}"

# Vérifier que la page principale existe
if [ ! -f "src/app/page.tsx" ]; then
    echo "🔧 Création de la page principale manquante..."
    cat > src/app/page.tsx << 'EOF'
export default function HomePage() {
  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          🧠 MultiAI
        </h1>
        <p className="text-xl text-gray-600">
          Bienvenue sur MultiAI - Port 3005
        </p>
      </div>

      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold mb-4">
          🧠 Fonctionnalités
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">🚀 Interface moderne</h3>
            <p className="text-gray-600">Interface utilisateur intuitive et responsive</p>
          </div>
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">⚡ Performance</h3>
            <p className="text-gray-600">Application optimisée pour la vitesse</p>
          </div>
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">🔒 Sécurité</h3>
            <p className="text-gray-600">Données protégées et sécurisées</p>
          </div>
          <div className="p-4 border border-gray-200 rounded-lg">
            <h3 className="font-medium mb-2">📱 Mobile</h3>
            <p className="text-gray-600">Compatible mobile et tablette</p>
          </div>
        </div>
      </div>

      <div className="text-center">
        <button className="btn btn-primary">
          Commencer
        </button>
      </div>
    </div>
  );
}
EOF
    echo -e "${GREEN}✅ Page principale créée${NC}"
fi

# Vérifier que le layout existe
if [ ! -f "src/app/layout.tsx" ]; then
    echo "🔧 Création du layout manquant..."
    cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'MultiAI',
  description: 'Application MultiAI - Plateforme MultiApps',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <body className="min-h-screen bg-gray-50">
        <div className="container mx-auto px-4 py-8">
          {children}
        </div>
      </body>
    </html>
  );
}
EOF
    echo -e "${GREEN}✅ Layout créé${NC}"
fi

echo ""
echo -e "${BLUE}🔄 [3/3] Test de la structure${NC}"
echo "==============================="

# Afficher la nouvelle structure
echo "📋 Nouvelle structure :"
find src -type f -name "*.ts" -o -name "*.tsx" | sort

echo ""
echo "🧪 Test du build..."
if npm run build > /tmp/multiai_build_test.log 2>&1; then
    echo -e "${GREEN}✅ Build réussi${NC}"
else
    echo -e "${RED}❌ Build échoué${NC}"
    echo "📋 Erreurs :"
    cat /tmp/multiai_build_test.log
fi

echo ""
echo "🚀 Test de démarrage..."
npm run dev > /tmp/multiai_start_test.log 2>&1 &
multiai_pid=$!

echo "⏳ Attente du démarrage (PID: $multiai_pid)..."
sleep 10

# Tester la connectivité
if curl -f -s "http://localhost:3005/api/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ MultiAI démarré avec succès !${NC}"
    echo "🌐 URL: http://localhost:3005"
    echo "❤️ Health: http://localhost:3005/api/health"
    
    # Tester la réponse health
    echo ""
    echo "📋 Réponse health :"
    curl -s "http://localhost:3005/api/health" | jq . 2>/dev/null || curl -s "http://localhost:3005/api/health"
    
else
    echo -e "${RED}❌ MultiAI n'a pas démarré correctement${NC}"
    echo "📋 Logs de démarrage :"
    cat /tmp/multiai_start_test.log
fi

# Arrêter le processus de test
kill $multiai_pid 2>/dev/null
wait $multiai_pid 2>/dev/null

cd - > /dev/null

echo ""
echo -e "${GREEN}🎉 CORRECTION TERMINÉE !${NC}"
echo "========================"
echo ""
echo "🎯 PROCHAINES ÉTAPES :"
echo "===================="
echo "1. Tester MultiAI: cd apps/multiai && npm run dev"
echo "2. Vérifier: curl http://localhost:3005/api/health"
echo "3. Démarrer toutes les apps: ./start_apps_fixed.sh"
echo "4. Lancer les tests: npm run test"
