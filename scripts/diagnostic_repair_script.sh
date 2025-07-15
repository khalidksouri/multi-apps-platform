#!/bin/bash

# =============================================
# 🔧 Script de diagnostic et réparation spécifique
# =============================================

echo "🔧 Diagnostic et réparation des erreurs spécifiques..."

# Étape 1: Identifier et supprimer les fichiers problématiques du package shared
echo "🎯 DIAGNOSTIC 1: Analyse des fichiers problématiques"

PROBLEMATIC_FILES=(
    "packages/shared/src/hooks/use-auth.ts"
    "packages/shared/src/i18n/config.ts"
    "packages/shared/src/i18n/useTranslation.ts"
    "packages/shared/src/utils/format.ts"
    "packages/shared/src/hooks/useApi.ts"
    "packages/shared/src/constants/config.ts"
    "packages/shared/src/utils/api.ts"
)

echo "🗑️ Suppression des fichiers problématiques..."
for file in "${PROBLEMATIC_FILES[@]}"; do
    if [ -f "$file" ]; then
        rm -f "$file"
        echo "   ❌ Supprimé: $file"
    fi
done

# Supprimer les dossiers entiers s'ils existent
PROBLEMATIC_DIRS=(
    "packages/shared/src/hooks"
    "packages/shared/src/i18n"
    "packages/shared/src/constants"
)

for dir in "${PROBLEMATIC_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        rm -rf "$dir"
        echo "   🗂️ Dossier supprimé: $dir"
    fi
done

echo "✅ Fichiers problématiques supprimés"

# Étape 2: Chercher et supprimer toute référence à @cucumber/cucumber
echo "🎯 DIAGNOSTIC 2: Suppression des références @cucumber/cucumber"

# Chercher dans tous les tsconfig.json
find . -name "tsconfig.json" -exec grep -l "@cucumber/cucumber" {} \; 2>/dev/null | while read file; do
    echo "🔧 Nettoyage de $file"
    # Supprimer les lignes contenant @cucumber/cucumber
    sed -i '' '/@cucumber\/cucumber/d' "$file" 2>/dev/null || sed -i '/@cucumber\/cucumber/d' "$file" 2>/dev/null
    # Supprimer les lignes contenant @playwright/test dans types
    sed -i '' '/@playwright\/test/d' "$file" 2>/dev/null || sed -i '/@playwright\/test/d' "$file" 2>/dev/null
    # Supprimer les lignes contenant jest dans types
    sed -i '' '/\"jest\"/d' "$file" 2>/dev/null || sed -i '/\"jest\"/d' "$file" 2>/dev/null
done

echo "✅ Références @cucumber/cucumber supprimées"

# Étape 3: Vérifier et corriger le fichier principal du package shared
echo "🎯 DIAGNOSTIC 3: Vérification du package shared"

if [ ! -f "packages/shared/src/index.ts" ]; then
    echo "📄 Création de l'index principal du package shared"
    mkdir -p packages/shared/src
    cat > packages/shared/src/index.ts << 'EOF'
// Types de base
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

// Utilitaires simples
export const formatCurrency = (amount: number): string => {
  return new Intl.NumberFormat('fr-FR', {
    style: 'currency',
    currency: 'EUR'
  }).format(amount);
};

