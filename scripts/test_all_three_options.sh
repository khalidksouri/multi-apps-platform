#!/bin/bash
set -e

echo "🧪 TEST AUTOMATIQUE DES 3 OPTIONS MATH4CHILD"
echo "   📋 Option A: App temporaire (/tmp/math4child-temp)"
echo "   📋 Option B: App standalone (~/math4child-standalone)"
echo "   📋 Option C: App dans monorepo (apps/math4child)"
echo ""

ROOT_DIR=$(pwd)
TEMP_DIR="/tmp/math4child-temp"
STANDALONE_DIR="$HOME/math4child-standalone"
MONOREPO_DIR="$ROOT_DIR/apps/math4child"

# Couleurs pour les résultats
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour tester une app
test_app() {
    local app_path=$1
    local app_name=$2
    local timeout_duration=$3
    
    echo ""
    echo "🧪 Test de $app_name..."
    echo "📁 Chemin: $app_path"
    
    if [ ! -d "$app_path" ]; then
        echo -e "${RED}❌ Dossier inexistant${NC}"
        return 1
    fi
    
    cd "$app_path"
    
    # Vérifier les fichiers essentiels
    if [ ! -f "package.json" ]; then
        echo -e "${RED}❌ package.json manquant${NC}"
        return 1
    fi
    
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}⚠️ node_modules manquant - tentative d'installation${NC}"
        npm install --legacy-peer-deps > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Installation npm échouée${NC}"
            return 1
        fi
    fi
    
    # Test de build
    echo "🔨 Test de build..."
    npm run build > build.log 2>&1
    local build_result=$?
    
    if [ $build_result -eq 0 ]; then
        echo -e "${GREEN}✅ Build réussi${NC}"
    else
        echo -e "${RED}❌ Build échoué${NC}"
        echo "📋 Dernières lignes du log:"
        tail -5 build.log
    fi
    
    # Test du serveur de développement
    echo "🚀 Test du serveur de développement ($timeout_duration secondes)..."
    timeout ${timeout_duration}s npm run dev > dev.log 2>&1 &
    local dev_pid=$!
    
    sleep 3
    
    if ps -p $dev_pid > /dev/null; then
        echo -e "${GREEN}✅ Serveur de développement démarré${NC}"
        
        # Test de connectivité HTTP
        sleep 2
        if curl -s http://localhost:3000 > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Application accessible sur http://localhost:3000${NC}"
            local http_test=0
        else
            echo -e "${YELLOW}⚠️ Application pas encore accessible${NC}"
            local http_test=1
        fi
        
        # Arrêter le serveur
        kill $dev_pid 2>/dev/null || true
        wait $dev_pid 2>/dev/null || true
        
        return $((build_result + http_test))
    else
        echo -e "${RED}❌ Serveur de développement échoué${NC}"
        echo "📋 Dernières lignes du log:"
        tail -5 dev.log
        return 1
    fi
}

