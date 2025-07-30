#!/bin/bash

# =============================================================================
# 🎨 CORRECTION TAILWIND - VRAI DESIGN MATH4CHILD COLORÉ
# Corrige Tailwind CSS pour afficher le design authentique avec couleurs
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_step() {
    echo -e "${CYAN}🎨 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${PURPLE}"
    echo "========================================"
    echo "  $1"
    echo "========================================"
    echo -e "${NC}"
}

print_header "CORRECTION TAILWIND - DESIGN COLORÉ MATH4CHILD"

TARGET_DIR="apps/math4child"

if [ ! -d "$TARGET_DIR" ]; then
    print_error "Dossier $TARGET_DIR non trouvé"
    exit 1
fi

cd "$TARGET_DIR"

# =============================================================================
# 1. ARRÊTER LE SERVEUR
# =============================================================================

print_step "1. Arrêt du serveur de développement..."

# Tuer le processus sur le port 3000
if lsof -ti:3000 > /dev/null 2>&1; then
    echo "🛑 Arrêt du serveur sur le port 3000..."
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

print_success "Serveur arrêté"

# =============================================================================
# 2. CORRIGER TAILWIND.CONFIG.JS
# =============================================================================

print_step "2. Correction de tailwind.config.js..."

cat << 'TAILWIND_CONFIG' > tailwind.config.js
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
        'bounce-soft': 'bounce 2s infinite',
        'fade-in-up': 'fadeInUp 0.6s ease-out',
        'slide-in-from-top': 'slideInFromTop 0.3s ease-out',
        'slide-in-from-bottom': 'slideInFromBottom 0.3s ease-out',
      },
      keyframes: {
        fadeInUp: {
          '0%': {
            opacity: '0',
            transform: 'translateY(30px)',
          },
          '100%': {
            opacity: '1',
            transform: 'translateY(0)',
          },
        },
        slideInFromTop: {
          '0%': {
            opacity: '0',
            transform: 'translateY(-10px) scaleY(0.95)',
          },
          '100%': {
            opacity: '1',
            transform: 'translateY(0) scaleY(1)',
          },
        },
        slideInFromBottom: {
          '0%': {
            opacity: '0',
            transform: 'translateY(10px)',
          },
          '100%': {
            opacity: '1',
            transform: 'translateY(0)',
          },
        },
      },
      backdropBlur: {
        'xs': '2px',
        'xl': '16px',
      },
    },
  },
  plugins: [],
}
TAILWIND_CONFIG

print_success "tailwind.config.js corrigé avec animations"

# =============================================================================
# 3. CORRIGER POSTCSS.CONFIG.JS
# =============================================================================

print_step "3. Création/correction de postcss.config.js..."

cat << 'POSTCSS_CONFIG' > postcss.config.js
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
POSTCSS_CONFIG

print_success "postcss.config.js créé"

# =============================================================================
# 4. CORRIGER GLOBALS.CSS AVEC TAILWIND COMPLET
# =============================================================================

print_step "4. Correction de globals.css avec Tailwind complet..."

cat << 'GLOBALS_CSS' > src/app/globals.css
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Variables CSS pour Math4Child */
:root {
  --math4child-primary: #3b82f6;
  --math4child-secondary: #10b981;
  --math4child-accent: #f59e0b;
  --math4child-surface: #ffffff;
  --math4child-background: #f8fafc;
  --math4child-text: #1f2937;
}

/* Reset global */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  line-height: 1.6;
  color: var(--math4child-text);
  background-color: var(--math4child-background);
}

/* Scroll personnalisé pour dropdown */
.language-dropdown-scroll {
  scrollbar-width: thin;
  scrollbar-color: #cbd5e1 #f1f5f9;
}

.language-dropdown-scroll::-webkit-scrollbar {
  width: 8px;
}

.language-dropdown-scroll::-webkit-scrollbar-track {
  background: #f1f5f9;
  border-radius: 4px;
  margin: 4px;
}

