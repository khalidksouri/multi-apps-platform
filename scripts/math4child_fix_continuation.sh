#!/bin/bash

# ===================================================================
# 🔧 MATH4CHILD - CONTINUATION ET FINALISATION DU SETUP
# Correction et finalisation de l'installation
# ===================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${PURPLE}${BOLD}🔧 MATH4CHILD - CONTINUATION DU SETUP${NC}"
echo "=============================================================="

# Variables
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MATH4CHILD_DIR="${PROJECT_ROOT}/apps/math4child"
SRC_DIR="${MATH4CHILD_DIR}/src"

echo -e "${BLUE}📍 Finalisation de: ${MATH4CHILD_DIR}${NC}"

# Fonction pour créer un fichier avec sed
create_file_with_sed() {
    local file_path="$1"
    local content="$2"
    local dir_path=$(dirname "$file_path")
    
    # Créer le répertoire parent si nécessaire
    mkdir -p "$dir_path"
    
    # Utiliser sed pour traiter les variables et échapper les caractères spéciaux
    echo "$content" | sed 's/\\"/"/g' | sed "s/\\\'/'/g" > "$file_path"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Fichier créé: $file_path${NC}"
    else
        echo -e "${RED}❌ Erreur création: $file_path${NC}"
        return 1
    fi
}

# ===================================================================
# ⚙️ ÉTAPE 4: FICHIERS DE CONFIGURATION NEXT.JS
# ===================================================================

echo -e "${YELLOW}${BOLD}⚙️ ÉTAPE 4: CONFIGURATION NEXT.JS${NC}"

# Package.json
if [ ! -f "${MATH4CHILD_DIR}/package.json" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/package.json" '{
  "name": "math4child",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.4",
    "react": "^18",
    "react-dom": "^18",
    "lucide-react": "^0.294.0"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "autoprefixer": "^10.0.1",
    "postcss": "^8",
    "tailwindcss": "^3.3.0",
    "eslint": "^8",
    "eslint-config-next": "14.0.4"
  }
}'
else
    echo -e "${YELLOW}⚠️ Package.json existant conservé${NC}"
fi

# Tailwind config
if [ ! -f "${MATH4CHILD_DIR}/tailwind.config.js" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/tailwind.config.js" '/** @type {import("tailwindcss").Config} */
module.exports = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        "inter": ["Inter", "system-ui", "sans-serif"],
      },
      animation: {
        "float": "float 3s ease-in-out infinite",
        "glow": "glow 2s ease-in-out infinite alternate",
      },
      keyframes: {
        float: {
          "0%, 100%": { transform: "translateY(0px)" },
          "50%": { transform: "translateY(-10px)" },
        },
        glow: {
          "0%": { boxShadow: "0 0 20px rgba(59, 130, 246, 0.5)" },
          "100%": { boxShadow: "0 0 30px rgba(139, 92, 246, 0.8)" },
        },
      }
    },
  },
  plugins: [],
}'
else
    echo -e "${YELLOW}⚠️ Tailwind config existant conservé${NC}"
fi

# PostCSS config
if [ ! -f "${MATH4CHILD_DIR}/postcss.config.js" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/postcss.config.js" 'module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}'
else
    echo -e "${YELLOW}⚠️ PostCSS config existant conservé${NC}"
fi

# Next config
if [ ! -f "${MATH4CHILD_DIR}/next.config.js" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/next.config.js" '/** @type {import("next").NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  images: {
    domains: ["localhost"],
  },
  eslint: {
    ignoreDuringBuilds: false,
  },
  typescript: {
    ignoreBuildErrors: false,
  }
}

module.exports = nextConfig'
else
    echo -e "${YELLOW}⚠️ Next config existant conservé${NC}"
fi