# Fonction pour créer l'option B si nécessaire
create_option_b() {
    echo ""
    echo "📦 Création de l'Option B (Standalone)..."
    
    if [ ! -d "$TEMP_DIR" ]; then
        echo -e "${RED}❌ App temporaire introuvable${NC}"
        return 1
    fi
    
    # Supprimer l'ancienne version si elle existe
    rm -rf "$STANDALONE_DIR"
    
    # Créer le dossier standalone
    mkdir -p "$STANDALONE_DIR"
    
    # Copier tout le contenu
    cp -r "$TEMP_DIR"/* "$STANDALONE_DIR/"
    
    # Modifier le package.json pour avoir un nom unique
    cd "$STANDALONE_DIR"
    sed 's/"math4child-temp"/"math4child-standalone"/' package.json > package.json.tmp
    mv package.json.tmp package.json
    
    echo -e "${GREEN}✅ Option B créée dans $STANDALONE_DIR${NC}"
    return 0
}

# Fonction pour préparer l'option C
prepare_option_c() {
    echo ""
    echo "🔧 Préparation de l'Option C (Monorepo)..."
    
    if [ ! -d "$TEMP_DIR" ]; then
        echo -e "${RED}❌ App temporaire introuvable${NC}"
        return 1
    fi
    
    # Nettoyer l'app monorepo
    rm -rf "$MONOREPO_DIR/node_modules" "$MONOREPO_DIR/package-lock.json" "$MONOREPO_DIR/.next"
    
    # Copier les fichiers source
    cp -r "$TEMP_DIR/src" "$MONOREPO_DIR/" 2>/dev/null || true
    cp "$TEMP_DIR/next.config.js" "$MONOREPO_DIR/" 2>/dev/null || true
    cp "$TEMP_DIR/tsconfig.json" "$MONOREPO_DIR/" 2>/dev/null || true
    
    # Créer un package.json adapté au monorepo
    cd "$MONOREPO_DIR"
    cat > package.json << 'EOF'
{
  "name": "math4child",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start -p 3000"
  },
  "dependencies": {
    "next": "14.2.30",
    "react": "18.3.1",
    "react-dom": "18.3.1"
  },
  "devDependencies": {
    "@types/node": "20.14.8",
    "@types/react": "18.3.3",
    "@types/react-dom": "18.3.0",
    "typescript": "5.4.5"
  }
}
EOF
    
    echo -e "${GREEN}✅ Option C préparée${NC}"
    return 0
}

# Variables pour stocker les résultats
option_a_result=999
option_b_result=999
option_c_result=999

echo "🚀 DÉBUT DES TESTS..."
echo "===================="

# TEST OPTION A
echo -e "${BLUE}📋 TEST OPTION A - App Temporaire${NC}"
if test_app "$TEMP_DIR" "Option A (Temporaire)" 8; then
    option_a_result=0
    echo -e "${GREEN}🎉 Option A: SUCCÈS COMPLET${NC}"
else
    option_a_result=1
    echo -e "${RED}💥 Option A: ÉCHEC${NC}"
fi

# TEST OPTION B
echo -e "${BLUE}📋 TEST OPTION B - App Standalone${NC}"
if create_option_b; then
    if test_app "$STANDALONE_DIR" "Option B (Standalone)" 8; then
        option_b_result=0
        echo -e "${GREEN}🎉 Option B: SUCCÈS COMPLET${NC}"
    else
        option_b_result=1
        echo -e "${RED}💥 Option B: ÉCHEC${NC}"
    fi
else
    option_b_result=2
    echo -e "${RED}💥 Option B: CRÉATION ÉCHOUÉE${NC}"
fi

# TEST OPTION C
echo -e "${BLUE}📋 TEST OPTION C - App Monorepo${NC}"
if prepare_option_c; then
    if test_app "$MONOREPO_DIR" "Option C (Monorepo)" 10; then
        option_c_result=0
        echo -e "${GREEN}🎉 Option C: SUCCÈS COMPLET${NC}"
    else
        option_c_result=1
        echo -e "${RED}💥 Option C: ÉCHEC${NC}"
    fi
else
    option_c_result=2
    echo -e "${RED}💥 Option C: PRÉPARATION ÉCHOUÉE${NC}"
fi

# RÉSULTATS FINAUX
echo ""
echo "🏆 RÉSULTATS FINAUX"
echo "==================="
echo ""

# Fonction pour afficher le statut
show_status() {
    local result=$1
    local option=$2
    local path=$3
    
    case $result in
        0)
            echo -e "${GREEN}✅ $option: PARFAITEMENT FONCTIONNEL${NC}"
            echo -e "   📁 Chemin: $path"
            echo -e "   🚀 Commandes:"
            echo -e "      cd $path"
            echo -e "      npm run dev    # http://localhost:3000"
            echo -e "      npm run build  # Build production"
            ;;
        1)
            echo -e "${YELLOW}⚠️ $option: PARTIELLEMENT FONCTIONNEL${NC}"
            echo -e "   📁 Chemin: $path"
            echo -e "   💡 Peut fonctionner en mode dev uniquement"
            ;;
        2)
            echo -e "${RED}❌ $option: NON FONCTIONNEL${NC}"
            echo -e "   📁 Création/préparation échouée"
            ;;
        *)
            echo -e "${RED}❌ $option: NON TESTÉ${NC}"
            ;;
    esac
    echo ""
}

show_status $option_a_result "Option A (Temporaire)" "$TEMP_DIR"
show_status $option_b_result "Option B (Standalone)" "$STANDALONE_DIR"
show_status $option_c_result "Option C (Monorepo)" "$MONOREPO_DIR"

# RECOMMANDATIONS
echo "🎯 RECOMMANDATIONS"
echo "=================="
echo ""

# Trouver la meilleure option
best_option=""
best_path=""

if [ $option_a_result -eq 0 ]; then
    best_option="A (Temporaire)"
    best_path="$TEMP_DIR"
elif [ $option_b_result -eq 0 ]; then
    best_option="B (Standalone)"
    best_path="$STANDALONE_DIR"
elif [ $option_c_result -eq 0 ]; then
    best_option="C (Monorepo)"
    best_path="$MONOREPO_DIR"
fi

if [ -n "$best_option" ]; then
    echo -e "${GREEN}🏆 OPTION RECOMMANDÉE: $best_option${NC}"
    echo -e "📁 Chemin: $best_path"
    echo ""
    echo -e "${BLUE}🚀 COMMANDES POUR DÉMARRER:${NC}"
    echo "   cd $best_path"
    echo "   npm run dev"
    echo "   Ouvrir http://localhost:3000"
    echo ""
else
    echo -e "${RED}⚠️ AUCUNE OPTION COMPLÈTEMENT FONCTIONNELLE${NC}"
    echo ""
    echo "💡 Solutions alternatives:"
    
    if [ $option_a_result -le 1 ]; then
        echo "   - Essayer Option A en mode dev uniquement"
    fi
    if [ $option_b_result -le 1 ]; then
        echo "   - Essayer Option B en mode dev uniquement"
    fi
    if [ $option_c_result -le 1 ]; then
        echo "   - Essayer Option C en mode dev uniquement"
    fi
fi

echo ""
echo "📊 STATISTIQUES"
echo "==============="
echo "Options testées: 3"
echo "Succès complets: $((3 - (option_a_result > 0) - (option_b_result > 0) - (option_c_result > 0)))"
echo "Échecs: $(((option_a_result > 0) + (option_b_result > 0) + (option_c_result > 0)))"

echo ""
echo "🎮 DÉVELOPPEMENT MATH4CHILD"
echo "==========================="
echo "Une fois l'app choisie, vous pouvez ajouter:"
echo "   🧮 Exercices mathématiques adaptatifs"
echo "   🎯 Système de niveaux et progression"
echo "   🏆 Badges et récompenses"
echo "   📊 Tableau de bord parents"
echo "   🎨 Interface ludique et colorée"
echo "   🔊 Sons et animations"
echo "   💾 Sauvegarde cloud des progrès"

cd "$ROOT_DIR"
echo ""
echo "✅ TESTS TERMINÉS - Choisissez votre option préférée !"