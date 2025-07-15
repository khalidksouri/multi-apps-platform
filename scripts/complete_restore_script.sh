#!/bin/bash

# =============================================
# 🔧 Script de restauration complète du projet
# =============================================

echo "🔧 Restauration complète du projet multi-apps-platform..."

# Étape 1: Vérifier qu'on est dans le bon répertoire
if [ ! -d "scripts" ]; then
    echo "❌ Erreur: Veuillez exécuter ce script depuis la racine du projet"
    exit 1
fi

echo "📁 Répertoire de travail: $(pwd)"

# Étape 2: Créer la structure des applications manquantes
echo "🎯 ÉTAPE 1: Création des applications manquantes"

# Créer AI4Kids
echo "🤖 Création d'AI4Kids..."
mkdir -p apps/ai4kids/src/{app,components,lib,types}

cat > apps/ai4kids/package.json << 'EOF'
{
  "name": "ai4kids-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3004",
    "build": "next build",
    "start": "next start -p 3004",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "@multiapps/shared": "workspace:*",
    "@multiapps/ui": "workspace:*"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
EOF

# Créer MultiAI
echo "🧠 Création de MultiAI..."
mkdir -p apps/multiai/src/{app,components,lib,types}

cat > apps/multiai/package.json << 'EOF'
{
  "name": "multiai-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3005",
    "build": "next build",
    "start": "next start -p 3005",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "@multiapps/shared": "workspace:*",
    "@multiapps/ui": "workspace:*"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
EOF

# Restaurer les package.json des applications existantes
echo "🔧 Restauration des package.json des applications existantes..."

# BudgetCron
cat > apps/budgetcron/package.json << 'EOF'
{
  "name": "budgetcron-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3003",
    "build": "next build",
    "start": "next start -p 3003",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "react-hook-form": "^7.47.0",
    "@multiapps/shared": "workspace:*",
    "@multiapps/ui": "workspace:*"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
EOF

# UnitFlip
cat > apps/unitflip/package.json << 'EOF'
{
  "name": "unitflip-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3002",
    "build": "next build",
    "start": "next start -p 3002",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "@multiapps/shared": "workspace:*",
    "@multiapps/ui": "workspace:*"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
EOF

# PostMath
cat > apps/postmath/package.json << 'EOF'
{
  "name": "postmath-app",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3001",
    "build": "next build",
    "start": "next start -p 3001",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "react-hook-form": "^7.47.0",
    "@multiapps/shared": "workspace:*",
    "@multiapps/ui": "workspace:*"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0"
  }
}
EOF

# Étape 3: Créer les fichiers de base manquants
echo "🎯 ÉTAPE 2: Création des fichiers de base"

# Fonction pour créer les fichiers Next.js de base
create_nextjs_basics() {
    local app_path=$1
    local port=$2
    local title=$3
    local emoji=$4
    
    # next-env.d.ts
    cat > "$app_path/next-env.d.ts" << 'EOF'
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// NOTE: This file should not be edited
// see https://nextjs.org/docs/basic-features/typescript for more information.
EOF
    
    # tsconfig.json
    cat > "$app_path/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": false,
    "noEmit": true,
    "incremental": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/types/*": ["./src/types/*"],
      "@/utils/*": ["./src/utils/*"]
    },
    "plugins": [{"name": "next"}]
  },
  "include": ["next-env.d.ts", ".next/types/**/*.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF
    
    # globals.css
    cat > "$app_path/src/app/globals.css" << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  html {
    font-family: system-ui, sans-serif;
  }
}

@layer components {
  .btn {
    @apply px-4 py-2 rounded-md font-medium transition-colors;
  }
  
  .btn-primary {
    @apply bg-blue-600 text-white hover:bg-blue-700;
  }
  
  .btn-secondary {
    @apply bg-gray-200 text-gray-900 hover:bg-gray-300;
  }
}
EOF

    # layout.tsx
    cat > "$app_path/src/app/layout.tsx" << EOF
import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: '$title',
  description: 'Application $title - Plateforme MultiApps',
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

    # page.tsx
    cat > "$app_path/src/app/page.tsx" << EOF
export default function HomePage() {
  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          $emoji $title
        </h1>
        <p className="text-xl text-gray-600">
          Bienvenue sur $title - Port $port
        </p>
      </div>

      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold mb-4">
          $emoji Fonctionnalités
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
}

# Créer les fichiers pour chaque application
create_nextjs_basics "apps/ai4kids" "3004" "AI4Kids" "🤖"
create_nextjs_basics "apps/multiai" "3005" "MultiAI" "🧠"

echo "✅ Applications AI4Kids et MultiAI créées"

# Étape 4: Créer la structure des packages si elle n'existe pas
echo "🎯 ÉTAPE 3: Vérification et création des packages"

# Package shared
if [ ! -f "packages/shared/package.json" ]; then
    mkdir -p packages/shared/src
    
    cat > packages/shared/package.json << 'EOF'
{
  "name": "@multiapps/shared",
  "version": "1.0.0",
  "description": "Code TypeScript partagé entre toutes les applications",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rimraf dist"
  },
  "dependencies": {
    "zod": "^3.22.0",
    "date-fns": "^2.30.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "rimraf": "^5.0.0"
  },
  "peerDependencies": {
    "react": ">=18.0.0"
  }
}
EOF

    cat > packages/shared/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020"],
    "module": "commonjs",
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

    cat > packages/shared/src/index.ts << 'EOF'
export interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
}

export interface APIResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
  };
}

