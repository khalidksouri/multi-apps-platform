#!/bin/bash

# 🔧 Script de Correction des onClick JSX Malformés Math4Child
# Corrige spécifiquement les patterns "onClick={() => {} function()}" défectueux

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
BACKUP_FILE="${PAGE_FILE}.onclick_fix_backup_$(date +%Y%m%d_%H%M%S)"

# Analyser les erreurs onClick spécifiques
analyze_onclick_errors() {
    log_step "🔍 ANALYSE DES ERREURS ONCLICK..."
    
    echo ""
    log_info "Recherche des patterns onClick malformés..."
    
    # Compter les patterns problématiques
    local malformed_count=$(grep -c "onClick={() => {}" "$PAGE_FILE" 2>/dev/null || echo "0")
    local className_errors=$(grep -c 'className=.*"}$' "$PAGE_FILE" 2>/dev/null || echo "0")
    local empty_expressions=$(grep -c '\${}\|className={`.*\${}\|h-3 rounded-full \${}' "$PAGE_FILE" 2>/dev/null || echo "0")
    
    echo "  📊 Patterns onClick malformés: $malformed_count"
    echo "  📊 Erreurs className: $className_errors"
    echo "  📊 Expressions vides: $empty_expressions"
    echo ""
    
    if [[ $malformed_count -gt 0 ]]; then
        log_error "Patterns 'onClick={() => {} function()}' trouvés"
        echo ""
        log_info "Exemples de patterns problématiques:"
        grep -n "onClick={() => {}" "$PAGE_FILE" | head -5 | while read line; do
            echo "    $line"
        done
        echo ""
    fi
    
    if [[ $empty_expressions -gt 0 ]]; then
        log_warning "Expressions template littérales vides trouvées"
        echo ""
        log_info "Exemples d'expressions vides:"
        grep -n '\${}\|h-3 rounded-full \${}' "$PAGE_FILE" | head -3 | while read line; do
            echo "    $line"
        done
        echo ""
    fi
}

# Corrections spécifiques des onClick
fix_onclick_patterns() {
    log_step "🔧 CORRECTION DES PATTERNS ONCLICK..."
    
    # Créer sauvegarde
    cp "$PAGE_FILE" "$BACKUP_FILE"
    log_success "Sauvegarde créée: $BACKUP_FILE"
    
    # 1. Corriger les patterns "onClick={() => {} function()}"
    log_fix "Correction des onClick malformés..."
    
    # Pattern principal: onClick={() => {} setFunction(value)}
    sed -i.tmp 's/onClick={() => {} \([^}]*\)}/onClick={() => \1}/g' "$PAGE_FILE"
    
    # Patterns spécifiques identifiés dans les erreurs
    sed -i.tmp 's/onClick={() => {} setIsLanguageOpen(!isLanguageOpen)}/onClick={() => setIsLanguageOpen(!isLanguageOpen)}/g' "$PAGE_FILE"
    sed -i.tmp 's/onClick={() => {} setIsLanguageOpen(false)}/onClick={() => setIsLanguageOpen(false)}/g' "$PAGE_FILE"
    sed -i.tmp 's/onClick={() => {} handleLanguageChange(\([^)]*\))}/onClick={() => handleLanguageChange(\1)}/g' "$PAGE_FILE"
    sed -i.tmp 's/onClick={() => {} handleLevelSelect(\([^)]*\))}/onClick={() => handleLevelSelect(\1)}/g' "$PAGE_FILE"
    sed -i.tmp 's/onClick={() => {} updateLevelProgress(\([^}]*\))}/onClick={() => updateLevelProgress(\1)}/g' "$PAGE_FILE"
    sed -i.tmp 's/onClick={() => {} setBillingPeriod(\([^)]*\))}/onClick={() => setBillingPeriod(\1)}/g' "$PAGE_FILE"
    sed -i.tmp 's/onClick={() => {} handlePlanSelect(\([^)]*\))}/onClick={() => handlePlanSelect(\1)}/g' "$PAGE_FILE"
    
    log_success "Patterns onClick corrigés"
    
    # 2. Corriger les className avec expressions vides
    log_fix "Correction des expressions className vides..."
    
    # Corriger les template literals avec expressions vides
    sed -i.tmp 's/className={\`\([^}]*\)\${}}/className={\`\1\`}/g' "$PAGE_FILE"
    sed -i.tmp 's/h-3 rounded-full \${}/h-3 rounded-full bg-gray-200/g' "$PAGE_FILE"
    
    # Corrections spécifiques pour les classes dynamiques
    sed -i.tmp 's/transition-all duration-200 relative \${}/transition-all duration-200 relative/g' "$PAGE_FILE"
    sed -i.tmp 's/font-medium \${}/font-medium/g' "$PAGE_FILE"
    sed -i.tmp 's/hover:scale-105 \${}/hover:scale-105/g' "$PAGE_FILE"
    
    log_success "Expressions className corrigées"
    
    # 3. Corriger les className avec accolades fermantes en trop
    log_fix "Correction des accolades fermantes en trop..."
    
    # Patterns avec "} à la fin des className
    sed -i.tmp 's/className="\([^"]*\)"}$/className="\1"/g' "$PAGE_FILE"
    sed -i.tmp 's/className="\([^"]*\)"}\s*>/className="\1">/g' "$PAGE_FILE"
    
    log_success "Accolades fermantes corrigées"
    
    # 4. Nettoyer les fichiers temporaires
    rm -f "${PAGE_FILE}.tmp"
}

