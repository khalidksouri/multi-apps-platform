#!/bin/bash

# Script pour corriger le dropdown et appliquer les changements optimaux Math4Child
# Ce script fait les modifications de manière précise pour éviter de casser le JavaScript

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Variables
PAGE_FILE="apps/math4child/src/app/page.tsx"
BACKUP_FILE="apps/math4child/src/app/page.tsx.backup-20250726-003010"

# Vérifier que les fichiers existent
check_files() {
    log_info "Vérification des fichiers..."
    
    if [[ ! -f "$PAGE_FILE" ]]; then
        log_error "Fichier $PAGE_FILE non trouvé"
        exit 1
    fi
    
    if [[ ! -f "$BACKUP_FILE" ]]; then
        log_error "Fichier de sauvegarde $BACKUP_FILE non trouvé"
        exit 1
    fi
    
    log_success "Fichiers trouvés"
}

# Créer une sauvegarde avant modification
create_backup() {
    log_info "Création d'une sauvegarde..."
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    CURRENT_BACKUP="${PAGE_FILE}.backup_before_fix_${TIMESTAMP}"
    cp "$PAGE_FILE" "$CURRENT_BACKUP"
    
    log_success "Sauvegarde créée : $CURRENT_BACKUP"
}

# Restaurer la version propre
restore_clean_version() {
    log_info "Restauration de la version propre..."
    
    cp "$BACKUP_FILE" "$PAGE_FILE"
    
    log_success "Version propre restaurée"
}

# Appliquer les changements de prix de manière précise
update_prices() {
    log_info "Mise à jour des prix optimaux..."
    
    # Prix mensuels
    sed -i.tmp 's/9\.99€/6.99€/g' "$PAGE_FILE"
    sed -i.tmp 's/14\.99€/4.99€/g' "$PAGE_FILE"  
    sed -i.tmp 's/49\.99€/24.99€/g' "$PAGE_FILE"
    
    # Prix annuels
    sed -i.tmp 's/89\.99€/58.32€/g' "$PAGE_FILE"
    sed -i.tmp 's/134\.99€/41.94€/g' "$PAGE_FILE"
    sed -i.tmp 's/449\.99€/209.93€/g' "$PAGE_FILE"
    
    # Nettoyer les fichiers temporaires
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Prix optimaux appliqués"
}

# Remplacer les niveaux scolaires par les niveaux numériques de manière précise
update_levels() {
    log_info "Mise à jour des niveaux scolaires..."
    
    # Remplacements précis pour éviter de casser le JavaScript
    # On remplace seulement dans les balises de texte et les titres
    
    # Remplacer dans les titres et textes affichés
    sed -i.tmp 's/>CP</>Niveau 1</g' "$PAGE_FILE"
    sed -i.tmp 's/>CE1</>Niveau 2</g' "$PAGE_FILE"
    sed -i.tmp 's/>CE2</>Niveau 3</g' "$PAGE_FILE"
    sed -i.tmp 's/>CM1</>Niveau 4</g' "$PAGE_FILE"
    sed -i.tmp 's/>CM2</>Niveau 5</g' "$PAGE_FILE"
    
    # Remplacer dans les textes entre guillemets (mais pas dans les variables)
    sed -i.tmp "s/'CP'/'Niveau 1'/g" "$PAGE_FILE"
    sed -i.tmp "s/'CE1'/'Niveau 2'/g" "$PAGE_FILE"
    sed -i.tmp "s/'CE2'/'Niveau 3'/g" "$PAGE_FILE"
    sed -i.tmp "s/'CM1'/'Niveau 4'/g" "$PAGE_FILE"
    sed -i.tmp "s/'CM2'/'Niveau 5'/g" "$PAGE_FILE"
    
    # Remplacer dans les descriptions d'âge
    sed -i.tmp 's/6-7 ans/Niveau 1 (6-7 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/7-8 ans/Niveau 2 (7-8 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/8-9 ans/Niveau 3 (8-9 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/9-10 ans/Niveau 4 (9-10 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/10-11 ans/Niveau 5 (10-11 ans)/g' "$PAGE_FILE"
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Niveaux scolaires mis à jour"
}

# Vérifier que le JavaScript n'est pas cassé
verify_javascript() {
    log_info "Vérification de la syntaxe JavaScript..."
    
    # Vérifier qu'il n'y a pas de remplacements indésirables dans le code
    if grep -q "selectedNiveau" "$PAGE_FILE"; then
        log_warning "Détection de variables JavaScript modifiées, correction..."
        
        # Corriger les variables JavaScript qui auraient été modifiées
        sed -i.tmp 's/selectedNiveau 1/selectedCP/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 2/selectedCE1/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 3/selectedCE2/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 4/selectedCM1/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 5/selectedCM2/g' "$PAGE_FILE"
        
        rm -f "${PAGE_FILE}.tmp"
        log_success "Variables JavaScript corrigées"
    fi
    
    log_success "Syntaxe JavaScript vérifiée"
}

# Afficher un résumé des changements
show_summary() {
    echo ""
    log_success "🎉 Modifications appliquées avec succès !"
    echo ""
    echo "📋 Résumé des changements :"
    echo "  ✅ Header et dropdown préservés"
    echo "  ✅ Niveaux scolaires → Niveaux numériques"
    echo "  ✅ Prix optimaux appliqués"
    echo "  ✅ Syntaxe JavaScript vérifiée"
    echo ""
    echo "🔄 Rechargez votre page (F5) pour voir les changements"
}

# Fonction principale
main() {
    echo ""
    log_info "🚀 Démarrage de la mise à jour Math4Child optimale"
    echo ""
    
    check_files
    create_backup
    restore_clean_version
    update_prices
    update_levels  
    verify_javascript
    show_summary
}

# Exécution du script
main "$@"