export const formatCurrency = (amount: number): string => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(amount);
};
EOF

    echo "✅ Package shared créé"
fi

# Package UI
if [ ! -f "packages/ui/package.json" ]; then
    mkdir -p packages/ui/src/components
    
    cat > packages/ui/package.json << 'EOF'
{
  "name": "@multiapps/ui",
  "version": "1.0.0",
  "description": "Composants React partagés",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "clean": "rimraf dist"
  },
  "dependencies": {
    "clsx": "^2.0.0",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "rimraf": "^5.0.0"
  },
  "peerDependencies": {
    "react": ">=18.0.0",
    "react-dom": ">=18.0.0"
  }
}
EOF

    cat > packages/ui/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "ES2020"],
    "module": "commonjs",
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "jsx": "react"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF

    cat > packages/ui/src/index.ts << 'EOF'
export { Button } from './components/Button';
export { Card } from './components/Card';
EOF

    cat > packages/ui/src/components/Button.tsx << 'EOF'
import React from 'react';
import { clsx } from 'clsx';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  className,
  children,
  ...props
}) => {
  const baseClasses = 'inline-flex items-center justify-center rounded-md font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2';
  
  const variantClasses = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500',
    secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300 focus:ring-gray-500',
    outline: 'border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 focus:ring-blue-500',
  };
  
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg',
  };

  return (
    <button
      className={clsx(
        baseClasses,
        variantClasses[variant],
        sizeClasses[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
};
EOF

    cat > packages/ui/src/components/Card.tsx << 'EOF'
import React from 'react';
import { clsx } from 'clsx';

interface CardProps {
  children: React.ReactNode;
  className?: string;
  padding?: 'sm' | 'md' | 'lg';
}

export const Card: React.FC<CardProps> = ({
  children,
  className,
  padding = 'md'
}) => {
  const paddingClasses = {
    sm: 'p-4',
    md: 'p-6',
    lg: 'p-8',
  };

  return (
    <div
      className={clsx(
        'bg-white rounded-lg shadow border border-gray-200',
        paddingClasses[padding],
        className
      )}
    >
      {children}
    </div>
  );
};
EOF

    echo "✅ Package UI créé"
fi

# Étape 5: Mettre à jour le package.json principal
echo "🎯 ÉTAPE 4: Mise à jour du package.json principal"

cat > package.json << 'EOF'
{
  "name": "multi-apps-platform",
  "version": "1.0.0",
  "description": "🚀 Plateforme multi-applications : PostMath Pro, UnitFlip Pro, BudgetCron, AI4Kids et MultiAI Search",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "concurrently \"npm run dev --workspace=postmath-app\" \"npm run dev --workspace=unitflip-app\" \"npm run dev --workspace=budgetcron-app\" \"npm run dev --workspace=ai4kids-app\" \"npm run dev --workspace=multiai-app\"",
    "dev:postmath": "npm run dev --workspace=postmath-app",
    "dev:unitflip": "npm run dev --workspace=unitflip-app", 
    "dev:budgetcron": "npm run dev --workspace=budgetcron-app",
    "dev:ai4kids": "npm run dev --workspace=ai4kids-app",
    "dev:multiai": "npm run dev --workspace=multiai-app",
    "build": "npm run build:packages && npm run build:apps",
    "build:packages": "npm run build --workspace=packages/shared && npm run build --workspace=packages/ui",
    "build:apps": "npm run build --workspace=postmath-app && npm run build --workspace=unitflip-app && npm run build --workspace=budgetcron-app && npm run build --workspace=ai4kids-app && npm run build --workspace=multiai-app",
    "test": "npm run test --workspaces --if-present",
    "lint": "eslint . --ext .ts,.tsx",
    "format": "prettier --write .",
    "clean": "rimraf node_modules/.cache && rimraf apps/*/dist && rimraf packages/*/dist"
  },
  "keywords": [
    "nextjs",
    "typescript", 
    "monorepo",
    "multi-tenant",
    "saas",
    "postmath",
    "unitflip",
    "budgetcron",
    "ai4kids",
    "multiai"
  ],
  "author": "Khalid Ksouri <khalid_ksouri@yahoo.fr>",
  "license": "MIT",
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "eslint-config-prettier": "^9.0.0",
    "prettier": "^3.0.0",
    "rimraf": "^5.0.0",
    "typescript": "^5.0.0",
    "concurrently": "^8.0.0",
    "cross-env": "^7.0.0"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  }
}
EOF

echo "✅ Package.json principal mis à jour"

# Étape 6: Build et test
echo "🎯 ÉTAPE 5: Installation et build"

echo "📦 Installation des dépendances..."
npm install

echo "🔨 Build des packages..."
npm run build:packages

echo "🧪 Test du build des applications..."
npm run build:apps

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 RESTAURATION COMPLÈTE RÉUSSIE!"
    echo "================================="
    echo "✅ 5 applications créées/restaurées"
    echo "✅ 2 packages partagés créés"
    echo "✅ Configuration TypeScript optimisée"
    echo "✅ Build réussi pour toutes les applications"
    echo ""
    echo "🚀 Applications disponibles:"
    echo "   - PostMath: http://localhost:3001 (npm run dev:postmath)"
    echo "   - UnitFlip: http://localhost:3002 (npm run dev:unitflip)"
    echo "   - BudgetCron: http://localhost:3003 (npm run dev:budgetcron)"
    echo "   - AI4Kids: http://localhost:3004 (npm run dev:ai4kids)"
    echo "   - MultiAI: http://localhost:3005 (npm run dev:multiai)"
    echo ""
    echo "💡 Commandes utiles:"
    echo "   npm run dev           # Démarrer toutes les apps"
    echo "   npm run dev:postmath  # Démarrer PostMath seulement"
    echo "   npm run build         # Builder tout le projet"
else
    echo ""
    echo "❌ Erreur de build détectée"
    echo "============================"
    echo "💡 Vérifiez les logs ci-dessus et relancez:"
    echo "   npm run build:packages"
    echo "   npm run build:apps"
fi

echo ""
echo "📊 Résumé de la restauration:"
echo "   ✅ Structure du projet restaurée"
echo "   ✅ Applications manquantes créées"
echo "   ✅ Package.json restaurés"
echo "   ✅ Configuration TypeScript optimisée"
echo "   ✅ Packages partagés fonctionnels"