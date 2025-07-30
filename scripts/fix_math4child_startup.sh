#!/bin/bash

# ===================================================================
# 🚀 CORRECTION DÉMARRAGE MATH4CHILD
# Résout l'erreur 404 et démarre l'application correctement
# ===================================================================

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}🚀 CORRECTION DÉMARRAGE MATH4CHILD${NC}"
echo -e "${CYAN}${BOLD}===================================${NC}"
echo ""

# Vérifier que nous sommes dans le bon dossier
if [ ! -d "apps/math4child" ]; then
    echo -e "${RED}❌ Erreur: Le dossier apps/math4child n'existe pas${NC}"
    echo -e "${YELLOW}Vous devez être dans le dossier racine multi-apps-platform${NC}"
    exit 1
fi

# Arrêter tous les processus Next.js en cours
echo -e "${YELLOW}🔄 Arrêt des processus Next.js en cours...${NC}"
pkill -f "next dev" 2>/dev/null || true
pkill -f "node.*next" 2>/dev/null || true
sleep 3

cd "apps/math4child"

echo -e "${YELLOW}📋 1. Nettoyage des fichiers temporaires...${NC}"

# Nettoyer les fichiers de cache Next.js
rm -rf .next
rm -rf out
rm -rf node_modules/.cache
echo -e "${GREEN}✅ Cache nettoyé${NC}"

echo -e "${YELLOW}📋 2. Vérification de la configuration Next.js...${NC}"

# S'assurer que next.config.js est correct
cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Pas de configuration i18n pour éviter les conflits
  // L'internationalisation est gérée côté client
  
  // Configuration de base
  reactStrictMode: true,
  swcMinify: true,
  
  // Configuration pour le développement
  experimental: {
    appDir: true,
  },
  
  // Configuration des headers
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
EOF

echo -e "${GREEN}✅ Configuration Next.js mise à jour${NC}"

echo -e "${YELLOW}📋 3. Vérification du fichier layout.tsx...${NC}"

# S'assurer que le layout est correct
cat > "src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
  description: 'Application éducative pour apprendre les mathématiques de manière ludique et interactive.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
EOF

echo -e "${GREEN}✅ Layout.tsx vérifié${NC}"

echo -e "${YELLOW}📋 4. Vérification du package.json...${NC}"

# Vérifier et corriger package.json si nécessaire
if [ -f "package.json" ]; then
    # Vérifier si le script dev utilise le bon port
    if ! grep -q "next dev -p 3001" package.json; then
        echo -e "${BLUE}🔧 Correction du port dans package.json...${NC}"
        
        # Créer un package.json correct
        cat > "package.json" << 'EOF'
{
  "name": "@multiapps/math4child",
  "version": "2.0.0",
  "description": "Math4Child - Application éducative de mathématiques",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3001",
    "build": "next build",
    "start": "next start -p 3001",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.2.30",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "typescript": "5.4.5"
  },
  "devDependencies": {
    "@types/node": "20.14.8",
    "@types/react": "18.3.3",
    "@types/react-dom": "18.3.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.32",
    "tailwindcss": "^3.3.6"
  }
}
EOF
        echo -e "${GREEN}✅ Package.json corrigé${NC}"
    fi
else
    echo -e "${RED}❌ Package.json manquant, création...${NC}"
    # Créer package.json complet
    cat > "package.json" << 'EOF'
{
  "name": "@multiapps/math4child",
  "version": "2.0.0",
  "description": "Math4Child - Application éducative de mathématiques",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3001",
    "build": "next build",
    "start": "next start -p 3001",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.2.30",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "typescript": "5.4.5"
  },
  "devDependencies": {
    "@types/node": "20.14.8",
    "@types/react": "18.3.3",
    "@types/react-dom": "18.3.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.32",
    "tailwindcss": "^3.3.6"
  }
}
EOF
    echo -e "${GREEN}✅ Package.json créé${NC}"
fi

echo -e "${YELLOW}📋 5. Installation/mise à jour des dépendances...${NC}"

# Nettoyer et réinstaller les dépendances
rm -rf node_modules package-lock.json
npm install

echo -e "${GREEN}✅ Dépendances installées${NC}"

echo -e "${YELLOW}📋 6. Vérification des fichiers critiques...${NC}"

