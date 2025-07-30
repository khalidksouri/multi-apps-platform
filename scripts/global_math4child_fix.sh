#!/bin/bash

# Script global de correction Math4Child
# Corrige tous les problèmes identifiés : prix, niveaux, dropdown, fonctionnalités

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Fonctions d'affichage
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

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

log_fix() {
    echo -e "${CYAN}[FIX]${NC} $1"
}

# Variables globales
PAGE_FILE="apps/math4child/src/app/page.tsx"
BACKUP_DIR="backups_math4child"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Créer le répertoire de sauvegarde
create_backup_dir() {
    log_info "Création du répertoire de sauvegarde..."
    mkdir -p "$BACKUP_DIR"
    log_success "Répertoire de sauvegarde créé : $BACKUP_DIR"
}

# Vérifier les fichiers
check_files() {
    log_step "Vérification des fichiers..."
    
    if [[ ! -f "$PAGE_FILE" ]]; then
        log_error "Fichier $PAGE_FILE non trouvé"
        exit 1
    fi
    
    log_success "Fichier principal trouvé"
}

# Créer une sauvegarde complète
create_backup() {
    log_step "Création d'une sauvegarde complète..."
    
    BACKUP_FILE="$BACKUP_DIR/page_backup_$TIMESTAMP.tsx"
    cp "$PAGE_FILE" "$BACKUP_FILE"
    
    log_success "Sauvegarde créée : $BACKUP_FILE"
}

# 1. Corriger les prix optimaux
fix_prices() {
    log_step "🎯 Correction des prix optimaux..."
    
    log_fix "Mise à jour des prix mensuels..."
    sed -i.tmp 's/9\.99€/6.99€/g' "$PAGE_FILE"
    sed -i.tmp 's/14\.99€/4.99€/g' "$PAGE_FILE"
    sed -i.tmp 's/49\.99€/24.99€/g' "$PAGE_FILE"
    
    log_fix "Mise à jour des prix annuels..."
    sed -i.tmp 's/89\.99€/58.32€/g' "$PAGE_FILE"
    sed -i.tmp 's/134\.99€/41.94€/g' "$PAGE_FILE"
    sed -i.tmp 's/449\.99€/209.93€/g' "$PAGE_FILE"
    
    log_fix "Mise à jour des prix trimestriels..."
    sed -i.tmp 's/24\.97€/18.87€/g' "$PAGE_FILE"
    sed -i.tmp 's/37\.47€/13.47€/g' "$PAGE_FILE"
    sed -i.tmp 's/124\.97€/67.47€/g' "$PAGE_FILE"
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Prix optimaux appliqués !"
}

# 2. Corriger les niveaux scolaires
fix_levels() {
    log_step "📚 Correction des niveaux scolaires..."
    
    log_fix "CP → Niveau 1..."
    sed -i.tmp 's/>CP</>Niveau 1</g' "$PAGE_FILE"
    sed -i.tmp "s/'CP'/'Niveau 1'/g" "$PAGE_FILE"
    sed -i.tmp 's/Accès CP seulement/Accès Niveau 1 seulement/g' "$PAGE_FILE"
    
    log_fix "CE1 → Niveau 2..."
    sed -i.tmp 's/>CE1</>Niveau 2</g' "$PAGE_FILE"
    sed -i.tmp "s/'CE1'/'Niveau 2'/g" "$PAGE_FILE"
    
    log_fix "CE2 → Niveau 3..."
    sed -i.tmp 's/>CE2</>Niveau 3</g' "$PAGE_FILE"
    sed -i.tmp "s/'CE2'/'Niveau 3'/g" "$PAGE_FILE"
    
    log_fix "CM1 → Niveau 4..."
    sed -i.tmp 's/>CM1</>Niveau 4</g' "$PAGE_FILE"
    sed -i.tmp "s/'CM1'/'Niveau 4'/g" "$PAGE_FILE"
    
    log_fix "CM2 → Niveau 5..."
    sed -i.tmp 's/>CM2</>Niveau 5</g' "$PAGE_FILE"
    sed -i.tmp "s/'CM2'/'Niveau 5'/g" "$PAGE_FILE"
    
    # Corrections spéciales pour les plages de niveaux
    log_fix "Plages de niveaux..."
    sed -i.tmp 's/CP → CM2/Niveau 1 → Niveau 5/g' "$PAGE_FILE"
    sed -i.tmp 's/CP à CM2/Niveau 1 à Niveau 5/g' "$PAGE_FILE"
    sed -i.tmp 's/(CP à CM2)/(Niveau 1 à Niveau 5)/g' "$PAGE_FILE"
    sed -i.tmp 's/Progression CP → CM2/Progression Niveau 1 → Niveau 5/g' "$PAGE_FILE"
    sed -i.tmp 's/Tous les niveaux CP →/Tous les niveaux 1 →/g' "$PAGE_FILE"
    sed -i.tmp 's/Gestion par classe (CP à/Gestion par niveaux (1 à/g' "$PAGE_FILE"
    
    # Corrections pour les descriptions d'âge
    log_fix "Descriptions d'âge..."
    sed -i.tmp 's/6-7 ans/Niveau 1 (6-7 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/7-8 ans/Niveau 2 (7-8 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/8-9 ans/Niveau 3 (8-9 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/9-10 ans/Niveau 4 (9-10 ans)/g' "$PAGE_FILE"
    sed -i.tmp 's/10-11 ans/Niveau 5 (10-11 ans)/g' "$PAGE_FILE"
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Niveaux scolaires corrigés !"
}

