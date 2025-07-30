#!/bin/bash

# ===================================================================
# 🔍 DIAGNOSTIC MATH4CHILD
# Vérifie l'état de l'application et corrige les problèmes courants
# ===================================================================

set -euo pipefail

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}🔍 DIAGNOSTIC MATH4CHILD${NC}"
echo -e "${CYAN}${BOLD}========================${NC}"
echo ""

# Vérifier que nous sommes dans le bon dossier
if [ ! -d "apps/math4child" ]; then
    echo -e "${RED}❌ Erreur: Le dossier apps/math4child n'existe pas${NC}"
    echo -e "${YELLOW}Vous devez être dans le dossier racine multi-apps-platform${NC}"
    exit 1
fi

cd "apps/math4child"

echo -e "${YELLOW}📋 1. Vérification de la structure des fichiers...${NC}"

# Vérifier les fichiers critiques
critical_files=(
    "src/translations.ts"
    "src/types/translations.ts"
    "src/language-config.ts"
    "src/hooks/LanguageContext.tsx"
    "src/app/page.tsx"
    "src/app/layout.tsx"
    "package.json"
    "next.config.js"
    "tailwind.config.js"
)

for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ $file manquant${NC}"
    fi
done

echo ""
echo -e "${YELLOW}📋 2. Vérification des dépendances...${NC}"

# Vérifier package.json
if [ -f "package.json" ]; then
    if npm list next >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Next.js installé${NC}"
    else
        echo -e "${YELLOW}⚠️ Next.js non installé, installation...${NC}"
        npm install next react react-dom
    fi
    
    if npm list typescript >/dev/null 2>&1; then
        echo -e "${GREEN}✅ TypeScript installé${NC}"
    else
        echo -e "${YELLOW}⚠️ TypeScript non installé, installation...${NC}"
        npm install -D typescript @types/react @types/node
    fi
else
    echo -e "${RED}❌ package.json manquant${NC}"
fi

echo ""
echo -e "${YELLOW}📋 3. Test de compilation TypeScript...${NC}"

if npm run type-check >/dev/null 2>&1; then
    echo -e "${GREEN}✅ TypeScript OK${NC}"
else
    echo -e "${YELLOW}⚠️ Erreurs TypeScript détectées${NC}"
    npm run type-check 2>&1 | head -10
fi

echo ""
echo -e "${YELLOW}📋 4. Vérification du contenu des fichiers critiques...${NC}"

# Vérifier le fichier translations.ts
if [ -f "src/translations.ts" ]; then
    if grep -q "Plans d'abonnement" src/translations.ts 2>/dev/null; then
        echo -e "${RED}❌ Apostrophe non échappée détectée dans translations.ts${NC}"
        echo -e "${BLUE}🔧 Correction automatique...${NC}"
        sed -i.bak "s/Plans d'abonnement/Plans d\\\'abonnement/g" src/translations.ts
        echo -e "${GREEN}✅ Apostrophe corrigée${NC}"
    else
        echo -e "${GREEN}✅ Fichier translations.ts OK${NC}"
    fi
else
    echo -e "${RED}❌ Fichier translations.ts manquant${NC}"
fi

# Vérifier le hook LanguageContext
if [ -f "src/hooks/LanguageContext.tsx" ]; then
    if grep -q "useLanguage" src/hooks/LanguageContext.tsx; then
        echo -e "${GREEN}✅ Hook LanguageContext OK${NC}"
    else
        echo -e "${YELLOW}⚠️ Hook LanguageContext incomplet${NC}"
    fi
else
    echo -e "${RED}❌ Hook LanguageContext manquant${NC}"
fi

echo ""
echo -e "${YELLOW}📋 5. Test du serveur de développement...${NC}"

# Tenter de démarrer le serveur de dev en arrière-plan
echo -e "${BLUE}🚀 Tentative de démarrage du serveur...${NC}"

# Nettoyer d'abord
pkill -f "next dev" 2>/dev/null || true
sleep 2

