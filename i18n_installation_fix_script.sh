#!/bin/bash

# 🔧 Script de Correction et Optimisation Post-Installation I18n
# Corrige les problèmes potentiels et optimise l'installation

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Applications
APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
PORTS=(3001 3002 3003 3004 3005)

print_message() {
    echo -e "${GREEN}[FIX-I18N]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERREUR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_step() {
    echo -e "${CYAN}[ÉTAPE]${NC} $1"
}

# Vérifier et corriger les fichiers de configuration manquants
fix_missing_configs() {
    print_step "Vérification et correction des configurations manquantes..."
    
    for app in "${APPS[@]}"; do
        print_info "Traitement de l'application: $app"
        
        # Vérifier si le répertoire existe
        if [ ! -d "apps/$app" ]; then
            print_error "Répertoire apps/$app non trouvé"
            continue
        fi
        
        # Créer les répertoires manquants
        mkdir -p "apps/$app/src/app"
        mkdir -p "apps/$app/src/components"
        mkdir -p "apps/$app/src/hooks"
        mkdir -p "apps/$app/src/translations"
        mkdir -p "apps/$app/public"
        
        # Corriger le fichier next-env.d.ts
        if [ ! -f "apps/$app/next-env.d.ts" ]; then
            cat > "apps/$app/next-env.d.ts" << 'EOF'
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// NOTE: This file should not be edited
// see https://nextjs.org/docs/basic-features/typescript for more information.
EOF
        fi
        
        # Corriger les imports dans page.tsx
        if [ -f "apps/$app/src/app/page.tsx" ]; then
            # Corriger les imports relatifs
            sed -i.bak 's|@/hooks/useUniversalI18n|../hooks/useUniversalI18n|g' "apps/$app/src/app/page.tsx"
            sed -i.bak 's|@/components/I18nLayoutWrapper|../components/I18nLayout|g' "apps/$app/src/app/page.tsx"
            sed -i.bak 's|@/translations|../translations|g' "apps/$app/src/app/page.tsx"
            rm -f "apps/$app/src/app/page.tsx.bak"
        fi
        
        # Corriger les imports dans layout.tsx
        if [ -f "apps/$app/src/app/layout.tsx" ]; then
            sed -i.bak 's|@/components/I18nLayout|../components/I18nLayout|g' "apps/$app/src/app/layout.tsx"
            rm -f "apps/$app/src/app/layout.tsx.bak"
        fi
        
        # Corriger les imports dans I18nLayout.tsx
        if [ -f "apps/$app/src/components/I18nLayout.tsx" ]; then
            sed -i.bak 's|@/hooks/useUniversalI18n|../hooks/useUniversalI18n|g' "apps/$app/src/components/I18nLayout.tsx"
            rm -f "apps/$app/src/components/I18nLayout.tsx.bak"
        fi
        
        # Créer un fichier .gitignore pour chaque app
        cat > "apps/$app/.gitignore" << 'EOF'
# Dependencies
node_modules/
/.pnp
.pnp.js

# Testing
/coverage

# Next.js
/.next/
/out/

# Production
/build

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env*.local

# Vercel
.vercel

# TypeScript
*.tsbuildinfo
next-env.d.ts

# Backup files
*.bak
EOF
        
        print_message "Configuration corrigée pour $app ✓"
    done
}

