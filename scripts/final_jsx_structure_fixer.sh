#!/bin/bash

# 🔧 Script Final de Correction Structure JSX Math4Child
# Corrige les dernières erreurs de balises JSX non fermées

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
BACKUP_FILE="${PAGE_FILE}.final_fix_backup_$(date +%Y%m%d_%H%M%S)"

# Analyser les erreurs TypeScript restantes
analyze_remaining_errors() {
    log_step "🔍 ANALYSE DES ERREURS RESTANTES..."
    
    echo ""
    log_info "Analyse TypeScript des erreurs actuelles..."
    
    if command -v npx &> /dev/null; then
        local error_output=$(npx tsc --noEmit "$PAGE_FILE" 2>&1)
        local total_errors=$(echo "$error_output" | grep -c "error TS" || echo "0")
        
        echo "  📊 Total erreurs TypeScript: $total_errors"
        echo ""
        
        # Analyser les types d'erreurs
        local jsx_closing_errors=$(echo "$error_output" | grep -c "no corresponding closing tag\|Expected corresponding JSX closing tag" || echo "0")
        local jsx_element_errors=$(echo "$error_output" | grep -c "JSX element.*has no corresponding" || echo "0")
        local syntax_errors=$(echo "$error_output" | grep -c "expected\|Unexpected token" || echo "0")
        
        log_info "Types d'erreurs détectées:"
        echo "  🏷️  Balises JSX non fermées: $jsx_closing_errors"
        echo "  🔧 Erreurs de syntaxe: $syntax_errors"
        echo ""
        
        if [[ $jsx_closing_errors -gt 0 ]]; then
            log_error "Focus sur les balises JSX non fermées"
            echo ""
            log_info "Erreurs spécifiques de fermeture:"
            echo "$error_output" | grep "no corresponding closing tag\|Expected corresponding JSX closing tag" | head -5
            echo ""
        fi
    fi
}

# Corrections ciblées des balises JSX
fix_jsx_closing_tags() {
    log_step "🏷️ CORRECTION DES BALISES JSX NON FERMÉES..."
    
    # Créer sauvegarde
    cp "$PAGE_FILE" "$BACKUP_FILE"
    log_success "Sauvegarde créée: $BACKUP_FILE"
    
    # 1. Identifier et corriger les button tags problématiques
    log_fix "Correction des balises button non fermées..."
    
    # Lignes spécifiques identifiées dans les erreurs TypeScript:
    # Ligne 448: button sans closing tag
    # Ligne 468: button sans closing tag  
    # Ligne 493: Expected corresponding JSX closing tag for 'button'
    
    # Approche: transformer les button en div quand c'est approprié
    # ou ajouter les closing tags manquants
    
    # Correction ligne par ligne basée sur l'analyse des erreurs
    sed -i.tmp '448s/<button/<div/g' "$PAGE_FILE"
    sed -i.tmp '468s/<button/<div/g' "$PAGE_FILE"
    
    # Corriger les closing tags correspondants qui étaient incorrects
    sed -i.tmp '457s/<\/button>/<\/div>/g' "$PAGE_FILE"
    sed -i.tmp '478s/<\/button>/<\/div>/g' "$PAGE_FILE"
    sed -i.tmp '493s/<\/button>/<\/div>/g' "$PAGE_FILE"
    
    log_success "Balises button corrigées"
    
    # 2. Vérifier et corriger les div tags non fermés
    log_fix "Vérification des div tags..."
    
    # Analyser si nous avons créé de nouveaux déséquilibres
    local line_448_content=$(sed -n '448p' "$PAGE_FILE")
    local line_457_content=$(sed -n '457p' "$PAGE_FILE")
    
    log_info "Ligne 448: $(echo "$line_448_content" | cut -c1-50)..."
    log_info "Ligne 457: $(echo "$line_457_content" | cut -c1-50)..."
    
    # 3. Corriger les expressions vides restantes
    log_fix "Correction des expressions vides restantes..."
    
    # Patterns spécifiques identifiés
    sed -i.tmp 's/className={\`\([^$]*\)\${}}/className="\1"/g' "$PAGE_FILE"
    sed -i.tmp 's/\${}//g' "$PAGE_FILE"
    
    # Corriger les template literals cassés
    sed -i.tmp 's/className={\`\([^`]*\)`}/className="\1"/g' "$PAGE_FILE"
    
    log_success "Expressions vides corrigées"
    
    # 4. Nettoyer les fichiers temporaires
    rm -f "${PAGE_FILE}.tmp"
}