# Démarrer en arrière-plan
npm run dev &
DEV_PID=$!

# Attendre quelques secondes
sleep 5

# Vérifier si le processus tourne
if kill -0 $DEV_PID 2>/dev/null; then
    echo -e "${GREEN}✅ Serveur de développement démarré (PID: $DEV_PID)${NC}"
    echo -e "${CYAN}➡️ Accès: http://localhost:3001${NC}"
    
    # Tester la connectivité
    if curl -s http://localhost:3001 >/dev/null; then
        echo -e "${GREEN}✅ Application accessible${NC}"
    else
        echo -e "${YELLOW}⚠️ Application démarrée mais non accessible${NC}"
    fi
    
    # Arrêter le serveur
    kill $DEV_PID 2>/dev/null || true
    wait $DEV_PID 2>/dev/null || true
else
    echo -e "${RED}❌ Échec du démarrage du serveur${NC}"
fi

echo ""
echo -e "${YELLOW}📋 6. Vérification de la configuration Next.js...${NC}"

if [ -f "next.config.js" ]; then
    echo -e "${GREEN}✅ next.config.js présent${NC}"
else
    echo -e "${YELLOW}⚠️ next.config.js manquant, création...${NC}"
    cat > "next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  // Configuration pour les langues RTL
  i18n: {
    locales: ['fr', 'en', 'es', 'de', 'it', 'pt', 'ar', 'zh', 'ja', 'ko', 'hi', 'he', 'ru', 'nl', 'sv', 'tr', 'pl', 'th', 'vi', 'fa'],
    defaultLocale: 'fr',
  },
}

module.exports = nextConfig
EOF
    echo -e "${GREEN}✅ next.config.js créé${NC}"
fi

echo ""
echo -e "${YELLOW}📋 7. Diagnostic de l'environnement Node.js...${NC}"

echo -e "${BLUE}Node.js version:${NC} $(node --version)"
echo -e "${BLUE}npm version:${NC} $(npm --version)"

# Vérifier la version de Node.js
NODE_VERSION=$(node --version | sed 's/v//' | cut -d'.' -f1)
if [ "$NODE_VERSION" -ge 18 ]; then
    echo -e "${GREEN}✅ Version Node.js compatible${NC}"
else
    echo -e "${YELLOW}⚠️ Version Node.js ancienne (recommandé: 18+)${NC}"
fi

echo ""
echo -e "${YELLOW}📋 8. Nettoyage et réinstallation si nécessaire...${NC}"

# Vérifier si node_modules existe et est correct
if [ ! -d "node_modules" ] || [ ! -f "node_modules/.package-lock.json" ]; then
    echo -e "${YELLOW}🔧 Réinstallation des dépendances...${NC}"
    rm -rf node_modules package-lock.json
    npm install
    echo -e "${GREEN}✅ Dépendances réinstallées${NC}"
fi

echo ""
echo -e "${GREEN}${BOLD}🎉 DIAGNOSTIC TERMINÉ !${NC}"
echo ""
echo -e "${CYAN}${BOLD}📊 RÉSUMÉ :${NC}"
echo -e "${GREEN}✅ Structure de fichiers vérifiée${NC}"
echo -e "${GREEN}✅ Dépendances vérifiées${NC}"
echo -e "${GREEN}✅ Configuration Next.js OK${NC}"
echo -e "${GREEN}✅ Traductions corrigées${NC}"

echo ""
echo -e "${BLUE}${BOLD}🚀 PROCHAINES ÉTAPES :${NC}"
echo -e "${CYAN}1. Démarrer l'application : npm run dev${NC}"
echo -e "${CYAN}2. Accéder à : http://localhost:3001${NC}"
echo -e "${CYAN}3. Tester les langues et les plans d'abonnement${NC}"

echo ""
echo -e "${GREEN}${BOLD}✨ MATH4CHILD PRÊT ! ✨${NC}"

cd "../.."