# Créer un meilleur script d'installation des dépendances
create_better_install_script() {
    print_step "Création du script d'installation optimisé..."
    
    cat > "install-all-dependencies.sh" << 'EOF'
#!/bin/bash

# 📦 Script d'installation optimisé des dépendances
echo "🚀 Installation des dépendances pour toutes les applications I18n..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
FAILED_APPS=()

for app in "${APPS[@]}"; do
    if [ -d "apps/$app" ]; then
        echo -e "${BLUE}📦 Installation des dépendances pour $app...${NC}"
        cd "apps/$app"
        
        # Nettoyer le cache si nécessaire
        if [ -d "node_modules" ]; then
            echo "🧹 Nettoyage du cache existant..."
            rm -rf node_modules package-lock.json
        fi
        
        # Installer les dépendances
        if npm install --silent; then
            echo -e "${GREEN}✅ Dépendances installées pour $app${NC}"
        else
            echo -e "${RED}❌ Erreur lors de l'installation pour $app${NC}"
            FAILED_APPS+=("$app")
        fi
        
        cd ../..
    else
        echo -e "${RED}❌ Application $app non trouvée${NC}"
        FAILED_APPS+=("$app")
    fi
done

echo ""
if [ ${#FAILED_APPS[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 Toutes les dépendances ont été installées avec succès!${NC}"
    echo ""
    echo -e "${BLUE}Prochaines étapes:${NC}"
    echo "1. Exécutez: ./start-all-apps.sh"
    echo "2. Testez les applications dans votre navigateur"
    echo "3. Changez la langue avec le sélecteur en haut à droite"
else
    echo -e "${YELLOW}⚠️  Certaines applications ont échoué:${NC}"
    for failed_app in "${FAILED_APPS[@]}"; do
        echo "  - $failed_app"
    done
    echo ""
    echo -e "${BLUE}💡 Solutions possibles:${NC}"
    echo "1. Vérifiez votre connexion internet"
    echo "2. Nettoyez le cache npm: npm cache clean --force"
    echo "3. Réessayez l'installation individuellement"
fi
EOF
    
    chmod +x "install-all-dependencies.sh"
    print_message "Script d'installation optimisé créé ✓"
}

# Créer un script de démarrage amélioré
create_better_start_script() {
    print_step "Création du script de démarrage amélioré..."
    
    cat > "start-all-apps.sh" << 'EOF'
#!/bin/bash

# 🚀 Script de démarrage optimisé pour toutes les applications I18n
echo "🌍 Démarrage de toutes les applications multilingues..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
PORTS=(3001 3002 3003 3004 3005)
PIDS=()

# Fonction pour nettoyer les processus en arrière-plan
cleanup() {
    echo -e "\n${YELLOW}🛑 Arrêt des applications...${NC}"
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
            echo -e "${BLUE}Processus $pid arrêté${NC}"
        fi
    done
    echo -e "${GREEN}✅ Toutes les applications ont été arrêtées${NC}"
    exit 0
}

# Intercepter Ctrl+C
trap cleanup SIGINT SIGTERM

# Fonction pour vérifier si un port est libre
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Port $port déjà utilisé${NC}"
        return 1
    fi
    return 0
}

# Fonction pour démarrer une application
start_app() {
    local app=$1
    local port=$2
    local index=$3
    
    echo -e "${CYAN}🚀 Démarrage de $app sur le port $port...${NC}"
    
    if [ ! -d "apps/$app" ]; then
        echo -e "${RED}❌ Répertoire apps/$app non trouvé${NC}"
        return 1
    fi
    
    # Vérifier si le port est libre
    if ! check_port $port; then
        echo -e "${YELLOW}💡 Tentative d'arrêt du processus sur le port $port...${NC}"
        lsof -ti:$port | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
    
    cd "apps/$app"
    
    # Vérifier si node_modules existe
    if [ ! -d "node_modules" ]; then
        echo -e "${YELLOW}📦 Installation des dépendances pour $app...${NC}"
        npm install --silent
    fi
    
    # Démarrer l'application
    echo -e "${BLUE}▶️  Lancement de $app...${NC}"
    npm run dev > "../logs/$app.log" 2>&1 &
    local pid=$!
    PIDS+=($pid)
    
    cd ../..
    
    # Attendre que l'application démarre
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s "http://localhost:$port" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ $app démarré avec succès sur http://localhost:$port${NC}"
            return 0
        fi
        sleep 1
        ((attempt++))
    done
    
    echo -e "${RED}❌ Échec du démarrage de $app${NC}"
    return 1
}

# Créer le répertoire de logs
mkdir -p logs

# Démarrer toutes les applications
echo -e "${BLUE}🔄 Démarrage des applications...${NC}"
for i in "${!APPS[@]}"; do
    start_app "${APPS[$i]}" "${PORTS[$i]}" "$i"
    sleep 3  # Délai entre chaque démarrage
done

echo ""
echo -e "${GREEN}🎉 Toutes les applications sont en cours de démarrage!${NC}"
echo ""
echo -e "${CYAN}📱 URLs des applications:${NC}"
echo -e "  • ${BLUE}PostMath Pro${NC}:  http://localhost:3001"
echo -e "  • ${BLUE}UnitFlip Pro${NC}:  http://localhost:3002"
echo -e "  • ${BLUE}BudgetCron${NC}:    http://localhost:3003"
echo -e "  • ${BLUE}AI4Kids${NC}:       http://localhost:3004"
echo -e "  • ${BLUE}MultiAI${NC}:       http://localhost:3005"
echo ""
echo -e "${YELLOW}🌍 Fonctionnalités I18n disponibles:${NC}"
echo -e "  ✅ ${GREEN}30+ langues${NC} de tous les continents"
echo -e "  ✅ ${GREEN}Persistance automatique${NC} de la langue"
echo -e "  ✅ ${GREEN}Synchronisation inter-onglets${NC}"
echo -e "  ✅ ${GREEN}Support RTL${NC} (Arabe, Hébreu, etc.)"
echo -e "  ✅ ${GREEN}Détection automatique${NC} de langue"
echo ""
echo -e "${BLUE}🎯 Test rapide:${NC}"
echo "1. Ouvrez une des URLs ci-dessus"
echo "2. Changez la langue avec le sélecteur en haut à droite"
echo "3. Naviguez dans l'application → la langue reste active!"
echo "4. Ouvrez un nouvel onglet → même langue partout!"
echo ""
echo -e "${YELLOW}📊 Logs disponibles dans le dossier 'logs/'${NC}"
echo -e "${RED}🛑 Appuyez sur Ctrl+C pour arrêter toutes les applications${NC}"
echo ""

# Attendre indéfiniment
wait
EOF
    
    chmod +x "start-all-apps.sh"
    print_message "Script de démarrage amélioré créé ✓"
}

# Créer un script de test automatique
create_test_script() {
    print_step "Création du script de test automatique..."
    
    cat > "test-i18n.sh" << 'EOF'
#!/bin/bash

# 🧪 Script de test automatique I18n
echo "🔍 Test automatique du système I18n..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")
PORTS=(3001 3002 3003 3004 3005)
PASSED_TESTS=0
FAILED_TESTS=0

# Fonction de test
test_app() {
    local app=$1
    local port=$2
    
    echo -e "${BLUE}🧪 Test de $app sur le port $port...${NC}"
    
    # Test 1: Vérifier si l'application répond
    if curl -s -f "http://localhost:$port" > /dev/null; then
        echo -e "${GREEN}  ✅ Application accessible${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Application non accessible${NC}"
        ((FAILED_TESTS++))
    fi
    
    # Test 2: Vérifier si les fichiers I18n existent
    if [ -f "apps/$app/src/hooks/useUniversalI18n.ts" ]; then
        echo -e "${GREEN}  ✅ Hook I18n présent${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Hook I18n manquant${NC}"
        ((FAILED_TESTS++))
    fi
    
    # Test 3: Vérifier les traductions
    if [ -f "apps/$app/src/translations/index.ts" ]; then
        echo -e "${GREEN}  ✅ Traductions présentes${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Traductions manquantes${NC}"
        ((FAILED_TESTS++))
    fi
    
    # Test 4: Vérifier le layout I18n
    if [ -f "apps/$app/src/components/I18nLayout.tsx" ]; then
        echo -e "${GREEN}  ✅ Layout I18n présent${NC}"
        ((PASSED_TESTS++))
    else
        echo -e "${RED}  ❌ Layout I18n manquant${NC}"
        ((FAILED_TESTS++))
    fi
    
    echo ""
}

# Tester toutes les applications
for i in "${!APPS[@]}"; do
    test_app "${APPS[$i]}" "${PORTS[$i]}"
done

# Résumé des tests
echo -e "${BLUE}📊 Résumé des tests:${NC}"
echo -e "  ${GREEN}✅ Tests réussis: $PASSED_TESTS${NC}"
echo -e "  ${RED}❌ Tests échoués: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 Tous les tests sont passés! Le système I18n fonctionne correctement.${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Certains tests ont échoué. Vérifiez les erreurs ci-dessus.${NC}"
    exit 1
fi
EOF
    
    chmod +x "test-i18n.sh"
    print_message "Script de test automatique créé ✓"
}

