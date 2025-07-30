#!/bin/bash

# Script de mise à jour partielle - Remplace seulement la section des abonnements
# Garde le header, navigation et autres éléments existants

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

# Créer une sauvegarde avec timestamp
create_backup() {
    log_info "Création d'une sauvegarde..."
    
    BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Trouver le fichier de page principal
    PAGE_FILES=(
        "apps/math4child/src/app/page.tsx"
        "apps/math4child/src/pages/index.tsx"
        "apps/math4child/src/components/HomePage.tsx"
        "apps/math4child/src/components/ImprovedHomePage.tsx"
    )
    
    for file in "${PAGE_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$BACKUP_DIR/$(basename $file).backup"
            MAIN_PAGE="$file"
            break
        fi
    done
    
    if [[ -z "$MAIN_PAGE" ]]; then
        log_error "Aucun fichier de page trouvé à sauvegarder"
        exit 1
    fi
    
    log_success "Sauvegarde créée dans $BACKUP_DIR"
}

# Restaurer la page originale depuis la sauvegarde
restore_original_page() {
    log_info "Restauration de la page originale..."
    
    # Chercher la sauvegarde la plus récente
    LATEST_BACKUP=$(ls -td backup_* 2>/dev/null | head -1)
    
    if [[ -z "$LATEST_BACKUP" ]]; then
        log_error "Aucune sauvegarde trouvée"
        exit 1
    fi
    
    # Restaurer le fichier
    BACKUP_FILE=$(find "$LATEST_BACKUP" -name "*.backup" | head -1)
    if [[ -f "$BACKUP_FILE" ]]; then
        cp "$BACKUP_FILE" "$MAIN_PAGE"
        log_success "Page originale restaurée depuis $BACKUP_FILE"
    else
        log_error "Fichier de sauvegarde introuvable"
        exit 1
    fi
}

