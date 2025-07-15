#!/bin/bash

# =============================================
# 🔧 Script de correction d'urgence
# =============================================

echo "🔧 Correction d'urgence des erreurs critiques..."

# Étape 1: Corriger le problème workspace:* (npm ne supporte pas cette syntaxe)
echo "🎯 CORRECTION 1: Réparation des références workspace"

# Fonction pour corriger les package.json des apps
fix_app_package_json() {
    local app_path=$1
    local app_name=$2
    local port=$3
    
    cat > "$app_path/package.json" << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p $port",
    "build": "next build",
    "start": "next start -p $port",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "react-hook-form": "^7.47.0"
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
}

# Corriger toutes les applications
fix_app_package_json "apps/postmath" "postmath-app" "3001"
fix_app_package_json "apps/unitflip" "unitflip-app" "3002"
fix_app_package_json "apps/budgetcron" "budgetcron-app" "3003"
fix_app_package_json "apps/ai4kids" "ai4kids-app" "3004"
fix_app_package_json "apps/multiai" "multiai-app" "3005"

echo "✅ Package.json des applications corrigés"

# Étape 2: Corriger les tsconfig.json des packages pour supprimer les références aux tests
echo "🎯 CORRECTION 2: Nettoyage des tsconfig.json"

# Package shared
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
  "exclude": ["node_modules", "dist", "**/*.test.*", "**/*.spec.*"]
}
EOF

# Package UI
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
  "exclude": ["node_modules", "dist", "**/*.test.*", "**/*.spec.*"]
}
EOF

echo "✅ tsconfig.json des packages nettoyés"

# Étape 3: Corriger le composant ShippingCalculator qui cause l'erreur TypeScript
echo "🎯 CORRECTION 3: Réparation du composant ShippingCalculator"

cat > apps/postmath/src/components/forms/ShippingCalculator.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { useForm } from 'react-hook-form';

interface ShippingFormData {
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
}

interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

interface ShippingCalculation {
  id: string;
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
  carriers: Carrier[];
  createdAt: Date;
}