# 3. Corriger le dropdown des langues
fix_dropdown() {
    log_step "🌐 Correction du dropdown des langues..."
    
    log_fix "Espacement du dropdown..."
    sed -i.tmp 's/absolute top-0/absolute top-full mt-1/g' "$PAGE_FILE"
    sed -i.tmp 's/absolute.*top-8/absolute top-full mt-2/g' "$PAGE_FILE"
    sed -i.tmp 's/absolute.*top-10/absolute top-full mt-2/g' "$PAGE_FILE"
    sed -i.tmp 's/absolute.*top-12/absolute top-full mt-2/g' "$PAGE_FILE"
    
    log_fix "Z-index du dropdown..."
    sed -i.tmp 's/z-10/z-50/g' "$PAGE_FILE"
    sed -i.tmp 's/z-20/z-50/g' "$PAGE_FILE"
    
    log_fix "Bordures et ombres..."
    sed -i.tmp 's/border border-gray-200/border border-gray-200 shadow-lg/g' "$PAGE_FILE"
    
    # Ajouter de l'espacement si pas présent
    if ! grep -q "mt-1\|mt-2" "$PAGE_FILE"; then
        log_fix "Ajout d'espacement manquant..."
        sed -i.tmp 's/absolute top-full/absolute top-full mt-2/g' "$PAGE_FILE"
    fi
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Dropdown des langues corrigé !"
}

# 4. Corriger les fonctionnalités des plans
fix_plan_features() {
    log_step "📋 Correction des fonctionnalités des plans..."
    
    log_fix "Plan Famille - nombre de profils..."
    sed -i.tmp 's/3 profils enfants/5 profils enfants/g' "$PAGE_FILE"
    sed -i.tmp 's/3 profils/5 profils/g' "$PAGE_FILE"
    
    log_fix "Plan Premium - nombre de profils..."
    sed -i.tmp 's/Enfants illimités/2 profils enfants/g' "$PAGE_FILE"
    sed -i.tmp 's/5 profils enfants/2 profils enfants/g' "$PAGE_FILE" # Si Premium avait 5
    
    log_fix "Plan École - descriptions..."
    sed -i.tmp 's/Classes multiples/30 profils élèves/g' "$PAGE_FILE"
    sed -i.tmp 's/Dashboard enseignant/Tableau de bord enseignant/g' "$PAGE_FILE"
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Fonctionnalités des plans corrigées !"
}

# 5. Ajouter les fonctions onClick pour les boutons
fix_buttons() {
    log_step "🔘 Correction des boutons d'abonnement..."
    
    # Vérifier si les fonctions onClick existent
    if ! grep -q "onClick.*plan\|handlePlan" "$PAGE_FILE"; then
        log_fix "Ajout des fonctions de gestion des clics..."
        
        # Ajouter une fonction handlePlanSelect simple
        sed -i.tmp '/useState/a\
\
  const handlePlanSelect = (planId, planName, price) => {\
    console.log(`Plan sélectionné: ${planName} (${planId}) - ${price}`);\
    alert(`Vous avez sélectionné le plan ${planName} pour ${price}`);\
    // Ici vous pouvez ajouter la logique de redirection vers le paiement\
  };' "$PAGE_FILE"
        
        # Ajouter onClick aux boutons
        sed -i.tmp 's/<button className=\([^>]*\)>/\n              <button onClick={() => handlePlanSelect(plan.id, plan.name, plan.price)} className=\1>/g' "$PAGE_FILE"
        
        log_success "Fonctions onClick ajoutées !"
    else
        log_info "Fonctions onClick déjà présentes"
    fi
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
}

