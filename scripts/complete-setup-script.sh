#!/bin/bash

# =============================================
# 🚀 Script de Setup Complet Multi-Apps Platform
# =============================================

set -e  # Arrêter si une commande échoue

echo "🚀 SETUP COMPLET - Multi-Apps Platform"
echo "======================================"
echo ""

# Fonction pour afficher les étapes
print_step() {
    echo ""
    echo "🎯 ÉTAPE $1: $2"
    echo "$(printf '=%.0s' {1..50})"
}

# Fonction pour vérifier si une commande existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Vérifications préliminaires
print_step "0" "Vérifications préliminaires"

if ! command_exists node; then
    echo "❌ Node.js n'est pas installé"
    exit 1
fi

if ! command_exists npm; then
    echo "❌ npm n'est pas installé"
    exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo "✅ npm version: $(npm --version)"

# Étape 1: Corriger la configuration TypeScript principale
print_step "1" "Configuration TypeScript principale"

cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "verbatimModuleSyntax": false,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./",
    "removeComments": false,
    "downlevelIteration": true,
    "importHelpers": true,
    "noEmit": false,
    "allowJs": true,
    "checkJs": false,
    "incremental": true,
    "tsBuildInfoFile": "./dist/.tsbuildinfo",
    "skipLibCheck": true,
    "skipDefaultLibCheck": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"],
      "@tests/*": ["tests/*"],
      "@features/*": ["tests/features/*"],
      "@steps/*": ["tests/steps/*"],
      "@support/*": ["tests/support/*"],
      "@fixtures/*": ["tests/fixtures/*"],
      "@utils/*": ["tests/utils/*"],
      "@config/*": ["config/*"],
      "@components/*": ["src/components/*"],
      "@pages/*": ["src/pages/*"],
      "@hooks/*": ["src/hooks/*"],
      "@lib/*": ["src/lib/*"],
      "@types/*": ["src/types/*"],
      "@ai4kids/*": ["apps/ai4kids/src/*"],
      "@multiai/*": ["apps/multiai/src/*"],
      "@budgetcron/*": ["apps/budgetcron/src/*"],
      "@unitflip/*": ["apps/unitflip/src/*"],
      "@postmath/*": ["apps/postmath/src/*"],
      "@multiapps/shared": ["packages/shared/src/index"],
      "@multiapps/shared/*": ["packages/shared/src/*"],
      "@multiapps/ui": ["packages/ui/src/index"],
      "@multiapps/ui/*": ["packages/ui/src/*"]
    },
    "typeRoots": ["./node_modules/@types", "./types", "./@types", "./packages/*/types"],
    "types": ["node", "jest", "@playwright/test", "@cucumber/cucumber"]
  },
  "include": [
    "src/**/*",
    "apps/*/src/**/*",
    "packages/*/src/**/*",
    "tests/**/*",
    "*.config.ts",
    "*.config.js",
    "scripts/**/*",
    "types/**/*",
    "@types/**/*"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "build",
    "coverage",
    "reports",
    "test-results",
    "playwright-report",
    "**/*.d.ts",
    "**/.next/**",
    "**/out/**",
    "**/tmp/**",
    "**/.cache/**",
    "apps/*/node_modules",
    "packages/*/node_modules",
    "apps/*/dist",
    "packages/*/dist"
  ],
  "ts-node": {
    "compilerOptions": {
      "module": "CommonJS",
      "target": "ES2022",
      "moduleResolution": "node",
      "allowSyntheticDefaultImports": true,
      "esModuleInterop": true,
      "isolatedModules": false
    },
    "files": true,
    "experimentalSpecifierResolution": "node",
    "transpileOnly": true,
    "swc": false
  },
  "watchOptions": {
    "watchFile": "useFsEvents",
    "watchDirectory": "useFsEvents",
    "fallbackPolling": "dynamicPriority",
    "synchronousWatchDirectory": true,
    "excludeDirectories": ["**/node_modules", "**/dist", "**/reports", "**/coverage", "**/test-results", "**/playwright-report"]
  }
}
EOF

echo "✅ tsconfig.json principal configuré"

# Étape 2: Créer la structure des packages
print_step "2" "Création de la structure des packages"

mkdir -p packages/shared/src/{types,utils,hooks,constants}
mkdir -p packages/ui/src/{components,utils}

# Package shared
cat > packages/shared/package.json << 'EOF'
{
  "name": "@multiapps/shared",
  "version": "1.0.0",
  "description": "Code TypeScript partagé",
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
  }
}
EOF

cat > packages/shared/tsconfig.json << 'EOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "composite": true
  },
  "include": ["src/**/*"],
  "exclude": ["dist", "node_modules"]
}
EOF

cat > packages/shared/src/index.ts << 'EOF'
export * from './types/common';
export * from './utils/validation';
EOF

cat > packages/shared/src/types/common.ts << 'EOF'
export interface User {
  id: string;
  email: string;
  name: string;
  role: 'user' | 'admin' | 'child';
  createdAt: Date;
  updatedAt: Date;
}

export interface APIResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
}

export interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

export interface ShippingCalculation {
  id: string;
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
  carriers: Carrier[];
  createdAt: Date;
}
EOF

cat > packages/shared/src/utils/validation.ts << 'EOF'
export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validateWeight = (weight: number): boolean => {
  return weight > 0 && weight <= 30;
};
EOF

# Package UI
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
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "composite": true,
    "jsx": "react-jsx"
  },
  "include": ["src/**/*"],
  "exclude": ["dist", "node_modules"]
}
EOF

cat > packages/ui/src/index.ts << 'EOF'
export * from './components/Button';
export * from './utils/cn';
EOF

cat > packages/ui/src/utils/cn.ts << 'EOF'
import { clsx, type ClassValue } from 'clsx';

export function cn(...inputs: ClassValue[]) {
  return clsx(inputs);
}
EOF

cat > packages/ui/src/components/Button.tsx << 'EOF'
import React from 'react';
import { cn } from '../utils/cn';

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = 'primary', size = 'md', loading, children, disabled, ...props }, ref) => {
    const baseStyles = 'inline-flex items-center justify-center rounded-md font-medium transition-colors';
    const variants = {
      primary: 'bg-blue-600 text-white hover:bg-blue-700',
      secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300',
    };
    const sizes = {
      sm: 'h-8 px-3 text-sm',
      md: 'h-10 px-4',
      lg: 'h-12 px-6 text-lg',
    };

    return (
      <button
        className={cn(baseStyles, variants[variant], sizes[size], className)}
        ref={ref}
        disabled={disabled || loading}
        {...props}
      >
        {loading && <span className="mr-2">⏳</span>}
        {children}
      </button>
    );
  }
);

Button.displayName = 'Button';
EOF

echo "✅ Structure des packages créée"

# Étape 3: Corriger les applications
print_step "3" "Correction des applications"

# Fonction pour créer tsconfig.json d'application
create_app_tsconfig() {
    local app_path=$1
    cat > "$app_path/tsconfig.json" << 'EOF'
{
  "extends": "../../tsconfig.json",
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
      "@/utils/*": ["./src/utils/*"],
      "@multiapps/shared": ["../../packages/shared/src/index"],
      "@multiapps/shared/*": ["../../packages/shared/src/*"],
      "@multiapps/ui": ["../../