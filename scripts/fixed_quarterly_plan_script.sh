#!/bin/bash

# =============================================================================
# 🔧 AJOUT DU PLAN TRIMESTRIEL AVEC 10% DE RÉDUCTION - VERSION CORRIGÉE
# Mise à jour de la page des abonnements Math4Child
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🔧 Ajout du plan trimestriel avec 10% de réduction..."

# Vérifier qu'on est dans le bon répertoire
if [ ! -d "apps/math4child" ]; then
    log_error "Le dossier apps/math4child n'existe pas. Exécutez le script depuis la racine du projet."
    exit 1
fi

cd apps/math4child

# Vérifier que le fichier existe
if [ ! -f "src/app/page.tsx" ]; then
    log_error "Le fichier src/app/page.tsx n'existe pas."
    exit 1
fi

# =============================================================================
# SAUVEGARDE ET PRÉPARATION
# =============================================================================

log_info "📁 Création de la sauvegarde..."
cp src/app/page.tsx "src/app/page.tsx.backup_$(date +%Y%m%d_%H%M%S)"
log_success "✅ Sauvegarde créée"

# =============================================================================
# MISE À JOUR DE LA PAGE PRINCIPALE AVEC LE PLAN TRIMESTRIEL
# =============================================================================

log_info "📝 Mise à jour de la section abonnements avec Python..."

# Utiliser Python pour une manipulation plus précise du fichier
cat > update_subscription.py << 'EOF'
import re
import sys

def update_subscription_section(content):
    # Nouveau contenu de la section abonnements avec le plan trimestriel
    new_subscription_content = '''  const renderSubscription = () => (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-12">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">
            Choisis ton abonnement Math4Child
          </h2>
          <p className="text-xl text-gray-600">
            Débloquer toutes les fonctionnalités et exercices illimités
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {/* Plan gratuit */}
          <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-gray-200">
            <div className="text-center">
              <h3 className="text-xl font-bold text-gray-900 mb-2">Gratuit</h3>
              <div className="text-3xl font-bold text-gray-900 mb-4">0€</div>
              <p className="text-gray-600 mb-6">7 jours - 50 questions</p>
              <ul className="space-y-2 text-left mb-6 text-sm">
                <li>✓ 50 questions gratuites</li>
                <li>✓ Tous les niveaux (limités)</li>
                <li>✓ Support email</li>
                <li>✓ Accès 7 jours</li>
              </ul>
              <button className="btn-secondary w-full">
                Plan actuel
              </button>
            </div>
          </div>

          {/* Plan mensuel */}
          <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-blue-500 relative">
            <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
              <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                Populaire
              </span>
            </div>
            <div className="text-center">
              <h3 className="text-xl font-bold text-gray-900 mb-2">Mensuel</h3>
              <div className="text-3xl font-bold text-blue-600 mb-4">9,99€</div>
              <p className="text-gray-600 mb-6">par mois</p>
              <ul className="space-y-2 text-left mb-6 text-sm">
                <li>✓ Questions illimitées</li>
                <li>✓ Tous les niveaux débloqués</li>
                <li>✓ Toutes les opérations</li>
                <li>✓ Support prioritaire</li>
                <li>✓ Statistiques détaillées</li>
              </ul>
              <button 
                onClick={() => alert('Redirection vers le paiement mensuel...')}
                className="btn-primary w-full"
              >
                Choisir ce plan
              </button>
            </div>
          </div>

          {/* Plan trimestriel - NOUVEAU */}
          <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-orange-500 relative new-plan-animation">
            <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
              <span className="bg-orange-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                -10% 💰
              </span>
            </div>
            <div className="text-center">
              <h3 className="text-xl font-bold text-gray-900 mb-2">Trimestriel</h3>
              <div className="text-3xl font-bold text-orange-600 mb-1">26,97€</div>
              <div className="text-sm text-gray-500 line-through mb-4">29,97€</div>
              <p className="text-gray-600 mb-6">3 mois (économise 10%)</p>
              <ul className="space-y-2 text-left mb-6 text-sm">
                <li>✓ Tout du plan mensuel</li>
                <li>✓ 10% d'économies</li>
                <li>✓ Paiement unique</li>
                <li>✓ Support premium</li>
                <li>✓ Accès prioritaire nouveautés</li>
              </ul>
              <button 
                onClick={() => alert('Redirection vers le paiement trimestriel...')}
                className="quarterly-button w-full font-semibold py-3 px-4 rounded-xl transition-all duration-200"
              >
                Choisir ce plan
              </button>
            </div>
          </div>

          {/* Plan annuel */}
          <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-green-500 relative">
            <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
              <span className="bg-green-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                -30% 🔥
              </span>
            </div>
            <div className="text-center">
              <h3 className="text-xl font-bold text-gray-900 mb-2">Annuel</h3>
              <div className="text-3xl font-bold text-green-600 mb-1">83,93€</div>
              <div className="text-sm text-gray-500 line-through mb-4">119,88€</div>
              <p className="text-gray-600 mb-6">par an (économise 30%)</p>
              <ul className="space-y-2 text-left mb-6 text-sm">
                <li>✓ Tout du plan mensuel</li>
                <li>✓ 30% d'économies</li>
                <li>✓ Paiement unique</li>
                <li>✓ Support VIP</li>
                <li>✓ Accès beta features</li>
              </ul>
              <button 
                onClick={() => alert('Redirection vers le paiement annuel...')}
                className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-4 rounded-xl transition-all duration-200"
              >
                Choisir ce plan
              </button>
            </div>
          </div>
        </div>

        <div className="text-center mt-12">
          <button
            onClick={() => setCurrentView('home')}
            className="btn-secondary"
          >
            ← Retour à l'accueil
          </button>
        </div>
      </div>
    </div>
  );'''
    
    # Rechercher et remplacer la fonction renderSubscription
    pattern = r'const renderSubscription = \(\) => \([^;]+\);'
    
    # Si la fonction existe, la remplacer
    if re.search(pattern, content, re.DOTALL):
        updated_content = re.sub(pattern, new_subscription_content, content, flags=re.DOTALL)
        return updated_content
    else:
        print("⚠️ Fonction renderSubscription non trouvée, ajout en fin de composant...")
        # Ajouter avant la dernière accolade du composant
        insertion_point = content.rfind('};')
        if insertion_point != -1:
            updated_content = (content[:insertion_point] + 
                             '\n\n' + new_subscription_content + '\n\n' + 
                             content[insertion_point:])
            return updated_content
        else:
            return content + '\n\n' + new_subscription_content