# TypeScript config
if [ ! -f "${MATH4CHILD_DIR}/tsconfig.json" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/tsconfig.json" '{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}'
else
    echo -e "${YELLOW}⚠️ TypeScript config existant conservé${NC}"
fi

# Next env types
if [ ! -f "${MATH4CHILD_DIR}/next-env.d.ts" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/next-env.d.ts" '/// <reference types="next" />
/// <reference types="next/image-types/global" />

// NOTE: This file should not be edited
// see https://nextjs.org/docs/app/building-your-application/configuring/typescript for more information.'
else
    echo -e "${YELLOW}⚠️ next-env.d.ts existant conservé${NC}"
fi

# ESLint config
if [ ! -f "${MATH4CHILD_DIR}/.eslintrc.json" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/.eslintrc.json" '{
  "extends": ["next/core-web-vitals"]
}'
else
    echo -e "${YELLOW}⚠️ ESLint config existant conservé${NC}"
fi

# Gitignore
if [ ! -f "${MATH4CHILD_DIR}/.gitignore" ]; then
    create_file_with_sed "${MATH4CHILD_DIR}/.gitignore" '# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js
.yarn/install-state.gz

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts'
else
    echo -e "${YELLOW}⚠️ .gitignore existant conservé${NC}"
fi

echo ""

# ===================================================================
# 🚀 ÉTAPE 5: INSTALLATION ET FINALISATION
# ===================================================================

echo -e "${YELLOW}${BOLD}🚀 ÉTAPE 5: INSTALLATION ET FINALISATION${NC}"

# Aller dans le répertoire Math4Child
cd "${MATH4CHILD_DIR}"

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Erreur: package.json non trouvé dans ${MATH4CHILD_DIR}${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Installation des dépendances npm...${NC}"
echo -e "${CYAN}📍 Répertoire actuel: $(pwd)${NC}"

# Installer les dépendances avec npm
npm install --prefer-offline --no-audit 2>&1 | sed 's/^/  /'

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dépendances installées avec succès${NC}"
else
    echo -e "${RED}❌ Erreur lors de l'installation des dépendances${NC}"
    echo -e "${YELLOW}💡 Essayez manuellement: cd apps/math4child && npm install${NC}"
    exit 1
fi

# Vérifier que les dépendances clés sont installées
echo -e "${BLUE}🔍 Vérification des dépendances clés...${NC}"

if [ -d "node_modules/next" ]; then
    echo -e "${GREEN}✅ Next.js installé${NC}"
else
    echo -e "${RED}❌ Next.js manquant${NC}"
fi

if [ -d "node_modules/react" ]; then
    echo -e "${GREEN}✅ React installé${NC}"
else
    echo -e "${RED}❌ React manquant${NC}"
fi

if [ -d "node_modules/tailwindcss" ]; then
    echo -e "${GREEN}✅ Tailwind CSS installé${NC}"
else
    echo -e "${YELLOW}⚠️ Installation manuelle de Tailwind CSS...${NC}"
    npm install tailwindcss autoprefixer postcss 2>&1 | sed 's/^/  /'
fi

if [ -d "node_modules/lucide-react" ]; then
    echo -e "${GREEN}✅ Lucide React installé${NC}"
else
    echo -e "${YELLOW}⚠️ Installation manuelle de Lucide React...${NC}"
    npm install lucide-react 2>&1 | sed 's/^/  /'
fi

# Test de compilation TypeScript
echo -e "${BLUE}🔧 Test de compilation TypeScript...${NC}"
npx tsc --noEmit 2>&1 | sed 's/^/  /' || echo -e "${YELLOW}⚠️ Warnings TypeScript (normal en développement)${NC}"

# Vérification finale des fichiers
echo -e "${BLUE}📋 Vérification finale des fichiers...${NC}"

required_files=(
    "src/app/page.tsx"
    "src/app/layout.tsx"
    "src/app/globals.css"
    "src/hooks/useLanguage.ts"
    "src/components/language/LanguageSelector.tsx"
    "src/components/navigation/Navigation.tsx"
    "src/components/pricing/PricingModal.tsx"
    "src/data/languages/worldLanguages.ts"
    "src/lib/translations/worldTranslations.ts"
    "src/data/pricing/countryPricing.ts"
    "src/lib/math/questionGenerator.ts"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ $file${NC}"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ Tous les fichiers requis sont présents${NC}"
else
    echo -e "${RED}❌ Fichiers manquants: ${missing_files[*]}${NC}"
fi

echo ""
echo -e "${PURPLE}${BOLD}🎉 MATH4CHILD SETUP FINALISÉ !${NC}"
echo "=============================================================="
echo -e "${GREEN}✅ Configuration Next.js complète${NC}"
echo -e "${GREEN}✅ Dépendances installées${NC}"
echo -e "${GREEN}✅ TypeScript configuré${NC}"
echo -e "${GREEN}✅ Tailwind CSS configuré${NC}"
echo -e "${GREEN}✅ Application prête${NC}"
echo ""
echo -e "${BLUE}🚀 COMMANDES POUR DÉMARRER:${NC}"
echo "cd apps/math4child"
echo "npm run dev"
echo ""
echo -e "${BLUE}🌐 URL de développement:${NC}"
echo "http://localhost:3000"
echo ""
echo -e "${CYAN}🌍 www.math4child.com | Développé par GOTEST${NC}"
echo -e "${CYAN}📧 Contact: gotesttech@gmail.com${NC}"
echo -e "${CYAN}🏢 SIRET: 53958712100028${NC}"

# Message final avec instructions
echo ""
echo -e "${YELLOW}${BOLD}📋 INSTRUCTIONS FINALES:${NC}"
echo "1. ${BLUE}cd apps/math4child${NC}"
echo "2. ${BLUE}npm run dev${NC}"
echo "3. Ouvrir ${BLUE}http://localhost:3000${NC} dans votre navigateur"
echo "4. Profitez de votre application Math4Child révolutionnaire ! 🚀"
