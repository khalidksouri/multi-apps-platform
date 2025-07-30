#!/bin/bash

# =============================================================================
# 🔧 CORRECTION DU LAYOUT.TSX - MATH4CHILD
# Supprime la dépendance au LanguageContext qui n'existe pas
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

print_step "CORRECTION DU LAYOUT.TSX"

cd "$TARGET_DIR"

# =============================================================================
# 1. Corriger le layout.tsx
# =============================================================================

print_step "1. Correction du layout.tsx..."

cat << 'LAYOUT_CONTENT' > "src/app/layout.tsx"
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprends les maths en t\'amusant !',
  description: 'L\'app éducative n°1 pour apprendre les maths en famille. Plus de 100k familles nous font confiance.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, famille',
  authors: [{ name: 'Math4Child Team' }],
  viewport: 'width=device-width, initial-scale=1',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <meta name="theme-color" content="#3b82f6" />
      </head>
      <body className={inter.className}>
        {children}
      </body>
    </html>
  )
}
LAYOUT_CONTENT

print_success "Layout.tsx corrigé - suppression de LanguageContext"

# =============================================================================
# 2. Vérifier le globals.css
# =============================================================================

print_step "2. Vérification du globals.css..."

if [ ! -f "src/app/globals.css" ]; then
    cat << 'GLOBALS_CSS' > "src/app/globals.css"
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
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
GLOBALS_CSS
    print_success "globals.css créé"
else
    print_success "globals.css existe déjà"
fi

# =============================================================================
# 3. Vérifier tailwind.config.js
# =============================================================================

print_step "3. Vérification de tailwind.config.js..."

if [ ! -f "tailwind.config.js" ]; then
    cat << 'TAILWIND_CONFIG' > "tailwind.config.js"
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
      }
    },
  },
  plugins: [],
}
TAILWIND_CONFIG
    print_success "tailwind.config.js créé"
else
    print_success "tailwind.config.js existe déjà"
fi

# =============================================================================
# 4. Vérifier next.config.js
# =============================================================================

print_step "4. Vérification de next.config.js..."

if [ ! -f "next.config.js" ]; then
    cat << 'NEXT_CONFIG' > "next.config.js"
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = nextConfig
NEXT_CONFIG
    print_success "next.config.js créé"
else
    print_success "next.config.js existe déjà"
fi

# =============================================================================
# 5. Supprimer le cache et redémarrer
# =============================================================================

print_step "5. Nettoyage final..."

rm -rf .next 2>/dev/null || true
rm -rf node_modules/.cache 2>/dev/null || true
rm -f *.tsbuildinfo 2>/dev/null || true

print_success "Cache supprimé"

# =============================================================================
# 6. Instructions finales
# =============================================================================

print_step "CORRECTION TERMINÉE"

echo ""
echo -e "${GREEN}🎉 LAYOUT.TSX CORRIGÉ !${NC}"
echo ""
echo -e "${CYAN}🚀 MAINTENANT TESTEZ :${NC}"
echo ""
echo "1️⃣ Arrêtez le serveur actuel (Ctrl+C)"
echo ""
echo "2️⃣ Relancez :"
echo "   npm run dev"
echo ""
echo "3️⃣ Ouvrez Safari en mode privé :"
echo "   http://localhost:3000"
echo ""
echo "✅ Le problème LanguageContext est résolu !"
echo "✅ Layout.tsx simplifié sans dépendances"
echo "✅ Configuration Next.js + Tailwind OK"

print_success "Math4Child devrait maintenant compiler et fonctionner !"
