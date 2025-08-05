#!/bin/bash

# ===================================================================
# 🔍 MATH4CHILD - DIAGNOSTIC COMPLET
# Vérification et diagnostic de l'installation
# ===================================================================

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${PURPLE}${BOLD}🔍 MATH4CHILD - DIAGNOSTIC COMPLET${NC}"
echo "=============================================================="

# Variables
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MATH4CHILD_DIR="${PROJECT_ROOT}/apps/math4child"
SRC_DIR="${MATH4CHILD_DIR}/src"

echo -e "${BLUE}📍 Diagnostic de: ${MATH4CHILD_DIR}${NC}"
echo ""

# ===================================================================
# 📂 VÉRIFICATION DE LA STRUCTURE
# ===================================================================

echo -e "${YELLOW}${BOLD}📂 STRUCTURE DES RÉPERTOIRES${NC}"

directories=(
    "apps/math4child"
    "apps/math4child/src"
    "apps/math4child/src/app"
    "apps/math4child/src/components"
    "apps/math4child/src/components/language"
    "apps/math4child/src/components/navigation"
    "apps/math4child/src/components/pricing"
    "apps/math4child/src/lib"
    "apps/math4child/src/lib/translations"
    "apps/math4child/src/lib/math"
    "apps/math4child/src/hooks"
    "apps/math4child/src/data"
    "apps/math4child/src/data/languages"
    "apps/math4child/src/data/pricing"
)

missing_dirs=()
for dir in "${directories[@]}"; do
    if [ -d "${PROJECT_ROOT}/$dir" ]; then
        echo -e "${GREEN}✅ $dir${NC}"
    else
        echo -e "${RED}❌ $dir${NC}"
        missing_dirs+=("$dir")
    fi
done

