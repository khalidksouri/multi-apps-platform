#!/bin/bash

# =============================================================================
# 🔧 CORRECTION ERREUR POSTCSS TAILWIND
# Corrige le problème de plugin PostCSS Tailwind
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "${CYAN}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

TARGET_DIR="apps/math4child"

print_step "CORRECTION ERREUR POSTCSS TAILWIND"

cd "$TARGET_DIR"

# =============================================================================
# 1. ARRÊTER LE SERVEUR
# =============================================================================

print_step "1. Arrêt du serveur..."

if lsof -ti:3000 > /dev/null 2>&1; then
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

print_success "Serveur arrêté"

# =============================================================================
# 2. DÉSINSTALLER ET RÉINSTALLER TAILWIND CORRECTEMENT
# =============================================================================

print_step "2. Réinstallation complète de Tailwind CSS..."

# Supprimer les anciennes versions
npm uninstall tailwindcss postcss autoprefixer @tailwindcss/forms @tailwindcss/typography 2>/dev/null || true

# Installer les bonnes versions compatibles
npm install --save-dev tailwindcss@^3.4.0 postcss@^8.4.0 autoprefixer@^10.4.0

print_success "Tailwind CSS réinstallé avec les bonnes versions"

# =============================================================================
# 3. CORRIGER POSTCSS.CONFIG.JS
# =============================================================================

print_step "3. Correction de postcss.config.js..."

cat << 'POSTCSS_FIX' > postcss.config.js
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
POSTCSS_FIX

print_success "postcss.config.js corrigé"

# =============================================================================
# 4. RECRÉER TAILWIND.CONFIG.JS SIMPLIFIÉ
# =============================================================================

print_step "4. Recréation de tailwind.config.js simplifié..."

cat << 'TAILWIND_SIMPLE' > tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      animation: {
        'pulse-soft': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
    },
  },
  plugins: [],
}
TAILWIND_SIMPLE

print_success "tailwind.config.js simplifié créé"

# =============================================================================
# 5. SIMPLIFIER GLOBALS.CSS
# =============================================================================

print_step "5. Simplification de globals.css..."

cat << 'GLOBALS_SIMPLE' > src/app/globals.css
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Scroll personnalisé */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f5f9;
}

::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* Focus pour accessibilité */
button:focus-visible,
a:focus-visible {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}

/* Animation personnalisée */
@keyframes pulse-soft {
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 0.5;
  }
}

.animate-pulse-soft {
  animation: pulse-soft 4s ease-in-out infinite;
}
GLOBALS_SIMPLE

print_success "globals.css simplifié"

# =============================================================================
# 6. NETTOYER COMPLÈTEMENT
# =============================================================================

print_step "6. Nettoyage complet..."

rm -rf .next 2>/dev/null || true
rm -rf node_modules/.cache 2>/dev/null || true
rm -f *.tsbuildinfo 2>/dev/null || true

print_success "Cache nettoyé"

# =============================================================================
# 7. VÉRIFIER LA VERSION NEXT.JS
# =============================================================================

print_step "7. Vérification des versions..."

echo "📦 Versions installées:"
echo "   Next.js: $(npm list next --depth=0 2>/dev/null | grep next || echo 'non trouvé')"
echo "   Tailwind: $(npm list tailwindcss --depth=0 2>/dev/null | grep tailwindcss || echo 'non trouvé')"
echo "   PostCSS: $(npm list postcss --depth=0 2>/dev/null | grep postcss || echo 'non trouvé')"

print_success "Versions vérifiées"

# =============================================================================
# 8. INSTRUCTIONS FINALES
# =============================================================================

print_step "CORRECTION TERMINÉE"

echo ""
echo -e "${GREEN}🔧 ERREUR POSTCSS CORRIGÉE !${NC}"
echo ""
echo -e "${CYAN}🚀 MAINTENANT TESTEZ :${NC}"
echo ""
echo "1️⃣ Lancez le serveur :"
echo "   npm run dev"
echo ""
echo "2️⃣ Si ça compile sans erreur :"
echo "   ✅ Tailwind fonctionne"
echo "   ✅ Le design sera coloré"
echo ""
echo "3️⃣ Ouvrez http://localhost:3000"
echo ""
echo "🎯 Si le design est toujours basique :"
echo "   • C'est normal - Tailwind est maintenant fonctionnel"
echo "   • On pourra ajouter plus de styles ensuite"
echo ""
echo -e "${GREEN}L'important : plus d'erreur de compilation ! ✅${NC}"

print_success "PostCSS Tailwind corrigé - Testez maintenant !"