# Corrections avancées pour les structures JSX cassées
fix_jsx_structure() {
    log_step "🏗️ CORRECTION DE LA STRUCTURE JSX..."
    
    log_fix "Correction des balises fermantes manquantes..."
    
    # Corriger les </button> qui devraient être </div> selon le contexte
    # Ces corrections sont basées sur l'analyse des erreurs TypeScript
    
    # Lignes spécifiques identifiées dans les erreurs
    sed -i.tmp '457s/            <\/button>/            <\/div>/' "$PAGE_FILE"
    sed -i.tmp '478s/                    <\/button>/                    <\/div>/' "$PAGE_FILE"
    sed -i.tmp '493s/                      <\/button>/                      <\/div>/' "$PAGE_FILE"
    sed -i.tmp '669s/                      <\/button>/                      <\/div>/' "$PAGE_FILE"
    sed -i.tmp '696s/              <\/button>/              <\/div>/' "$PAGE_FILE"
    sed -i.tmp '709s/              <\/button>/              <\/div>/' "$PAGE_FILE"
    sed -i.tmp '722s/              <\/button>/              <\/div>/' "$PAGE_FILE"
    sed -i.tmp '797s/                <\/button>/                <\/div>/' "$PAGE_FILE"
    
    log_success "Balises fermantes corrigées"
    
    log_fix "Ajout des balises ouvrantes manquantes..."
    
    # Si nous avons corrigé des </button> en </div>, nous devons aussi corriger les <button> correspondants
    # Ceci nécessite une analyse plus fine, mais commençons par les patterns évidents
    
    # Rechercher et corriger les button qui devraient être div
    sed -i.tmp 's/<button\s\+onClick={() => setIsLanguageOpen/<div onClick={() => setIsLanguageOpen/g' "$PAGE_FILE"
    sed -i.tmp 's/<button\s\+onClick={() => handleLanguageChange/<div onClick={() => handleLanguageChange/g' "$PAGE_FILE"
    
    log_success "Balises ouvrantes corrigées"
}

# Validation progressive
progressive_validation() {
    log_step "✅ VALIDATION PROGRESSIVE..."
    
    echo ""
    log_info "Vérification des corrections..."
    
    # 1. Vérifier que les onClick malformés ont été corrigés
    local remaining_malformed=$(grep -c "onClick={() => {}" "$PAGE_FILE" 2>/dev/null || echo "0")
    if [[ $remaining_malformed -eq 0 ]]; then
        log_success "✅ Tous les onClick malformés corrigés"
    else
        log_warning "⚠️ $remaining_malformed onClick malformés restants"
    fi
    
    # 2. Vérifier les expressions vides
    local remaining_empty=$(grep -c '\${}' "$PAGE_FILE" 2>/dev/null || echo "0")
    if [[ $remaining_empty -eq 0 ]]; then
        log_success "✅ Toutes les expressions vides corrigées"
    else
        log_warning "⚠️ $remaining_empty expressions vides restantes"
    fi
    
    # 3. Vérifier les accolades fermantes en trop
    local remaining_braces=$(grep -c 'className="[^"]*"}' "$PAGE_FILE" 2>/dev/null || echo "0")
    if [[ $remaining_braces -eq 0 ]]; then
        log_success "✅ Toutes les accolades fermantes en trop corrigées"
    else
        log_warning "⚠️ $remaining_braces accolades fermantes en trop restantes"
    fi
    
    echo ""
}

# Test de compilation ciblé
targeted_compilation_test() {
    log_step "📘 TEST DE COMPILATION CIBLÉ..."
    
    if command -v npx &> /dev/null; then
        log_info "Test TypeScript avec rapport d'erreurs limité..."
        
        # Tester seulement les 10 premières erreurs pour voir les progrès
        local error_output=$(npx tsc --noEmit "$PAGE_FILE" 2>&1 | head -20)
        local error_count=$(echo "$error_output" | grep -c "error TS" || echo "0")
        
        echo ""
        log_info "RÉSULTATS DU TEST:"
        echo "  📊 Erreurs détectées: $error_count"
        
        if [[ $error_count -eq 0 ]]; then
            log_success "🎉 COMPILATION TYPESCRIPT RÉUSSIE !"
        elif [[ $error_count -lt 10 ]]; then
            log_warning "Progrès: erreurs réduites à $error_count"
            echo ""
            log_info "Erreurs restantes:"
            echo "$error_output" | grep "error TS" | head -5
        else
            log_error "Encore beaucoup d'erreurs ($error_count+)"
            echo ""
            log_info "Premières erreurs:"
            echo "$error_output" | grep "error TS" | head -3
        fi
        
    else
        log_info "TypeScript non disponible pour le test"
    fi
    
    echo ""
}