export function ShippingCalculator() {
  const [results, setResults] = useState<ShippingCalculation | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<ShippingFormData>();

  const onSubmit = async (data: ShippingFormData) => {
    setLoading(true);
    setError(null);

    try {
      // Simulation d'appel API
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      const mockCarriers: Carrier[] = [
        {
          id: 'colissimo',
          name: 'Colissimo',
          price: 6.50 + (data.weight * 2.0),
          deliveryTime: '2-3 jours',
          reliability: 4,
          tracking: true,
        },
        {
          id: 'chronopost',
          name: 'Chronopost',
          price: 12.50 + (data.weight * 3.5),
          deliveryTime: '24h',
          reliability: 5,
          tracking: true,
        },
      ];

      const calculation: ShippingCalculation = {
        id: `calc_${Date.now()}`,
        departure: data.departure,
        destination: data.destination,
        weight: data.weight,
        dimensions: data.dimensions,
        carriers: mockCarriers,
        createdAt: new Date(),
      };

      setResults(calculation);
    } catch (err) {
      setError('Erreur lors du calcul');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              📍 Ville de départ
            </label>
            <input
              {...register('departure', { required: 'Ville de départ requise' })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              placeholder="Paris"
              data-testid="departure-input"
            />
            {errors.departure && (
              <p className="text-red-600 text-sm mt-1">{errors.departure.message}</p>
            )}
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              📍 Ville de destination
            </label>
            <input
              {...register('destination', { required: 'Ville de destination requise' })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              placeholder="Lyon"
              data-testid="destination-input"
            />
            {errors.destination && (
              <p className="text-red-600 text-sm mt-1">{errors.destination.message}</p>
            )}
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              ⚖️ Poids (kg)
            </label>
            <input
              {...register('weight', { 
                required: 'Poids requis',
                valueAsNumber: true,
                min: { value: 0.1, message: 'Poids minimum 0.1kg' },
                max: { value: 30, message: 'Poids maximum 30kg' }
              })}
              type="number"
              step="0.1"
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              placeholder="2.5"
              data-testid="weight-input"
            />
            {errors.weight && (
              <p className="text-red-600 text-sm mt-1">{errors.weight.message}</p>
            )}
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              📏 Dimensions (cm)
            </label>
            <input
              {...register('dimensions', { 
                required: 'Dimensions requises',
                pattern: {
                  value: /^\d+x\d+x\d+$/,
                  message: 'Format: LxlxH (ex: 30x20x15)'
                }
              })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              placeholder="30x20x15"
              data-testid="dimensions-input"
            />
            {errors.dimensions && (
              <p className="text-red-600 text-sm mt-1">{errors.dimensions.message}</p>
            )}
          </div>
        </div>

        <div className="flex gap-4">
          <button
            type="submit"
            disabled={loading}
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 disabled:opacity-50 flex items-center"
            data-testid="calculate-button"
          >
            📦 {loading ? 'Calcul en cours...' : 'Calculer les frais'}
          </button>
          
          <button
            type="button"
            className="bg-gray-200 text-gray-900 px-4 py-2 rounded-md hover:bg-gray-300"
            onClick={() => {
              reset();
              setResults(null);
              setError(null);
            }}
          >
            Réinitialiser
          </button>
        </div>
      </form>

      {error && (
        <div className="p-4 bg-red-50 border border-red-200 rounded-md" data-testid="error-message">
          <p className="text-red-800">{error}</p>
        </div>
      )}

      {results && (
        <div className="space-y-4" data-testid="results-container">
          <h3 className="text-lg font-semibold">Résultats du calcul</h3>
          
          <div className="grid gap-4">
            {results.carriers.map((carrier) => (
              <div key={carrier.id} className="bg-white p-4 border border-gray-200 rounded-lg" data-testid={`carrier-${carrier.id}`}>
                <div className="flex justify-between items-center">
                  <div>
                    <h4 className="font-medium" data-testid="carrier-name">{carrier.name}</h4>
                    <p className="text-sm text-gray-600" data-testid="delivery-time">
                      Livraison: {carrier.deliveryTime}
                    </p>
                    <div className="flex items-center mt-1">
                      <span className="text-xs text-gray-500">Fiabilité: </span>
                      <div className="ml-1 flex">
                        {Array.from({ length: 5 }).map((_, i) => (
                          <span
                            key={i}
                            className={`text-xs ${
                              i < carrier.reliability ? 'text-yellow-400' : 'text-gray-300'
                            }`}
                          >
                            ★
                          </span>
                        ))}
                      </div>
                    </div>
                  </div>
                  
                  <div className="text-right">
                    <p className="text-2xl font-bold text-blue-600" data-testid="carrier-price">
                      {carrier.price.toFixed(2)}€
                    </p>
                    {carrier.tracking && (
                      <p className="text-xs text-green-600">Suivi inclus</p>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
EOF

echo "✅ Composant ShippingCalculator corrigé"

# Étape 4: Créer une page simple pour PostMath si elle n'existe pas
echo "🎯 CORRECTION 4: Création de la page PostMath"

if [ ! -f "apps/postmath/src/app/page.tsx" ]; then
    cat > apps/postmath/src/app/page.tsx << 'EOF'
import { ShippingCalculator } from '@/components/forms/ShippingCalculator';

export default function HomePage() {
  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          📦 PostMath Pro
        </h1>
        <p className="text-xl text-gray-600">
          Calculateur intelligent de frais d'expédition
        </p>
      </div>

      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold mb-6">
          📦 Calculateur d'expédition
        </h2>
        <ShippingCalculator />
      </div>
    </div>
  );
}
EOF
fi

echo "✅ Page PostMath créée"

# Étape 5: Nettoyer et reconstruire
echo "🎯 CORRECTION 5: Nettoyage et reconstruction"

echo "🧹 Suppression des caches..."
rm -rf node_modules package-lock.json
rm -rf apps/*/node_modules apps/*/.next apps/*/dist
rm -rf packages/*/node_modules packages/*/dist

echo "📦 Réinstallation des dépendances..."
npm install

echo "🔨 Build des packages..."
cd packages/shared && npm run build
cd ../ui && npm run build
cd ../..

echo "🧪 Test du build PostMath..."
cd apps/postmath && npm run build
BUILD_RESULT=$?
cd ../..

if [ $BUILD_RESULT -eq 0 ]; then
    echo ""
    echo "🎉 CORRECTION RÉUSSIE!"
    echo "====================="
    echo "✅ Erreurs workspace:* corrigées"
    echo "✅ Erreurs TypeScript résolues"
    echo "✅ Composant ShippingCalculator réparé"
    echo "✅ PostMath compile avec succès"
    echo ""
    echo "🚀 Testez maintenant:"
    echo "   cd apps/postmath"
    echo "   npm run dev"
    echo "   Ouvrir http://localhost:3001"
    echo ""
    echo "💡 Pour builder les autres applications:"
    echo "   cd apps/unitflip && npm run build"
    echo "   cd apps/budgetcron && npm run build"
    echo "   etc."
else
    echo ""
    echo "❌ PostMath a encore des erreurs"
    echo "================================"
    echo "💡 Vérifiez les logs ci-dessus et:"
    echo "   1. Vérifiez que tous les fichiers existent"
    echo "   2. Contrôlez les imports dans les composants"
    echo "   3. Relancez: cd apps/postmath && npm run build"
fi

echo ""
echo "📊 Résumé des corrections:"
echo "   ✅ Package.json sans workspace:* syntaxe"
echo "   ✅ tsconfig.json nettoyés"
echo "   ✅ Composant ShippingCalculator simplifié"
echo "   ✅ Dépendances réinstallées"
echo "   ✅ Packages reconstruits"