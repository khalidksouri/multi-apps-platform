#!/bin/bash

# =============================================
# 🔍 Script de diagnostic des erreurs de build
# =============================================

echo "🔍 Diagnostic complet des erreurs de build..."
echo ""

# Fonction pour vérifier un fichier
check_file() {
    local file_path="$1"
    local description="$2"
    
    if [ -f "$file_path" ]; then
        echo "✅ $description: EXISTE"
        echo "📄 Premières lignes:"
        head -3 "$file_path" | sed 's/^/    /'
        echo ""
    else
        echo "❌ $description: MANQUANT"
        echo ""
    fi
}

# Fonction pour vérifier le contenu CSS
check_css_content() {
    local css_file="$1"
    local app_name="$2"
    
    echo "🎨 Vérification CSS pour $app_name:"
    if [ -f "$css_file" ]; then
        if grep -q "^//" "$css_file"; then
            echo "❌ Commentaires JavaScript détectés dans le CSS"
            echo "🔍 Lignes problématiques:"
            grep -n "^//" "$css_file" | head -5
        else
            echo "✅ CSS propre (pas de commentaires JS)"
        fi
        
        if grep -q "@tailwind" "$css_file"; then
            echo "✅ Directives Tailwind présentes"
        else
            echo "❌ Directives Tailwind manquantes"
        fi
    else
        echo "❌ Fichier CSS manquant"
    fi
    echo ""
}

# Fonction pour vérifier les tsconfig
check_tsconfig() {
    local tsconfig_file="$1"
    local app_name="$2"
    
    echo "⚙️  Vérification tsconfig.json pour $app_name:"
    if [ -f "$tsconfig_file" ]; then
        if grep -q "@cucumber/cucumber" "$tsconfig_file"; then
            echo "❌ Référence @cucumber/cucumber trouvée"
            grep -n "@cucumber/cucumber" "$tsconfig_file"
        else
            echo "✅ Pas de référence @cucumber/cucumber"
        fi
        
        if grep -q '"types".*:' "$tsconfig_file"; then
            echo "🔍 Section types trouvée:"
            grep -A 3 -B 1 '"types".*:' "$tsconfig_file" | sed 's/^/    /'
        else
            echo "✅ Pas de section types problématique"
        fi
    else
        echo "❌ tsconfig.json manquant"
    fi
    echo ""
}

# Fonction pour tester la compilation d'une app
test_app_build() {
    local app_name="$1"
    local workspace="$2"
    
    echo "🧪 Test de build pour $app_name..."
    cd "apps/$app_name" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "📁 Répertoire apps/$app_name existe"
        
        # Test de compilation TypeScript simple
        if npx tsc --noEmit --skipLibCheck 2>/dev/null; then
            echo "✅ TypeScript: OK"
        else
            echo "❌ TypeScript: ERREURS"
            echo "🔍 Erreurs TypeScript:"
            npx tsc --noEmit --skipLibCheck 2>&1 | head -10 | sed 's/^/    /'
        fi
        
        cd - > /dev/null
    else
        echo "❌ Répertoire apps/$app_name manquant"
    fi
    echo ""
}

# Diagnostic global
echo "🏗️  DIAGNOSTIC GLOBAL DU PROJET"
echo "================================"
echo ""