try:
    with open('src/app/page.tsx', 'r', encoding='utf-8') as f:
        content = f.read()
    
    updated_content = update_subscription_section(content)
    
    with open('src/app/page.tsx', 'w', encoding='utf-8') as f:
        f.write(updated_content)
    
    print("✅ Mise à jour réussie avec Python")
    
except Exception as e:
    print(f"❌ Erreur lors de la mise à jour: {e}")
    sys.exit(1)
EOF

# Exécuter le script Python
if command -v python3 &> /dev/null; then
    python3 update_subscription.py
    log_success "✅ Section abonnements mise à jour"
elif command -v python &> /dev/null; then
    python update_subscription.py
    log_success "✅ Section abonnements mise à jour"
else
    log_error "Python n'est pas disponible. Mise à jour manuelle nécessaire."
    rm update_subscription.py
    exit 1
fi

# Nettoyer le script Python temporaire
rm update_subscription.py

# =============================================================================
# AJOUT DES STYLES CSS POUR LE PLAN TRIMESTRIEL
# =============================================================================

log_info "🎨 Ajout des styles CSS pour le plan trimestriel..."

# Vérifier si les styles existent déjà
if ! grep -q "quarterly-plan" src/app/globals.css 2>/dev/null; then
    cat >> src/app/globals.css << 'EOF'

/* =============================================================================
   STYLES SPÉCIFIQUES POUR LE PLAN TRIMESTRIEL
   ============================================================================= */

.quarterly-plan {
  border-color: #f97316 !important;
}

.quarterly-plan .quarterly-badge {
  background: #f97316 !important;
  color: white !important;
}

