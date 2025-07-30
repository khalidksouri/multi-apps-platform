#!/bin/bash

#===============================================================================
# MATH4CHILD - AJOUT PLAN ÉCOLES/ASSOCIATIONS
# Ajoute le plan spécialisé pour institutions éducatives
#===============================================================================

set -euo pipefail

# Couleurs
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_message() {
    local level=$1
    shift
    local message="$*"
    echo -e "${GREEN}[$(date '+%H:%M:%S')] ✅ $level: ${message}${NC}"
}

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║           🏫 MATH4CHILD - AJOUT PLAN ÉCOLES/ASSOCIATIONS                    ║
║               Formule spécialisée pour institutions éducatives              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Aller dans le répertoire de l'application
go_to_app_directory() {
    if [ -d "apps/math4child" ]; then
        cd apps/math4child
    elif [ -f "package.json" ] && grep -q "math4child" package.json; then
        # Déjà dans le bon répertoire
        :
    else
        log_message "ERROR" "Répertoire de l'application non trouvé"
        exit 1
    fi
}

# Mettre à jour la page d'abonnement avec le plan Écoles/Associations
update_subscription_page() {
    log_message "INFO" "📝 Mise à jour de la page d'abonnement avec le plan Écoles/Associations..."
    
    cat > src/app/subscription/page.tsx << 'EOF'
'use client'

import { useState } from 'react'

export default function SubscriptionPage() {
  const [billingPeriod, setBillingPeriod] = useState('monthly')

  const plans = [
    {
      id: 'free',
      name: 'Découverte',
      description: 'Parfait pour tester Math4Child',
      price: { monthly: 0, yearly: 0 },
      features: [
        '5 exercices par jour',
        'Suivi basique des progrès',
        'Accès aux additions simples',
        'Support par email',
        '1 profil enfant'
      ],
      limitations: [
        'Exercices limités',
        'Pas de statistiques avancées',
        'Pas de mode hors ligne'
      ],
      color: 'border-gray-300',
      buttonColor: 'bg-gray-600 hover:bg-gray-700',
      target: 'Particuliers'
    },
    {
      id: 'premium',
      name: 'Premium',
      description: 'L\'expérience complète pour un enfant',
      price: { monthly: 9.99, yearly: 7.99 },
      features: [
        'Exercices illimités',
        'Toutes les opérations mathématiques',
        'Analyses détaillées des progrès',
        'Mode hors ligne',
        'Contenu adaptatif IA',
        'Support prioritaire',
        'Jusqu\'à 3 profils enfants',
        'Contrôle parental avancé',
        'Badges et récompenses'
      ],
      color: 'border-blue-500 ring-4 ring-blue-100',
      buttonColor: 'bg-blue-600 hover:bg-blue-700',
      popular: true,
      savings: billingPeriod === 'yearly' ? '20%' : null,
      target: 'Familles'
    },
    {
      id: 'family',
      name: 'Famille',
      description: 'Idéal pour les familles nombreuses',
      price: { monthly: 19.99, yearly: 15.99 },
      features: [
        'Tout le contenu Premium',
        'Jusqu\'à 6 profils enfants',
        'Rapports détaillés par enfant',
        'Contrôle parental complet',
        'Support téléphonique',
        'Accès anticipé aux nouveautés',
        'Sessions de groupe',
        'Tableau de bord familial',
        'Synchronisation multi-appareils'
      ],
      color: 'border-purple-300',
      buttonColor: 'bg-purple-600 hover:bg-purple-700',
      savings: billingPeriod === 'yearly' ? '20%' : null,
      target: 'Grandes familles'
    },
    {
      id: 'school',
      name: 'Écoles & Associations',
      description: 'Solution complète pour institutions éducatives',
      price: { monthly: 49.99, yearly: 39.99 },
      features: [
        'Comptes illimités élèves',
        'Tableau de bord enseignant',
        'Gestion de classes multiples',
        'Rapports de progression détaillés',
        'Outils d\'évaluation intégrés',
        'Support technique dédié',
        'Formation des enseignants incluse',
        'Conformité RGPD éducation',
        'Personnalisation par établissement',
        'API pour intégration LMS',
        'Statistiques par classe/niveau',
        'Mode examen sécurisé'
      ],
      color: 'border-emerald-400 ring-4 ring-emerald-100',
      buttonColor: 'bg-emerald-600 hover:bg-emerald-700',
      savings: billingPeriod === 'yearly' ? '20%' : null,
      target: 'Institutions',
      badge: '🏫 Professionnel',
      contact: true
    }
  ]

  const faqs = [
    {
      question: 'Puis-je changer de plan à tout moment ?',
      answer: 'Oui, vous pouvez upgrader ou downgrader votre plan à tout moment. Les changements prennent effet immédiatement.'
    },
    {
      question: 'Y a-t-il une période d\'essai gratuite ?',
      answer: 'Oui, tous les plans payants incluent une période d\'essai gratuite de 7 jours, sans engagement.'
    },
    {
      question: 'Comment fonctionne le plan Écoles & Associations ?',
      answer: 'Le plan institutionnel inclut des comptes illimités pour vos élèves, des outils de gestion de classe, et un support dédié. Contactez-nous pour une démonstration personnalisée.'
    },
    {
      question: 'Que se passe-t-il si je résilie mon abonnement ?',
      answer: 'Vous gardez l\'accès aux fonctionnalités premium jusqu\'à la fin de votre période de facturation, puis revenez au plan gratuit.'
    },
    {
      question: 'Y a-t-il des tarifs préférentiels pour les écoles ?',
      answer: 'Oui, nous proposons des remises spéciales pour les établissements publics et les associations à but non lucratif. Contactez notre équipe éducation.'
    },
    {
      question: 'Les prix sont-ils les mêmes dans tous les pays ?',
      answer: 'Non, nos prix s\'adaptent à la parité de pouvoir d\'achat de votre région pour rester accessibles.'
    }
  ]

  const institutionalBenefits = [
    {
      icon: '👩‍🏫',
      title: 'Outils Enseignant',
      description: 'Tableau de bord complet pour suivre les progrès de tous vos élèves'
    },
    {
      icon: '📊',
      title: 'Analytics Avancées',
      description: 'Rapports détaillés par classe, niveau et compétence mathématique'
    },
    {
      icon: '🔒',
      title: 'Conformité RGPD',
      description: 'Protection maximale des données des élèves selon la réglementation'
    },
    {
      icon: '🎓',
      title: 'Formation Incluse',
      description: 'Sessions de formation pour vos enseignants et support pédagogique'
    }
  ]

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          💎 Choisissez votre abonnement
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          Débloquez tout le potentiel de Math4Child pour votre enfant ou votre établissement
        </p>

        {/* Période de facturation */}
        <div className="flex items-center justify-center space-x-4 mb-8">
          <span className={billingPeriod === 'monthly' ? 'font-semibold' : 'text-gray-500'}>
            Mensuel
          </span>
          <button
            onClick={() => setBillingPeriod(billingPeriod === 'monthly' ? 'yearly' : 'monthly')}
            className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
              billingPeriod === 'yearly' ? 'bg-blue-600' : 'bg-gray-200'
            }`}
          >
            <span
              className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                billingPeriod === 'yearly' ? 'translate-x-6' : 'translate-x-1'
              }`}
            />
          </button>
          <span className={billingPeriod === 'yearly' ? 'font-semibold' : 'text-gray-500'}>
            Annuel
          </span>
          {billingPeriod === 'yearly' && (
            <span className="bg-green-100 text-green-800 px-2 py-1 rounded-full text-sm font-medium">
              💰 Économisez 20%
            </span>
          )}
        </div>
      </div>

      {/* Plans */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 mb-16">
        {plans.map((plan) => (
          <div key={plan.id} className={`bg-white rounded-2xl p-6 ${plan.color} relative shadow-lg ${plan.id === 'school' ? 'lg:col-span-1' : ''}`}>
            {plan.popular && (
              <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-medium">
                  🔥 Plus populaire
                </span>
              </div>
            )}

            {plan.badge && (
              <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                <span className="bg-emerald-500 text-white px-4 py-2 rounded-full text-sm font-medium">
                  {plan.badge}
                </span>
              </div>
            )}

            {plan.savings && (
              <div className="absolute -top-2 -right-2">
                <span className="bg-green-500 text-white px-3 py-1 rounded-full text-xs font-medium">
                  -{plan.savings}
                </span>
              </div>
            )}

            <div className="text-center mb-6">
              <div className="text-xs font-medium text-gray-500 mb-2">{plan.target}</div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">{plan.name}</h3>
              <p className="text-gray-600 mb-4 text-sm">{plan.description}</p>
              
              <div className="mb-4">
                {plan.price[billingPeriod] === 0 ? (
                  <span className="text-3xl font-bold text-gray-900">Gratuit</span>
                ) : plan.contact ? (
                  <div>
                    <span className="text-3xl font-bold text-emerald-600">Sur devis</span>
                    <div className="text-sm text-gray-500 mt-1">
                      Tarifs préférentiels disponibles
                    </div>
                  </div>
                ) : (
                  <div>
                    <span className="text-3xl font-bold text-gray-900">
                      {plan.price[billingPeriod]}€
                    </span>
                    <span className="text-gray-600 text-sm">
                      /{billingPeriod === 'monthly' ? 'mois' : 'mois'}
                    </span>
                    {billingPeriod === 'yearly' && (
                      <div className="text-xs text-gray-500">
                        Facturé {(plan.price.yearly * 12).toFixed(2)}€/an
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>

            <ul className="space-y-2 mb-6 text-sm">
              {plan.features.map((feature, index) => (
                <li key={index} className="flex items-start text-gray-700">
                  <span className="text-green-500 mr-2 mt-0.5 text-xs">✓</span>
                  <span>{feature}</span>
                </li>
              ))}
            </ul>

            {plan.limitations && (
              <ul className="space-y-1 mb-6 border-t pt-4">
                {plan.limitations.map((limitation, index) => (
                  <li key={index} className="flex items-start text-gray-500 text-xs">
                    <span className="text-gray-400 mr-2 mt-0.5">✗</span>
                    <span>{limitation}</span>
                  </li>
                ))}
              </ul>
            )}

            <button className={`w-full text-white px-4 py-3 rounded-lg font-semibold transition-all duration-200 text-sm ${plan.buttonColor}`}>
              {plan.price[billingPeriod] === 0 ? 'Commencer gratuitement' : 
               plan.contact ? 'Nous contacter' : 'Choisir ce plan'}
            </button>

            {plan.price[billingPeriod] > 0 && !plan.contact && (
              <p className="text-center text-xs text-gray-500 mt-3">
                Essai gratuit de 7 jours • Annulable à tout moment
              </p>
            )}

            {plan.contact && (
              <p className="text-center text-xs text-gray-500 mt-3">
                Démonstration gratuite • Devis personnalisé • Support dédié
              </p>
            )}
          </div>
        ))}
      </div>

      {/* Avantages Institutionnels */}
      <section className="mb-16 bg-emerald-50 rounded-2xl p-8">
        <h2 className="text-2xl font-bold text-center text-gray-900 mb-8">
          🏫 Pourquoi choisir Math4Child pour votre établissement ?
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          {institutionalBenefits.map((benefit, index) => (
            <div key={index} className="text-center">
              <div className="text-3xl mb-3">{benefit.icon}</div>
              <h3 className="text-lg font-semibold text-gray-900 mb-2">{benefit.title}</h3>
              <p className="text-gray-600 text-sm">{benefit.description}</p>
            </div>
          ))}
        </div>
        <div className="text-center mt-8">
          <button className="bg-emerald-600 hover:bg-emerald-700 text-white px-8 py-3 rounded-lg font-semibold">
            📞 Demander une démonstration
          </button>
        </div>
      </section>

      {/* FAQ */}
      <section className="mb-16">
        <h2 className="text-2xl font-bold text-center text-gray-900 mb-8">
          Questions fréquentes
        </h2>
        <div className="space-y-6">
          {faqs.map((faq, index) => (
            <div key={index} className="bg-white rounded-lg p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-3">
                {faq.question}
              </h3>
              <p className="text-gray-600">{faq.answer}</p>
            </div>
          ))}
        </div>
      </section>

      {/* CTA Final pour les écoles */}
      <section className="bg-gradient-to-r from-emerald-600 to-blue-600 text-white rounded-2xl p-8 text-center">
        <h2 className="text-2xl font-bold mb-4">
          🎓 Transformez l'enseignement des mathématiques dans votre établissement
        </h2>
        <p className="text-lg mb-6 opacity-90">
          Rejoignez plus de 500 écoles qui utilisent déjà Math4Child
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <button className="bg-white text-emerald-600 px-6 py-3 rounded-lg font-semibold hover:shadow-lg">
            📞 Planifier une démonstration
          </button>
          <button className="bg-emerald-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-emerald-400">
            📧 Recevoir une brochure
          </button>
        </div>
      </section>
    </div>
  )
}
EOF
    
    log_message "SUCCESS" "Page d'abonnement mise à jour avec le plan Écoles/Associations"
}

# Fonction principale
main() {
    show_banner
    
    log_message "INFO" "Ajout du plan Écoles/Associations à Math4Child..."
    
    go_to_app_directory
    update_subscription_page
    
    log_message "SUCCESS" "🎉 Plan Écoles/Associations ajouté avec succès !"
    
    echo ""
    echo -e "${BLUE}🏫 NOUVEAU PLAN AJOUTÉ :${NC}"
    echo "   • 🎓 Écoles & Associations - 49,99€/mois (39,99€/an)"
    echo "   • 👨‍🏫 Comptes illimités élèves"
    echo "   • 📊 Tableau de bord enseignant"
    echo "   • 🔒 Conformité RGPD éducation"
    echo "   • 🎯 Formation des enseignants incluse"
    echo "   • 📞 Support technique dédié"
    echo "   • 🏫 Section spécialisée institutions"
    echo ""
    echo "🌐 Rechargez la page : http://localhost:3000/subscription"
}

main "$@"