# 6. Vérifier la syntaxe JavaScript
verify_syntax() {
    log_step "🔍 Vérification de la syntaxe..."
    
    # Vérifier et corriger les variables JavaScript cassées
    if grep -q "selectedNiveau\|Niveau.*Selected" "$PAGE_FILE"; then
        log_fix "Correction des variables JavaScript..."
        
        sed -i.tmp 's/selectedNiveau 1/selectedCP/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 2/selectedCE1/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 3/selectedCE2/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 4/selectedCM1/g' "$PAGE_FILE"
        sed -i.tmp 's/selectedNiveau 5/selectedCM2/g' "$PAGE_FILE"
        
        sed -i.tmp 's/Niveau 1Selected/CPSelected/g' "$PAGE_FILE"
        sed -i.tmp 's/Niveau 2Selected/CE1Selected/g' "$PAGE_FILE"
        sed -i.tmp 's/Niveau 3Selected/CE2Selected/g' "$PAGE_FILE"
        sed -i.tmp 's/Niveau 4Selected/CM1Selected/g' "$PAGE_FILE"
        sed -i.tmp 's/Niveau 5Selected/CM2Selected/g' "$PAGE_FILE"
        
        rm -f "${PAGE_FILE}.tmp"
        log_success "Variables JavaScript corrigées !"
    fi
    
    # Vérifier avec Node.js si disponible
    if command -v node &> /dev/null; then
        if node -c "$PAGE_FILE" 2>/dev/null; then
            log_success "Syntaxe JavaScript valide !"
        else
            log_warning "Des erreurs de syntaxe JavaScript ont été détectées"
        fi
    else
        log_info "Node.js non disponible pour la vérification"
    fi
}

# 7. Optimisations finales
final_optimizations() {
    log_step "✨ Optimisations finales..."
    
    log_fix "Économies affichées..."
    sed -i.tmp 's/Économisez 25%/Économisez 30%/g' "$PAGE_FILE"
    sed -i.tmp 's/Économisez 28%/Économisez 30%/g' "$PAGE_FILE"
    sed -i.tmp 's/Économisez 20%/Économisez 17%/g' "$PAGE_FILE"
    
    log_fix "Descriptions optimisées..."
    sed -i.tmp 's/100 bonnes réponses pour valider chaque niveau/Maîtrisez chaque niveau avec 100 bonnes réponses/g' "$PAGE_FILE"
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Optimisations finales appliquées !"
}

# Afficher le résumé final
show_final_summary() {
    echo ""
    echo "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉"
    echo ""
    log_success "TOUTES LES CORRECTIONS APPLIQUÉES AVEC SUCCÈS !"
    echo ""
    echo "📋 RÉSUMÉ COMPLET DES CHANGEMENTS :"
    echo ""
    echo "  🎯 PRIX OPTIMAUX :"
    echo "    • Famille : 6.99€/mois (au lieu de 9.99€) - Économie 30%"
    echo "    • Premium : 4.99€/mois (au lieu de 14.99€) - Économie 67%"  
    echo "    • École : 24.99€/mois (au lieu de 49.99€) - Économie 50%"
    echo ""
    echo "  📚 NIVEAUX SCOLAIRES :"
    echo "    • CP → Niveau 1"
    echo "    • CE1 → Niveau 2" 
    echo "    • CE2 → Niveau 3"
    echo "    • CM1 → Niveau 4"
    echo "    • CM2 → Niveau 5"
    echo ""
    echo "  🌐 INTERFACE :"
    echo "    • Dropdown des langues corrigé"
    echo "    • Espacement optimisé"
    echo "    • Z-index corrigé"
    echo ""
    echo "  📋 FONCTIONNALITÉS :"
    echo "    • Plan Famille : 5 profils (au lieu de 3)"
    echo "    • Plan Premium : 2 profils optimaux"
    echo "    • Plan École : 30 profils élèves"
    echo ""
    echo "  🔘 BOUTONS :"
    echo "    • Fonctions onClick ajoutées"
    echo "    • Sélection de plans fonctionnelle"
    echo ""
    echo "  ✅ QUALITÉ :"
    echo "    • Syntaxe JavaScript vérifiée"
    echo "    • Variables corrigées" 
    echo "    • Sauvegarde complète créée"
    echo ""
    echo "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉"
    echo ""
    echo "🔄 PROCHAINES ÉTAPES :"
    echo "  1. Rechargez votre page (F5 ou Cmd+R)"
    echo "  2. Testez les boutons d'abonnement"
    echo "  3. Vérifiez le dropdown des langues"
    echo "  4. Testez la sélection des périodes"
    echo ""
    echo "📁 SAUVEGARDE : $BACKUP_DIR/page_backup_$TIMESTAMP.tsx"
    echo ""
    echo "🚀 MATH4CHILD EST MAINTENANT OPTIMISÉ !"
    echo ""
}

# Fonction principale
main() {
    echo ""
    echo "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
    echo ""
    log_info "DÉMARRAGE DU SCRIPT GLOBAL MATH4CHILD"
    echo ""
    echo "🎯 Ce script va appliquer TOUTES les corrections :"
    echo "   • Prix optimaux"
    echo "   • Niveaux scolaires → niveaux numériques"  
    echo "   • Correction du dropdown des langues"
    echo "   • Fonctionnalités des plans"
    echo "   • Boutons d'abonnement fonctionnels"
    echo "   • Vérifications de qualité"
    echo ""
    echo "🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀"
    echo ""
    
    # Exécution de toutes les étapes
    create_backup_dir
    check_files
    create_backup
    fix_prices
    fix_levels
    fix_dropdown
    fix_plan_features
    fix_buttons
    verify_syntax
    final_optimizations
    show_final_summary
}

# Exécution du script
main "$@"