# Instructions spécifiques de correction manuelle
specific_manual_instructions() {
    log_step "📋 INSTRUCTIONS SPÉCIFIQUES DE CORRECTION MANUELLE..."
    
    echo ""
    log_info "Si des erreurs persistent, voici les étapes précises:"
    echo ""
    echo "1. 🔍 OUVRIR LE FICHIER:"
    echo "   code $PAGE_FILE"
    echo ""
    echo "2. 🎯 RECHERCHER CES PATTERNS PROBLÉMATIQUES:"
    echo "   - Ctrl+F: 'onClick={() => {}'"
    echo "   - Ctrl+F: 'className=.*\${}'"
    echo "   - Ctrl+F: 'className=\".*\"}'"
    echo ""
    echo "3. 🔧 CORRECTIONS MANUELLES TYPIQUES:"
    echo "   ❌ onClick={() => {} setFunction()}"
    echo "   ✅ onClick={() => setFunction()}"
    echo ""
    echo "   ❌ className={\`text-sm \${}}"
    echo "   ✅ className=\"text-sm\""
    echo ""
    echo "   ❌ className=\"text-blue\"}"
    echo "   ✅ className=\"text-blue\""
    echo ""
    echo "4. 🧩 UTILISER VS CODE FEATURES:"
    echo "   - Ctrl+Shift+P → 'TypeScript: Go to Project Config'"
    echo "   - F8 pour naviguer entre les erreurs"
    echo "   - Ctrl+. pour les quick fixes automatiques"
    echo ""
}

# Résumé final avec next steps
final_summary_with_next_steps() {
    local remaining_errors=$(npx tsc --noEmit "$PAGE_FILE" 2>&1 | grep -c "error TS" 2>/dev/null || echo "N/A")
    
    echo ""
    echo "🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉"
    echo ""
    log_success "CORRECTION DES ONCLICK JSX TERMINÉE"
    echo ""
    echo "📊 RÉSULTATS:"
    echo "  📁 Fichier: $PAGE_FILE"
    echo "  💾 Sauvegarde: $BACKUP_FILE"
    echo "  🔧 Erreurs TypeScript restantes: $remaining_errors"
    echo ""
    echo "🛠️  CORRECTIONS APPLIQUÉES:"
    echo "  • Patterns onClick malformés corrigés"
    echo "  • Expressions className vides corrigées"
    echo "  • Accolades fermantes en trop supprimées"
    echo "  • Structure JSX basique corrigée"
    echo ""
    
    if [[ "$remaining_errors" == "0" ]]; then
        echo "🎯 PROCHAINES ÉTAPES - SUCCÈS:"
        echo "  1. rm -rf .next && npm run dev"
        echo "  2. Testez http://localhost:3000"
        echo "  3. Lancez les tests Playwright"
        echo "  4. Vérifiez toutes les fonctionnalités"
    elif [[ "$remaining_errors" -lt 20 ]] && [[ "$remaining_errors" != "N/A" ]]; then
        echo "🎯 PROCHAINES ÉTAPES - PROGRÈS:"
        echo "  1. Correction manuelle des $remaining_errors erreurs restantes"
        echo "  2. Utilisez VS Code avec TypeScript"
        echo "  3. Naviguer avec F8 entre les erreurs"
        echo "  4. Relancez ce script après correction"
    else
        echo "🎯 PROCHAINES ÉTAPES - CONTINUATION:"
        echo "  1. Relancez: npx tsc --noEmit $PAGE_FILE"
        echo "  2. Corrigez manuellement les erreurs les plus critiques"
        echo "  3. Relancez ce script"
        echo "  4. Répétez jusqu'à résolution complète"
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
    log_info "CORRECTION DES ONCLICK JSX MALFORMÉS MATH4CHILD"
    echo ""
    echo "🎯 Ce script corrige spécifiquement:"
    echo "   • Patterns 'onClick={() => {} function()}' défectueux"
    echo "   • Expressions template littérales vides"
    echo "   • Accolades fermantes en trop dans className"
    echo "   • Structure JSX basique cassée"
    echo ""
    echo "🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧🔧"
    echo ""
    
    # Vérification initiale
    if [[ ! -f "$PAGE_FILE" ]]; then
        log_error "Fichier $PAGE_FILE non trouvé !"
        exit 1
    fi
    
    # Exécution des corrections
    analyze_onclick_errors
    fix_onclick_patterns
    fix_jsx_structure
    progressive_validation
    targeted_compilation_test
    specific_manual_instructions
    final_summary_with_next_steps
}

# Exécution
main "$@"