#!/bin/bash

# =============================================================================
# ⚡ DÉMARRAGE RAPIDE MATH4CHILD
# =============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}              ${YELLOW}⚡ DÉMARRAGE RAPIDE MATH4CHILD${NC}               ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Vérifier l'état du projet
check_project_status() {
    echo -e "${YELLOW}🔍 Vérification de l'état du projet...${NC}"
    echo ""
    
    # Vérifier si le projet existe
    if [ -d "apps/math4child" ]; then
        print_success "Projet trouvé dans apps/math4child"
        cd apps/math4child
        
        # Vérifier package.json
        if [ -f "package.json" ]; then
            print_success "Configuration package.json OK"
        else
            print_error "package.json manquant"
            return 1
        fi
        
        # Vérifier node_modules
        if [ -d "node_modules" ]; then
            print_success "Dépendances installées"
        else
            print_info "Installation des dépendances nécessaire"
            npm install --legacy-peer-deps
        fi
        
        # Vérifier les fichiers principaux
        if [ -f "src/app/page.tsx" ]; then
            print_success "Application principale OK"
        else
            print_error "Fichiers application manquants"
            return 1
        fi
        
        return 0
    else
        print_error "Projet non trouvé dans apps/math4child"
        echo ""
        echo -e "${YELLOW}💡 Pour créer le projet, lancez:${NC}"
        echo "   ./math4child_complete_script.sh"
        return 1
    fi
}

# Démarrer le serveur de développement
start_dev_server() {
    echo ""
    echo -e "${YELLOW}🚀 Démarrage du serveur de développement...${NC}"
    echo ""
    
    # Vérifier si le port 3000 est libre
    if lsof -i :3000 >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Le port 3000 est déjà utilisé${NC}"
        echo ""
        echo "Voulez-vous:"
        echo "1) Arrêter le processus existant et redémarrer"
        echo "2) Utiliser un autre port"
        echo "3) Annuler"
        echo ""
        read -p "Votre choix (1-3): " choice
        
        case $choice in
            1)
                print_info "Arrêt du processus sur le port 3000..."
                lsof -ti:3000 | xargs kill -9 2>/dev/null || true
                sleep 2
                ;;
            2)
                print_info "Démarrage sur le port 3001..."
                npm run dev -- -p 3001 &
                sleep 3
                echo ""
                echo -e "${GREEN}🌐 Application disponible sur: http://localhost:3001${NC}"
                return 0
                ;;
            3)
                print_info "Annulation du démarrage"
                return 1
                ;;
        esac
    fi
    
    # Démarrer le serveur
    print_info "Lancement du serveur Next.js..."
    npm run dev &
    DEV_PID=$!
    
    # Attendre que le serveur démarre
    print_info "Attente du démarrage du serveur..."
    sleep 5
    
    # Vérifier si le serveur répond
    if curl -s http://localhost:3000 > /dev/null; then
        print_success "Serveur démarré avec succès !"
        echo ""
        echo -e "${GREEN}🌐 Application disponible sur: http://localhost:3000${NC}"
        echo ""
        echo -e "${YELLOW}💡 Commandes utiles :${NC}"
        echo "   • Ctrl+C pour arrêter le serveur"
        echo "   • npm run build pour build production"
        echo "   • npm run test:optimal pour les tests"
        echo ""
        
        # Proposer d'ouvrir le navigateur
        if command -v open >/dev/null 2>&1; then
            echo -e "${BLUE}🌐 Ouvrir dans le navigateur ? (y/n):${NC}"
            read -t 5 -n 1 open_browser
            if [ "$open_browser" = "y" ] || [ "$open_browser" = "Y" ]; then
                open http://localhost:3000
            fi
        fi
        
        # Garder le script actif
        echo ""
        echo -e "${BLUE}📋 Serveur actif - Appuyez sur Ctrl+C pour arrêter${NC}"
        
        # Attendre que l'utilisateur arrête le serveur
        wait $DEV_PID
        
    else
        print_error "Échec du démarrage du serveur"
        echo ""
        echo -e "${YELLOW}💡 Pour diagnostiquer:${NC}"
        echo "   1. Vérifiez les erreurs ci-dessus"
        echo "   2. Lancez: npm run type-check"
        echo "   3. Lancez: npm run build"
        echo "   4. Essayez: ./final_fix_script.sh"
        
        # Arrêter le processus
        kill $DEV_PID 2>/dev/null || true
        return 1
    fi
}

# Afficher les informations du projet
show_project_info() {
    echo -e "${BLUE}📊 INFORMATIONS DU PROJET${NC}"
    echo "═══════════════════════════════════════════════════════════════════"
    
    # Version Node.js
    echo "Node.js: $(node --version)"
    echo "npm: $(npm --version)"
    
    # Dépendances principales
    echo ""
    echo "📦 Dépendances principales:"
    npm ls --depth=0 2>/dev/null | grep -E "(next|react|typescript)" | head -5
    
    # Scripts disponibles
    echo ""
    echo "🔧 Scripts disponibles:"
    npm run 2>/dev/null | grep -v "Lifecycle scripts" | grep -E "(dev|build|test|lint)" | head -10
    
    # Taille du projet
    echo ""
    echo "📁 Taille du projet:"
    du -sh . 2>/dev/null || echo "Calcul impossible"
    
    echo ""
}

# Menu principal
show_menu() {
    echo -e "${YELLOW}🎯 Que souhaitez-vous faire ?${NC}"
    echo ""
    echo "1) 🚀 Démarrer le serveur de développement"
    echo "2) 🏗️  Build de production"
    echo "3) 🧪 Lancer les tests"
    echo "4) 🔍 Vérifications (lint + type-check)"
    echo "5) 📊 Informations du projet"
    echo "6) 🔧 Corriger les erreurs (script final)"
    echo "7) 🧹 Nettoyer le cache"
    echo "0) ❌ Quitter"
    echo ""
    read -p "Votre choix (0-7): " choice
    
    case $choice in
        1)
            start_dev_server
            ;;
        2)
            echo ""
            print_info "Build de production..."
            if npm run build; then
                print_success "Build réussi !"
                echo ""
                echo -e "${BLUE}Pour démarrer en production:${NC}"
                echo "   npm run start"
            else
                print_error "Build échoué"
            fi
            ;;
        3)
            echo ""
            print_info "Lancement des tests..."
            npm run test:optimal || print_error "Tests échoués"
            ;;
        4)
            echo ""
            print_info "Vérifications..."
            echo "🔍 Lint:"
            npm run lint || true
            echo ""
            echo "🔍 TypeScript:"
            npm run type-check || true
            ;;
        5)
            echo ""
            show_project_info
            ;;
        6)
            echo ""
            print_info "Lancement du script de correction..."
            if [ -f "../final_fix_script.sh" ]; then
                ../final_fix_script.sh
            elif [ -f "../../final_fix_script.sh" ]; then
                ../../final_fix_script.sh
            else
                print_error "Script de correction non trouvé"
            fi
            ;;
        7)
            echo ""
            print_info "Nettoyage du cache..."
            npm run clean 2>/dev/null || true
            npm cache clean --force
            print_success "Cache nettoyé"
            ;;
        0)
            print_info "Au revoir !"
            exit 0
            ;;
        *)
            print_error "Choix invalide"
            show_menu
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}Appuyez sur Entrée pour continuer...${NC}"
    read -r
    show_menu
}

# Fonction principale
main() {
    print_header
    
    if check_project_status; then
        show_menu
    else
        echo ""
        print_error "Impossible de continuer - projet non configuré"
        exit 1
    fi
}

# Gestion propre de l'arrêt
trap 'echo ""; print_info "Arrêt en cours..."; exit 0' INT

# Exécution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi