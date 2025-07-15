#!/bin/bash

# =============================================
# 🔧 Script de correction des applications
# =============================================

echo "🔧 Correction des erreurs de build des applications..."

# Applications ayant des erreurs
APPS=("budgetcron" "unitflip" "postmath")

for app in "${APPS[@]}"; do
    echo "📱 Correction de l'application: $app"
    
    APP_PATH="apps/$app"
    
    # Créer le dossier lib s'il n'existe pas
    mkdir -p "$APP_PATH/src/lib"
    
    # Créer le fichier shipping.ts manquant
    cat > "$APP_PATH/src/lib/shipping.ts" << 'EOF'
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

    # Corriger le tsconfig.json de l'application
    cat > "$APP_PATH/tsconfig.json" << 'EOF'
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

    echo "✅ Application $app corrigée"
done

# Corriger aussi ai4kids et multiai (même structure)
echo "📱 Correction des applications AI4Kids et MultiAI..."

for app in "ai4kids" "multiai"; do
    APP_PATH="apps/$app"
    
    # Corriger le tsconfig.json
    cat > "$APP_PATH/tsconfig.json" << 'EOF'
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

    echo "✅ Application $app corrigée"
done

echo ""
echo "🎯 CORRECTIONS TERMINÉES"
echo "========================"
echo ""
echo "✅ Fichiers créés/corrigés:"
echo "   - apps/budgetcron/src/lib/shipping.ts"
echo "   - apps/unitflip/src/lib/shipping.ts"
echo "   - apps/postmath/src/lib/shipping.ts"
echo "   - tsconfig.json corrigé pour chaque app"
echo ""
echo "🔄 Prochaines étapes:"
echo "   1. Créer la structure packages: ./packages-structure.sh"
echo "   2. Build packages: cd packages/shared && npm run build"
echo "   3. Build packages: cd packages/ui && npm run build"
echo "   4. Test build apps: npm run build:apps"
echo ""
echo "💡 Commandes rapides:"
echo "   chmod +x fix-apps.sh && ./fix-apps.sh"
echo "   chmod +x packages-structure.sh && ./packages-structure.sh"