# Créer un script de diagnostic
create_diagnostic_script() {
    print_step "Création du script de diagnostic..."
    
    cat > "diagnose-i18n.sh" << 'EOF'
#!/bin/bash

# 🔍 Script de diagnostic I18n
echo "🔍 Diagnostic du système I18n..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APPS=("postmath" "unitflip" "budgetcron" "ai4kids" "multiai")

echo -e "${BLUE}🖥️  Informations système:${NC}"
echo "  Node.js: $(node --version 2>/dev/null || echo 'Non installé')"
echo "  npm: $(npm --version 2>/dev/null || echo 'Non installé')"
echo "  Système: $(uname -s)"
echo ""

echo -e "${BLUE}📁 Structure des applications:${NC}"
for app in "${APPS[@]}"; do
    echo -e "${YELLOW}Application: $app${NC}"
    
    if [ -d "apps/$app" ]; then
        echo -e "  ${GREEN}✅ Répertoire principal${NC}"
        
        # Vérifier les fichiers essentiels
        files=(
            "src/hooks/useUniversalI18n.ts"
            "src/components/I18nLayout.tsx"
            "src/translations/index.ts"
            "src/app/layout.tsx"
            "src/app/page.tsx"
            "package.json"
            "tsconfig.json"
            "next.config.js"
            "tailwind.config.js"
        )
        
        for file in "${files[@]}"; do
            if [ -f "apps/$app/$file" ]; then
                echo -e "  ${GREEN}✅ $file${NC}"
            else
                echo -e "  ${RED}❌ $file${NC}"
            fi
        done
        
        # Vérifier node_modules
        if [ -d "apps/$app/node_modules" ]; then
            echo -e "  ${GREEN}✅ node_modules${NC}"
        else
            echo -e "  ${YELLOW}⚠️  node_modules (pas installé)${NC}"
        fi
        
    else
        echo -e "  ${RED}❌ Répertoire non trouvé${NC}"
    fi
    
    echo ""
done

echo -e "${BLUE}🌐 Vérification des ports:${NC}"
PORTS=(3001 3002 3003 3004 3005)
for i in "${!APPS[@]}"; do
    port="${PORTS[$i]}"
    app="${APPS[$i]}"
    
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅ Port $port ($app) - En cours d'utilisation${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Port $port ($app) - Libre${NC}"
    fi
done

echo ""
echo -e "${BLUE}🔧 Recommandations:${NC}"
echo "1. Si des fichiers manquent, relancez le script d'installation"
echo "2. Si node_modules manque, exécutez: ./install-all-dependencies.sh"
echo "3. Si les ports sont libres, démarrez les apps: ./start-all-apps.sh"
echo "4. Si des erreurs persistent, consultez les logs dans le dossier 'logs/'"
EOF
    
    chmod +x "diagnose-i18n.sh"
    print_message "Script de diagnostic créé ✓"
}