.language-dropdown-scroll::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 4px;
  transition: background 0.2s ease;
}

.language-dropdown-scroll::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

.language-dropdown-scroll::-webkit-scrollbar-thumb:active {
  background: #64748b;
}

/* Animations personnalisées Math4Child */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideInFromTop {
  from {
    opacity: 0;
    transform: translateY(-10px) scaleY(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scaleY(1);
  }
}

@keyframes slideInFromBottom {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse-soft {
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 0.5;
  }
}

@keyframes bounce-soft {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-5px);
  }
}

/* Classes utilitaires personnalisées */
.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out;
}

.animate-pulse-soft {
  animation: pulse-soft 4s ease-in-out infinite;
}

.animate-bounce-soft {
  animation: bounce-soft 2s ease-in-out infinite;
}

.animate-slide-in-from-top {
  animation: slideInFromTop 0.3s ease-out;
}

.animate-slide-in-from-bottom {
  animation: slideInFromBottom 0.3s ease-out;
}

/* Effets de glassmorphism */
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Transitions globales */
* {
  transition: all 0.2s ease;
}

/* Focus visible pour l'accessibilité */
button:focus-visible,
a:focus-visible,
input:focus-visible,
select:focus-visible {
  outline: 2px solid var(--math4child-primary);
  outline-offset: 2px;
  border-radius: 4px;
}

/* Styles pour les boutons CTA */
.btn-gradient-primary {
  background: linear-gradient(135deg, #10b981, #059669);
  color: white;
  font-weight: 700;
  border: none;
  border-radius: 16px;
  padding: 16px 32px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3);
  transform: translateY(0);
}

