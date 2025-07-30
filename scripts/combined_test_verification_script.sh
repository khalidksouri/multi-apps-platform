#!/bin/bash

# combined_test_verification.sh - Test rapide et vérification complète de Math4Child

echo "🔍 TEST COMPLET ET VÉRIFICATION MATH4CHILD"
echo "   ⚡ Test rapide de démarrage serveur"
echo "   🎯 Vérification complète des fonctionnalités"
echo "   📊 Rapport de santé détaillé"
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "==========================================="
echo "    TEST COMPLET MATH4CHILD               "
echo "==========================================="

cd apps/math4child

# Variables de suivi
server_test_passed=false
build_success=false
all_files_exist=false

# PARTIE 1: TEST RAPIDE DE DÉMARRAGE
echo -e "${BLUE}⚡ PARTIE 1/2: TEST RAPIDE DE DÉMARRAGE${NC}"
echo ""

echo -e "${YELLOW}📡 Test de démarrage du serveur...${NC}"

# Lancer le serveur en arrière-plan et capturer les logs
timeout 10s npm run dev > server_test.log 2>&1 &
SERVER_PID=$!

sleep 5

# Vérifier si le serveur tourne
if kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "${GREEN}✅ Serveur démarré avec succès${NC}"
    server_test_passed=true
    
    # Vérifier les logs pour des erreurs critiques
    if grep -q "Error\|error\|❌" server_test.log; then
        echo -e "${YELLOW}⚠️  Warnings détectés dans les logs${NC}"
        echo -e "${BLUE}📄 Aperçu des logs :${NC}"
        tail -5 server_test.log
    else
        echo -e "${GREEN}✅ Aucune erreur critique détectée${NC}"
    fi
    
    # Tuer le serveur de test
    kill $SERVER_PID 2>/dev/null
    
else
    echo -e "${RED}❌ Échec du démarrage du serveur${NC}"
    echo -e "${BLUE}📄 Logs d'erreur :${NC}"
    cat server_test.log
    server_test_passed=false
fi

# Nettoyage
rm -f server_test.log

echo ""
echo -e "${BLUE}📋 RÉSULTAT DU TEST RAPIDE :${NC}"

# Vérifier les fichiers essentiels rapidement
essential_files=("src/app/page.tsx" "src/app/layout.tsx" "tailwind.config.js")
quick_check_passed=true

for file in "${essential_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file OK${NC}"
    else
        echo -e "${RED}❌ $file manquant${NC}"
        quick_check_passed=false
    fi
done

echo ""
echo "==========================================="
echo "    VÉRIFICATION DÉTAILLÉE                "
echo "==========================================="

# PARTIE 2: VÉRIFICATION COMPLÈTE
echo -e "${BLUE}🔍 PARTIE 2/2: VÉRIFICATION DÉTAILLÉE${NC}"
echo ""

# Vérification 1: Structure complète des fichiers
echo -e "${BLUE}📁 VÉRIFICATION 1/6: Structure complète des fichiers${NC}"

files_to_check=(
    "src/app/layout.tsx"
    "src/app/page.tsx"
    "src/app/exercises/page.tsx"
    "src/app/exercises/styles.css"
    "src/app/games/page.tsx"
    "tailwind.config.js"
    "public/manifest.json"
    "package.json"
    "next.config.js"
    "src/app/globals.css"
)

all_files_exist=true
missing_files=()

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file existe${NC}"
    else
        echo -e "${RED}❌ $file manquant${NC}"
        all_files_exist=false
        missing_files+=("$file")
    fi
done

if [ "$all_files_exist" = true ]; then
    echo -e "${GREEN}✅ Tous les fichiers essentiels sont présents${NC}"
else
    echo -e "${YELLOW}⚠️  ${#missing_files[@]} fichier(s) manquant(s)${NC}"
fi

# Vérification 2: Dépendances
echo -e "${BLUE}📦 VÉRIFICATION 2/6: Dépendances installées${NC}"

dependencies_ok=true

# Vérifier lucide-react
if npm list lucide-react >/dev/null 2>&1; then
    echo -e "${GREEN}✅ lucide-react installé${NC}"
else
    echo -e "${YELLOW}⚠️  lucide-react manquant - Installation automatique...${NC}"
    npm install lucide-react --silent
    if npm list lucide-react >/dev/null 2>&1; then
        echo -e "${GREEN}✅ lucide-react installé avec succès${NC}"
    else
        echo -e "${RED}❌ Échec installation lucide-react${NC}"
        dependencies_ok=false
    fi
fi

# Vérifier next
if npm list next >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Next.js installé${NC}"
else
    echo -e "${RED}❌ Next.js manquant${NC}"
    dependencies_ok=false
fi

# Vérifier tailwindcss
if npm list tailwindcss >/dev/null 2>&1; then
    echo -e "${GREEN}✅ TailwindCSS installé${NC}"
