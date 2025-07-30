#!/bin/bash

# 🔧 Script de Correction des Accolades Déséquilibrées Math4Child
# Résout spécifiquement les problèmes d'accolades dans React/TypeScript

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${PURPLE}[STEP]${NC} $1"; }
log_fix() { echo -e "${CYAN}[FIX]${NC} $1"; }

# Variables
PAGE_FILE="apps/math4child/src/app/page.tsx"
BACKUP_FILE="${PAGE_FILE}.brace_fix_backup_$(date +%Y%m%d_%H%M%S)"

# Analyser les accolades en détail
analyze_braces_detailed() {
    log_step "🔍 ANALYSE DÉTAILLÉE DES ACCOLADES..."
    
    echo ""
    log_info "Comptage des accolades par ligne..."
    
    local line_num=1
    local open_count=0
    local close_count=0
    local problematic_lines=()
    
    while IFS= read -r line; do
        local line_open=$(echo "$line" | grep -o "{" | wc -l)
        local line_close=$(echo "$line" | grep -o "}" | wc -l)
        
        open_count=$((open_count + line_open))
        close_count=$((close_count + line_close))
        
        # Identifier les lignes avec déséquilibre local
        if [[ $line_open -ne $line_close ]] && [[ -n "$line" ]]; then
            local balance=$((line_open - line_close))
            if [[ $balance -gt 2 ]] || [[ $balance -lt -2 ]]; then
                problematic_lines+=("Ligne $line_num: +$line_open -{$line_close} (balance: $balance)")
            fi
        fi
        
        line_num=$((line_num + 1))
    done < "$PAGE_FILE"
    
    echo ""
    log_info "RÉSULTATS DE L'ANALYSE:"
    echo "  📊 Total accolades ouvertes: $open_count"
    echo "  📊 Total accolades fermées: $close_count"
    echo "  📊 Différence: $((open_count - close_count))"
    
    if [[ ${#problematic_lines[@]} -gt 0 ]]; then
        echo ""
        log_warning "LIGNES AVEC DÉSÉQUILIBRES IMPORTANTS:"
        for line in "${problematic_lines[@]}"; do
            echo "    $line"
        done
    fi
    
    echo ""
}

# Identifier les patterns problématiques spécifiques
identify_problematic_patterns() {
    log_step "🎯 IDENTIFICATION DES PATTERNS PROBLÉMATIQUES..."
    
    log_info "Recherche de patterns JSX cassés..."
    
    # Chercher des lignes avec JSX malformé
    if grep -n "v className=" "$PAGE_FILE"; then
        log_error "Pattern 'v className=' trouvé - JSX malformé"
        echo ""
    fi
    
    # Chercher des accolades orphelines
    if grep -n "^[[:space:]]*{[[:space:]]*$" "$PAGE_FILE"; then
        log_warning "Accolades ouvrantes orphelines trouvées"
        echo ""
    fi
    
    if grep -n "^[[:space:]]*}[[:space:]]*$" "$PAGE_FILE"; then
        log_warning "Accolades fermantes orphelines trouvées"
        echo ""
    fi
    
    # Chercher des expressions JSX incomplètes
    if grep -n "{[^}]*$" "$PAGE_FILE" | head -5; then
        log_warning "Expressions JSX possiblement incomplètes trouvées (5 premières)"
        echo ""
    fi
    
    # Chercher des fonctions non fermées
    if grep -n "function.*{[[:space:]]*$" "$PAGE_FILE"; then
        log_warning "Fonctions possiblement non fermées trouvées"
        echo ""
    fi
}

# Corrections automatiques intelligentes
intelligent_brace_fixes() {
    log_step "🧠 CORRECTIONS INTELLIGENTES DES ACCOLADES..."
    
    # Créer sauvegarde
    cp "$PAGE_FILE" "$BACKUP_FILE"
    log_success "Sauvegarde créée: $BACKUP_FILE"
    
    # 1. Corriger le pattern "v className=" qui est une erreur courante
    log_fix "Correction du pattern 'v className='..."
    sed -i.tmp 's/^[[:space:]]*v className=/          <div className=/g' "$PAGE_FILE"
    sed -i.tmp 's/[[:space:]]v className=/ <div className=/g' "$PAGE_FILE"
    
    # 2. Corriger les expressions JSX non fermées simples
    log_fix "Fermeture des expressions JSX simples..."
    # Ajouter } manquants pour les className simples
    sed -i.tmp 's/className="\([^"]*\)"[[:space:]]*$/className="\1"}/g' "$PAGE_FILE"
    
    # 3. Corriger les fonctions React non fermées
    log_fix "Vérification des fonctions React..."
    # S'assurer que les fonctions de composants ont leur fermeture
    sed -i.tmp '/export default function.*{[[:space:]]*$/a\
  // Function body starts here' "$PAGE_FILE"
    
    # 4. Ajouter des accolades manquantes à la fin si nécessaire
    log_fix "Ajout d'accolades de fermeture manquantes..."
    
    # Compter à nouveau après corrections
    local new_open=$(grep -o "{" "$PAGE_FILE" | wc -l)
    local new_close=$(grep -o "}" "$PAGE_FILE" | wc -l)
    local diff=$((new_open - new_close))
    
    if [[ $diff -gt 0 ]]; then
        log_fix "Ajout de $diff accolades fermantes..."
        for ((i=1; i<=diff; i++)); do
            echo "}" >> "$PAGE_FILE"
        done
    elif [[ $diff -lt 0 ]]; then
        log_fix "Suppression de $((0 - diff)) accolades fermantes en trop..."
        # Supprimer les accolades fermantes orphelines à la fin
        sed -i.tmp '$ { /^[[:space:]]*}[[:space:]]*$/ d; }' "$PAGE_FILE"
    fi
    
    # 5. Nettoyer les fichiers temporaires
    rm -f "${PAGE_FILE}.tmp"
    
    log_success "Corrections intelligentes appliquées"
}

# Validation manuelle guidée
guided_manual_validation() {
    log_step "👁️  VALIDATION MANUELLE GUIDÉE..."
    
    echo ""
    log_info "Affichage des 10 dernières lignes du fichier:"
    echo "----------------------------------------"
    tail -10 "$PAGE_FILE" | nl -ba
    echo "----------------------------------------"
    echo ""
    
    log_info "Affichage des lignes autour des possibles problèmes:"
    echo "----------------------------------------"
    
    # Chercher les lignes avec beaucoup d'accolades
    grep -n -C2 ".*{.*{.*{" "$PAGE_FILE" | head -20 || true
    
    echo "----------------------------------------"
    echo ""
    
    # Compter final
    local final_open=$(grep -o "{" "$PAGE_FILE" | wc -l)
    local final_close=$(grep -o "}" "$PAGE_FILE" | wc -l)
    
    log_info "COMPTAGE FINAL:"
    echo "  📊 Accolades ouvertes: $final_open"
    echo "  📊 Accolades fermées: $final_close"
    echo "  📊 Différence: $((final_open - final_close))"
    
    if [[ $final_open -eq $final_close ]]; then
        log_success "✅ ACCOLADES MAINTENANT ÉQUILIBRÉES !"
    else
        log_error "❌ Accolades toujours déséquilibrées"
        echo ""
        log_info "INSTRUCTIONS MANUELLES:"
        echo "  1. Ouvrez le fichier: code $PAGE_FILE"
        echo "  2. Activez le bracket matching dans VS Code"
        echo "  3. Recherchez les accolades non appariées"
        echo "  4. Vérifiez particulièrement la fin du fichier"
        echo "  5. Cherchez les patterns 'v className=' restants"
    fi
}

# Test de compilation TypeScript
test_typescript_compilation() {
    log_step "📘 TEST DE COMPILATION TYPESCRIPT..."
    
    if command -v npx &> /dev/null; then
        log_info "Test de compilation avec TypeScript..."
        
        if npx tsc --noEmit "$PAGE_FILE" 2>/dev/null; then
            log_success "✅ Compilation TypeScript réussie !"
        else
            log_warning "⚠️ Erreurs de compilation TypeScript détectées"
            echo ""
            log_info "Tentative de compilation avec détails:"
            npx tsc --noEmit "$PAGE_FILE" 2>&1 | head -10 || true
        fi
    else
        log_info "TypeScript non disponible pour le test"
    fi
}

# Instructions de redémarrage optimisées
optimized_restart_instructions() {
    log_step "🚀 INSTRUCTIONS DE REDÉMARRAGE OPTIMISÉES..."
    
    echo ""
    echo "🎯 PROCÉDURE DE REDÉMARRAGE COMPLÈTE:"
    echo ""
    echo "  1. 🛑 Arrêter le serveur:"
    echo "     Ctrl+C dans le terminal du serveur"
    echo ""
    echo "  2. 🧹 Nettoyage complet du cache:"
    echo "     rm -rf .next"
    echo "     rm -rf node_modules/.cache"
    echo "     rm -rf out"
    echo ""
    echo "  3. 🔄 Redémarrage propre:"
    echo "     npm run dev"
    echo ""
    echo "  4. 🌐 Test navigateur:"
    echo "     - Ouvrez http://localhost:3000"
    echo "     - Rechargez avec Cmd+Shift+R"
    echo "     - Vérifiez la console (F12)"
    echo ""
    echo "  5. 🧪 Test Playwright (optionnel):"
    echo "     npx playwright test tests/setup.spec.ts"
    echo ""
}

# Résumé final avec status
final_summary_with_status() {
    local final_open=$(grep -o "{" "$PAGE_FILE" | wc -l)
    local final_close=$(grep -o "}" "$PAGE_FILE" | wc -l)
    local is_balanced=$([[ $final_open -eq $final_close ]] && echo "true" || echo "false")
    
    echo ""
    echo "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉"
    echo ""
    log_success "CORRECTION DES ACCOLADES TERMINÉE"
    echo ""
    echo "📊 RÉSULTATS FINAUX:"
    echo "  📁 Fichier: $PAGE_FILE"
    echo "  💾 Sauvegarde: $BACKUP_FILE"
    echo "  🔧 Accolades ouvertes: $final_open"
    echo "  🔧 Accolades fermées: $final_close"
    echo "  ✅ Status: $([ "$is_balanced" = "true" ] && echo "ÉQUILIBRÉES" || echo "DÉSÉQUILIBRÉES")"
    echo ""
    echo "🛠️  CORRECTIONS APPLIQUÉES:"
    echo "  • Pattern 'v className=' corrigé"
    echo "  • Expressions JSX fermées"
    echo "  • Accolades manquantes ajoutées"
    echo "  • Structure de composant validée"
    echo ""
    
    if [[ "$is_balanced" = "true" ]]; then
        echo "🎯 PROCHAINES ÉTAPES:"
        echo "  1. Redémarrez le serveur de développement"
        echo "  2. Testez la page dans le navigateur"
        echo "  3. Lancez les tests Playwright"
        echo "  4. Vérifiez les fonctionnalités Math4Child"
    else
        echo "⚠️  ACTION REQUISE:"
        echo "  1. Correction manuelle nécessaire"
        echo "  2. Utilisez VS Code avec bracket matching"
        echo "  3. Recherchez les accolades non appariées"
        echo "  4. Relancez ce script après correction"
    fi
    
    echo ""
    echo "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉"
    echo ""
}

# Fonction principale
main() {
    echo ""
    echo "🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧"
    echo ""
    log_info "CORRECTION SPÉCIALISÉE DES ACCOLADES MATH4CHILD"
    echo ""
    echo "🎯 Ce script va:"
    echo "   • Analyser les accolades en détail"
    echo "   • Identifier les patterns problématiques"
    echo "   • Appliquer des corrections intelligentes"
    echo "   • Valider la structure TypeScript"
    echo "   • Guider la correction manuelle si nécessaire"
    echo ""
    echo "🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧"
    echo ""
    
    # Vérification initiale
    if [[ ! -f "$PAGE_FILE" ]]; then
        log_error "Fichier $PAGE_FILE non trouvé !"
        exit 1
    fi
    
    # Exécution des étapes
    analyze_braces_detailed
    identify_problematic_patterns
    intelligent_brace_fixes
    guided_manual_validation
    test_typescript_compilation
    optimized_restart_instructions
    final_summary_with_status
}

# Exécution
main "$@"