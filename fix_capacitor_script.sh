#!/bin/bash

# fix-capacitor-init.sh - Script pour réparer l'initialisation Capacitor

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "${CYAN}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Configuration des applications
get_app_info() {
    case $1 in
        "postmath")
            echo "🧮 Postmath Pro|#667eea|#764ba2|Calculatrice avancée avec historique et fonctions scientifiques"
            ;;
        "unitflip")
            echo "🔄 UnitFlip Pro|#10b981|#059669|Convertisseur d'unités universel (longueur, poids, température, devises)"
            ;;
        "budgetcron")
            echo "💰 BudgetCron|#3b82f6|#1d4ed8|Gestionnaire de budget personnel avec suivi des dépenses"
            ;;
        "ai4kids")
            echo "🎨 AI4Kids|#ec4899|#be185d|Application éducative interactive pour enfants"
            ;;
        "multiai")
            echo "🤖 MultiAI Search|#6b7280|#111827|Plateforme de recherche multi-moteurs avec IA"
            ;;
    esac
}

# Liste des applications
APPS_LIST="postmath unitflip budgetcron ai4kids multiai"

# Fonction pour réparer Capacitor pour une application
fix_capacitor_for_app() {
    local app_name=$1
    
    print_step "Réparation Capacitor pour $app_name..."
    
    if [ ! -d "apps/$app_name" ]; then
        print_error "L'application $app_name n'existe pas"
        return 1
    fi
    
    cd "apps/$app_name"
    
    # Supprimer les fichiers Capacitor existants s'ils existent
    if [ -f "capacitor.config.ts" ]; then
        mv capacitor.config.ts capacitor.config.ts.backup
        print_step "Sauvegarde de la configuration personnalisée"
    fi
    
    # Supprimer les dossiers de plateformes s'ils existent
    [ -d "android" ] && rm -rf android
    [ -d "ios" ] && rm -rf ios
    
    # Initialiser Capacitor avec un nom simplifié
    local app_info=$(get_app_info "$app_name")
    local display_name=$(echo "$app_info" | cut -d'|' -f1)
    
    print_step "Initialisation de Capacitor..."
    npx cap init "$display_name" "com.multiapps.$app_name" --web-dir=dist
    
    # Restaurer notre configuration personnalisée
    if [ -f "capacitor.config.ts.backup" ]; then
        mv capacitor.config.ts.backup capacitor.config.ts
        print_step "Restauration de la configuration personnalisée"
    fi
    
    # Ajouter les plateformes
    print_step "Ajout des plateformes Android et iOS..."
    npx cap add android
    npx cap add ios
    
    # Synchroniser
    print_step "Synchronisation initiale..."
    npx cap sync
    
    cd ../..
    
    print_success "$app_name réparé avec succès"
}

# Fonction principale
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              🔧 RÉPARATION CAPACITOR POUR TOUTES LES APPS   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    # Vérifier qu'on est dans le bon dossier
    if [ ! -d "apps" ]; then
        print_error "Dossier 'apps' non trouvé. Exécutez ce script depuis la racine du projet."
        exit 1
    fi
    
    print_step "Démarrage de la réparation pour toutes les applications..."
    echo ""
    
    # Réparer chaque application
    for app_name in $APPS_LIST; do
        if [ -d "apps/$app_name" ]; then
            fix_capacitor_for_app "$app_name"
            echo ""
        else
            print_warning "Application $app_name non trouvée, ignorée"
        fi
    done
    
    # Créer les scripts de gestion s'ils n'existent pas
    if [ ! -d "scripts" ]; then
        print_step "Création des scripts de gestion globale..."
        mkdir -p scripts
        
        # Script pour démarrer toutes les applications
        cat > scripts/dev-all-apps.sh << 'EOF'
#!/bin/bash

echo "🚀 Démarrage de toutes les applications en mode développement..."

# Ports pour chaque application
declare -a ports=(3001 3002 3003 3004 3005)
apps=(postmath unitflip budgetcron ai4kids multiai)

# Fonction pour tuer tous les processus
cleanup() {
    echo "🛑 Arrêt de tous les serveurs..."
    jobs -p | xargs -r kill 2>/dev/null
    exit 0
}

trap cleanup INT

# Démarrer chaque application
for i in "${!apps[@]}"; do
    app="${apps[$i]}"
    port="${ports[$i]}"
    
    if [ -d "apps/$app" ]; then
        echo "📱 Démarrage de $app sur le port $port..."
        cd "apps/$app"
        PORT=$port npm run dev &
        cd ../..
        sleep 2
    fi
done

echo ""
echo "🌟 Toutes les applications sont démarrées :"
echo "   🧮 Postmath Pro:    http://localhost:3001"
echo "   🔄 UnitFlip Pro:    http://localhost:3002"
echo "   💰 BudgetCron:      http://localhost:3003"
echo "   🎨 AI4Kids:         http://localhost:3004"
echo "   🤖 MultiAI Search:  http://localhost:3005"
echo ""
echo "Appuyez sur Ctrl+C pour arrêter tous les serveurs"

wait
EOF
        chmod +x scripts/dev-all-apps.sh
        
        # Script pour installer les dépendances
        cat > scripts/install-all-deps.sh << 'EOF'
#!/bin/bash

echo "📦 Installation des dépendances pour toutes les applications..."

for app in postmath unitflip budgetcron ai4kids multiai; do
    if [ -d "apps/$app" ]; then
        echo "📱 Installation pour $app..."
        cd "apps/$app"
        npm install
        cd ../..
        echo "✅ $app terminé"
    fi
done

echo "✅ Toutes les dépendances sont installées !"
EOF
        chmod +x scripts/install-all-deps.sh
        
        print_success "Scripts de gestion créés"
    fi
    
    echo ""
    echo -e "${GREEN}🎉 RÉPARATION TERMINÉE !${NC}"
    echo ""
    echo -e "${CYAN}📱 Applications prêtes :${NC}"
    echo "   🧮 Postmath Pro     - apps/postmath/"
    echo "   🔄 UnitFlip Pro     - apps/unitflip/"
    echo "   💰 BudgetCron       - apps/budgetcron/"
    echo "   🎨 AI4Kids          - apps/ai4kids/"
    echo "   🤖 MultiAI Search   - apps/multiai/"
    echo ""
    echo -e "${YELLOW}🚀 Commandes disponibles :${NC}"
    echo "   ./scripts/dev-all-apps.sh      # Démarrer toutes les apps"
    echo "   cd apps/postmath && npm run dev # Tester une app"
    echo ""
    echo -e "${CYAN}🤖 Capacitor prêt pour :${NC}"
    echo "   npm run android    # Ouvrir Android Studio"
    echo "   npm run ios        # Ouvrir Xcode (macOS)"
    echo ""
    
    # Proposer de tester
    read -p "Voulez-vous démarrer toutes les applications maintenant ? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Démarrage de toutes les applications..."
        ./scripts/dev-all-apps.sh
    fi
}

# Exécution
main "$@"