else
    echo -e "${RED}❌ TailwindCSS manquant${NC}"
    dependencies_ok=false
fi

# Vérification 3: Configuration TailwindCSS
echo -e "${BLUE}🎨 VÉRIFICATION 3/6: Configuration TailwindCSS${NC}"

tailwind_config_ok=false
if [ -f "tailwind.config.js" ]; then
    if grep -q "content:" tailwind.config.js; then
        echo -e "${GREEN}✅ TailwindCSS content configuré${NC}"
        tailwind_config_ok=true
    else
        echo -e "${RED}❌ TailwindCSS content manquant${NC}"
    fi
else
    echo -e "${RED}❌ tailwind.config.js manquant${NC}"
fi

# Vérification 4: Layout Next.js
echo -e "${BLUE}📄 VÉRIFICATION 4/6: Layout Next.js${NC}"

layout_ok=false
if [ -f "src/app/layout.tsx" ]; then
    layout_ok=true
    if grep -q "viewport:" src/app/layout.tsx; then
        echo -e "${GREEN}✅ Viewport séparé configuré${NC}"
    elif grep -q "viewport" src/app/layout.tsx; then
        echo -e "${YELLOW}⚠️  Viewport détecté mais pourrait être dans metadata${NC}"
    else
        echo -e "${YELLOW}⚠️  Viewport non trouvé${NC}"
    fi
    
    if grep -q "Inter\|font" src/app/layout.tsx; then
        echo -e "${GREEN}✅ Font configuré${NC}"
    else
        echo -e "${YELLOW}⚠️  Font pourrait ne pas être configuré${NC}"
    fi
    
    if grep -q "globals.css" src/app/layout.tsx; then
        echo -e "${GREEN}✅ CSS global importé${NC}"
    else
        echo -e "${YELLOW}⚠️  CSS global pourrait ne pas être importé${NC}"
    fi
else
    echo -e "${RED}❌ layout.tsx manquant${NC}"
fi

# Vérification 5: Build test
echo -e "${BLUE}🔨 VÉRIFICATION 5/6: Test de build${NC}"

echo -e "${YELLOW}📦 Test de build en cours...${NC}"

# Créer globals.css si manquant avant le build
if [ ! -f "src/app/globals.css" ]; then
    echo -e "${YELLOW}📝 Création de globals.css manquant...${NC}"
    cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Styles personnalisés Math4Child */
* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
}

