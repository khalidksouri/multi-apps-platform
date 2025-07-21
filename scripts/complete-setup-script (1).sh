#!/bin/bash

# =============================================================================
# SCRIPT COMPLET CONFIGURATION GOTEST + MATH4KIDS + STRIPE + QONTO
# =============================================================================
# Ce script configure automatiquement :
# 1. Structure des dossiers
# 2. Fichiers de configuration Stripe/Qonto
# 3. Composants React pour abonnements
# 4. API routes pour paiements
# 5. Variables d'environnement
# 6. Installation des dépendances
#
# Usage: ./setup-gotest-math4kids.sh
# =============================================================================

set -e  # Arrêter en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="apps/math4kids"
BUSINESS_NAME="GOTEST"
SIRET="53958712100028"
ACTIVITY="Conseil en systèmes et logiciels informatiques"
ACTIVITY_CODE="6202A"
OWNER_NAME="KSOURI KHALID"
ADDRESS="1 ALLEE DE LA HAUTE PLACE"
POSTAL_CODE="93160"
CITY="NOISY-LE-GRAND"
COUNTRY="FR"
IBAN="FR7616958000016218830371501"
BIC="QNTOFRP1XXX"

# =============================================================================
# FONCTIONS UTILITAIRES
# =============================================================================

print_header() {
    echo -e "\n${WHITE}════════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}🚀 CONFIGURATION COMPLÈTE GOTEST + MATH4KIDS + STRIPE + QONTO${NC}"
    echo -e "${WHITE}════════════════════════════════════════════════════════════════════════════════${NC}\n"
}

