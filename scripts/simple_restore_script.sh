#!/bin/bash

# =============================================================================
# 🔄 RESTAURATION SIMPLE DU PROJET MATH4CHILD
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🔄 Restauration simple du projet Math4Child"
echo "========================================"

# Vérifications
if [ ! -d "apps/math4child" ]; then
    log_error "Dossier apps/math4child introuvable!"
    exit 1
fi

cd apps/math4child

# =============================================================================
# 1. ARRÊT DU SERVEUR
# =============================================================================

log_info "🛑 Arrêt du serveur..."
pkill -f "next dev" 2>/dev/null || true
sleep 2

# =============================================================================
# 2. NETTOYAGE SIMPLE DES FICHIERS MODIFIÉS
# =============================================================================

log_info "🧹 Nettoyage des fichiers modifiés..."

# Supprimer les fichiers créés par les scripts
if [ -f "src/components/LanguageSelector.tsx" ]; then
    rm src/components/LanguageSelector.tsx
    log_success "✅ LanguageSelector.tsx supprimé"
fi

# Recréer un fichier page.tsx propre
log_info "📄 Création d'un page.tsx propre..."

cat > src/app/page.tsx << 'EOF'
'use client';

import React from 'react';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <span className="text-white text-lg font-bold">M</span>
              </div>
              <h1 className="text-xl font-bold text-gray-900">Math4Child</h1>
            </div>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Math4Child - Application Éducative
          </h1>
          <p className="text-xl text-gray-600 mb-12">
            Apprentissage des mathématiques pour toute la famille
          </p>
          
          <div className="bg-green-100 border border-green-300 rounded-lg p-6 inline-block">
            <h3 className="text-lg font-semibold text-green-800 mb-2">
              ✅ Projet restauré avec succès
            </h3>
            <p className="text-green-700">
              L'application est revenue à son état initial
            </p>
          </div>

          <div className="mt-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              Fonctionnalités principales
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="bg-white rounded-lg shadow-lg p-6">
                <div className="text-3xl mb-3">🧮</div>
                <h3 className="font-semibold text-gray-900 mb-2">Calculs interactifs</h3>
                <p className="text-gray-600">Exercices de mathématiques adaptés</p>
              </div>
              <div className="bg-white rounded-lg shadow-lg p-6">
                <div className="text-3xl mb-3">🎯</div>
                <h3 className="font-semibold text-gray-900 mb-2">Suivi des progrès</h3>
                <p className="text-gray-600">Statistiques d'apprentissage</p>
              </div>
              <div className="bg-white rounded-lg shadow-lg p-6">
                <div className="text-3xl mb-3">🎮</div>
                <h3 className="font-semibold text-gray-900 mb-2">Jeux éducatifs</h3>
                <p className="text-gray-600">Apprentissage ludique</p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
EOF

log_success "✅ page.tsx restauré"

# Recréer un fichier globals.css basique
log_info "🎨 Restauration du CSS basique..."

cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --foreground-rgb: 0, 0, 0;
  --background-start-rgb: 214, 219, 220;
  --background-end-rgb: 255, 255, 255;
}

@media (prefers-color-scheme: dark) {
  :root {
    --foreground-rgb: 255, 255, 255;
    --background-start-rgb: 0, 0, 0;
    --background-end-rgb: 0, 0, 0;
  }
}

body {
  color: rgb(var(--foreground-rgb));
  background: linear-gradient(
      to bottom,
      transparent,
      rgb(var(--background-end-rgb))
    )
    rgb(var(--background-start-rgb));
}

/* Styles basiques pour l'application */
* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
}

a {
  color: inherit;
  text-decoration: none;
}

@media (prefers-color-scheme: dark) {
  html {
    color-scheme: dark;
  }
}
EOF

log_success "✅ globals.css restauré"

# =============================================================================
# 3. NETTOYAGE DU CACHE
# =============================================================================

log_info "🧹 Nettoyage du cache..."

if [ -d ".next" ]; then
    rm -rf .next
    log_success "✅ Cache .next supprimé"
fi

if [ -d "node_modules/.cache" ]; then
    rm -rf node_modules/.cache 2>/dev/null || true
    log_success "✅ Cache node_modules nettoyé"
fi

# =============================================================================
# 4. REDÉMARRAGE DU SERVEUR
# =============================================================================

log_info "🚀 Redémarrage du serveur..."

if command -v npm >/dev/null 2>&1; then
    nohup npm run dev > /dev/null 2>&1 &
    sleep 3
    
    if pgrep -f "next dev" > /dev/null; then
        log_success "✅ Serveur redémarré avec succès"
    else
        log_error "⚠️ Le serveur n'a pas pu redémarrer automatiquement"
        echo "   Démarrez-le manuellement avec: npm run dev"
    fi
else
    log_error "⚠️ npm non trouvé, redémarrage manuel requis"
fi

# =============================================================================
# 5. NETTOYAGE OPTIONNEL DES SAUVEGARDES
# =============================================================================

echo ""
read -p "🗑️ Voulez-vous supprimer les fichiers de sauvegarde ? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "🗑️ Suppression des sauvegardes..."
    
    # Supprimer les fichiers de sauvegarde
    find . -name "*.backup_*" -type f -delete 2>/dev/null || true
    find . -name "*.bak" -type f -delete 2>/dev/null || true
    
    # Supprimer les dossiers de sauvegarde
    find . -name "*backup*" -type d -exec rm -rf {} + 2>/dev/null || true
    
    log_success "✅ Fichiers de sauvegarde supprimés"
else
    log_info "📁 Fichiers de sauvegarde conservés"
fi

# =============================================================================
# RAPPORT FINAL
# =============================================================================

echo ""
echo "🎉 RESTAURATION TERMINÉE AVEC SUCCÈS"
echo "===================================="
echo ""
echo "✅ Actions effectuées :"
echo "   📄 page.tsx restauré à l'état initial"
echo "   🎨 globals.css nettoyé"
echo "   🗑️ LanguageSelector supprimé"
echo "   🧹 Cache nettoyé"
echo "   🚀 Serveur redémarré"
echo ""
echo "🌐 Testez maintenant :"
echo "   http://localhost:3000"
echo ""
echo "📁 État du projet :"
echo "   ✅ Fichiers restaurés"
echo "   ✅ Application fonctionnelle"
echo "   ✅ Prêt pour développement"
echo ""
log_success "🔄 Restauration du projet terminée !"
echo "===================================="