body {
  color: #000;
  background: linear-gradient(to bottom, transparent, #f1f5f9) #fff;
}

a {
  color: inherit;
  text-decoration: none;
}

/* Animations personnalisées */
@keyframes fadeIn {
  0% { opacity: 0; }
  100% { opacity: 1; }
}

@keyframes slideUp {
  0% { transform: translateY(10px); opacity: 0; }
  100% { transform: translateY(0); opacity: 1; }
}

/* Utilitaires */
.animate-fade-in {
  animation: fadeIn 0.5s ease-in-out;
}

.animate-slide-up {
  animation: slideUp 0.3s ease-out;
}
EOF
    echo -e "${GREEN}✅ globals.css créé${NC}"
fi

# Nettoyer le cache avant le build
rm -rf .next 2>/dev/null

# Tester le build
if npm run build >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Build réussi - aucune erreur${NC}"
    build_success=true
else
    echo -e "${RED}❌ Erreurs de build détectées${NC}"
    echo -e "${YELLOW}📄 Tentative de diagnostic...${NC}"
    
    # Faire un build avec logs pour diagnostiquer
    npm run build 2>&1 | tail -10
    
    build_success=false
fi

# Vérification 6: Rapport final et recommandations
echo -e "${BLUE}📊 VÉRIFICATION 6/6: Rapport final${NC}"

echo ""
echo "==========================================="
echo "    RAPPORT FINAL COMPLET                 "
echo "==========================================="
echo ""

# Calcul du score de santé
score=0
max_score=6

if [ "$server_test_passed" = true ]; then ((score++)); fi
if [ "$all_files_exist" = true ]; then ((score++)); fi
if [ "$dependencies_ok" = true ]; then ((score++)); fi
if [ "$tailwind_config_ok" = true ]; then ((score++)); fi
if [ "$layout_ok" = true ]; then ((score++)); fi
if [ "$build_success" = true ]; then ((score++)); fi

health_percentage=$((score * 100 / max_score))

if [ $health_percentage -ge 85 ]; then
    echo -e "${GREEN}🎉 MATH4CHILD EST EXCELLENT ! (${health_percentage}%)${NC}"
    status="EXCELLENT"
elif [ $health_percentage -ge 70 ]; then
    echo -e "${YELLOW}✅ MATH4CHILD FONCTIONNE BIEN (${health_percentage}%)${NC}"
    status="GOOD"
elif [ $health_percentage -ge 50 ]; then
    echo -e "${YELLOW}⚠️  MATH4CHILD NÉCESSITE QUELQUES AJUSTEMENTS (${health_percentage}%)${NC}"
    status="PARTIAL"
else
    echo -e "${RED}❌ MATH4CHILD NÉCESSITE UNE CORRECTION MAJEURE (${health_percentage}%)${NC}"
    status="CRITICAL"
fi

echo ""
echo -e "${CYAN}📊 TABLEAU DE BORD DE SANTÉ :${NC}"
echo ""

# Affichage détaillé des résultats
echo -e "${BLUE}🧪 TESTS :${NC}"
if [ "$server_test_passed" = true ]; then
    echo -e "   ${GREEN}✅ Démarrage serveur${NC}"
else
    echo -e "   ${RED}❌ Démarrage serveur${NC}"
fi

echo -e "${BLUE}📁 STRUCTURE :${NC}"
if [ "$all_files_exist" = true ]; then
    echo -e "   ${GREEN}✅ Tous les fichiers présents${NC}"
else
    echo -e "   ${YELLOW}⚠️  ${#missing_files[@]} fichier(s) manquant(s)${NC}"
    for file in "${missing_files[@]}"; do
        echo -e "      ${RED}• $file${NC}"
    done
fi

echo -e "${BLUE}📦 DÉPENDANCES :${NC}"
if [ "$dependencies_ok" = true ]; then
    echo -e "   ${GREEN}✅ Toutes les dépendances installées${NC}"
else
    echo -e "   ${RED}❌ Certaines dépendances manquent${NC}"
fi

echo -e "${BLUE}🎨 CONFIGURATION :${NC}"
if [ "$tailwind_config_ok" = true ]; then
    echo -e "   ${GREEN}✅ TailwindCSS configuré${NC}"
else
    echo -e "   ${RED}❌ TailwindCSS mal configuré${NC}"
fi

echo -e "${BLUE}📄 LAYOUT :${NC}"
if [ "$layout_ok" = true ]; then
    echo -e "   ${GREEN}✅ Layout Next.js OK${NC}"
else
    echo -e "   ${RED}❌ Layout Next.js problématique${NC}"
fi

echo -e "${BLUE}🔨 BUILD :${NC}"
if [ "$build_success" = true ]; then
    echo -e "   ${GREEN}✅ Build réussi${NC}"
else
    echo -e "   ${RED}❌ Build échoué${NC}"
fi

echo ""
echo -e "${BLUE}🚀 ACTIONS RECOMMANDÉES :${NC}"
echo ""

if [ "$status" = "EXCELLENT" ] || [ "$status" = "GOOD" ]; then
    echo -e "${GREEN}🎯 PRÊT À UTILISER :${NC}"
    echo "   1. cd apps/math4child"
    echo "   2. npm run dev"
    echo "   3. Ouvrir http://localhost:3000"
    echo ""
    echo -e "${BLUE}📱 PAGES À TESTER :${NC}"
    echo "   • http://localhost:3000 (Accueil)"
    echo "   • http://localhost:3000/exercises (Exercices)"
    echo "   • http://localhost:3000/games (Jeux)"
    
elif [ "$status" = "PARTIAL" ]; then
    echo -e "${YELLOW}🔧 CORRECTIONS RECOMMANDÉES :${NC}"
    if [ "$server_test_passed" = false ]; then
        echo "   • Relancer: ./emergency_fix.sh"
    fi
    if [ "$all_files_exist" = false ]; then
        echo "   • Relancer: ./fix_math4child_complete.sh"
    fi
    if [ "$build_success" = false ]; then
        echo "   • Vérifier les erreurs de syntaxe"
        echo "   • Nettoyer le cache: rm -rf .next"
    fi
    
else
    echo -e "${RED}🚨 CORRECTION MAJEURE NÉCESSAIRE :${NC}"
    echo "   1. Lancer: ./emergency_fix.sh"
    echo "   2. Puis: ./fix_math4child_complete.sh"
    echo "   3. Retester avec ce script"
fi

echo ""
echo -e "${PURPLE}📞 SUPPORT :${NC}"
echo "   • Logs serveur: npm run dev"
echo "   • Console navigateur: F12"
echo "   • Build logs: npm run build"

echo ""
if [ "$status" = "EXCELLENT" ]; then
    echo -e "${GREEN}🎊 MATH4CHILD PARFAITEMENT FONCTIONNEL ! 🎊${NC}"
elif [ "$status" = "GOOD" ]; then
    echo -e "${GREEN}🎉 MATH4CHILD PRÊT POUR UTILISATION ! 🎉${NC}"
else
    echo -e "${YELLOW}🔧 MATH4CHILD NÉCESSITE QUELQUES AJUSTEMENTS${NC}"
fi

echo ""
echo -e "${GREEN}✅ TEST COMPLET TERMINÉ !${NC}"

cd ../..