if [ ${#missing_dirs[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ Tous les répertoires requis sont présents${NC}"
else
    echo -e "${RED}❌ Répertoires manquants: ${#missing_dirs[@]}${NC}"
fi

echo ""

# ===================================================================
# 📄 VÉRIFICATION DES FICHIERS
# ===================================================================

echo -e "${YELLOW}${BOLD}📄 FICHIERS SOURCES${NC}"

required_files=(
    "apps/math4child/package.json"
    "apps/math4child/next.config.js"
    "apps/math4child/tailwind.config.js"
    "apps/math4child/postcss.config.js"
    "apps/math4child/tsconfig.json"
    "apps/math4child/next-env.d.ts"
    "apps/math4child/.eslintrc.json"
    "apps/math4child/.gitignore"
    "apps/math4child/src/app/page.tsx"
    "apps/math4child/src/app/layout.tsx"
    "apps/math4child/src/app/globals.css"
    "apps/math4child/src/hooks/useLanguage.ts"
    "apps/math4child/src/components/language/LanguageProvider.tsx"
    "apps/math4child/src/components/language/LanguageSelector.tsx"
    "apps/math4child/src/components/navigation/Navigation.tsx"
    "apps/math4child/src/components/pricing/PricingModal.tsx"
    "apps/math4child/src/data/languages/worldLanguages.ts"
    "apps/math4child/src/lib/translations/worldTranslations.ts"
    "apps/math4child/src/data/pricing/countryPricing.ts"
    "apps/math4child/src/lib/math/questionGenerator.ts"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ -f "${PROJECT_ROOT}/$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ $file${NC}"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ Tous les fichiers requis sont présents${NC}"
else
    echo -e "${RED}❌ Fichiers manquants: ${#missing_files[@]}${NC}"
fi

echo ""

# ===================================================================
# 📦 VÉRIFICATION DES DÉPENDANCES
# ===================================================================

echo -e "${YELLOW}${BOLD}📦 DÉPENDANCES NODE.JS${NC}"

if [ -f "${MATH4CHILD_DIR}/package.json" ]; then
    echo -e "${GREEN}✅ package.json trouvé${NC}"
    
    if [ -d "${MATH4CHILD_DIR}/node_modules" ]; then
        echo -e "${GREEN}✅ node_modules présent${NC}"
        
        # Vérifier les dépendances clés
        key_deps=("next" "react" "react-dom" "tailwindcss" "lucide-react" "typescript")
        for dep in "${key_deps[@]}"; do
            if [ -d "${MATH4CHILD_DIR}/node_modules/$dep" ]; then
                echo -e "${GREEN}✅ $dep installé${NC}"
            else
                echo -e "${RED}❌ $dep manquant${NC}"
            fi
        done
        
    else
        echo -e "${RED}❌ node_modules manquant - Exécuter: npm install${NC}"
    fi
else
    echo -e "${RED}❌ package.json manquant${NC}"
fi

echo ""

# ===================================================================
# 🔧 VÉRIFICATION DES CONFIGURATIONS
# ===================================================================

echo -e "${YELLOW}${BOLD}🔧 CONFIGURATIONS${NC}"

# Vérifier le contenu des fichiers de configuration
if [ -f "${MATH4CHILD_DIR}/package.json" ]; then
    if grep -q "math4child" "${MATH4CHILD_DIR}/package.json"; then
        echo -e "${GREEN}✅ package.json contient le nom correct${NC}"
    else
        echo -e "${RED}❌ package.json nom incorrect${NC}"
    fi
    
    if grep -q "\"next\":" "${MATH4CHILD_DIR}/package.json"; then
        echo -e "${GREEN}✅ Next.js configuré dans package.json${NC}"
    else
        echo -e "${RED}❌ Next.js manquant dans package.json${NC}"
    fi
fi

if [ -f "${MATH4CHILD_DIR}/tailwind.config.js" ]; then
    if grep -q "content:" "${MATH4CHILD_DIR}/tailwind.config.js"; then
        echo -e "${GREEN}✅ Tailwind config valide${NC}"
    else
        echo -e "${RED}❌ Tailwind config invalide${NC}"
    fi
fi

if [ -f "${MATH4CHILD_DIR}/tsconfig.json" ]; then
    if grep -q "@/\\*" "${MATH4CHILD_DIR}/tsconfig.json"; then
        echo -e "${GREEN}✅ TypeScript chemins absolus configurés${NC}"
    else
        echo -e "${RED}❌ TypeScript chemins absolus manquants${NC}"
    fi
fi

echo ""

# ===================================================================
# 🧪 TEST DE COMPILATION
# ===================================================================

echo -e "${YELLOW}${BOLD}🧪 TEST DE COMPILATION${NC}"

if [ -d "${MATH4CHILD_DIR}/node_modules" ] && [ -f "${MATH4CHILD_DIR}/package.json" ]; then
    cd "${MATH4CHILD_DIR}"
    
    echo -e "${BLUE}🔄 Test de compilation TypeScript...${NC}"
    if npx tsc --noEmit --skipLibCheck 2>/dev/null; then
        echo -e "${GREEN}✅ Compilation TypeScript réussie${NC}"
    else
        echo -e "${YELLOW}⚠️ Warnings TypeScript (vérifiez les erreurs)${NC}"
    fi
    
    echo -e "${BLUE}🔄 Test de build Next.js...${NC}"
    if timeout 30s npm run build >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Build Next.js réussi${NC}"
    else
        echo -e "${YELLOW}⚠️ Build Next.js échoué ou trop long${NC}"
    fi
    
else
    echo -e "${RED}❌ Impossible de tester - dépendances manquantes${NC}"
fi

echo ""

# ===================================================================
# 📊 RÉSUMÉ DU DIAGNOSTIC
# ===================================================================

echo -e "${PURPLE}${BOLD}📊 RÉSUMÉ DU DIAGNOSTIC${NC}"
echo "=============================================================="

total_dirs=${#directories[@]}
total_files=${#required_files[@]}
missing_dirs_count=${#missing_dirs[@]}
missing_files_count=${#missing_files[@]}

structure_score=$((100 * (total_dirs - missing_dirs_count) / total_dirs))
files_score=$((100 * (total_files - missing_files_count) / total_files))
overall_score=$(((structure_score + files_score) / 2))

echo -e "${BLUE}📂 Structure: ${structure_score}% (${missing_dirs_count} manquants)${NC}"
echo -e "${BLUE}📄 Fichiers: ${files_score}% (${missing_files_count} manquants)${NC}"

if [ $overall_score -ge 90 ]; then
    echo -e "${GREEN}🎉 Score global: ${overall_score}% - Excellent !${NC}"
    echo -e "${GREEN}✅ Application prête à être lancée${NC}"
elif [ $overall_score -ge 70 ]; then
    echo -e "${YELLOW}⚠️ Score global: ${overall_score}% - Quelques problèmes mineurs${NC}"
    echo -e "${YELLOW}🔧 Corrections mineures nécessaires${NC}"
else
    echo -e "${RED}❌ Score global: ${overall_score}% - Problèmes majeurs${NC}"
    echo -e "${RED}🔧 Reconstruction recommandée${NC}"
fi

echo ""

# ===================================================================
# 💡 RECOMMANDATIONS
# ===================================================================

echo -e "${YELLOW}${BOLD}💡 RECOMMANDATIONS${NC}"

if [ ${#missing_dirs[@]} -gt 0 ]; then
    echo -e "${BLUE}1. Recréer les répertoires manquants:${NC}"
    for dir in "${missing_dirs[@]}"; do
        echo "   mkdir -p ${PROJECT_ROOT}/$dir"
    done
    echo ""
fi

if [ ${#missing_files[@]} -gt 0 ]; then
    echo -e "${BLUE}2. Recréer les fichiers manquants avec le script:${NC}"
    echo "   ./continue_math4child_setup.sh"
    echo ""
fi

if [ ! -d "${MATH4CHILD_DIR}/node_modules" ]; then
    echo -e "${BLUE}3. Installer les dépendances:${NC}"
    echo "   cd apps/math4child && npm install"
    echo ""
fi

echo -e "${BLUE}4. Pour relancer l'application:${NC}"
echo "   cd apps/math4child"
echo "   npm run dev"
echo ""

echo -e "${CYAN}🌍 www.math4child.com | Développé par GOTEST${NC}"