print_section() {
    echo -e "\n${BLUE}📋 $1${NC}"
    echo -e "${BLUE}$(printf '%*s' ${#1} '' | tr ' ' '-')${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

check_project_dir() {
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Répertoire $PROJECT_DIR non trouvé"
        echo "Assurez-vous d'être à la racine du projet multi-apps-platform"
        exit 1
    fi
    
    if [ ! -f "$PROJECT_DIR/package.json" ]; then
        print_error "package.json non trouvé dans $PROJECT_DIR"
        exit 1
    fi
    
    print_success "Projet Math4Kids trouvé"
}

# =============================================================================
# CRÉATION DE LA STRUCTURE DES DOSSIERS
# =============================================================================

create_directory_structure() {
    print_section "Création de la structure des dossiers"
    
    # Dossiers principaux
    directories=(
        "$PROJECT_DIR/src/lib"
        "$PROJECT_DIR/src/lib/stripe"
        "$PROJECT_DIR/src/components/subscription"
        "$PROJECT_DIR/src/components/payments"
        "$PROJECT_DIR/src/app/api/stripe/create-checkout-session"
        "$PROJECT_DIR/src/app/api/stripe/setup-account"
        "$PROJECT_DIR/src/app/api/stripe/webhooks"
        "$PROJECT_DIR/src/app/subscription/success"
        "$PROJECT_DIR/src/app/subscription/cancel"
        "$PROJECT_DIR/src/app/stripe/onboarding"
        "$PROJECT_DIR/src/app/stripe/success"
        "$PROJECT_DIR/src/app/stripe/refresh"
        "$PROJECT_DIR/src/types"
        "$PROJECT_DIR/src/hooks"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
        print_success "Créé : $dir"
    done
}

# =============================================================================
# INSTALLATION DES DÉPENDANCES
# =============================================================================

install_dependencies() {
    print_section "Installation des dépendances Stripe"
    
    cd "$PROJECT_DIR"
    
    # Vérifier si les dépendances sont déjà installées
    if npm list @stripe/stripe-js >/dev/null 2>&1; then
        print_info "Dépendances Stripe déjà installées"
    else
        print_info "Installation de @stripe/stripe-js et stripe..."
        npm install @stripe/stripe-js stripe
        print_success "Dépendances Stripe installées"
    fi
    
    cd - > /dev/null
}

# =============================================================================
# CONFIGURATION STRIPE + QONTO
# =============================================================================

create_qonto_stripe_config() {
    print_section "Création de la configuration Stripe + Qonto"
    
    cat > "$PROJECT_DIR/src/lib/qonto-stripe-config.ts" << EOF
// =============================================================================
// CONFIGURATION STRIPE + QONTO POUR MATH4KIDS - GOTEST
// Configuration complète pour $OWNER_NAME - Auto-entrepreneur GOTEST
// =============================================================================

// Configuration des informations bancaires Qonto
export const QONTO_BANK_CONFIG = {
  // Informations bancaires Qonto
  iban: "$IBAN",
  bic: "$BIC",
  bank_name: "Qonto",
  account_holder_name: "$BUSINESS_NAME - $OWNER_NAME",
  
  // Adresse du titulaire
  address: {
    line1: "$ADDRESS",
    postal_code: "$POSTAL_CODE",
    city: "$CITY",
    country: "$COUNTRY"
  }
} as const

// Configuration Stripe pour auto-entrepreneur GOTEST
export const STRIPE_BUSINESS_CONFIG = {
  // Type de compte pour auto-entrepreneur
  type: "express" as const,
  country: "$COUNTRY",
  
  // Informations business GOTEST
  business_type: "individual",
  business_profile: {
    category: "software",
    subcategory: "educational_software",
    name: "$BUSINESS_NAME - Math4Kids",
    description: "$ACTIVITY - Application Math4Kids",
    url: "https://math4child.com",
    support_url: "https://math4child.com/support",
    support_email: "support@math4child.com",
    mcc: "5734" // Code pour services informatiques/logiciels
  },
  
  // Informations SIRET et activité
  company: {
    name: "$BUSINESS_NAME",
    registration_number: "$SIRET", // SIRET
    structure: "sole_proprietorship", // Auto-entrepreneur
    address: {
      line1: "$ADDRESS",
      postal_code: "$POSTAL_CODE",
      city: "$CITY",
      country: "$COUNTRY"
    }
  },
  
  // Informations individuelles (auto-entrepreneur)
  individual: {
    first_name: "KHALID",
    last_name: "KSOURI",
    email: "khalid@math4child.com", // À remplacer par votre email
    phone: "+33", // À compléter avec votre numéro
    address: {
      line1: "$ADDRESS",
      postal_code: "$POSTAL_CODE",
      city: "$CITY",
      country: "$COUNTRY"
    },
    dob: {
      day: "", // À compléter
      month: "", // À compléter  
      year: "" // À compléter
    },
    // Métadonnées pour l'activité
    metadata: {
      siret: "$SIRET",
      activity_code: "$ACTIVITY_CODE",
      activity_name: "$ACTIVITY"
    }
  },
  
  // Paramètres de virement
  settings: {
    payouts: {
      schedule: {
        interval: "weekly", // Virements hebdomadaires
        weekly_anchor: "friday" // Chaque vendredi
      }
    }
  }
} as const

// Plans d'abonnement Math4Kids
export const SUBSCRIPTION_PLANS = {
  monthly: {
    name: 'Math4Kids Mensuel',
    price: 999, // 9.99€ en centimes
    currency: 'eur',
    interval: 'month' as const,
    features: [
      'Accès illimité à tous les niveaux',
      'Support multilingue (30+ langues)',
      'Applications Web + Mobile',
      'Statistiques de progression',
      'Support prioritaire'
    ]
  },
  quarterly: {
    name: 'Math4Kids Trimestriel',
    price: 2697, // 26.97€ en centimes
    currency: 'eur',
    interval: 'month' as const,
    interval_count: 3,
    features: [
      'Tout du plan mensuel',
      '10% de réduction',
      'Fonctionnalités bonus',
      'Rapport de progression détaillé'
    ]
  },
  annual: {
    name: 'Math4Kids Annuel',
    price: 8392, // 83.92€ en centimes
    currency: 'eur',
    interval: 'year' as const,
    features: [
      'Tout du plan mensuel',
      '30% de réduction',
      'Accès anticipé aux nouvelles fonctionnalités',
      'Support téléphonique',
      'Certification de progression'
    ]
  }
} as const

export type SubscriptionPlan = keyof typeof SUBSCRIPTION_PLANS
EOF
    
    print_success "Configuration Qonto + Stripe créée"
}

# =============================================================================
# CONFIGURATION STRIPE PRINCIPALE
# =============================================================================

create_stripe_config() {
    print_section "Création de la configuration Stripe principale"
    
    cat > "$PROJECT_DIR/src/lib/stripe.ts" << 'EOF'
import { loadStripe } from '@stripe/stripe-js'
import Stripe from 'stripe'
import { QONTO_BANK_CONFIG, STRIPE_BUSINESS_CONFIG, SUBSCRIPTION_PLANS } from './qonto-stripe-config'

// Configuration côté client
export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
)

// Configuration côté serveur
export const stripe = new Stripe(
  process.env.STRIPE_SECRET_KEY!,
  {
    apiVersion: '2023-10-16',
  }
)

// Export des configurations
export { QONTO_BANK_CONFIG, STRIPE_BUSINESS_CONFIG, SUBSCRIPTION_PLANS }
export type { SubscriptionPlan } from './qonto-stripe-config'
EOF
    
    print_success "Configuration Stripe principale créée"
}

# =============================================================================
# API ROUTES STRIPE
# =============================================================================

create_api_routes() {
    print_section "Création des API routes Stripe"
    
    # API Setup Account
    cat > "$PROJECT_DIR/src/app/api/stripe/setup-account/route.ts" << 'EOF'
import { NextRequest } from 'next/server'
import { stripe, QONTO_BANK_CONFIG, STRIPE_BUSINESS_CONFIG } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  try {
    // Créer le compte Stripe Express pour GOTEST
    const account = await stripe.accounts.create({
      type: 'express',
      country: 'FR',
      email: 'khalid@math4child.com', // Votre email
      business_type: 'individual',
      individual: {
        first_name: 'KHALID',
        last_name: 'KSOURI',
        email: 'khalid@math4child.com',
        address: {
          line1: '1 ALLEE DE LA HAUTE PLACE',
          postal_code: '93160',
          city: 'NOISY-LE-GRAND',
          country: 'FR'
        }
      },
      business_profile: {
        category: 'software',
        name: 'GOTEST - Math4Kids',
        description: 'Conseil en systèmes et logiciels informatiques',
        url: 'https://math4child.com',
        mcc: '5734' // Services informatiques
      },
      // Informations SIRET GOTEST
      company: {
        name: 'GOTEST',
        registration_number: '53958712100028',
        structure: 'sole_proprietorship',
        address: {
          line1: '1 ALLEE DE LA HAUTE PLACE',
          postal_code: '93160',
          city: 'NOISY-LE-GRAND',
          country: 'FR'
        }
      },
      settings: {
        payouts: {
          schedule: {
            interval: 'weekly'
          }
        }
      }
    })

    // Ajouter le compte bancaire Qonto
    await stripe.accounts.createExternalAccount(account.id, {
      external_account: {
        object: 'bank_account',
        country: 'FR',
        currency: 'eur',
        account_number: QONTO_BANK_CONFIG.iban,
        routing_number: QONTO_BANK_CONFIG.bic,
        account_holder_name: 'GOTEST - KSOURI KHALID',
        account_holder_type: 'individual'
      }
    })

    // Créer le lien d'onboarding
    const accountLink = await stripe.accountLinks.create({
      account: account.id,
      refresh_url: `${process.env.NEXT_PUBLIC_SITE_URL}/stripe/refresh`,
      return_url: `${process.env.NEXT_PUBLIC_SITE_URL}/stripe/success`,
      type: 'account_onboarding'
    })

    return Response.json({
      account_id: account.id,
      onboarding_url: accountLink.url
    })

  } catch (error) {
    console.error('Erreur création compte Stripe:', error)
    return Response.json({ error: 'Erreur configuration Stripe' }, { status: 500 })
  }
}
EOF
    
    # API Create Checkout Session
    cat > "$PROJECT_DIR/src/app/api/stripe/create-checkout-session/route.ts" << 'EOF'
import { NextRequest } from 'next/server'
import { stripe, SUBSCRIPTION_PLANS } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  try {
    const { plan, customerEmail } = await request.json()
    
    if (!plan || !SUBSCRIPTION_PLANS[plan as keyof typeof SUBSCRIPTION_PLANS]) {
      return Response.json({ error: 'Plan invalide' }, { status: 400 })
    }

    const planConfig = SUBSCRIPTION_PLANS[plan as keyof typeof SUBSCRIPTION_PLANS]
    
    // Créer ou récupérer le produit Stripe
    const product = await stripe.products.create({
      name: planConfig.name,
      description: `Abonnement Math4Kids - ${planConfig.name}`,
      metadata: {
        app: 'math4kids',
        plan: plan,
        business: 'GOTEST'
      }
    })

    // Créer le prix
    const price = await stripe.prices.create({
      product: product.id,
      unit_amount: planConfig.price,
      currency: planConfig.currency,
      recurring: {
        interval: planConfig.interval,
        interval_count: planConfig.interval_count || 1
      },
      metadata: {
        plan: plan
      }
    })

    // Créer la session de checkout
    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      payment_method_types: ['card', 'sepa_debit'],
      line_items: [
        {
          price: price.id,
          quantity: 1,
        },
      ],
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL}/subscription/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL}/subscription/cancel`,
      customer_email: customerEmail,
      allow_promotion_codes: true,
      billing_address_collection: 'required',
      tax_id_collection: {
        enabled: true
      },
      locale: 'fr',
      metadata: {
        plan: plan,
        app: 'math4kids',
        business: 'GOTEST'
      },
      subscription_data: {
        metadata: {
          plan: plan,
          app: 'math4kids',
          business: 'GOTEST'
        }
      }
    })

    return Response.json({ 
      sessionId: session.id,
      url: session.url 
    })
    
  } catch (error) {
    console.error('Erreur Stripe checkout:', error)
    return Response.json(
      { error: 'Erreur lors de la création de la session de paiement' }, 
      { status: 500 }
    )
  }
}
EOF
    
    # API Webhooks
    cat > "$PROJECT_DIR/src/app/api/stripe/webhooks/route.ts" << 'EOF'
import { NextRequest } from 'next/server'
import { stripe } from '@/lib/stripe'
import { headers } from 'next/headers'

export async function POST(request: NextRequest) {
  const body = await request.text()
  const signature = headers().get('stripe-signature')

  if (!signature) {
    return Response.json({ error: 'Signature manquante' }, { status: 400 })
  }

  try {
    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    )

    console.log('Webhook GOTEST reçu:', event.type)

    switch (event.type) {
      case 'checkout.session.completed':
        await handleCheckoutCompleted(event.data.object)
        break
        
      case 'invoice.payment_succeeded':
        await handlePaymentSucceeded(event.data.object)
        break
        
      case 'payout.paid':
        await handlePayoutToQonto(event.data.object)
        break
        
      case 'customer.subscription.created':
        await handleSubscriptionCreated(event.data.object)
        break
        
      default:
        console.log(`Événement non géré: ${event.type}`)
    }

    return Response.json({ received: true })
    
  } catch (error) {
    console.error('Erreur webhook Stripe GOTEST:', error)
    return Response.json({ error: 'Erreur webhook' }, { status: 400 })
  }
}

async function handleCheckoutCompleted(session: any) {
  console.log('💰 GOTEST - Checkout complété:', session.id)
  console.log('📧 Client:', session.customer_email)
  console.log('💵 Montant:', session.amount_total / 100, '€')
  
  // TODO: Activer l'abonnement utilisateur Math4Kids
}

async function handlePaymentSucceeded(invoice: any) {
  console.log('✅ GOTEST - Paiement réussi:', invoice.id)
  
  // TODO: Mettre à jour la comptabilité GOTEST
}

async function handlePayoutToQonto(payout: any) {
  console.log('🏦 GOTEST - Virement vers Qonto:', payout.amount / 100, '€')
  console.log('📅 Date d\'arrivée:', new Date(payout.arrival_date * 1000))
  
  // TODO: Notification comptabilité auto-entrepreneur
}

async function handleSubscriptionCreated(subscription: any) {
  console.log('🎯 GOTEST - Nouvel abonnement Math4Kids:', subscription.id)
  
  // TODO: Activer fonctionnalités premium
}
EOF
    
    print_success "API routes Stripe créées"
}

# =============================================================================
# COMPOSANTS REACT
# =============================================================================

create_react_components() {
    print_section "Création des composants React"
    
    # Hook useAnalytics pour tracking
    cat > "$PROJECT_DIR/src/hooks/useAnalytics.ts" << 'EOF'
import { useCallback } from 'react'

declare global {
  interface Window {
    gtag: (
      command: string,
      targetId: string | Date,
      config?: Record<string, any>
    ) => void
  }
}

export const useAnalytics = () => {
  const trackSubscription = useCallback((
    plan: 'monthly' | 'quarterly' | 'annual',
    price: number,
    currency: string = 'EUR'
  ) => {
    if (typeof window !== 'undefined' && window.gtag) {
      window.gtag('event', 'purchase', {
        transaction_id: `gotest_${Date.now()}`,
        value: price,
        currency: currency,
        items: [{
          item_id: plan,
          item_name: `GOTEST Math4Kids ${plan}`,
          category: 'subscription',
          quantity: 1,
          price: price
        }]
      })
    }
  }, [])

  const trackEvent = useCallback((
    action: string,
    category: string,
    label?: string,
    value?: number
  ) => {
    if (typeof window !== 'undefined' && window.gtag) {
      window.gtag('event', action, {
        event_category: category,
        event_label: label,
        value: value,
        business: 'GOTEST'
      })
    }
  }, [])

  return { trackSubscription, trackEvent }
}
EOF
    
    # Composant SubscriptionCard
    cat > "$PROJECT_DIR/src/components/subscription/SubscriptionCard.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import { Crown, Check, Loader2 } from 'lucide-react'
import { SUBSCRIPTION_PLANS, SubscriptionPlan } from '@/lib/stripe'
import { useAnalytics } from '@/hooks/useAnalytics'

interface SubscriptionCardProps {
  plan: SubscriptionPlan
  isPopular?: boolean
  currentPlan?: SubscriptionPlan | null
  onSubscribe: (plan: SubscriptionPlan) => Promise<void>
}

const SubscriptionCard: React.FC<SubscriptionCardProps> = ({
  plan,
  isPopular = false,
  currentPlan,
  onSubscribe
}) => {
  const [loading, setLoading] = useState(false)
  const { trackSubscription, trackEvent } = useAnalytics()
  const planConfig = SUBSCRIPTION_PLANS[plan]
  const isCurrentPlan = currentPlan === plan
  
  const handleSubscribe = async () => {
    if (isCurrentPlan) return
    
    setLoading(true)
    try {
      trackEvent('subscription_clicked', 'payment', plan)
      await onSubscribe(plan)
      trackSubscription(plan, planConfig.price / 100, 'EUR')
    } catch (error) {
      console.error('Erreur abonnement:', error)
      trackEvent('subscription_error', 'payment', plan)
    } finally {
      setLoading(false)
    }
  }

  const formatPrice = (price: number) => {
    return (price / 100).toFixed(2)
  }

  const getDiscountBadge = () => {
    if (plan === 'quarterly') return '10% de réduction'
    if (plan === 'annual') return '30% de réduction'
    return null
  }

  return (
    <div className={`relative rounded-2xl p-6 ${
      isPopular 
        ? 'border-2 border-blue-500 bg-blue-50' 
        : 'border-2 border-gray-200 bg-white'
    }`}>
      {isPopular && (
        <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
          <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
            Plus populaire
          </span>
        </div>
      )}
      
      {getDiscountBadge() && (
        <div className="absolute -top-3 right-4">
          <span className="bg-green-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
            {getDiscountBadge()}
          </span>
        </div>
      )}

      <div className="text-center mb-6">
        <h3 className="text-xl font-bold text-gray-800 mb-2">
          {planConfig.name}
        </h3>
        
        <div className="mb-4">
          <span className="text-3xl font-bold text-gray-900">
            {formatPrice(planConfig.price)}€
          </span>
          <span className="text-gray-600 ml-1">
            /{planConfig.interval === 'year' ? 'an' : 
              planConfig.interval_count === 3 ? '3 mois' : 'mois'}
          </span>
        </div>

        {plan === 'quarterly' && (
          <p className="text-sm text-gray-600">
            Soit {formatPrice(planConfig.price / 3)}€/mois
          </p>
        )}
        
        {plan === 'annual' && (
          <p className="text-sm text-gray-600">
            Soit {formatPrice(planConfig.price / 12)}€/mois
          </p>
        )}
      </div>

      <ul className="space-y-3 mb-6">
        {planConfig.features.map((feature, index) => (
          <li key={index} className="flex items-center gap-3">
            <Check className="w-5 h-5 text-green-500 flex-shrink-0" />
            <span className="text-sm text-gray-700">{feature}</span>
          </li>
        ))}
      </ul>

      <button
        onClick={handleSubscribe}
        disabled={loading || isCurrentPlan}
        className={`w-full py-3 px-4 rounded-lg font-semibold transition-colors flex items-center justify-center gap-2 ${
          isCurrentPlan
            ? 'bg-gray-200 text-gray-500 cursor-not-allowed'
            : isPopular
              ? 'bg-blue-500 hover:bg-blue-600 text-white'
              : 'bg-gray-800 hover:bg-gray-900 text-white'
        }`}
      >
        {loading ? (
          <>
            <Loader2 className="w-4 h-4 animate-spin" />
            Redirection...
          </>
        ) : isCurrentPlan ? (
          <>
            <Crown className="w-4 h-4" />
            Plan actuel
          </>
        ) : (
          'Choisir ce plan'
        )}
      </button>
      
      <div className="text-center mt-3">
        <p className="text-xs text-gray-500">Facturé par GOTEST</p>
      </div>
    </div>
  )
}

export default SubscriptionCard
EOF
    
    # Page d'abonnement principale
    cat > "$PROJECT_DIR/src/app/subscription/page.tsx" << 'EOF'
'use client'

import { useState } from 'react'
import SubscriptionCard from '@/components/subscription/SubscriptionCard'
import { SubscriptionPlan } from '@/lib/stripe'

export default function SubscriptionPage() {
  const [loading, setLoading] = useState(false)

  const handleSubscribe = async (plan: SubscriptionPlan) => {
    setLoading(true)
    
    try {
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          plan,
          customerEmail: '' // L'utilisateur saisira son email dans Stripe Checkout
        })
      })

      const { sessionId, url } = await response.json()
      
      if (url) {
        window.location.href = url
      }
      
    } catch (error) {
      console.error('Erreur lors de la création de la session:', error)
      alert('Erreur lors de la redirection vers le paiement')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-12 px-4">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Choisissez votre plan Math4Kids
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Débloquez toutes les fonctionnalités et aidez votre enfant à exceller en mathématiques
          </p>
          <div className="mt-4 inline-flex items-center gap-2 bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm">
            <span>💼</span>
            <span>Facturé par GOTEST - Entreprise française</span>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
          <SubscriptionCard 
            plan="monthly" 
            onSubscribe={handleSubscribe}
          />
          <SubscriptionCard 
            plan="quarterly" 
            isPopular 
            onSubscribe={handleSubscribe}
          />
          <SubscriptionCard 
            plan="annual" 
            onSubscribe={handleSubscribe}
          />
        </div>

        <div className="bg-white rounded-2xl p-8 shadow-lg">
          <h2 className="text-2xl font-bold text-center mb-6">
            Pourquoi choisir Math4Kids Premium ?
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="text-center">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                🌍
              </div>
              <h3 className="font-semibold mb-2">Multilingue</h3>
              <p className="text-sm text-gray-600">Plus de 30 langues disponibles</p>
            </div>
            
            <div className="text-center">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                📱
              </div>
              <h3 className="font-semibold mb-2">Multi-plateforme</h3>
              <p className="text-sm text-gray-600">Web, iOS et Android</p>
            </div>
            
            <div className="text-center">
              <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
                🎯
              </div>
              <h3 className="font-semibold mb-2">Progression adaptée</h3>
              <p className="text-sm text-gray-600">5 niveaux de difficulté</p>
            </div>
            
            <div className="text-center">
              <div className="w-16 h-16 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-4">
                📊
              </div>
              <h3 className="font-semibold mb-2">Suivi détaillé</h3>
              <p className="text-sm text-gray-600">Statistiques et rapports</p>
            </div>
          </div>
          
          <div className="mt-8 text-center">
            <div className="bg-gray-50 rounded-lg p-4 inline-block">
              <p className="text-sm text-gray-700">
                <strong>Paiement sécurisé</strong> • Facturé par GOTEST (SIRET: 53958712100028)
              </p>
              <p className="text-xs text-gray-500 mt-1">
                Conseil en systèmes et logiciels informatiques • Auto-entrepreneur français
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
EOF
    
    print_success "Composants React créés"
}

# =============================================================================
# VARIABLES D'ENVIRONNEMENT
# =============================================================================

create_env_files() {
    print_section "Création des fichiers d'environnement"
    
    # Fichier .env.example
    cat > "$PROJECT_DIR/.env.example" << EOF
# Google Analytics Configuration
NEXT_PUBLIC_GA_MEASUREMENT_ID=G-XXXXXXXXXX

# Site Configuration
NEXT_PUBLIC_SITE_URL=https://math4child.com
NEXT_PUBLIC_API_URL=https://math4child.com/api

# Stripe Configuration GOTEST
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Business Information GOTEST
NEXT_PUBLIC_BUSINESS_NAME="$BUSINESS_NAME"
NEXT_PUBLIC_BUSINESS_SIRET="$SIRET"
NEXT_PUBLIC_BUSINESS_EMAIL="khalid@math4child.com"
NEXT_PUBLIC_BUSINESS_PHONE="+33123456789"

# Qonto Bank Details
QONTO_IBAN="$IBAN"
QONTO_BIC="$BIC"

# Environment
NODE_ENV=production
EOF
    
    # Fichier .env.local (si n'existe pas)
    if [ ! -f "$PROJECT_DIR/.env.local" ]; then
        cat > "$PROJECT_DIR/.env.local" << EOF
# ATTENTION: Remplacez ces valeurs par vos vraies clés Stripe !

# Site Configuration
NEXT_PUBLIC_SITE_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3000/api

# Stripe Configuration GOTEST (TEST - À remplacer)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_KEY_HERE
STRIPE_SECRET_KEY=sk_test_YOUR_KEY_HERE
STRIPE_WEBHOOK_SECRET=whsec_YOUR_SECRET_HERE

# Business Information GOTEST
NEXT_PUBLIC_BUSINESS_NAME="$BUSINESS_NAME"
NEXT_PUBLIC_BUSINESS_SIRET="$SIRET"
NEXT_PUBLIC_BUSINESS_EMAIL="khalid@math4child.com"
NEXT_PUBLIC_BUSINESS_PHONE="+33123456789"

# Qonto Bank Details
QONTO_IBAN="$IBAN"
QONTO_BIC="$BIC"

# Environment
NODE_ENV=development
EOF
        print_success "Fichier .env.local créé (complétez avec vos clés Stripe)"
    else
        print_info "Fichier .env.local existe déjà (non modifié)"
    fi
    
    print_success "Fichiers d'environnement créés"
}

# =============================================================================
# CONFIGURATION PACKAGE.JSON
# =============================================================================

update_package_json() {
    print_section "Mise à jour du package.json"
    
    # Vérifier si les scripts existent déjà
    if grep -q "stripe:setup" "$PROJECT_DIR/package.json"; then
        print_info "Scripts Stripe déjà présents dans package.json"
    else
        # Ajouter les scripts Stripe (nécessite jq)
        if command -v jq >/dev/null 2>&1; then
            tmp_file=$(mktemp)
            jq '.scripts += {
              "stripe:setup": "node -e \"console.log('Allez sur https://dashboard.stripe.com pour récupérer vos clés')\"",
              "stripe:webhooks": "stripe listen --forward-to localhost:3000/api/stripe/webhooks",
              "dev:stripe": "concurrently \"npm run dev\" \"npm run stripe:webhooks\"",
              "test:payments": "node -e \"console.log('Testez les paiements sur http://localhost:3000/subscription')\""
            }' "$PROJECT_DIR/package.json" > "$tmp_file" && mv "$tmp_file" "$PROJECT_DIR/package.json"
            print_success "Scripts Stripe ajoutés au package.json"
        else
            print_warning "jq non installé - Ajoutez manuellement les scripts Stripe"
        fi
    fi
}

# =============================================================================
# DOCUMENTATION
# =============================================================================

create_documentation() {
    print_section "Création de la documentation"
    
    cat > "$PROJECT_DIR/SETUP_GOTEST_STRIPE.md" << EOF
# 🚀 Configuration GOTEST + Math4Kids + Stripe + Qonto

## ✅ Configuration automatique terminée !

Ce script a créé automatiquement :

### 📁 **Structure créée :**
\`\`\`
src/
├── lib/
│   ├── stripe.ts                    # Configuration Stripe principale
│   └── qonto-stripe-config.ts       # Configuration GOTEST + Qonto
├── components/subscription/
│   └── SubscriptionCard.tsx         # Cartes d'abonnement
├── app/
│   ├── api/stripe/                  # API routes Stripe
│   └── subscription/                # Pages d'abonnement
└── hooks/
    └── useAnalytics.ts              # Tracking événements
\`\`\`

### 💳 **Informations configurées :**
- **Entreprise :** $BUSINESS_NAME
- **SIRET :** $SIRET
- **Activité :** $ACTIVITY ($ACTIVITY_CODE)
- **Compte Qonto :** $IBAN
- **Adresse :** $ADDRESS, $POSTAL_CODE $CITY

## 🔑 **Prochaines étapes obligatoires :**

### 1. **Créer votre compte Stripe (15 min)**
1. Allez sur https://dashboard.stripe.com/register
2. Choisissez "Entreprise individuelle"
3. Renseignez vos informations GOTEST :
   - Nom : $BUSINESS_NAME
   - SIRET : $SIRET
   - Adresse : $ADDRESS, $POSTAL_CODE $CITY
4. Ajoutez votre pièce d'identité pour vérification

### 2. **Récupérer vos clés API Stripe**
1. Dashboard Stripe → Développeurs → Clés API
2. Copiez :
   - **Clé publique :** \`pk_test_...\`
   - **Clé secrète :** \`sk_test_...\`

### 3. **Configurer les webhooks Stripe**
1. Dashboard Stripe → Développeurs → Webhooks
2. Ajouter endpoint : \`https://math4child.com/api/stripe/webhooks\`
3. Événements à écouter :
   - \`checkout.session.completed\`
   - \`invoice.payment_succeeded\`
   - \`payout.paid\`
   - \`customer.subscription.*\`
4. Copiez le secret webhook : \`whsec_...\`

### 4. **Mettre à jour .env.local**
Modifiez le fichier \`.env.local\` avec vos vraies clés :
\`\`\`bash
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_REAL_KEY
STRIPE_SECRET_KEY=sk_test_YOUR_REAL_KEY
STRIPE_WEBHOOK_SECRET=whsec_YOUR_REAL_SECRET
\`\`\`

### 5. **Connecter votre compte bancaire Qonto**
1. Dans Stripe Dashboard → Paramètres → Détails bancaires
2. IBAN : $IBAN
3. BIC : $BIC
4. Nom du compte : $BUSINESS_NAME - $OWNER_NAME

## 🧪 **Tester l'installation**

\`\`\`bash
# Démarrer le serveur de développement
npm run dev

# Dans un autre terminal, écouter les webhooks Stripe
npm run stripe:webhooks

# Tester les paiements
# Allez sur http://localhost:3000/subscription
# Utilisez la carte de test : 4242 4242 4242 4242
\`\`\`

## 💰 **Flux des paiements**

\`\`\`
Client paie → Stripe → Qonto ($IBAN) → URSSAF (21.2%) → Vous
\`\`\`

## 📊 **Revenus attendus**

\`\`\`
100 abonnés × 9.99€ = 999€/mois
- Frais Stripe (1.4%) = -14€
- Charges sociales URSSAF (21.2%) = -209€
- Impôts (~30%) = -233€
= ~543€ net/mois
\`\`\`

## 🚀 **Déploiement en production**

\`\`\`bash
# 1. Remplacer les clés test par les clés live dans .env.local
# 2. Build et déployer
npm run build
npm run deploy:web

# 3. Configurer webhook production :
# https://math4child.com/api/stripe/webhooks
\`\`\`

## 📞 **Support**

- **Stripe :** https://support.stripe.com
- **Documentation :** https://stripe.com/docs
- **Qonto :** Support client Qonto

**🎉 Félicitations ! Votre système de paiement GOTEST + Math4Kids est prêt ! 💳**
EOF
    
    print_success "Documentation créée : SETUP_GOTEST_STRIPE.md"
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================

main() {
    print_header
    
    print_info "Configuration automatique pour :"
    echo "  • Entreprise : $BUSINESS_NAME"
    echo "  • SIRET : $SIRET" 
    echo "  • Activité : $ACTIVITY"
    echo "  • Compte Qonto : $IBAN"
    echo "  • Adresse : $ADDRESS, $POSTAL_CODE $CITY"
    echo ""
    
    # Vérifications préliminaires
    check_project_dir
    
    # Exécution des étapes
    create_directory_structure
    install_dependencies
    create_qonto_stripe_config
    create_stripe_config
    create_api_routes
    create_react_components
    create_env_files
    update_package_json
    create_documentation
    
    # Résumé final
    echo -e "\n${WHITE}🎉 CONFIGURATION TERMINÉE AVEC SUCCÈS ! 🎉${NC}\n"
    
    print_info "📁 Fichiers créés :"
    echo "  ✅ Configuration Stripe + Qonto"
    echo "  ✅ API routes de paiement"
    echo "  ✅ Composants React d'abonnement"
    echo "  ✅ Variables d'environnement"
    echo "  ✅ Documentation complète"
    
    echo -e "\n${YELLOW}🔑 PROCHAINES ÉTAPES OBLIGATOIRES :${NC}"
    echo "  1. 🏦 Créer compte Stripe : https://dashboard.stripe.com/register"
    echo "  2. 🔑 Récupérer clés API et webhook secret"
    echo "  3. ⚙️  Mettre à jour .env.local avec vraies clés"
    echo "  4. 🧪 Tester : npm run dev puis /subscription"
    echo "  5. 📖 Lire : apps/math4kids/SETUP_GOTEST_STRIPE.md"
    
    echo -e "\n${GREEN}💡 RAPPEL : Votre compte Qonto ($IBAN) recevra automatiquement les paiements !${NC}"
    echo -e "${GREEN}🚀 Math4Kids est maintenant prêt à générer des revenus pour GOTEST ! 💰${NC}\n"
}

# =============================================================================
# EXÉCUTION
# =============================================================================

# Vérifier si le script est exécuté directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi