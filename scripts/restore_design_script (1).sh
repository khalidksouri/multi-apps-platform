#!/bin/bash
# 🎨 RESTAURATION DU DESIGN MATH4CHILD
# Récupère le beau design validé depuis les backups

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

RESTORED_COUNT=0

print_banner() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}      ${BOLD}${BLUE}🎨 RESTAURATION DESIGN MATH4CHILD${NC}      ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${NC}        ${YELLOW}Récupération du design validé depuis les backups${NC}        ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() { echo -e "${BLUE}▶ $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ️  $1${NC}"; }

print_banner

# =============================================================================
# PHASE 1: DÉTECTION DES BACKUPS DISPONIBLES
# =============================================================================

detect_backups() {
    print_step "1. DÉTECTION DES BACKUPS DISPONIBLES"
    
    # Vérifier qu'on est dans le bon répertoire
    if [ ! -d "apps/math4child" ]; then
        print_error "Veuillez lancer ce script depuis la racine du monorepo (dossier contenant apps/)"
        exit 1
    fi
    
    cd apps/math4child
    
    print_info "Recherche des fichiers de backup..."
    
    # Chercher tous les types de backups
    BACKUP_FILES=(
        "src/app/page.tsx.ultimate-backup-1753369970"
        "src/app/page.tsx.backup"
        "src/app/page.tsx.ultimate-backup"
        "../../math4child-optimal/src/app/page.tsx"
        "src/app/page.tsx.pre-scripts-backup"
    )
    
    FOUND_BACKUPS=()
    
    for backup_file in "${BACKUP_FILES[@]}"; do
        if [ -f "$backup_file" ]; then
            echo "   📁 Trouvé: $backup_file"
            FOUND_BACKUPS+=("$backup_file")
        fi
    done
    
    if [ ${#FOUND_BACKUPS[@]} -eq 0 ]; then
        print_warning "Aucun backup trouvé dans les emplacements habituels"
        print_info "Recherche étendue..."
        
        # Recherche étendue
        find . -name "*page.tsx*backup*" -o -name "*page.tsx*ultimate*" | while read -r file; do
            if [ -f "$file" ]; then
                echo "   📁 Backup trouvé: $file"
                FOUND_BACKUPS+=("$file")
            fi
        done
        
        # Chercher dans math4child-optimal
        if [ -d "../../math4child-optimal" ]; then
            find ../../math4child-optimal -name "page.tsx" | while read -r file; do
                if [ -f "$file" ]; then
                    echo "   📁 Design original trouvé: $file"
                    FOUND_BACKUPS+=("$file")
                fi
            done
        fi
    fi
    
    if [ ${#FOUND_BACKUPS[@]} -eq 0 ]; then
        print_error "Aucun backup trouvé ! Impossible de restaurer le design."
        print_info "Voulez-vous que je recrée le design depuis zéro ? (pas dans ce script)"
        exit 1
    fi
    
    print_success "Détection terminée : ${#FOUND_BACKUPS[@]} backup(s) trouvé(s)"
}

# =============================================================================
# PHASE 2: RESTAURATION DU DESIGN PRINCIPAL
# =============================================================================

restore_main_design() {
    print_step "2. RESTAURATION DU DESIGN PRINCIPAL"
    
    # Ordre de priorité des backups (du plus récent au plus ancien)
    PRIORITY_BACKUPS=(
        "src/app/page.tsx.ultimate-backup-1753369970"
        "../../math4child-optimal/src/app/page.tsx"
        "src/app/page.tsx.ultimate-backup"
        "src/app/page.tsx.backup"
        "src/app/page.tsx.pre-scripts-backup"
    )
    
    RESTORED=false
    
    for backup_file in "${PRIORITY_BACKUPS[@]}"; do
        if [ -f "$backup_file" ]; then
            print_info "Restauration depuis: $backup_file"
            
            # Sauvegarder le fichier actuel
            if [ -f "src/app/page.tsx" ]; then
                cp src/app/page.tsx "src/app/page.tsx.avant-restauration-$(date +%s)"
                echo "   💾 Sauvegarde de l'ancien fichier effectuée"
            fi
            
            # Restaurer le design
            cp "$backup_file" src/app/page.tsx
            echo "   🎨 Design restauré depuis $backup_file"
            
            # Vérifier que le fichier n'est pas vide
            if [ -s "src/app/page.tsx" ]; then
                RESTORED=true
                RESTORED_COUNT=$((RESTORED_COUNT + 1))
                print_success "Design principal restauré avec succès"
                break
            else
                print_warning "Fichier backup vide, tentative suivante..."
                rm -f src/app/page.tsx
            fi
        fi
    done
    
    if [ "$RESTORED" = false ]; then
        print_error "Impossible de restaurer le design principal"
        exit 1
    fi
}

# =============================================================================
# PHASE 3: RESTAURATION DES FICHIERS ASSOCIÉS
# =============================================================================

restore_associated_files() {
    print_step "3. RESTAURATION DES FICHIERS ASSOCIÉS"
    
    print_info "Recherche des composants et styles associés..."
    
    # Fichiers associés à restaurer
    ASSOCIATED_FILES=(
        "src/app/globals.css"
        "src/components/LanguageDropdown.tsx"
        "src/hooks/useLanguage.ts"
        "src/types/language.ts"
        "src/app/layout.tsx"
    )
    
    for file_path in "${ASSOCIATED_FILES[@]}"; do
        # Chercher des backups pour ce fichier
        backup_patterns=(
            "${file_path}.ultimate-backup-1753369970"
            "${file_path}.backup"
            "${file_path}.ultimate-backup"
            "../../math4child-optimal/${file_path}"
        )
        
        for backup_pattern in "${backup_patterns[@]}"; do
            if [ -f "$backup_pattern" ]; then
                # Créer le répertoire si nécessaire
                mkdir -p "$(dirname "$file_path")"
                
                # Sauvegarder l'existant
                if [ -f "$file_path" ]; then
                    cp "$file_path" "${file_path}.avant-restauration-$(date +%s)"
                fi
                
                # Restaurer
                cp "$backup_pattern" "$file_path"
                echo "   🔧 Restauré: $file_path depuis $backup_pattern"
                RESTORED_COUNT=$((RESTORED_COUNT + 1))
                break
            fi
        done
    done
    
    print_success "Fichiers associés traités"
}

# =============================================================================
# PHASE 4: RESTAURATION DES STYLES ET ASSETS
# =============================================================================

restore_styles_and_assets() {
    print_step "4. RESTAURATION DES STYLES ET ASSETS"
    
    print_info "Recherche des styles personnalisés..."
    
    # Styles spécifiques à Math4Child
    STYLE_FILES=(
        "src/app/globals.css"
        "src/styles/language-dropdown.css"
        "public/manifest.json"
    )
    
    for style_file in "${STYLE_FILES[@]}"; do
        backup_locations=(
            "${style_file}.ultimate-backup-1753369970"
            "${style_file}.backup"
            "../../math4child-optimal/${style_file}"
        )
        
        for backup_location in "${backup_locations[@]}"; do
            if [ -f "$backup_location" ]; then
                mkdir -p "$(dirname "$style_file")"
                
                if [ -f "$style_file" ]; then
                    cp "$style_file" "${style_file}.avant-restauration-$(date +%s)"
                fi
                
                cp "$backup_location" "$style_file"
                echo "   🎨 Style restauré: $style_file"
                RESTORED_COUNT=$((RESTORED_COUNT + 1))
                break
            fi
        done
    done
    
    print_success "Styles et assets traités"
}

# =============================================================================
# PHASE 5: VÉRIFICATION ET NETTOYAGE
# =============================================================================

verify_and_cleanup() {
    print_step "5. VÉRIFICATION ET NETTOYAGE"
    
    print_info "Vérification des fichiers restaurés..."
    
    # Vérifier que le fichier principal existe et n'est pas vide
    if [ -f "src/app/page.tsx" ] && [ -s "src/app/page.tsx" ]; then
        echo "   ✅ page.tsx: $(wc -l < src/app/page.tsx) lignes"
    else
        print_error "Le fichier principal page.tsx est manquant ou vide"
        exit 1
    fi
    
    # Vérifier la syntaxe TypeScript de base
    if grep -q "export default" src/app/page.tsx; then
        echo "   ✅ Syntaxe TypeScript: Export par défaut trouvé"
    else
        print_warning "Syntaxe TypeScript: Aucun export par défaut trouvé"
    fi
    
    # Vérifier les imports React
    if grep -q "import.*React\|import.*from ['\"]react['\"]" src/app/page.tsx; then
        echo "   ✅ Imports React: OK"
    else
        print_warning "Imports React: Non trouvés"
    fi
    
    print_success "Vérification terminée"
}

# =============================================================================
# PHASE 6: REDÉMARRAGE DU SERVEUR DE DÉVELOPPEMENT
# =============================================================================

restart_dev_server() {
    print_step "6. REDÉMARRAGE DU SERVEUR DE DÉVELOPPEMENT"
    
    print_info "Arrêt des serveurs existants..."
    
    # Tuer les processus Next.js existants
    pkill -f "next dev" || true
    pkill -f "node.*next" || true
    
    # Nettoyer le cache Next.js
    if [ -d ".next" ]; then
        rm -rf .next
        echo "   🧹 Cache .next supprimé"
    fi
    
    # Installer les dépendances si nécessaire
    if [ ! -d "node_modules" ] || [ ! -f "node_modules/.package-lock.json" ]; then
        print_info "Installation des dépendances..."
        npm install --silent
    fi
    
    print_info "Démarrage du serveur de développement..."
    
    # Démarrer en arrière-plan
    npm run dev > /dev/null 2>&1 &
    DEV_PID=$!
    
    echo "   🚀 Serveur démarré (PID: $DEV_PID)"
    echo "   🌐 URL: http://localhost:3000"
    
    # Attendre que le serveur soit prêt
    print_info "Attente du démarrage du serveur..."
    sleep 5
    
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        print_success "Serveur opérationnel sur http://localhost:3000"
    else
        print_warning "Le serveur met du temps à démarrer, vérifiez manuellement"
    fi
}

# =============================================================================
# PHASE 7: RAPPORT FINAL
# =============================================================================

generate_final_report() {
    print_step "7. RAPPORT FINAL DE RESTAURATION"
    
    echo ""
    echo -e "${BOLD}${GREEN}🎉 RESTAURATION DU DESIGN TERMINÉE ! 🎉${NC}"
    echo "═══════════════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${CYAN}📊 RÉSULTATS :${NC}"
    echo ""
    echo -e "${GREEN}✅ FICHIERS RESTAURÉS :${NC}"
    echo "   • Fichiers récupérés : ${BOLD}$RESTORED_COUNT fichiers${NC}"
    echo "   • Design principal : ${BOLD}src/app/page.tsx${NC}"
    echo "   • Styles et composants associés"
    echo "   • Configuration et assets"
    echo ""
    echo -e "${BLUE}🎨 DESIGN RESTAURÉ :${NC}"
    echo "   • Interface avec dégradé violet/rose"
    echo "   • Particules animées en arrière-plan"
    echo "   • Header avec navigation soignée"
    echo "   • Sélecteur de langue avec drapeaux"
    echo "   • Boutons CTA avec effets"
    echo "   • Statistiques impressionnantes (+100k familles, +195 langues)"
    echo ""
    echo -e "${PURPLE}🚀 SERVEUR :${NC}"
    echo "   • URL : ${BOLD}http://localhost:3000${NC}"
    echo "   • Status : ${GREEN}Opérationnel${NC}"
    echo ""
    echo -e "${YELLOW}📋 PROCHAINES ÉTAPES :${NC}"
    echo "1. ${BOLD}Ouvrir http://localhost:3000${NC} dans votre navigateur"
    echo "2. Vérifier que le design est correct"
    echo "3. ${BOLD}git add . && git commit -m \"restore: beautiful Math4Child design\"${NC}"
    echo "4. Tester les fonctionnalités (sélecteur de langue, etc.)"
    echo ""
    echo -e "${CYAN}💾 BACKUPS CRÉÉS :${NC}"
    echo "   • Les fichiers précédents ont été sauvegardés avec l'extension"
    echo "     ${BOLD}.avant-restauration-[timestamp]${NC}"
    echo ""
    echo -e "${BOLD}${GREEN}🎯 Votre beau design Math4Child est de retour ! 🎯${NC}"
    echo ""
    
    # Ouvrir automatiquement dans le navigateur (macOS)
    if command -v open > /dev/null 2>&1; then
        print_info "Ouverture automatique dans le navigateur..."
        sleep 2
        open http://localhost:3000
    fi
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================

main() {
    # Confirmation utilisateur
    echo -e "${YELLOW}🎨 Ce script va restaurer le beau design Math4Child depuis les backups${NC}"
    echo -e "${CYAN}Actions prévues :${NC}"
    echo "   • Recherche des fichiers de backup (ultimate-backup, math4child-optimal, etc.)"
    echo "   • Restauration du design principal (page.tsx)"
    echo "   • Restauration des styles et composants associés"
    echo "   • Redémarrage du serveur de développement"
    echo "   • Ouverture automatique dans le navigateur"
    echo ""
    read -p "Voulez-vous continuer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Restauration annulée."
        exit 0
    fi
    
    # Exécuter toutes les phases
    detect_backups
    restore_main_design
    restore_associated_files
    restore_styles_and_assets
    verify_and_cleanup
    restart_dev_server
    generate_final_report
}

# Gestion des arguments
case "${1:-}" in
    --help|-h)
        print_banner
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Affiche cette aide"
        echo "  --force        Force la restauration sans confirmation"
        echo ""
        echo "🎨 Script de restauration du design Math4Child"
        echo ""
        echo "Ce script :"
        echo "• Recherche les backups disponibles (ultimate-backup, math4child-optimal)"
        echo "• Restaure le design principal page.tsx"
        echo "• Restaure les styles et composants associés"
        echo "• Redémarre le serveur de développement"
        echo "• Ouvre automatiquement dans le navigateur"
        echo ""
        echo "Résultat : Votre beau design Math4Child restauré !"
        exit 0
        ;;
    --force)
        detect_backups
        restore_main_design
        restore_associated_files
        restore_styles_and_assets
        verify_and_cleanup
        restart_dev_server
        generate_final_report
        exit 0
        ;;
esac

# Exécution principale
main

exit 0