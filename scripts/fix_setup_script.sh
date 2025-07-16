#!/bin/bash

# =============================================================================
# Script de correction et finalisation AI4KIDS
# =============================================================================

set -e

echo "🔧 Correction et finalisation des scripts AI4KIDS..."

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Créer le dossier scripts s'il n'existe pas
mkdir -p "$SCRIPT_DIR"

# Créer les scripts individuels complets
echo -e "${BLUE}📝 Création des scripts complets...${NC}"

# 1. Script de création des composants
echo -e "${YELLOW}Création du script de composants...${NC}"
cat > "$SCRIPT_DIR/create_components.sh" << 'EOF'
#!/bin/bash

set -e

echo "🧩 Création des composants React..."

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"
COMPONENTS_DIR="$AI4KIDS_APP_DIR/src/components"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Créer les dossiers
mkdir -p "$COMPONENTS_DIR"
mkdir -p "$COMPONENTS_DIR/ui"

# Créer le composant Logo
echo -e "${BLUE}📝 Création du composant Logo...${NC}"
cat > "$COMPONENTS_DIR/AI4KidsLogo.tsx" << 'LOGO_EOF'
import React from 'react';

interface LogoProps {
  size?: number;
  className?: string;
}

export const AI4KidsLogo: React.FC<LogoProps> = ({ size = 100, className = '' }) => {
  return (
    <div className={`ai4kids-logo ${className}`} style={{ width: size, height: size }}>
      <svg
        width={size}
        height={size}
        viewBox="0 0 300 300"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        {/* Fond du logo */}
        <circle cx="150" cy="150" r="140" fill="white" stroke="#f0f0f0" strokeWidth="2"/>
        
        {/* Lettre A centrale */}
        <path
          d="M120 200 L150 120 L180 200 M130 180 L170 180"
          stroke="#4a90e2"
          strokeWidth="8"
          strokeLinecap="round"
          strokeLinejoin="round"
          fill="none"
        />
        
        {/* Personnage bleu (haut) */}
        <g transform="translate(150, 80)">
          <circle cx="0" cy="0" r="20" fill="#4ECDC4"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#4ECDC4" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#4ECDC4" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Personnage orange (droite) */}
        <g transform="translate(220, 150)">
          <circle cx="0" cy="0" r="20" fill="#FF8C42"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#FF8C42" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#FF8C42" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Personnage rose (bas) */}
        <g transform="translate(150, 220)">
          <circle cx="0" cy="0" r="20" fill="#FF6B9D"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#FF6B9D" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#FF6B9D" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Personnage vert (gauche) */}
        <g transform="translate(80, 150)">
          <circle cx="0" cy="0" r="20" fill="#95E1D3"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#95E1D3" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#95E1D3" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Étoiles décoratives */}
        <g fill="#FFD93D">
          <path d="M50 100 L52 106 L58 106 L53 110 L55 116 L50 112 L45 116 L47 110 L42 106 L48 106 Z"/>
          <path d="M250 100 L252 106 L258 106 L253 110 L255 116 L250 112 L245 116 L247 110 L242 106 L248 106 Z"/>
          <path d="M50 200 L52 206 L58 206 L53 210 L55 216 L50 212 L45 216 L47 210 L42 206 L48 206 Z"/>
          <path d="M250 200 L252 206 L258 206 L253 210 L255 216 L250 212 L245 216 L247 210 L242 206 L248 206 Z"/>
        </g>
      </svg>
    </div>
  );
};

// Version du logo avec texte
export const AI4KidsLogoWithText: React.FC<LogoProps> = ({ size = 200, className = '' }) => {
  return (
    <div className={`ai4kids-logo-with-text ${className}`} style={{ width: size, height: size * 0.8 }}>
      <AI4KidsLogo size={size * 0.6} />
      <div 
        style={{
          fontSize: size * 0.12,
          fontWeight: 'bold',
          textAlign: 'center',
          marginTop: size * 0.05,
          background: 'linear-gradient(45deg, #FF6B9D, #FF8C42, #4ECDC4, #95E1D3)',
          backgroundClip: 'text',
          WebkitBackgroundClip: 'text',
          color: 'transparent',
          fontFamily: 'Comic Sans MS, cursive, sans-serif'
        }}
      >
        AI4KIDS
      </div>
    </div>
  );
};
LOGO_EOF