# Corrections spécifiques aux lignes problématiques
fix_specific_problematic_lines() {
    log_step "🎯 CORRECTIONS SPÉCIFIQUES AUX LIGNES PROBLÉMATIQUES..."
    
    log_fix "Correction ligne 529 - h-3 rounded-full..."
    # Ligne 529: <div className={`h-3 rounded-full ${}
    sed -i.tmp '529s/className={\`h-3 rounded-full \${}/className="h-3 rounded-full bg-gray-200"/g' "$PAGE_FILE"
    
    log_fix "Correction ligne 555 - p-6 bg-white..."
    # Ligne 555: className={`p-6 bg-white ... relative ${}
    sed -i.tmp '555s/relative \${}/relative"/g' "$PAGE_FILE"
    sed -i.tmp '555s/className={\`\([^$]*\)relative"/className="\1relative"/g' "$PAGE_FILE"
    
    log_fix "Correction ligne 601 - h-2 rounded-full..."
    # Ligne 601: className={`h-2 rounded-full transition-all duration-500 ${}
    sed -i.tmp '601s/duration-500 \${}/duration-500 bg-blue-500"/g' "$PAGE_FILE"
    sed -i.tmp '601s/className={\`\([^$]*\)bg-blue-500"/className="\1bg-blue-500"/g' "$PAGE_FILE"
    
    log_success "Lignes spécifiques corrigées"
    
    # Nettoyer
    rm -f "${PAGE_FILE}.tmp"
}

# Validation structure globale
validate_global_structure() {
    log_step "🏗️ VALIDATION STRUCTURE GLOBALE..."
    
    echo ""
    log_info "Vérification de l'équilibre des balises..."
    
    # Compter les balises principales
    local div_open=$(grep -o "<div" "$PAGE_FILE" | wc -l)
    local div_close=$(grep -o "</div>" "$PAGE_FILE" | wc -l)
    local button_open=$(grep -o "<button" "$PAGE_FILE" | wc -l)
    local button_close=$(grep -o "</button>" "$PAGE_FILE" | wc -l)
    
    echo "  📊 Balises <div>: $div_open ouvertures, $div_close fermetures"
    echo "  📊 Balises <button>: $button_open ouvertures, $button_close fermetures"
    
    if [[ $div_open -eq $div_close ]]; then
        log_success "✅ Balises div équilibrées"
    else
        log_warning "⚠️ Balises div déséquilibrées: +$((div_open - div_close))"
    fi
    
    if [[ $button_open -eq $button_close ]]; then
        log_success "✅ Balises button équilibrées"
    else
        log_warning "⚠️ Balises button déséquilibrées: +$((button_open - button_close))"
    fi
    
    echo ""
}

# Test de compilation final
final_compilation_test() {
    log_step "🎯 TEST DE COMPILATION FINAL..."
    
    if command -v npx &> /dev/null; then
        log_info "Test TypeScript complet..."
        
        local error_output=$(npx tsc --noEmit "$PAGE_FILE" 2>&1)
        local error_count=$(echo "$error_output" | grep -c "error TS" || echo "0")
        
        echo ""
        if [[ $error_count -eq 0 ]]; then
            log_success "🎉🎉🎉 COMPILATION TYPESCRIPT PARFAITE ! 🎉🎉🎉"
            return 0
        elif [[ $error_count -lt 10 ]]; then
            log_success "🎯 EXCELLENT PROGRÈS: Seulement $error_count erreurs restantes !"
            echo ""
            log_info "Erreurs restantes à corriger:"
            echo "$error_output" | grep "error TS" | head -5 | while read line; do
                echo "    $line"
            done
            return 1
        elif [[ $error_count -lt 20 ]]; then
            log_warning "📈 BON PROGRÈS: $error_count erreurs (était 37)"
            echo ""
            log_info "Erreurs principales restantes:"
            echo "$error_output" | grep "error TS" | head -3 | while read line; do
                echo "    $line"
            done
            return 2
        else
            log_error "🔄 Encore beaucoup d'erreurs: $error_count"
            echo ""
            log_info "Premières erreurs:"
            echo "$error_output" | grep "error TS" | head -2 | while read line; do
                echo "    $line"
            done
            return 3
        fi
    else
        log_warning "TypeScript non disponible pour le test"
        return 4
    fi
}