# Mettre à jour seulement la section des abonnements
update_pricing_section_only() {
    log_info "Mise à jour de la section des abonnements uniquement..."
    
    # Trouver le fichier de page principal
    PAGE_FILES=(
        "apps/math4child/src/app/page.tsx"
        "apps/math4child/src/pages/index.tsx"
        "apps/math4child/src/components/HomePage.tsx"
        "apps/math4child/src/components/ImprovedHomePage.tsx"
    )
    
    MAIN_PAGE=""
    for file in "${PAGE_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            MAIN_PAGE="$file"
            log_info "Page trouvée: $file"
            break
        fi
    done
    
    if [[ -z "$MAIN_PAGE" ]]; then
        log_error "Aucun fichier de page trouvé"
        exit 1
    fi
    
    # Créer le composant de pricing optimal
    cat > temp_pricing_component.tsx << 'EOF'
// Composant des plans optimaux Math4Child
const OptimalPricingSection = () => {
  const [selectedPeriod, setSelectedPeriod] = useState<'monthly' | 'quarterly' | 'annual'>('monthly');
  const [loading, setLoading] = useState<string | null>(null);

  // Plans optimaux Math4Child
  const OPTIMAL_PRICING_PLANS: Record<string, any[]> = {
    monthly: [
      {
        id: 'gratuit',
        name: 'Gratuit',
        price: 0,
        period: 'monthly',
        profiles: 1,
        features: [
          '1 profil enfant',
          'Accès Niveau 1 seulement',
          '10 exercices par jour',
          'Suivi de base des progrès'
        ],
        button: 'Commencer gratuitement',
        color: 'gray'
      },
      {
        id: 'famille',
        name: 'Famille',
        price: 6.99,
        originalPrice: 9.99,
        savings: 'Économisez 30%',
        period: 'monthly',
        profiles: 5,
        features: [
          '5 profils enfants',
          'Tous les niveaux 1 → 5',
          'Exercices illimités',
          'Suivi détaillé des 100 bonnes réponses',
          'Statistiques par opération',
          'Rapports de progression'
        ],
        button: 'Choisir ce plan',
        color: 'blue',
        popular: true
      },
      {
        id: 'premium',
        name: 'Premium',
        price: 4.99,
        originalPrice: 6.99,
        savings: 'Économisez 28%',
        period: 'monthly',
        profiles: 2,
        features: [
          '2 profils enfants',
          'Tous les niveaux + exercices bonus',
          'Mode révision niveaux validés',
          'Défis chronométrés',
          'Analyse détaillée des erreurs',
          'Recommandations personnalisées'
        ],
        button: 'Choisir ce plan',
        color: 'purple'
      },
      {
        id: 'ecole',
        name: 'École',
        price: 24.99,
        originalPrice: 29.99,
        savings: 'Économisez 20%',
        period: 'monthly',
        profiles: 30,
        features: [
          '30 profils élèves',
          'Gestion par niveaux (1 à 5)',
          'Tableau de bord enseignant',
          'Suivi collectif des validations',
          'Attribution d\'exercices ciblés',
          'Rapports de classe détaillés',
          'Support pédagogique dédié'
        ],
        button: 'Choisir ce plan',
        color: 'green'
      }
    ],
    quarterly: [
      {
        id: 'gratuit',
        name: 'Gratuit',
        price: 0,
        period: 'quarterly',
        profiles: 1,
        features: [
          '1 profil enfant',
          'Accès Niveau 1 seulement',
          '10 exercices par jour',
          'Suivi de base des progrès'
        ],
        button: 'Commencer gratuitement',
        color: 'gray'
      },
      {
        id: 'famille',
        name: 'Famille',
        price: 18.87,
        originalPrice: 29.97,
        savings: 'Économisez 37%',
        period: 'quarterly',
        profiles: 5,
        features: [
          '5 profils enfants',
          'Tous les niveaux 1 → 5',
          'Exercices illimités',
          'Suivi détaillé des 100 bonnes réponses',
          'Statistiques par opération',
          'Rapports de progression'
        ],
        button: 'Choisir ce plan',
        color: 'blue',
        popular: true
      },
      {
        id: 'premium',
        name: 'Premium',
        price: 13.47,
        originalPrice: 20.97,
        savings: 'Économisez 36%',
        period: 'quarterly',
        profiles: 2,
        features: [
          '2 profils enfants',
          'Tous les niveaux + exercices bonus',
          'Mode révision niveaux validés',
          'Défis chronométrés',
          'Analyse détaillée des erreurs',
          'Recommandations personnalisées'
        ],
        button: 'Choisir ce plan',
        color: 'purple'
      },
      {
        id: 'ecole',
        name: 'École',
        price: 67.47,
        originalPrice: 89.97,
        savings: 'Économisez 25%',
        period: 'quarterly',
        profiles: 30,
        features: [
          '30 profils élèves',
          'Gestion par niveaux (1 à 5)',
          'Tableau de bord enseignant',
          'Suivi collectif des validations',
          'Attribution d\'exercices ciblés',
          'Rapports de classe détaillés',
          'Support pédagogique dédié'
        ],
        button: 'Choisir ce plan',
        color: 'green'
      }
    ],
    annual: [
      {
        id: 'gratuit',
        name: 'Gratuit',
        price: 0,
        period: 'annual',
        profiles: 1,
        features: [
          '1 profil enfant',
          'Accès Niveau 1 seulement',
          '10 exercices par jour',
          'Suivi de base des progrès'
        ],
        button: 'Commencer gratuitement',
        color: 'gray'
      },
      {
        id: 'famille',
        name: 'Famille',
        price: 58.32,
        originalPrice: 119.88,
        savings: 'Économisez 51%',
        period: 'annual',
        profiles: 5,
        features: [
          '5 profils enfants',
          'Tous les niveaux 1 → 5',
          'Exercices illimités',
          'Suivi détaillé des 100 bonnes réponses',
          'Statistiques par opération',
          'Rapports de progression'
        ],
        button: 'Choisir ce plan',
        color: 'blue',
        popular: true
      },
      {
        id: 'premium',
        name: 'Premium',
        price: 41.94,
        originalPrice: 83.88,
        savings: 'Économisez 50%',
        period: 'annual',
        profiles: 2,
        features: [
          '2 profils enfants',
          'Tous les niveaux + exercices bonus',
          'Mode révision niveaux validés',
          'Défis chronométrés',
          'Analyse détaillée des erreurs',
          'Recommandations personnalisées',
          'Mode hors-ligne complet'
        ],
        button: 'Choisir ce plan',
        color: 'purple'
      },
      {
        id: 'ecole',
        name: 'École',
        price: 209.93,
        originalPrice: 359.88,
        savings: 'Économisez 42%',
        period: 'annual',
        profiles: 30,
        features: [
          '30 profils élèves',
          'Gestion par niveaux (1 à 5)',
          'Tableau de bord enseignant',
          'Suivi collectif des validations',
          'Attribution d\'exercices ciblés',
          'Rapports de classe détaillés',
          'Support pédagogique dédié'
        ],
        button: 'Choisir ce plan',
        color: 'green'
      }
    ]
  };

  const handlePlanSelect = async (planId: string) => {
    setLoading(planId);
    try {
      console.log(`Plan sélectionné: ${planId}, Période: ${selectedPeriod}`);
      await new Promise(resolve => setTimeout(resolve, 1000));
      alert(`Plan ${planId} sélectionné pour la période ${selectedPeriod}`);
    } catch (error) {
      console.error('Erreur lors de la sélection du plan:', error);
    } finally {
      setLoading(null);
    }
  };

  const plans = OPTIMAL_PRICING_PLANS[selectedPeriod];

  const getPeriodLabel = (period: string) => {
    switch (period) {
      case 'monthly': return 'Mensuel';
      case 'quarterly': return 'Trimestriel';
      case 'annual': return 'Annuel';
      default: return 'Mensuel';
    }
  };

  const getColorClasses = (color: string, isPopular: boolean = false) => {
    const baseClasses = {
      gray: 'border-gray-200 bg-gray-50',
      blue: 'border-blue-200 bg-blue-50',
      purple: 'border-purple-200 bg-purple-50',
      green: 'border-green-200 bg-green-50'
    };

    const popularClasses = {
      gray: 'border-gray-400 bg-gray-100',
      blue: 'border-blue-400 bg-blue-100 ring-2 ring-blue-400',
      purple: 'border-purple-400 bg-purple-100 ring-2 ring-purple-400',
      green: 'border-green-400 bg-green-100'
    };

    return isPopular ? popularClasses[color as keyof typeof popularClasses] : baseClasses[color as keyof typeof baseClasses];
  };

  return (
    <>
      {/* Section des abonnements */}
      <div className="text-center mb-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          Choisissez votre abonnement
        </h1>
      </div>

      {/* Sélecteur de période */}
      <div className="flex justify-center mb-8">
        <div className="bg-gray-100 p-1 rounded-lg flex">
          <button
            onClick={() => setSelectedPeriod('monthly')}
            className={`px-6 py-2 rounded-md font-medium transition-all ${
              selectedPeriod === 'monthly'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-blue-600'
            }`}
          >
            Mensuel
          </button>
          <button
            onClick={() => setSelectedPeriod('quarterly')}
            className={`px-6 py-2 rounded-md font-medium transition-all relative ${
              selectedPeriod === 'quarterly'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-blue-600'
            }`}
          >
            Trimestriel
            <span className="ml-2 text-xs bg-green-500 text-white px-2 py-1 rounded">-10%</span>
          </button>
          <button
            onClick={() => setSelectedPeriod('annual')}
            className={`px-6 py-2 rounded-md font-medium transition-all relative ${
              selectedPeriod === 'annual'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-gray-600 hover:text-blue-600'
            }`}
          >
            Annuel
            <span className="ml-2 text-xs bg-green-500 text-white px-2 py-1 rounded">-25%</span>
          </button>
        </div>
      </div>

      {/* Grille des plans */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {plans.map((plan) => (
          <div
            key={plan.id}
            data-plan={plan.id}
            data-testid={`plan-${plan.id}`}
            className={`relative rounded-2xl border-2 p-6 transition-all hover:shadow-lg ${getColorClasses(plan.color, plan.popular)}`}
          >
            {/* Badge populaire */}
            {plan.popular && (
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                  Populaire
                </span>
              </div>
            )}

            {/* En-tête du plan */}
            <div className="text-center mb-6">
              <h3 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h3>
              <div className="mb-2">
                {plan.price === 0 ? (
                  <span className="text-3xl font-bold text-blue-600">Gratuit</span>
                ) : (
                  <div className="flex items-center justify-center">
                    <span className="text-3xl font-bold text-gray-900" data-testid="price">
                      {plan.price}€
                    </span>
                    <span className="text-gray-600 ml-1">
                      /{selectedPeriod === 'monthly' ? 'mois' : selectedPeriod === 'quarterly' ? 'trim' : 'an'}
                    </span>
                  </div>
                )}
              </div>

              {/* Prix barré et économies */}
              {plan.originalPrice && plan.originalPrice > plan.price && (
                <div className="text-center">
                  <span className="text-sm text-gray-500 line-through">
                    {plan.originalPrice}€
                  </span>
                  {plan.savings && (
                    <div className="text-sm text-green-600 font-medium mt-1">
                      {plan.savings}
                    </div>
                  )}
                </div>
              )}

              <div className="text-sm text-gray-600 mt-2">
                {plan.profiles} profil{plan.profiles > 1 ? 's' : ''}
              </div>
            </div>

            {/* Fonctionnalités */}
            <ul className="space-y-3 mb-6">
              {plan.features.map((feature, index) => (
                <li key={index} className="flex items-start">
                  <svg
                    className="w-5 h-5 text-green-500 mt-0.5 mr-3 flex-shrink-0"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path
                      fillRule="evenodd"
                      d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                      clipRule="evenodd"
                    />
                  </svg>
                  <span className="text-sm text-gray-700">{feature}</span>
                </li>
              ))}
            </ul>

            {/* Bouton d'action */}
            <button
              onClick={() => handlePlanSelect(plan.id)}
              disabled={loading === plan.id}
              className={`w-full py-3 px-4 rounded-lg font-medium transition-all ${
                plan.popular
                  ? 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-2 focus:ring-blue-500'
                  : 'bg-gray-900 text-white hover:bg-gray-800 focus:ring-2 focus:ring-gray-500'
              } ${loading === plan.id ? 'opacity-50 cursor-not-allowed' : ''}`}
            >
              {loading === plan.id ? (
                <div className="flex items-center justify-center">
                  <div className="animate-spin rounded-full h-4 w-4 border-2 border-white border-t-transparent mr-2"></div>
                  Chargement...
                </div>
              ) : (
                plan.button
              )}
            </button>
          </div>
        ))}
      </div>

      {/* Section de sélection actuelle */}
      <div className="bg-gray-50 rounded-lg p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Votre sélection</h3>
        <div className="flex items-center justify-between">
          <div>
            <span className="text-sm text-gray-600">Plan:</span>
            <span className="font-medium text-gray-900 ml-2">Gratuit</span>
          </div>
          <div>
            <span className="text-sm text-gray-600">Période:</span>
            <span className="font-medium text-gray-900 ml-2">{getPeriodLabel(selectedPeriod)}</span>
          </div>
        </div>
        <p className="text-sm text-gray-500 mt-2">1 profils inclus</p>
      </div>
    </>
  );
};
EOF

    # Utiliser un script Python pour faire la mise à jour précise
    python3 << 'PYTHON_SCRIPT'
import re
import sys

try:
    # Lire le fichier de page
    with open(sys.argv[1], 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Lire le nouveau composant
    with open('temp_pricing_component.tsx', 'r', encoding='utf-8') as f:
        new_pricing = f.read()
    
    # Pattern pour trouver la section des abonnements
    patterns = [
        # Pattern 1: Section avec titre "Choisissez votre abonnement"
        r'(<div[^>]*>\s*<h1[^>]*>Choisissez votre abonnement</h1>.*?</div>\s*</div>\s*</div>)',
        # Pattern 2: Section avec grille de plans
        r'(<div[^>]*grid[^>]*>.*?</div>\s*</div>\s*</div>)',
        # Pattern 3: Plus général - section contenant "9.99€" et "14.99€"
        r'(<div[^>]*>.*?9\.99€.*?14\.99€.*?</div>)',
    ]
    
    updated = False
    for pattern in patterns:
        if re.search(pattern, content, re.DOTALL | re.IGNORECASE):
            # Remplacer la section trouvée
            content = re.sub(pattern, f'<OptimalPricingSection />', content, flags=re.DOTALL | re.IGNORECASE)
            updated = True
            break
    
    if not updated:
        # Si aucun pattern ne correspond, insérer avant la fin du dernier div
        content = content.replace('</div>\n    </div>\n  );', f'      <OptimalPricingSection />\n    </div>\n  );')
    
    # Ajouter les imports useState si pas présent
    if 'useState' not in content:
        content = re.sub(r"import React", "import React, { useState }", content)
    
    # Insérer le composant au début de la fonction
    function_start = re.search(r'export default function \w+\(\)[^{]*{', content)
    if function_start:
        insert_pos = function_start.end()
        content = content[:insert_pos] + '\n' + new_pricing + '\n' + content[insert_pos:]
    
    # Écrire le fichier mis à jour
    with open(sys.argv[1], 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("SUCCESS: Fichier mis à jour avec succès")
    
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)
PYTHON_SCRIPT "$MAIN_PAGE"

    # Supprimer le fichier temporaire
    rm -f temp_pricing_component.tsx
    
    if [[ $? -eq 0 ]]; then
        log_success "Section des abonnements mise à jour avec les plans optimaux"
    else
        log_error "Erreur lors de la mise à jour"
        exit 1
    fi
}

# Afficher le menu
show_menu() {
    echo ""
    log_info "🚀 Script de mise à jour des plans Math4Child"
    echo ""
    echo "1) Mettre à jour seulement la section des abonnements (RECOMMANDÉ)"
    echo "2) Restaurer la page originale depuis la sauvegarde"
    echo "3) Quitter"
    echo ""
    read -p "Choisissez une option (1-3): " choice
}

# Fonction principale
main() {
    show_menu
    
    case $choice in
        1)
            create_backup
            update_pricing_section_only
            log_success "✅ Mise à jour terminée!"
            log_info "Rechargez votre page (F5) pour voir les changements"
            ;;
        2)
            restore_original_page
            log_success "✅ Page restaurée!"
            ;;
        3)
            log_info "Au revoir!"
            exit 0
            ;;
        *)
            log_error "Option invalide"
            exit 1
            ;;
    esac
}

# Exécution
main "$@"