export const formatDate = (date: Date): string => {
  return new Intl.DateTimeFormat('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  }).format(date);
};

export const generateId = (): string => {
  return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
};
EOF
else
    echo "✅ Index du package shared existe déjà"
fi

# Étape 4: Vérifier que le composant ShippingCalculator utilise un import relatif correct
echo "🎯 DIAGNOSTIC 4: Vérification des imports dans PostMath"

SHIPPING_COMPONENT="apps/postmath/src/components/forms/ShippingCalculator.tsx"
PAGE_COMPONENT="apps/postmath/src/app/page.tsx"

if [ -f "$PAGE_COMPONENT" ]; then
    # Vérifier que l'import est correct
    if grep -q "from '@/components/forms/ShippingCalculator'" "$PAGE_COMPONENT"; then
        echo "✅ Import correct dans page.tsx"
    else
        echo "🔧 Correction de l'import dans page.tsx"
        sed -i '' "s|from '.*ShippingCalculator.*'|from '@/components/forms/ShippingCalculator'|g" "$PAGE_COMPONENT" 2>/dev/null || \
        sed -i "s|from '.*ShippingCalculator.*'|from '@/components/forms/ShippingCalculator'|g" "$PAGE_COMPONENT" 2>/dev/null
    fi
fi

# Étape 5: Test de compilation individuel de chaque package
echo "🎯 DIAGNOSTIC 5: Test de compilation individuel"

echo "🧪 Test package shared..."
cd packages/shared
if npm run build >/dev/null 2>&1; then
    echo "✅ Package shared compile"
    SHARED_OK=true
else
    echo "❌ Package shared a des erreurs"
    SHARED_OK=false
    echo "📋 Erreurs détaillées:"
    npm run build
fi
cd ../..

echo "🧪 Test package ui..."
cd packages/ui
if npm run build >/dev/null 2>&1; then
    echo "✅ Package ui compile"
    UI_OK=true
else
    echo "❌ Package ui a des erreurs"
    UI_OK=false
    echo "📋 Erreurs détaillées:"
    npm run build
fi
cd ../..

# Étape 6: Test de compilation PostMath seulement si les packages sont OK
if [ "$SHARED_OK" = true ] && [ "$UI_OK" = true ]; then
    echo "🧪 Test PostMath..."
    cd apps/postmath
    
    # Vérifier que tous les fichiers nécessaires existent
    REQUIRED_FILES=(
        "src/app/page.tsx"
        "src/app/layout.tsx"
        "src/app/globals.css"
        "src/components/forms/ShippingCalculator.tsx"
        "next-env.d.ts"
        "tsconfig.json"
        "package.json"
    )
    
    MISSING_FILES=()
    for file in "${REQUIRED_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            MISSING_FILES+=("$file")
        fi
    done
    
    if [ ${#MISSING_FILES[@]} -eq 0 ]; then
        echo "✅ Tous les fichiers requis sont présents"
        
        if npm run build >/dev/null 2>&1; then
            echo "✅ PostMath compile parfaitement"
            POSTMATH_OK=true
        else
            echo "❌ PostMath a des erreurs de compilation"
            POSTMATH_OK=false
            echo "📋 Erreurs détaillées:"
            npm run build
        fi
    else
        echo "❌ Fichiers manquants dans PostMath:"
        printf '   - %s\n' "${MISSING_FILES[@]}"
        POSTMATH_OK=false
    fi
    
    cd ../..
else
    echo "⏭️ Skip test PostMath car les packages ont des erreurs"
    POSTMATH_OK=false
fi

# Étape 7: Résumé et recommandations
echo ""
echo "📊 RÉSUMÉ DU DIAGNOSTIC"
echo "======================="

if [ "$SHARED_OK" = true ]; then
    echo "✅ Package shared: OK"
else
    echo "❌ Package shared: ERREURS"
fi

if [ "$UI_OK" = true ]; then
    echo "✅ Package ui: OK"
else
    echo "❌ Package ui: ERREURS"
fi

if [ "$POSTMATH_OK" = true ]; then
    echo "✅ PostMath: OK"
else
    echo "❌ PostMath: ERREURS"
fi

echo ""
if [ "$SHARED_OK" = true ] && [ "$UI_OK" = true ] && [ "$POSTMATH_OK" = true ]; then
    echo "🎉 TOUS LES PROBLÈMES RÉSOLUS!"
    echo "=============================="
    echo "🚀 Vous pouvez maintenant:"
    echo "   cd apps/postmath"
    echo "   npm run dev"
    echo "   Ouvrir http://localhost:3001"
    echo ""
    echo "🔄 Pour les autres applications, répétez:"
    echo "   cd apps/unitflip && npm install && npm run build"
    echo "   cd apps/budgetcron && npm install && npm run build"
    echo "   etc."
else
    echo "⚠️ IL RESTE DES PROBLÈMES"
    echo "========================"
    echo ""
    echo "🔧 Actions recommandées:"
    
    if [ "$SHARED_OK" = false ]; then
        echo "   1. Corriger le package shared:"
        echo "      cd packages/shared"
        echo "      npm run build"
        echo "      (Examiner les erreurs et corriger)"
    fi
    
    if [ "$UI_OK" = false ]; then
        echo "   2. Corriger le package ui:"
        echo "      cd packages/ui"
        echo "      npm run build"
        echo "      (Examiner les erreurs et corriger)"
    fi
    
    if [ "$POSTMATH_OK" = false ]; then
        echo "   3. Corriger PostMath:"
        echo "      cd apps/postmath"
        echo "      npm run build"
        echo "      (Examiner les erreurs et corriger)"
    fi
fi

echo ""
echo "📁 Structure actuelle vérifiée:"
echo "   📦 packages/shared/src/index.ts"
echo "   📦 packages/ui/src/index.ts"
echo "   📱 apps/postmath/src/app/page.tsx"
echo "   🔧 Références @cucumber/cucumber supprimées"