# Instructions finales basées sur le résultat
final_instructions() {
    local test_result=$1
    
    log_step "📋 INSTRUCTIONS FINALES..."
    
    echo ""
    case $test_result in
        0)
            echo "🎉🎉🎉 SUCCÈS COMPLET ! 🎉🎉🎉"
            echo ""
            echo "✅ MATH4CHILD EST MAINTENANT PRÊT !"
            echo ""
            echo "🚀 PROCHAINES ÉTAPES:"
            echo "  1. rm -rf .next"
            echo "  2. npm run dev"
            echo "  3. Ouvrez http://localhost:3000"
            echo "  4. Testez toutes les fonctionnalités"
            echo "  5. Lancez les tests Playwright:"
            echo "     npx playwright test tests/setup.spec.ts"
            ;;
        1)
            echo "🎯 QUASI-SUCCÈS ! Correction finale requise"
            echo ""
            echo "📝 ÉTAPES FINALES:"
            echo "  1. code apps/math4child/src/app/page.tsx"
            echo "  2. Appuyez sur F8 pour naviguer entre les erreurs"
            echo "  3. Corrigez les dernières erreurs (< 10)"
            echo "  4. Sauvegardez et testez"
            ;;
        2|3)
            echo "📈 PROGRÈS SIGNIFICATIF ! Continuation requise"
            echo ""
            echo "🔄 PROCHAINES ÉTAPES:"
            echo "  1. Relancez: npx tsc --noEmit $PAGE_FILE"
            echo "  2. Identifiez les patterns d'erreurs restants"
            echo "  3. Corrigez manuellement les plus critiques"
            echo "  4. Relancez ce script si nécessaire"
            ;;
        *)
            echo "🔧 CONTINUATION NÉCESSAIRE"
            echo ""
            echo "💡 SUGGESTIONS:"
            echo "  1. Vérifiez les erreurs avec VS Code"
            echo "  2. Utilisez TypeScript Error Lens extension"
            echo "  3. Corrigez ligne par ligne"
            ;;
    esac
    
    echo ""
}

# Résumé complet avec métriques
comprehensive_summary() {
    local test_result=$1
    local initial_errors=117
    local after_onclick=37
    local final_errors=$(npx tsc --noEmit "$PAGE_FILE" 2>&1 | grep -c "error TS" 2>/dev/null || echo "N/A")
    
    echo ""
    echo "📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊"
    echo ""
    log_success "RÉSUMÉ COMPLET DE LA CORRECTION MATH4CHILD"
    echo ""
    echo "🎯 PROGRESSION DES ERREURS:"
    echo "  🔴 Erreurs initiales: $initial_errors"
    echo "  🟡 Après correction onClick: $after_onclick (-$((initial_errors - after_onclick)))"
    echo "  🟢 Erreurs finales: $final_errors"
    echo ""
    
    if [[ "$final_errors" != "N/A" ]]; then
        local total_fixed=$((initial_errors - final_errors))
        local success_rate=$((total_fixed * 100 / initial_errors))
        echo "✅ TAUX DE RÉUSSITE: $success_rate% ($total_fixed/$initial_errors erreurs corrigées)"
    fi
    
    echo ""
    echo "🛠️  CORRECTIONS APPLIQUÉES:"
    echo "  • Prix optimaux Math4Child"
    echo "  • Niveaux scolaires corrigés"
    echo "  • Profils optimisés"
    echo "  • Dropdown des langues"
    echo "  • Patterns onClick malformés"
    echo "  • Expressions className vides"
    echo "  • Structure JSX basique"
    echo "  • Balises fermantes manquantes"
    echo ""
    echo "💾 SAUVEGARDES DISPONIBLES:"
    echo "  📁 $(ls -1 apps/math4child/src/app/page.tsx.*backup* 2>/dev/null | tail -3 | while read f; do echo "    $f"; done)"
    echo ""
    echo "📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊📊"
    echo ""
}

# Fonction principale
main() {
    echo ""
    echo "🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧"
    echo ""
    log_info "SCRIPT FINAL DE CORRECTION STRUCTURE JSX MATH4CHILD"
    echo ""
    echo "🎯 Objectif: Éliminer les dernières erreurs TypeScript"
    echo "📊 Erreurs actuelles: ~37 (était 117)"
    echo "🔧 Focus: Balises JSX non fermées et expressions vides"
    echo ""
    echo "🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧"
    echo ""
    
    # Vérification initiale
    if [[ ! -f "$PAGE_FILE" ]]; then
        log_error "Fichier $PAGE_FILE non trouvé !"
        exit 1
    fi
    
    # Exécution des corrections
    analyze_remaining_errors
    fix_jsx_closing_tags
    fix_specific_problematic_lines
    validate_global_structure
    
    # Test final et instructions
    final_compilation_test
    local test_result=$?
    
    final_instructions $test_result
    comprehensive_summary $test_result
    
    return $test_result
}

# Exécution
main "$@"