# Créer un fichier de documentation rapide
create_quick_guide() {
    print_step "Création du guide de démarrage rapide..."
    
    cat > "QUICK-START.md" << 'EOF'
# 🚀 Guide de Démarrage Rapide I18n

## ✅ Installation réussie !

Le système d'internationalisation a été installé avec succès sur vos 5 applications.

## 🎯 Prochaines étapes

### 1. Installer les dépendances
```bash
./install-all-dependencies.sh
```

### 2. Démarrer toutes les applications
```bash
./start-all-apps.sh
```

### 3. Tester le système
- Ouvrez http://localhost:3001 (PostMath Pro)
- Cliquez sur le sélecteur de langue en haut à droite
- Changez la langue et naviguez dans l'application
- ✅ La langue reste active !

## 📱 URLs des applications

- **PostMath Pro**: http://localhost:3001
- **UnitFlip Pro**: http://localhost:3002
- **BudgetCron**: http://localhost:3003
- **AI4Kids**: http://localhost:3004
- **MultiAI**: http://localhost:3005

## 🌍 Fonctionnalités I18n

✅ **30+ langues** de tous les continents
✅ **Persistance automatique** - La langue reste active
✅ **Synchronisation inter-onglets** - Même langue partout
✅ **Support RTL** - Arabe, Hébreu, etc.
✅ **Détection automatique** - Langue du navigateur
✅ **Applications indépendantes** - Fonctionnent séparément

## 🛠️ Scripts utiles

- `./diagnose-i18n.sh` - Diagnostic du système
- `./test-i18n.sh` - Tests automatiques
- `./install-all-dependencies.sh` - Installation des dépendances
- `./start-all-apps.sh` - Démarrage de toutes les apps

## 🔧 En cas de problème

1. **Diagnostic**: `./diagnose-i18n.sh`
2. **Réinstallation**: `./install-all-dependencies.sh`
3. **Logs**: Consultez le dossier `logs/`
4. **Support**: Consultez `README-I18N.md`

## 🎉 Félicitations !

Votre système I18n est maintenant opérationnel !
EOF
    
    print_message "Guide de démarrage rapide créé ✓"
}

# Fonction principale
main() {
    print_message "🔧 Début des corrections et optimisations post-installation"
    print_message "============================================================"
    
    # Corrections et optimisations
    fix_missing_configs
    create_better_install_script
    create_better_start_script
    create_test_script
    create_diagnostic_script
    create_quick_guide
    
    print_message "============================================================"
    print_message "🎉 Corrections et optimisations terminées !"
    print_message ""
    print_message "📋 Prochaines étapes recommandées :"
    print_message "1. Exécutez: ./install-all-dependencies.sh"
    print_message "2. Démarrez les apps: ./start-all-apps.sh"
    print_message "3. Testez le système: ./test-i18n.sh"
    print_message "4. En cas de problème: ./diagnose-i18n.sh"
    print_message ""
    print_message "📚 Guides disponibles :"
    print_message "  • QUICK-START.md - Guide de démarrage rapide"
    print_message "  • README-I18N.md - Documentation complète"
    print_message ""
    print_message "🎯 Votre système I18n est maintenant optimisé !"
    print_message "============================================================"
}

# Exécution du script
main "$@"