# Vérifier la structure du projet
echo "📁 STRUCTURE DU PROJET:"
echo "✅ Répertoire racine: $(pwd)"
echo "📦 Applications disponibles:"
for app_dir in apps/*/; do
    if [ -d "$app_dir" ]; then
        app_name=$(basename "$app_dir")
        echo "  - $app_name"
    fi
done
echo ""

# Vérifier les packages
echo "📦 PACKAGES:"
check_file "packages/shared/package.json" "Package shared"
check_file "packages/ui/package.json" "Package UI"
check_file "packages/shared/dist/index.js" "Package shared (build)"
check_file "packages/ui/dist/index.js" "Package UI (build)"

# Diagnostic détaillé par application
echo "🔍 DIAGNOSTIC DÉTAILLÉ PAR APPLICATION"
echo "====================================="
echo ""

# AI4Kids
echo "🤖 AI4KIDS:"
check_file "apps/ai4kids/package.json" "Package.json"
check_file "apps/ai4kids/next-env.d.ts" "next-env.d.ts"
check_file "apps/ai4kids/src/app/page.tsx" "Page principale"
check_css_content "apps/ai4kids/src/app/globals.css" "AI4Kids"
check_tsconfig "apps/ai4kids/tsconfig.json" "AI4Kids"

# MultiAI
echo "🧠 MULTIAI:"
check_file "apps/multiai/package.json" "Package.json"
check_file "apps/multiai/next-env.d.ts" "next-env.d.ts"
check_file "apps/multiai/src/app/page.tsx" "Page principale"
check_css_content "apps/multiai/src/app/globals.css" "MultiAI"
check_tsconfig "apps/multiai/tsconfig.json" "MultiAI"

# BudgetCron
echo "💰 BUDGETCRON:"
check_file "apps/budgetcron/package.json" "Package.json"
check_file "apps/budgetcron/next-env.d.ts" "next-env.d.ts"
check_file "apps/budgetcron/src/app/page.tsx" "Page principale"
check_css_content "apps/budgetcron/src/app/globals.css" "BudgetCron"
check_tsconfig "apps/budgetcron/tsconfig.json" "BudgetCron"

# UnitFlip
echo "🔄 UNITFLIP:"
check_file "apps/unitflip/package.json" "Package.json"
check_file "apps/unitflip/next-env.d.ts" "next-env.d.ts"
check_file "apps/unitflip/src/app/page.tsx" "Page principale"
check_css_content "apps/unitflip/src/app/globals.css" "UnitFlip"
check_tsconfig "apps/unitflip/tsconfig.json" "UnitFlip"

# PostMath
echo "📦 POSTMATH:"
check_file "apps/postmath/package.json" "Package.json"
check_file "apps/postmath/next-env.d.ts" "next-env.d.ts"
check_file "apps/postmath/src/app/page.tsx" "Page principale"
check_file "apps/postmath/src/components/forms/ShippingCalculator.tsx" "Composant Shipping"
check_css_content "apps/postmath/src/app/globals.css" "PostMath"
check_tsconfig "apps/postmath/tsconfig.json" "PostMath"

# Vérification des dépendances
echo "📚 VÉRIFICATION DES DÉPENDANCES:"
echo "==============================="
echo ""

for app in "ai4kids" "multiai" "budgetcron" "unitflip" "postmath"; do
    if [ -d "apps/$app" ]; then
        echo "📦 Dépendances pour $app:"
        cd "apps/$app"
        
        if [ -f "package.json" ]; then
            echo "  🔍 Dependencies:"
            jq -r '.dependencies | keys[]' package.json 2>/dev/null | sed 's/^/    - /' || echo "    ❌ Erreur lecture package.json"
            
            echo "  🔍 DevDependencies:"
            jq -r '.devDependencies | keys[]' package.json 2>/dev/null | sed 's/^/    - /' || echo "    ❌ Erreur lecture package.json"
        fi
        
        cd - > /dev/null
        echo ""
    fi
done

# Tests de compilation individuels
echo "🧪 TESTS DE COMPILATION INDIVIDUELS:"
echo "===================================="
echo ""

for app in "ai4kids" "multiai" "budgetcron" "unitflip" "postmath"; do
    test_app_build "$app" "${app}-app"
done

# Vérifications système
echo "🖥️  VÉRIFICATIONS SYSTÈME:"
echo "=========================="
echo ""

echo "🔧 Versions des outils:"
echo "  Node.js: $(node --version 2>/dev/null || echo 'Non installé')"
echo "  npm: $(npm --version 2>/dev/null || echo 'Non installé')"
echo "  TypeScript: $(npx tsc --version 2>/dev/null || echo 'Non installé')"
echo ""

echo "💾 Espace disque:"
df -h . | tail -1 | awk '{print "  Disponible: " $4 " (" $5 " utilisé)"}'
echo ""

echo "🗂️  Taille des node_modules:"
if [ -d "node_modules" ]; then
    du -sh node_modules 2>/dev/null | awk '{print "  Racine: " $1}'
fi

for app in "ai4kids" "multiai" "budgetcron" "unitflip" "postmath"; do
    if [ -d "apps/$app/node_modules" ]; then
        size=$(du -sh "apps/$app/node_modules" 2>/dev/null | awk '{print $1}')
        echo "  $app: $size"
    fi
done
echo ""

# Recommandations
echo "💡 RECOMMANDATIONS:"
echo "=================="
echo ""

# Vérifier si des corrections sont nécessaires
css_issues=0
ts_issues=0

for app in "ai4kids" "multiai" "budgetcron" "unitflip" "postmath"; do
    if [ -f "apps/$app/src/app/globals.css" ] && grep -q "^//" "apps/$app/src/app/globals.css"; then
        css_issues=$((css_issues + 1))
    fi
    
    if [ -f "apps/$app/tsconfig.json" ] && grep -q "@cucumber/cucumber" "apps/$app/tsconfig.json"; then
        ts_issues=$((ts_issues + 1))
    fi
done

if [ $css_issues -gt 0 ]; then
    echo "🎨 $css_issues fichier(s) CSS contiennent des commentaires JavaScript"
    echo "   Exécutez: ./ultimate_fix_script.sh"
fi

if [ $ts_issues -gt 0 ]; then
    echo "⚙️  $ts_issues fichier(s) tsconfig.json contiennent des références @cucumber/cucumber"
    echo "   Exécutez: ./ultimate_fix_script.sh"
fi

if [ $css_issues -eq 0 ] && [ $ts_issues -eq 0 ]; then
    echo "✅ Aucun problème évident détecté dans les fichiers de configuration"
    echo "   Essayez un build individuel pour identifier l'app problématique:"
    echo "   npm run build --workspace=budgetcron-app"
fi

echo ""
echo "🔍 Diagnostic terminé!"
echo "====================="