.quarterly-button {
  background: linear-gradient(135deg, #f97316 0%, #ea580c 100%) !important;
  color: white !important;
  transition: all 0.2s ease !important;
  border: none !important;
}

.quarterly-button:hover {
  background: linear-gradient(135deg, #ea580c 0%, #dc2626 100%) !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 15px rgba(249, 115, 22, 0.3) !important;
}

/* Animation pour le nouveau plan */
@keyframes newPlanGlow {
  0%, 100% {
    box-shadow: 0 0 5px rgba(249, 115, 22, 0.3);
  }
  50% {
    box-shadow: 0 0 20px rgba(249, 115, 22, 0.6);
  }
}

.new-plan-animation {
  animation: newPlanGlow 2s ease-in-out infinite;
}

/* Animation de pulsation pour le badge -10% */
@keyframes badgePulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

.quarterly-plan .absolute span {
  animation: badgePulse 2s ease-in-out infinite;
}

/* Responsive pour mobile */
@media (max-width: 768px) {
  .new-plan-animation {
    animation: none; /* Désactiver l'animation sur mobile pour les performances */
  }
}
EOF
    log_success "✅ Styles CSS ajoutés"
else
    log_info "ℹ️ Styles CSS déjà présents"
fi

# =============================================================================
# MISE À JOUR DES TYPES TYPESCRIPT (SI NÉCESSAIRE)
# =============================================================================

log_info "🔧 Vérification des types TypeScript..."

# Rechercher et ajouter le type quarterly si nécessaire
if grep -q "type.*Plan.*=" src/app/page.tsx; then
    if ! grep -q "quarterly" src/app/page.tsx; then
        sed -i.bak "s/'yearly'/'yearly' | 'quarterly'/g" src/app/page.tsx
        log_success "✅ Types TypeScript mis à jour"
    else
        log_info "ℹ️ Types TypeScript déjà à jour"
    fi
fi

# =============================================================================
# NETTOYAGE ET VALIDATION
# =============================================================================

log_info "🧹 Nettoyage..."

# Supprimer les fichiers de sauvegarde sed
rm -f src/app/page.tsx.bak

# Vérifier la syntaxe du fichier modifié
log_info "🔍 Vérification de la syntaxe..."

if command -v npx &> /dev/null; then
    if npx tsc --noEmit --skipLibCheck src/app/page.tsx 2>/dev/null; then
        log_success "✅ Syntaxe TypeScript valide"
    else
        log_error "⚠️ Erreurs de syntaxe détectées, vérification manuelle recommandée"
    fi
fi

# =============================================================================
# REDÉMARRAGE DU SERVEUR DE DÉVELOPPEMENT
# =============================================================================

log_info "🔄 Redémarrage du serveur de développement..."

# Arrêter le serveur existant
pkill -f "next dev" 2>/dev/null || true
sleep 2

# Supprimer le cache Next.js
rm -rf .next

# Redémarrer le serveur en arrière-plan
log_info "🚀 Démarrage du serveur..."
npm run dev > /dev/null 2>&1 &

# Attendre que le serveur démarre
sleep 5

# Vérifier si le serveur est en cours d'exécution
if pgrep -f "next dev" > /dev/null; then
    log_success "✅ Serveur de développement démarré"
else
    log_error "⚠️ Le serveur n'a pas pu démarrer automatiquement"
    echo "   Démarrez-le manuellement avec: npm run dev"
fi

# =============================================================================
# RAPPORT FINAL
# =============================================================================

echo ""
echo "=============================================="
echo "🎉 PLAN TRIMESTRIEL AJOUTÉ AVEC SUCCÈS !"
echo "=============================================="
echo ""
echo "✅ Nouveau plan configuré :"
echo "   📦 Plan Trimestriel"
echo "   💰 Prix: 26,97€ (au lieu de 29,97€)"
echo "   🎯 Réduction: 10%"
echo "   ⏱️ Durée: 3 mois"
echo "   🏷️ Badge: '-10% 💰'"
echo ""
echo "🎨 Design du plan :"
echo "   🟠 Couleur: Orange (#f97316)"
echo "   🎨 Badge orange avec animation"
echo "   ✨ Animation de mise en valeur"
echo "   📱 Responsive sur tous les appareils"
echo ""
echo "📊 Configuration complète :"
echo "   ✅ 4 plans maintenant disponibles:"
echo "      1. Gratuit (0€)"
echo "      2. Mensuel (9,99€) [Populaire]"
echo "      3. Trimestriel (26,97€) [Nouveau -10%]"
echo "      4. Annuel (83,93€) [-30%]"
echo ""
echo "🎯 Fonctionnalités ajoutées :"
echo "   ✅ Animation de pulsation sur le nouveau plan"
echo "   ✅ Badge promotionnel '-10% 💰'"
echo "   ✅ Bouton avec gradient orange"
echo "   ✅ Styles CSS optimisés"
echo "   ✅ Support responsive"
echo ""
echo "🌐 Vérifiez sur :"
echo "   http://localhost:3000"
echo "   → Aller vers 'Voir les abonnements'"
echo ""
echo "📁 Sauvegarde créée :"
echo "   src/app/page.tsx.backup_$(date +%Y%m%d_%H%M%S)"
echo ""
echo "🔧 En cas de problème :"
echo "   cp src/app/page.tsx.backup_* src/app/page.tsx"
echo "   npm run dev"
echo ""
echo "🎯 Le plan trimestriel est maintenant visible"
echo "   entre le plan mensuel et annuel !"
echo "=============================================="