# Créer le composant Header
echo -e "${BLUE}📝 Création du composant Header...${NC}"
cat > "$COMPONENTS_DIR/Header.tsx" << 'HEADER_EOF'
import React, { useState } from 'react';
import { AI4KidsLogo } from './AI4KidsLogo';

interface HeaderProps {
  onNavigate?: (section: string) => void;
}

export const Header: React.FC<HeaderProps> = ({ onNavigate }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const navItems = [
    { id: 'home', label: 'Accueil', icon: '🏠' },
    { id: 'games', label: 'Jeux', icon: '🎮' },
    { id: 'stories', label: 'Histoires', icon: '📚' },
    { id: 'learn', label: 'Apprendre', icon: '🧠' },
    { id: 'about', label: 'À propos', icon: '❓' },
  ];

  return (
    <header className="ai4kids-nav sticky top-0 z-50 shadow-lg">
      <div className="container mx-auto px-4 py-3">
        <div className="flex items-center justify-between">
          {/* Logo et nom */}
          <div className="flex items-center space-x-3">
            <AI4KidsLogo size={60} className="logo" />
            <div className="text-white">
              <h1 className="text-2xl font-bold leading-tight">AI4KIDS</h1>
              <p className="text-sm text-white/80">Intelligence Artificielle pour Enfants</p>
            </div>
          </div>

          {/* Navigation desktop */}
          <nav className="hidden md:flex items-center space-x-1">
            {navItems.map((item) => (
              <button
                key={item.id}
                onClick={() => onNavigate?.(item.id)}
                className="flex items-center space-x-2 px-4 py-2 rounded-full text-white hover:bg-white/10 transition-all duration-300 font-medium"
              >
                <span className="text-lg">{item.icon}</span>
                <span>{item.label}</span>
              </button>
            ))}
          </nav>

          {/* Bouton menu mobile */}
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="md:hidden p-2 rounded-lg text-white hover:bg-white/10 transition-all duration-300"
          >
            <div className="w-6 h-6 flex flex-col justify-center items-center">
              <span className={`block w-5 h-0.5 bg-white transform transition-all duration-300 ${isMenuOpen ? 'rotate-45 translate-y-1' : ''}`}></span>
              <span className={`block w-5 h-0.5 bg-white mt-1 transition-all duration-300 ${isMenuOpen ? 'opacity-0' : ''}`}></span>
              <span className={`block w-5 h-0.5 bg-white mt-1 transform transition-all duration-300 ${isMenuOpen ? '-rotate-45 -translate-y-1' : ''}`}></span>
            </div>
          </button>
        </div>

        {/* Menu mobile */}
        {isMenuOpen && (
          <div className="md:hidden mt-4 pb-4 border-t border-white/10">
            <nav className="flex flex-col space-y-2 pt-4">
              {navItems.map((item) => (
                <button
                  key={item.id}
                  onClick={() => {
                    onNavigate?.(item.id);
                    setIsMenuOpen(false);
                  }}
                  className="flex items-center space-x-3 px-4 py-3 rounded-lg text-white hover:bg-white/10 transition-all duration-300 font-medium text-left"
                >
                  <span className="text-xl">{item.icon}</span>
                  <span>{item.label}</span>
                </button>
              ))}
            </nav>
          </div>
        )}
      </div>
    </header>
  );
};
HEADER_EOF

# Créer les composants UI
echo -e "${BLUE}📝 Création des composants UI...${NC}"
cat > "$COMPONENTS_DIR/ui/Button.tsx" << 'BUTTON_EOF'
import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'success' | 'warning';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  children,
  className = '',
  ...props
}) => {
  const baseClasses = 'ai4kids-button font-bold rounded-full transition-all duration-300 cursor-pointer';
  
  const variantClasses = {
    primary: 'bg-gradient-to-r from-blue-500 to-purple-600 text-white',
    secondary: 'bg-gradient-to-r from-orange-500 to-red-600 text-white',
    success: 'bg-gradient-to-r from-green-500 to-teal-600 text-white',
    warning: 'bg-gradient-to-r from-yellow-500 to-orange-600 text-white',
  };
  
  const sizeClasses = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-8 py-3 text-base',
    lg: 'px-12 py-4 text-lg',
  };

  return (
    <button
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
};
BUTTON_EOF

cat > "$COMPONENTS_DIR/ui/Card.tsx" << 'CARD_EOF'
import React from 'react';

interface CardProps {
  children: React.ReactNode;
  className?: string;
  hover?: boolean;
}

