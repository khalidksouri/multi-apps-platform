#!/bin/bash

set -e

echo "📦 Mise à jour du package.json..."

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

cd "$AI4KIDS_APP_DIR"

# Vérifier si package.json existe
if [ ! -f "package.json" ]; then
    echo -e "${YELLOW}⚠️ package.json non trouvé, création...${NC}"
    npm init -y
fi

# Sauvegarder l'ancien package.json
cp package.json package.json.backup

echo -e "${BLUE}📝 Mise à jour du package.json...${NC}"

# Mettre à jour le package.json avec les nouvelles informations
cat > package.json << 'PACKAGE_EOF'
{
  "name": "@multiapps/ai4kids",
  "version": "2.0.0",
  "private": true,
  "description": "Intelligence Artificielle pour Enfants - Application éducative interactive",
  "keywords": ["ai4kids", "intelligence artificielle", "enfants", "éducation", "jeux", "apprentissage"],
  "homepage": "https://ai4kids.com",
  "scripts": {
    "dev": "next dev -p 3004",
    "build": "next build",
    "start": "next start -p 3004",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    "test": "vitest",
    "test:unit": "vitest run",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "extract-translations": "node scripts/extract-translations.js",
    "update-translations": "node scripts/update-translations.js",
    "generate-assets": "node scripts/generate-assets.js",
    "optimize-images": "node scripts/optimize-images.js",
    "deploy": "npm run build && npm run start",
    "clean": "rm -rf .next dist node_modules/.cache"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.3.3",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.31",
    "clsx": "^2.0.0",
    "framer-motion": "^10.16.4",
    "lucide-react": "^0.294.0"
  },
  "devDependencies": {
    "@types/node": "^20.8.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@typescript-eslint/eslint-plugin": "^6.7.0",
    "@typescript-eslint/parser": "^6.7.0",
    "eslint": "^8.50.0",
    "eslint-config-next": "^14.0.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.0",
    "prettier": "^3.0.3",
    "vitest": "^0.34.6",
    "@vitejs/plugin-react": "^4.1.0",
    "playwright": "^1.39.0",
    "@playwright/test": "^1.39.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=9.0.0"
  }
}
PACKAGE_EOF

# Créer/mettre à jour le fichier de configuration TypeScript
echo -e "${BLUE}📝 Mise à jour de tsconfig.json...${NC}"
cat > tsconfig.json << 'TSCONFIG_EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
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
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/styles/*": ["./src/styles/*"]
    }
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": [
    "node_modules",
    "dist",
    ".next"
  ]
}
TSCONFIG_EOF

# Créer/mettre à jour le fichier Tailwind CSS
echo -e "${BLUE}📝 Mise à jour de tailwind.config.js...${NC}"
cat > tailwind.config.js << 'TAILWIND_EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'ai4kids': {
          blue: '#4ECDC4',
          orange: '#FF8C42',
          pink: '#FF6B9D',
          green: '#95E1D3',
          yellow: '#FFD93D',
          purple: '#667eea',
          primary: '#4ECDC4',
          secondary: '#FF8C42',
          success: '#95E1D3',
          warning: '#FFD93D',
          danger: '#FF6B9D',
        },
      },
      fontFamily: {
        'comic': ['Comic Neue', 'Comic Sans MS', 'cursive'],
        'sans': ['Inter', 'system-ui', 'sans-serif'],
      },
      animation: {
        'float': 'float 3s ease-in-out infinite',
        'bounce-slow': 'bounce 2s ease-in-out infinite',
        'twinkle': 'twinkle 3s ease-in-out infinite',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        twinkle: {
          '0%, 100%': { opacity: '0.3', transform: 'scale(1)' },
          '50%': { opacity: '1', transform: 'scale(1.2)' },
        },
      },
    },
  },
  plugins: [],
}
TAILWIND_EOF

# Créer/mettre à jour le fichier PostCSS
echo -e "${BLUE}📝 Mise à jour de postcss.config.js...${NC}"
cat > postcss.config.js << 'POSTCSS_EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
POSTCSS_EOF

# Créer/mettre à jour le fichier Next.js config
echo -e "${BLUE}📝 Mise à jour de next.config.js...${NC}"
cat > next.config.js << 'NEXT_CONFIG_EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['localhost'],
    formats: ['image/webp', 'image/avif'],
  },
  experimental: {
    optimizeCss: true,
  },
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },
};

module.exports = nextConfig;
NEXT_CONFIG_EOF

# Créer les dossiers app et globals.css
mkdir -p src/app
cat > src/app/globals.css << 'GLOBALS_EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@import url('https://fonts.googleapis.com/css2?family=Comic+Neue:wght@300;400;700&display=swap');

:root {
  --ai4kids-blue: #4ECDC4;
  --ai4kids-orange: #FF8C42;
  --ai4kids-pink: #FF6B9D;
  --ai4kids-green: #95E1D3;
  --ai4kids-yellow: #FFD93D;
  --ai4kids-purple: #667eea;
}

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
  font-family: 'Comic Neue', 'Comic Sans MS', cursive, system-ui, sans-serif;
}

/* Styles pour améliorer l'accessibilité */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Styles pour les focus keyboard */
*:focus {
  outline: 2px solid var(--ai4kids-blue);
  outline-offset: 2px;
}

/* Styles pour les animations réduites */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
GLOBALS_EOF

echo -e "${GREEN}✅ Package.json et configurations mis à jour${NC}"