.btn-gradient-primary:hover {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 20px 40px rgba(16, 185, 129, 0.4);
  background: linear-gradient(135deg, #059669, #047857);
}

.btn-gradient-secondary {
  background: linear-gradient(135deg, #3b82f6, #1d4ed8);
  color: white;
  font-weight: 700;
  border: none;
  border-radius: 16px;
  padding: 16px 32px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
  transform: translateY(0);
}

.btn-gradient-secondary:hover {
  transform: translateY(-3px) scale(1.02);
  box-shadow: 0 20px 40px rgba(59, 130, 246, 0.4);
  background: linear-gradient(135deg, #1d4ed8, #1e40af);
}

/* Cards avec effet de profondeur */
.card-elevated {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(16px);
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  transform: translateY(0);
}

.card-elevated:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
}

/* Gradients de fond */
.bg-gradient-math4child {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.bg-gradient-hero {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.bg-gradient-premium {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

/* Responsive design */
@media (max-width: 640px) {
  .language-dropdown-scroll {
    max-height: 60vh;
  }
  
  .language-dropdown-scroll::-webkit-scrollbar {
    width: 12px;
  }
  
  .btn-gradient-primary,
  .btn-gradient-secondary {
    padding: 14px 28px;
    font-size: 16px;
  }
}

/* Dark mode support (futur) */
@media (prefers-color-scheme: dark) {
  :root {
    --math4child-surface: #1f2937;
    --math4child-background: #111827;
    --math4child-text: #f9fafb;
  }
}

/* Print styles */
@media print {
  .no-print {
    display: none !important;
  }
}

/* Amélioration de la lisibilité */
.text-shadow {
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.text-shadow-lg {
  text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

/* Particules animées */
.particle {
  position: absolute;
  border-radius: 50%;
  pointer-events: none;
  mix-blend-mode: multiply;
  filter: blur(1px);
  animation: float 6s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-20px) rotate(180deg);
  }
}

/* Loading spinner */
.spinner {
  border: 4px solid #f3f4f6;
  border-top: 4px solid #3b82f6;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
GLOBALS_CSS

print_success "globals.css corrigé avec styles complets"

# =============================================================================
# 5. INSTALLER/RÉINSTALLER TAILWIND ET DÉPENDANCES
# =============================================================================

print_step "5. Installation/réinstallation des dépendances Tailwind..."

# Installer Tailwind CSS et ses dépendances
npm install --save-dev tailwindcss@latest postcss@latest autoprefixer@latest
npm install --save-dev @tailwindcss/forms @tailwindcss/typography

print_success "Dépendances Tailwind installées"

# =============================================================================
# 6. NETTOYER ET RÉGÉNÉRER LE CACHE
# =============================================================================

print_step "6. Nettoyage complet du cache..."

# Supprimer tous les caches
rm -rf .next 2>/dev/null || true
rm -rf node_modules/.cache 2>/dev/null || true
rm -rf .cache 2>/dev/null || true
rm -f *.tsbuildinfo 2>/dev/null || true
rm -f next-env.d.ts 2>/dev/null || true

# Nettoyer le cache npm
npm cache clean --force 2>/dev/null || true

print_success "Cache complètement nettoyé"

# =============================================================================
# 7. VÉRIFIER LA CONFIGURATION PACKAGE.JSON
# =============================================================================

print_step "7. Vérification de package.json..."

# Vérifier que Tailwind est bien dans package.json
if grep -q "tailwindcss" package.json; then
    print_success "Tailwind CSS trouvé dans package.json"
else
    print_error "Tailwind CSS manquant - ajout en cours..."
    npm install --save-dev tailwindcss postcss autoprefixer
fi

# Vérifier lucide-react
if ! grep -q "lucide-react" package.json; then
    echo "📦 Installation de lucide-react..."
    npm install lucide-react
fi

print_success "Dépendances vérifiées"

# =============================================================================
# 8. CORRIGER NEXT.CONFIG.JS
# =============================================================================

print_step "8. Correction de next.config.js..."

cat << 'NEXT_CONFIG' > next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
}

module.exports = nextConfig
NEXT_CONFIG

print_success "next.config.js corrigé"

# =============================================================================
# 9. RÉGÉNÉRER TAILWIND CSS
# =============================================================================

print_step "9. Régénération de Tailwind CSS..."

# Générer la configuration Tailwind
npx tailwindcss init -p --force

print_success "Configuration Tailwind régénérée"

# =============================================================================
# 10. INSTRUCTIONS FINALES
# =============================================================================

print_header "CORRECTION TAILWIND TERMINÉE"

echo ""
echo -e "${GREEN}🎨 TAILWIND CSS CORRECTEMENT CONFIGURÉ !${NC}"
echo ""
echo -e "${YELLOW}🚀 MAINTENANT FAITES CECI :${NC}"
echo ""
echo "1️⃣ Dans le terminal actuel :"
echo "   npm run dev"
echo ""
echo "2️⃣ Ouvrez Safari en mode privé :"
echo "   http://localhost:3000"
echo ""
echo "3️⃣ Vous devriez maintenant voir :"
echo "   ✅ 🎨 Design COLORÉ avec gradients"
echo "   ✅ 🌈 Header avec fond dégradé"
echo "   ✅ ✨ Boutons verts/bleus stylés"  
echo "   ✅ 🎭 Animations et particules"
echo "   ✅ 🎪 Cards avec ombres et effets"
echo "   ✅ 📱 Design responsive moderne"
echo ""
echo -e "${CYAN}🎯 DIFFÉRENCES VISIBLES :${NC}"
echo "   • Fond dégradé bleu/violet au lieu de blanc"
echo "   • Logo orange avec dégradé"
echo "   • Boutons avec gradients et animations"
echo "   • Cards avec glassmorphism"
echo "   • Particules animées en arrière-plan"
echo "   • Header avec backdrop blur"
echo ""
echo -e "${GREEN}Le design Math4Child sera maintenant MAGNIFIQUE ! 🎨✨${NC}"

print_success "Correction Tailwind terminée - Le design va être transformé !"

echo ""
echo -e "${PURPLE}🎊 PRÉPAREZ-VOUS À VOIR LA MAGIE OPÉRER ! 🎊${NC}"