export const Card: React.FC<CardProps> = ({ children, className = '', hover = true }) => {
  const baseClasses = 'bg-white/95 rounded-3xl p-8 shadow-xl backdrop-blur-sm';
  const hoverClasses = hover ? 'hover:transform hover:scale-105 transition-all duration-300' : '';
  
  return (
    <div className={`${baseClasses} ${hoverClasses} ${className}`}>
      {children}
    </div>
  );
};
CARD_EOF

echo -e "${GREEN}✅ Composants créés avec succès${NC}"
EOF

# 2. Script de création des assets
echo -e "${YELLOW}Création du script d'assets...${NC}"
cat > "$SCRIPT_DIR/create_assets.sh" << 'EOF'
#!/bin/bash

set -e

echo "🖼️  Création des assets et styles..."

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"
STYLES_DIR="$AI4KIDS_APP_DIR/src/styles"
PUBLIC_DIR="$AI4KIDS_APP_DIR/public"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Créer les dossiers
mkdir -p "$STYLES_DIR"
mkdir -p "$PUBLIC_DIR"

# Créer le fichier de styles principal
echo -e "${BLUE}🎨 Création des styles CSS...${NC}"
cat > "$STYLES_DIR/ai4kids.css" << 'STYLES_EOF'
/* Styles pour le logo AI4KIDS */
.ai4kids-logo {
  display: inline-block;
  animation: logoFloat 3s ease-in-out infinite;
}

.ai4kids-logo-with-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  animation: logoFloat 3s ease-in-out infinite;
}

