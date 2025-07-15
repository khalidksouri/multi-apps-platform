#!/bin/bash

# =============================================
# 🔧 Correction des tsconfig.json manquants
# =============================================

echo "🔧 Création des tsconfig.json manquants..."

# Fonction pour créer tsconfig.json pour une application
create_app_tsconfig() {
    local app=$1
    local app_path="apps/$app"
    
    echo "📝 Création de tsconfig.json pour $app..."
    
    # Vérifier si le dossier existe
    if [ ! -d "$app_path" ]; then
        echo "❌ Dossier $app_path n'existe pas"
        return 1
    fi
    
    # Créer le tsconfig.json
    cat > "$app_path/tsconfig.json" << 'EOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
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
      "@multiapps/ui": ["../../packages/ui/src/index"],
      "@multiapps/ui/*": ["../../packages/ui/src/*"]
    },
    "plugins": [
      {
        "name": "next"
      }
    ]
  },
  "include": [
    "next-env.d.ts",
    ".next/types/**/*.ts",
    "**/*.ts",
    "**/*.tsx"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF
    
    echo "✅ tsconfig.json créé pour $app"
}

# Vérifier la structure du projet
echo "🔍 Vérification de la structure du projet..."

# Lister les applications existantes
echo "📁 Applications trouvées:"
for app_dir in apps/*/; do
    if [ -d "$app_dir" ]; then
        app_name=$(basename "$app_dir")
        echo "   - $app_name"
        
        # Vérifier si tsconfig.json existe
        if [ -f "$app_dir/tsconfig.json" ]; then
            echo "     ✅ tsconfig.json existe"
        else
            echo "     ❌ tsconfig.json manquant"
            create_app_tsconfig "$app_name"
        fi
        
        # Vérifier si src/lib existe pour les apps qui en ont besoin
        if [[ "$app_name" == "budgetcron" || "$app_name" == "unitflip" || "$app_name" == "postmath" ]]; then
            if [ -f "$app_dir/src/lib/shipping.ts" ]; then
                echo "     ✅ shipping.ts existe"
            else
                echo "     ❌ shipping.ts manquant"
                mkdir -p "$app_dir/src/lib"
                
                # Créer shipping.ts
                cat > "$app_dir/src/lib/shipping.ts" << 'EOF'
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

export class ShippingService {
  private carriers = [
    {
      id: 'colissimo',
      name: 'Colissimo',
      baseRate: 6.50,
      weightMultiplier: 2.0,
      maxWeight: 30,
      deliveryTime: '2-3 jours',
      reliability: 4,
      tracking: true,
    },
    {
      id: 'chronopost',
      name: 'Chronopost',
      baseRate: 12.50,
      weightMultiplier: 3.5,
      maxWeight: 30,
      deliveryTime: '24h',
      reliability: 5,
      tracking: true,
    },
    {
      id: 'dhl',
      name: 'DHL Express',
      baseRate: 18.00,
      weightMultiplier: 4.0,
      maxWeight: 30,
      deliveryTime: '24-48h',
      reliability: 5,
      tracking: true,
    },
  ];

  async calculateShipping(data: {
    departure: string;
    destination: string;
    weight: number;
    dimensions: string;
  }): Promise<ShippingCalculation> {
    // Simulation d'un appel API
    await this.delay(1000);

    const carriers: Carrier[] = this.carriers.map((carrier) => {
      const price = this.calculatePrice(carrier, data.weight, data.departure, data.destination);
      
      return {
        id: carrier.id,
        name: carrier.name,
        price,
        deliveryTime: carrier.deliveryTime,
        reliability: carrier.reliability,
        tracking: carrier.tracking,
      };
    });

    // Tri par prix croissant
    carriers.sort((a, b) => a.price - b.price);

    return {
      id: `calc_${Date.now()}`,
      departure: data.departure,
      destination: data.destination,
      weight: data.weight,
      dimensions: data.dimensions,
      carriers,
      createdAt: new Date(),
    };
  }

  private calculatePrice(
    carrier: any,
    weight: number,
    departure: string,
    destination: string
  ): number {
    let price = carrier.baseRate + (weight * carrier.weightMultiplier);
    
    // Majoration pour certaines destinations
    const internationalDestinations = ['londres', 'berlin', 'madrid', 'rome'];
    if (internationalDestinations.some(dest => 
      destination.toLowerCase().includes(dest)
    )) {
      price *= 1.8;
    }
    
    // Arrondi au centime
    return Math.round(price * 100) / 100;
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
EOF
                echo "     ✅ shipping.ts créé"
            fi
        fi
    fi
done

echo ""
echo "🎯 VÉRIFICATION TERMINÉE"
echo "========================"

# Vérifier si le tsconfig.json principal existe et est correct
if [ -f "tsconfig.json" ]; then
    echo "✅ tsconfig.json principal existe"
else
    echo "❌ tsconfig.json principal manquant - création..."
    
    # Créer le tsconfig.json principal optimisé
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    /* ===== CONFIGURATION DE BASE ===== */
    "target": "ES2022",
    "lib": [
      "ES2022",
      "DOM",
      "DOM.Iterable"
    ],
    "module": "ESNext",
    "moduleResolution": "bundler",
    
    /* ===== STRICT TYPE CHECKING ===== */
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
    
    /* ===== MODULES ===== */
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "verbatimModuleSyntax": false,
    
    /* ===== EMIT ===== */
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./",
    "removeComments": false,
    "downlevelIteration": true,
    "importHelpers": true,
    "noEmit": false,
    
    /* ===== JAVASCRIPT SUPPORT ===== */
    "allowJs": true,
    "checkJs": false,
    
    /* ===== EDITOR SUPPORT ===== */
    "incremental": true,
    "tsBuildInfoFile": "./dist/.tsbuildinfo",
    
    /* ===== INTEROP CONSTRAINTS ===== */
    "skipLibCheck": true,
    "skipDefaultLibCheck": true,
    
    /* ===== ADVANCED ===== */
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    
    /* ===== PATH MAPPING WORKSPACE ===== */
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
      
      /* ===== PATH MAPPING PAR APPLICATION ===== */
      "@ai4kids/*": ["apps/ai4kids/src/*"],
      "@multiai/*": ["apps/multiai/src/*"],
      "@budgetcron/*": ["apps/budgetcron/src/*"],
      "@unitflip/*": ["apps/unitflip/src/*"],
      "@postmath/*": ["apps/postmath/src/*"],
      
      /* ===== PACKAGES PARTAGÉS ===== */
      "@multiapps/shared": ["packages/shared/src/index"],
      "@multiapps/shared/*": ["packages/shared/src/*"],
      "@multiapps/ui": ["packages/ui/src/index"],
      "@multiapps/ui/*": ["packages/ui/src/*"]
    },
    
    /* ===== TYPE ACQUISITION ===== */
    "typeRoots": [
      "./node_modules/@types",
      "./types",
      "./@types",
      "./packages/*/types"
    ],
    "types": [
      "node",
      "jest",
      "@playwright/test",
      "@cucumber/cucumber"
    ]
  },
  
  /* ===== INCLUSION/EXCLUSION ===== */
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
    "allure-report",
    "allure-results",
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
  
  /* ===== TS-NODE CONFIGURATION ===== */
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
  
  /* ===== WATCHOPTIONS ===== */
  "watchOptions": {
    "watchFile": "useFsEvents",
    "watchDirectory": "useFsEvents",
    "fallbackPolling": "dynamicPriority",
    "synchronousWatchDirectory": true,
    "excludeDirectories": [
      "**/node_modules",
      "**/dist",
      "**/reports",
      "**/coverage",
      "**/test-results",
      "**/playwright-report"
    ]
  },
  
  /* ===== CONFIGURATION RÉFÉRENCES WORKSPACE ===== */
  "references": [
    { "path": "./packages/shared" },
    { "path": "./packages/ui" },
    { "path": "./apps/ai4kids" },
    { "path": "./apps/multiai" },
    { "path": "./apps/budgetcron" },
    { "path": "./apps/unitflip" },
    { "path": "./apps/postmath" }
  ]
}
EOF
    echo "✅ tsconfig.json principal créé"
fi

# Vérifier les packages
echo ""
echo "📦 Vérification des packages..."

if [ -d "packages" ]; then
    echo "✅ Dossier packages existe"
else
    echo "❌ Dossier packages manquant"
    echo "💡 Exécutez: ./packages-structure.sh"
fi

echo ""
echo "🚀 PROCHAINES ÉTAPES:"
echo "===================="
echo "1. 📦 Créer packages: ./packages-structure.sh"
echo "2. 🔨 Build packages: cd packages/shared && npm install && npm run build"
echo "3. 🔨 Build packages: cd packages/ui && npm install && npm run build"
echo "4. 🧪 Test build: npm run build:apps"
echo ""
echo "💡 Ou exécuter tout d'un coup:"
echo "   ./complete-setup.sh"