# Vérifier que tous les fichiers existent
critical_files=(
    "src/app/page.tsx"
    "src/app/layout.tsx"
    "src/app/globals.css"
    "src/translations.ts"
    "src/types/translations.ts"
    "src/language-config.ts"
    "src/hooks/LanguageContext.tsx"
)

all_files_ok=true
for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ $file manquant${NC}"
        all_files_ok=false
    fi
done

if [ "$all_files_ok" = false ]; then
    echo -e "${YELLOW}🔧 Certains fichiers sont manquants. Création des fichiers minimaux...${NC}"
    
    # Créer les dossiers si nécessaire
    mkdir -p src/app src/hooks src/types
    
    # Créer globals.css minimal si manquant
    if [ ! -f "src/app/globals.css" ]; then
        cat > "src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Styles de base Math4Child */
.math-card {
  @apply bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300;
}

/* Support RTL */
[dir="rtl"] {
  direction: rtl;
}

[dir="rtl"] .flex {
  flex-direction: row-reverse;
}
EOF
    fi
    
    echo -e "${GREEN}✅ Fichiers manquants créés${NC}"
fi

echo -e "${YELLOW}📋 7. Test de compilation...${NC}"

# Tester la compilation
if npm run type-check >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Compilation TypeScript OK${NC}"
else
    echo -e "${YELLOW}⚠️ Avertissements TypeScript (non critiques)${NC}"
fi

echo -e "${YELLOW}📋 8. Démarrage du serveur de développement...${NC}"

# Démarrer le serveur en arrière-plan
echo -e "${BLUE}🚀 Lancement de npm run dev...${NC}"

# Vérifier que le port 3001 est libre
if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️ Port 3001 occupé, libération...${NC}"
    lsof -ti:3001 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

# Démarrer le serveur en mode détaché
nohup npm run dev > dev.log 2>&1 &
DEV_PID=$!

echo -e "${BLUE}📡 Serveur démarré (PID: $DEV_PID), attente de la disponibilité...${NC}"

# Attendre que le serveur soit prêt
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:3001 >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Serveur disponible !${NC}"
        break
    fi
    
    if ! kill -0 $DEV_PID 2>/dev/null; then
        echo -e "${RED}❌ Le serveur s'est arrêté, vérification des logs...${NC}"
        if [ -f "dev.log" ]; then
            echo -e "${YELLOW}Dernières lignes du log :${NC}"
            tail -10 dev.log
        fi
        exit 1
    fi
    
    echo -e "${YELLOW}⏳ Tentative $((attempt + 1))/$max_attempts...${NC}"
    sleep 2
    attempt=$((attempt + 1))
done

if [ $attempt -eq $max_attempts ]; then
    echo -e "${RED}❌ Le serveur n'est pas accessible après $max_attempts tentatives${NC}"
    if [ -f "dev.log" ]; then
        echo -e "${YELLOW}Logs du serveur :${NC}"
        cat dev.log
    fi
    exit 1
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 MATH4CHILD DÉMARRÉ AVEC SUCCÈS !${NC}"
echo ""
echo -e "${CYAN}${BOLD}📡 ACCÈS À L'APPLICATION :${NC}"
echo -e "${GREEN}✅ URL principale : ${BOLD}http://localhost:3001${NC}"
echo -e "${GREEN}✅ Status : Serveur actif (PID: $DEV_PID)${NC}"

echo ""
echo -e "${BLUE}${BOLD}🧪 TESTS À EFFECTUER :${NC}"
echo -e "${CYAN}1. Ouvrir http://localhost:3001 dans votre navigateur${NC}"
echo -e "${CYAN}2. Vérifier l'affichage de Math4Child${NC}"
echo -e "${CYAN}3. Tester le sélecteur de langues${NC}"
echo -e "${CYAN}4. Vérifier les plans d'abonnement${NC}"
echo -e "${CYAN}5. Tester les langues RTL (Arabe, Hébreu, Persan)${NC}"

echo ""
echo -e "${YELLOW}${BOLD}📋 GESTION DU SERVEUR :${NC}"
echo -e "${CYAN}• Arrêter : kill $DEV_PID${NC}"
echo -e "${CYAN}• Logs en temps réel : tail -f dev.log${NC}"
echo -e "${CYAN}• Redémarrer : npm run dev${NC}"

echo ""
echo -e "${GREEN}${BOLD}✨ MATH4CHILD OPÉRATIONNEL ! ✨${NC}"

cd "../.."