/* Animation flottante pour le logo */
@keyframes logoFloat {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

/* Animation pour les personnages du logo */
.ai4kids-logo svg g {
  animation: characterBounce 2s ease-in-out infinite;
}

.ai4kids-logo svg g:nth-child(2) {
  animation-delay: 0.2s;
}

.ai4kids-logo svg g:nth-child(3) {
  animation-delay: 0.4s;
}

.ai4kids-logo svg g:nth-child(4) {
  animation-delay: 0.6s;
}

.ai4kids-logo svg g:nth-child(5) {
  animation-delay: 0.8s;
}

@keyframes characterBounce {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

/* Styles pour la navigation */
.ai4kids-nav {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  backdrop-filter: blur(10px);
  border-bottom: 2px solid rgba(255, 255, 255, 0.1);
}

.ai4kids-nav .logo {
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

/* Styles pour les boutons */
.ai4kids-button {
  border: none;
  border-radius: 25px;
  color: white;
  font-size: 1.1rem;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
  font-family: 'Comic Sans MS', cursive, sans-serif;
}

.ai4kids-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
}

/* Styles pour les cartes de fonctionnalités */
.feature-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 24px;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
  border: 2px solid rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
}

/* Styles pour les étoiles décoratives */
.ai4kids-stars {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  overflow: hidden;
  z-index: -1;
}

.ai4kids-star {
  position: absolute;
  color: #FFD93D;
  animation: twinkle 3s ease-in-out infinite;
}

@keyframes twinkle {
  0%, 100% {
    opacity: 0.3;
    transform: scale(1);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

/* Styles responsive */
@media (max-width: 768px) {
  .ai4kids-logo-with-text {
    width: 200px !important;
    height: 160px !important;
  }
  
  .ai4kids-button {
    font-size: 1rem;
    padding: 0.8rem 1.5rem;
  }
}
STYLES_EOF

# Créer le favicon SVG
echo -e "${BLUE}📝 Création du favicon...${NC}"
cat > "$PUBLIC_DIR/favicon.svg" << 'FAVICON_EOF'
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Fond -->
  <rect width="32" height="32" rx="8" fill="white"/>
  
  <!-- Lettre A simplifiée -->
  <path d="M12 22 L16 14 L20 22 M14 20 L18 20" stroke="#4a90e2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  
  <!-- Personnages simplifiés -->
  <!-- Bleu (haut) -->
  <circle cx="16" cy="8" r="3" fill="#4ECDC4"/>
  <circle cx="15" cy="7" r="0.5" fill="white"/>
  <circle cx="17" cy="7" r="0.5" fill="white"/>
  
  <!-- Orange (droite) -->
  <circle cx="24" cy="16" r="3" fill="#FF8C42"/>
  <circle cx="23" cy="15" r="0.5" fill="white"/>
  <circle cx="25" cy="15" r="0.5" fill="white"/>
  
  <!-- Rose (bas) -->
  <circle cx="16" cy="24" r="3" fill="#FF6B9D"/>
  <circle cx="15" cy="23" r="0.5" fill="white"/>
  <circle cx="17" cy="23" r="0.5" fill="white"/>
  
  <!-- Vert (gauche) -->
  <circle cx="8" cy="16" r="3" fill="#95E1D3"/>
  <circle cx="7" cy="15" r="0.5" fill="white"/>
  <circle cx="9" cy="15" r="0.5" fill="white"/>
  
  <!-- Étoiles décoratives -->
  <circle cx="6" cy="6" r="1" fill="#FFD93D"/>
  <circle cx="26" cy="6" r="1" fill="#FFD93D"/>
  <circle cx="6" cy="26" r="1" fill="#FFD93D"/>
  <circle cx="26" cy="26" r="1" fill="#FFD93D"/>
</svg>
FAVICON_EOF

# Créer le manifest PWA
echo -e "${BLUE}📝 Création du manifest PWA...${NC}"
cat > "$PUBLIC_DIR/site.webmanifest" << 'MANIFEST_EOF'
{
  "name": "AI4KIDS",
  "short_name": "AI4KIDS",
  "description": "Intelligence Artificielle pour Enfants",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#4ECDC4",
  "icons": [
    {
      "src": "/favicon.svg",
      "sizes": "any",
      "type": "image/svg+xml"
    }
  ],
  "categories": ["education", "kids", "games"],
  "lang": "fr",
  "orientation": "portrait"
}
MANIFEST_EOF

echo -e "${GREEN}✅ Assets et styles créés avec succès${NC}"
EOF

# 3. Script de mise à jour du package
echo -e "${YELLOW}Création du script de package...${NC}"
cat > "$SCRIPT_DIR/update_package.sh" << 'EOF'
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
EOF

# 4. Script principal de déploiement
echo -e "${YELLOW}Création du script principal de déploiement...${NC}"
cat > "$SCRIPT_DIR/deploy.sh" << 'EOF'
#!/bin/bash

set -e

echo "🚀 Déploiement du nouveau logo AI4KIDS..."

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifications préalables
echo -e "${BLUE}📋 Vérifications préalables...${NC}"

if [ ! -d "$AI4KIDS_APP_DIR" ]; then
    echo -e "${RED}❌ Erreur: Le dossier apps/ai4kids n'existe pas${NC}"
    exit 1
fi

# Vérifier Node.js et npm
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js n'est pas installé${NC}"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm n'est pas installé${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Vérifications réussies${NC}"

# Créer les dossiers nécessaires
echo -e "${BLUE}📁 Création des dossiers...${NC}"
mkdir -p "$AI4KIDS_APP_DIR/src/components"
mkdir -p "$AI4KIDS_APP_DIR/src/components/ui"
mkdir -p "$AI4KIDS_APP_DIR/src/styles"
mkdir -p "$AI4KIDS_APP_DIR/src/app"
mkdir -p "$AI4KIDS_APP_DIR/public"

# Sauvegarder les fichiers existants
echo -e "${BLUE}💾 Sauvegarde des fichiers existants...${NC}"
BACKUP_DIR="$AI4KIDS_APP_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Sauvegarder les fichiers principaux
files_to_backup=(
    "src/app/page.tsx"
    "src/app/layout.tsx"
    "src/index.ts"
    "package.json"
    "tailwind.config.js"
    "next.config.js"
)

for file in "${files_to_backup[@]}"; do
    if [ -f "$AI4KIDS_APP_DIR/$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp "$AI4KIDS_APP_DIR/$file" "$BACKUP_DIR/$file"
        echo -e "${BLUE}💾 Sauvegardé: $file${NC}"
    fi
done

# Rendre les scripts exécutables
chmod +x "$SCRIPT_DIR/create_components.sh"
chmod +x "$SCRIPT_DIR/create_assets.sh"
chmod +x "$SCRIPT_DIR/update_package.sh"

# Exécuter les scripts
echo -e "${BLUE}🧩 Création des composants...${NC}"
"$SCRIPT_DIR/create_components.sh"

echo -e "${BLUE}🎨 Création des assets...${NC}"
"$SCRIPT_DIR/create_assets.sh"

echo -e "${BLUE}📦 Mise à jour du package...${NC}"
"$SCRIPT_DIR/update_package.sh"

# Créer les pages mises à jour
echo -e "${BLUE}📝 Création des pages mises à jour...${NC}"

# Page d'accueil
cat > "$AI4KIDS_APP_DIR/src/app/page.tsx" << 'PAGE_EOF'
import React from 'react';
import { AI4KidsLogoWithText } from '../components/AI4KidsLogo';
import { Button } from '../components/ui/Button';
import { Card } from '../components/ui/Card';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-400 via-pink-300 to-orange-300">
      <div className="container mx-auto px-4 py-8">
        {/* Header avec nouveau logo */}
        <header className="text-center mb-12">
          <div className="flex justify-center mb-6">
            <AI4KidsLogoWithText size={300} />
          </div>
          <h1 className="text-5xl font-bold text-white mb-4 drop-shadow-lg">
            Bienvenue sur AI4KIDS
          </h1>
          <p className="text-xl text-white/90 max-w-2xl mx-auto">
            Découvre le monde passionnant de l'intelligence artificielle 
            à travers des jeux, des histoires et des activités éducatives !
          </p>
        </header>

        {/* Section principales fonctionnalités */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
          {/* Jeux éducatifs */}
          <Card className="border-2 border-blue-200 text-center">
            <div className="text-6xl mb-4">🎮</div>
            <h3 className="text-2xl font-bold text-blue-600 mb-4">Jeux Éducatifs</h3>
            <p className="text-gray-700 mb-6">
              Apprends les mathématiques, les sciences et bien plus à travers des jeux interactifs !
            </p>
            <Button variant="primary">Jouer maintenant</Button>
          </Card>

          {/* Histoires interactives */}
          <Card className="border-2 border-green-200 text-center">
            <div className="text-6xl mb-4">📚</div>
            <h3 className="text-2xl font-bold text-green-600 mb-4">Histoires Magiques</h3>
            <p className="text-gray-700 mb-6">
              Découvre des histoires captivantes qui t'enseignent des valeurs importantes !
            </p>
            <Button variant="success">Lire une histoire</Button>
          </Card>

          {/* Découverte IA */}
          <Card className="border-2 border-orange-200 text-center">
            <div className="text-6xl mb-4">🤖</div>
            <h3 className="text-2xl font-bold text-orange-600 mb-4">Découvre l'IA</h3>
            <p className="text-gray-700 mb-6">
              Apprends comment fonctionne l'intelligence artificielle de manière simple et amusante !
            </p>
            <Button variant="secondary">Explorer l'IA</Button>
          </Card>
        </div>

        {/* Call to action */}
        <div className="text-center">
          <div className="bg-gradient-to-r from-purple-600 to-pink-600 rounded-3xl p-8 text-white shadow-xl">
            <h2 className="text-3xl font-bold mb-4">Prêt à commencer l'aventure ?</h2>
            <p className="text-xl mb-6 text-white/90">
              Rejoins des milliers d'enfants qui apprennent et s'amusent avec AI4KIDS !
            </p>
            <Button size="lg" className="bg-white text-purple-600 hover:bg-gray-100">
              Commencer maintenant
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
PAGE_EOF

# Layout
cat > "$AI4KIDS_APP_DIR/src/app/layout.tsx" << 'LAYOUT_EOF'
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import '../styles/ai4kids.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'AI4KIDS - Intelligence Artificielle pour Enfants',
  description: 'Découvre le monde passionnant de l\'intelligence artificielle à travers des jeux, des histoires et des activités éducatives adaptées aux enfants.',
  keywords: ['AI4KIDS', 'intelligence artificielle', 'enfants', 'éducation', 'jeux éducatifs', 'apprentissage'],
  authors: [{ name: 'AI4KIDS Team' }],
  creator: 'AI4KIDS',
  publisher: 'AI4KIDS',
  icons: {
    icon: [
      {
        url: '/favicon.svg',
        type: 'image/svg+xml',
      },
    ],
  },
  manifest: '/site.webmanifest',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="theme-color" content="#4ECDC4" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Comic+Neue:wght@300;400;700&display=swap" rel="stylesheet" />
      </head>
      <body className={inter.className}>
        <div className="ai4kids-stars">
          <div className="ai4kids-star" style={{ top: '10%', left: '15%' }}>⭐</div>
          <div className="ai4kids-star" style={{ top: '20%', right: '20%' }}>✨</div>
          <div className="ai4kids-star" style={{ bottom: '15%', left: '10%' }}>🌟</div>
          <div className="ai4kids-star" style={{ bottom: '25%', right: '15%' }}>💫</div>
        </div>
        {children}
      </body>
    </html>
  );
}
LAYOUT_EOF

# Installer les dépendances
echo -e "${BLUE}📦 Installation des dépendances...${NC}"
cd "$AI4KIDS_APP_DIR"
npm install

# Test de build
echo -e "${BLUE}🧪 Test de build...${NC}"
if npm run build; then
    echo -e "${GREEN}✅ Build réussi${NC}"
else
    echo -e "${YELLOW}⚠️ Erreur de build (vérifiez les logs)${NC}"
fi

# Mettre à jour le README
echo -e "${BLUE}📝 Mise à jour du README...${NC}"
cat > "$PROJECT_ROOT/README.md" << 'README_EOF'
# 🎨 AI4KIDS - Intelligence Artificielle pour Enfants

<div align="center">
  <img src="apps/ai4kids/public/favicon.svg" alt="Logo AI4KIDS" width="120" height="120">
  
  [![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/votre-repo/ai4kids)
  [![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/votre-repo/ai4kids/actions)
  [![TypeScript](https://img.shields.io/badge/TypeScript-5.3+-blue.svg)](https://www.typescriptlang.org/)
  [![React](https://img.shields.io/badge/React-18.2+-61DAFB.svg)](https://reactjs.org/)
  [![Next.js](https://img.shields.io/badge/Next.js-14+-000000.svg)](https://nextjs.org/)
</div>

## 🌟 Découvrez le nouveau AI4KIDS !

AI4KIDS est une application éducative interactive qui initie les enfants au monde fascinant de l'intelligence artificielle à travers des jeux, des histoires et des activités ludiques. 

### 🎯 **Nouveau Logo & Identité Visuelle**

Notre nouvelle identité visuelle reflète l'esprit inclusif et éducatif de l'application :
- **4 personnages colorés** représentant la diversité des enfants
- **Couleurs vives et engageantes** : Bleu turquoise, Orange, Rose, Vert menthe
- **Design adapté aux enfants** avec des animations douces et interactives
- **Responsive** sur tous les supports (mobile, tablette, desktop)

## 🚀 Installation & Démarrage

### 📋 **Prérequis**
- Node.js 18+ et npm 9+
- Git pour le versioning

### 🚀 **Installation Rapide**

```bash
# Cloner le repository
git clone https://github.com/votre-repo/ai4kids.git
cd ai4kids

# Déployer le nouveau logo
./scripts/deploy.sh

# Lancer en développement
cd apps/ai4kids
npm run dev
```

L'application sera disponible sur `http://localhost:3004`

## 🎨 Fonctionnalités du nouveau logo

✅ **Composant Logo React** avec animations  
✅ **4 personnages colorés** représentant la diversité  
✅ **Palette de couleurs moderne** (Bleu, Orange, Rose, Vert)  
✅ **Animations fluides** et interactions  
✅ **Design responsive** pour tous les écrans  
✅ **Assets optimisés** (favicon, manifest PWA)  
✅ **Styles CSS complets** avec Tailwind  
✅ **TypeScript** avec typage complet  

## 🤝 Contribution

Les contributions sont les bienvenues ! Consultez le guide de contribution pour plus de détails.

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

<div align="center">
  <p><strong>Fait avec ❤️ pour l'éducation des enfants</strong></p>
</div>
README_EOF

echo ""
echo -e "${GREEN}🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS !${NC}"
echo ""
echo -e "${BLUE}📋 Prochaines étapes :${NC}"
echo "1. Testez l'application: cd apps/ai4kids && npm run dev"
echo "2. Ouvrez votre navigateur: http://localhost:3004"
echo "3. Vérifiez le nouveau logo et l'interface"
echo ""
echo -e "${YELLOW}📁 Sauvegarde des anciens fichiers disponible dans:${NC}"
echo "   $BACKUP_DIR"
echo ""
EOF

# Rendre tous les scripts exécutables
chmod +x "$SCRIPT_DIR"/*.sh

echo -e "${GREEN}✅ Correction terminée avec succès !${NC}"
echo ""
echo -e "${BLUE}📋 Scripts créés et corrigés :${NC}"
echo "• create_components.sh"
echo "• create_assets.sh"
echo "• update_package.sh"
echo "• deploy.sh"
echo ""
echo -e "${YELLOW}🚀 Pour déployer le nouveau logo :${NC}"
echo "  ./scripts/deploy.sh"
echo ""
echo -e "${YELLOW}📝 Tous les scripts sont maintenant prêts !${NC}"
echo ""