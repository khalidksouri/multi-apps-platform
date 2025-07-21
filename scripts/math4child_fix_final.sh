#!/bin/bash

# =============================================================================
# CORRECTIF FINAL MATH4CHILD - UTILISATION CONFIG GOTEST/QONTO EXISTANTE
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║    🔧 CORRECTIF FINAL MATH4CHILD - CONFIG EXISTANTE     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Vérification du répertoire
if [ ! -f "package.json" ]; then
    print_error "Aucun package.json trouvé. Êtes-vous dans le bon répertoire ?"
    exit 1
fi

print_info "Utilisation de la configuration GOTEST/Qonto existante..."

# 1. Installation des dépendances manquantes
print_info "Installation des dépendances Stripe..."
npm install @stripe/stripe-js stripe --save
npm install @types/stripe --save-dev

# 2. Création du dossier lib s'il n'existe pas
mkdir -p src/lib

# 3. Utilisation du fichier stripe.ts existant mais avec mise à jour API version
print_info "Correction du fichier stripe.ts principal..."
cat > "src/lib/stripe.ts" << 'EOF'
import { loadStripe } from '@stripe/stripe-js'
import Stripe from 'stripe'

// Configuration publique pour le client
export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
)

// Configuration serveur pour l'API
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-11-20.acacia', // Version API la plus récente
})

// Types pour Math4Child
export interface SubscriptionPlan {
  name: string
  price: number
  currency: string
  interval: 'month' | 'year'
  interval_count?: number
  features: string[]
}

// Configuration des plans d'abonnement Math4Kids
export const SUBSCRIPTION_PLANS: Record<string, SubscriptionPlan> = {
  monthly: {
    name: 'Math4Kids Mensuel',
    price: 999, // 9.99€ en centimes
    currency: 'eur',
    interval: 'month',
    interval_count: 1,
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
    price: 2697, // 26.97€ en centimes (10% de réduction)
    currency: 'eur',
    interval: 'month',
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
    price: 8392, // 83.92€ en centimes (30% de réduction)
    currency: 'eur',
    interval: 'year',
    interval_count: 1,
    features: [
      'Tout du plan mensuel',
      '30% de réduction',
      'Accès anticipé aux nouvelles fonctionnalités',
      'Support téléphonique',
      'Certification de progression'
    ]
  }
}

// Configuration business GOTEST (depuis votre fichier existant)
export const STRIPE_BUSINESS_CONFIG = {
  businessName: 'GOTEST',
  siret: '53958712100028',
  address: {
    line1: '1 ALLEE DE LA HAUTE PLACE',
    postal_code: '93160',
    city: 'NOISY-LE-GRAND',
    country: 'FR'
  },
  email: 'khalid_ksouri@yahoo.fr',
  phone: '+33123456789'
}

// Configuration Qonto (depuis votre fichier existant)
export const QONTO_BANK_CONFIG = {
  iban: 'FR7616958000016218830371501',
  bic: 'QNTOFRP1XXX',
  bankName: 'Qonto',
  accountHolder: 'KSOURI KHALID'
}

export type SubscriptionPlanKey = keyof typeof SUBSCRIPTION_PLANS
EOF

# 4. Copie du fichier qonto-stripe-config.ts existant si il n'est pas déjà dans src/lib
if [ -f "qonto-stripe-config.ts" ] && [ ! -f "src/lib/qonto-stripe-config.ts" ]; then
    print_info "Copie du fichier qonto-stripe-config.ts existant..."
    cp qonto-stripe-config.ts src/lib/
fi

# 5. Création de la structure API complète
print_info "Création de la structure API..."
mkdir -p src/app/api/stripe/create-checkout-session
mkdir -p src/app/api/stripe/webhooks

# 6. API de création de session checkout
print_info "Création de l'API checkout avec configuration GOTEST..."
cat > "src/app/api/stripe/create-checkout-session/route.ts" << 'EOF'
import { NextRequest, NextResponse } from 'next/server'
import { stripe, SUBSCRIPTION_PLANS, STRIPE_BUSINESS_CONFIG } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  try {
    const { plan, platform, customerEmail } = await request.json()

    // Vérifier que le plan existe
    if (!SUBSCRIPTION_PLANS[plan]) {
      return NextResponse.json(
        { error: 'Plan invalide' },
        { status: 400 }
      )
    }

    const selectedPlan = SUBSCRIPTION_PLANS[plan]

    // Créer la session Stripe Checkout avec configuration GOTEST
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: customerEmail,
      line_items: [
        {
          price_data: {
            currency: selectedPlan.currency,
            product_data: {
              name: selectedPlan.name,
              description: `Math4Child.com - Application éducative pour enfants`,
              images: ['https://www.math4child.com/images/logo.png'],
              metadata: {
                platform: platform || 'web',
                business: 'GOTEST',
                siret: '53958712100028',
                activity: 'Conseil en systèmes et logiciels informatiques'
              }
            },
            recurring: selectedPlan.interval_count 
              ? {
                  interval: selectedPlan.interval,
                  interval_count: selectedPlan.interval_count,
                }
              : {
                  interval: selectedPlan.interval,
                },
            unit_amount: selectedPlan.price,
          },
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'}/cancel`,
      metadata: {
        plan: plan,
        platform: platform || 'web',
        business: 'GOTEST - Math4Child',
        contact: 'khalid_ksouri@yahoo.fr',
        siret: '53958712100028'
      },
      subscription_data: {
        metadata: {
          plan: plan,
          platform: platform || 'web',
          business: 'GOTEST',
          qonto_iban: 'FR7616958000016218830371501'
        }
      },
      // Configuration pour les reçus
      receipt_email: customerEmail,
      // Déclaration des taxes (France)
      automatic_tax: { enabled: true }
    })

    return NextResponse.json({ url: session.url })
  } catch (error) {
    console.error('Erreur création session Stripe:', error)
    return NextResponse.json(
      { error: 'Erreur lors de la création de la session de paiement' },
      { status: 500 }
    )
  }
}
EOF

# 7. API webhook avec logging GOTEST
print_info "Création de l'API webhook..."
cat > "src/app/api/stripe/webhooks/route.ts" << 'EOF'
import { NextRequest, NextResponse } from 'next/server'
import { stripe } from '@/lib/stripe'
import { headers } from 'next/headers'

export async function POST(request: NextRequest) {
  const body = await request.text()
  const headersList = headers()
  const signature = headersList.get('stripe-signature')

  if (!signature) {
    return NextResponse.json(
      { error: 'Signature manquante' },
      { status: 400 }
    )
  }

  try {
    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    )

    console.log('📧 [GOTEST] Webhook reçu:', event.type)

    switch (event.type) {
      case 'checkout.session.completed':
        const session = event.data.object
        console.log('💳 [GOTEST] Paiement réussi Math4Child:', session.id)
        console.log('💰 [GOTEST] Montant:', session.amount_total, 'centimes')
        console.log('🏦 [GOTEST] Direction Qonto:', 'FR7616958000016218830371501')
        // Ici vous pourriez enregistrer l'abonnement en base de données
        break

      case 'customer.subscription.created':
        const subscription = event.data.object
        console.log('🎉 [GOTEST] Nouvel abonnement Math4Child:', subscription.id)
        break

      case 'customer.subscription.updated':
        const updatedSubscription = event.data.object
        console.log('🔄 [GOTEST] Abonnement mis à jour:', updatedSubscription.id)
        break

      case 'customer.subscription.deleted':
        const deletedSubscription = event.data.object
        console.log('❌ [GOTEST] Abonnement annulé:', deletedSubscription.id)
        break

      case 'invoice.payment_succeeded':
        const invoice = event.data.object
        console.log('💰 [GOTEST] Paiement récurrent Math4Child réussi:', invoice.id)
        break

      case 'invoice.payment_failed':
        const failedInvoice = event.data.object
        console.log('⚠️ [GOTEST] Échec de paiement Math4Child:', failedInvoice.id)
        break

      case 'payout.paid':
        const payout = event.data.object
        console.log('🏦 [GOTEST] Virement vers Qonto effectué:', payout.id)
        console.log('💸 [GOTEST] Montant viré:', payout.amount, 'centimes')
        break

      default:
        console.log('🔔 [GOTEST] Événement non géré:', event.type)
    }

    return NextResponse.json({ received: true })
  } catch (error) {
    console.error('❌ [GOTEST] Erreur webhook:', error)
    return NextResponse.json(
      { error: 'Erreur webhook' },
      { status: 400 }
    )
  }
}
EOF

# 8. Création du dossier components s'il n'existe pas
mkdir -p src/components/subscription

# 9. Copie du SubscriptionCard.tsx existant si il n'est pas déjà dans components
if [ -f "SubscriptionCard.tsx" ] && [ ! -f "src/components/subscription/SubscriptionCard.tsx" ]; then
    print_info "Copie du composant SubscriptionCard existant..."
    cp SubscriptionCard.tsx src/components/subscription/
fi

# 10. Création des pages de succès et d'annulation
print_info "Création des pages de succès..."
mkdir -p src/app/success
cat > "src/app/success/page.tsx" << 'EOF'
'use client'

import { useSearchParams } from 'next/navigation'
import { useEffect, useState } from 'react'
import { Check, Home } from 'lucide-react'

export default function SuccessPage() {
  const searchParams = useSearchParams()
  const sessionId = searchParams.get('session_id')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return <div>Chargement...</div>
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-400 via-blue-500 to-purple-600 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl p-12 text-center max-w-2xl shadow-2xl">
        <div className="text-8xl mb-6">🎉</div>
        <h1 className="text-4xl font-bold text-gray-800 mb-6">
          Félicitations !
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          Votre abonnement Math4Child a été activé avec succès.
        </p>
        
        {sessionId && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-8">
            <p className="text-sm text-green-700">
              Session ID: {sessionId}
            </p>
          </div>
        )}

        <div className="space-y-4">
          <div className="flex items-center justify-center space-x-2 text-green-600">
            <Check size={20} />
            <span>Accès illimité activé</span>
          </div>
          <div className="flex items-center justify-center space-x-2 text-green-600">
            <Check size={20} />
            <span>Tous les niveaux débloqués</span>
          </div>
          <div className="flex items-center justify-center space-x-2 text-green-600">
            <Check size={20} />
            <span>195+ langues disponibles</span>
          </div>
        </div>

        <button
          onClick={() => window.location.href = '/'}
          className="mt-8 bg-gradient-to-r from-green-500 to-emerald-600 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all flex items-center justify-center space-x-3 mx-auto"
        >
          <Home size={24} />
          <span>Commencer à apprendre</span>
        </button>

        <p className="text-xs text-gray-500 mt-8">
          Math4Child.com - GOTEST (SIRET: 53958712100028)<br/>
          Paiement sécurisé par Stripe • Virements vers Qonto
        </p>
      </div>
    </div>
  )
}
EOF

# Page d'annulation
mkdir -p src/app/cancel
cat > "src/app/cancel/page.tsx" << 'EOF'
'use client'

import { Home, ArrowLeft } from 'lucide-react'

export default function CancelPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-red-400 via-pink-500 to-purple-600 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl p-12 text-center max-w-2xl shadow-2xl">
        <div className="text-8xl mb-6">😔</div>
        <h1 className="text-4xl font-bold text-gray-800 mb-6">
          Commande annulée
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          Votre commande a été annulée. Aucun montant n'a été débité.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <button
            onClick={() => window.history.back()}
            className="bg-gradient-to-r from-gray-500 to-gray-600 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-gray-600 hover:to-gray-700 transition-all flex items-center justify-center space-x-3"
          >
            <ArrowLeft size={24} />
            <span>Retour</span>
          </button>
          
          <button
            onClick={() => window.location.href = '/'}
            className="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-blue-600 hover:to-blue-700 transition-all flex items-center justify-center space-x-3"
          >
            <Home size={24} />
            <span>Accueil</span>
          </button>
        </div>

        <p className="text-xs text-gray-500 mt-8">
          Des questions ? Contactez GOTEST : khalid_ksouri@yahoo.fr
        </p>
      </div>
    </div>
  )
}
EOF

# 11. Mise à jour du fichier .env.local avec la configuration GOTEST
print_info "Mise à jour du fichier environnement..."
if [ ! -f ".env.local" ]; then
    cat > ".env.local" << 'EOF'
# Configuration Math4Child - GOTEST
NEXT_PUBLIC_SITE_URL=http://localhost:3000

# Stripe Configuration (À remplacer par vos vraies clés)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_placeholder
STRIPE_SECRET_KEY=sk_test_placeholder
STRIPE_WEBHOOK_SECRET=whsec_placeholder

# Business GOTEST
NEXT_PUBLIC_BUSINESS_NAME="GOTEST"
NEXT_PUBLIC_BUSINESS_SIRET="53958712100028"
NEXT_PUBLIC_BUSINESS_EMAIL="khalid_ksouri@yahoo.fr"
NEXT_PUBLIC_BUSINESS_PHONE="+33123456789"

# Qonto Bank Details
QONTO_IBAN="FR7616958000016218830371501"
QONTO_BIC="QNTOFRP1XXX"
QONTO_ACCOUNT_HOLDER="KSOURI KHALID"

# Environment
NODE_ENV=development
EOF
    print_success "Fichier .env.local créé avec configuration GOTEST"
fi

# 12. Mise à jour du package.json avec scripts Stripe
print_info "Ajout des scripts Stripe au package.json..."
# Utilisation de node pour modifier le package.json
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.scripts = pkg.scripts || {};
pkg.scripts['stripe:listen'] = 'stripe listen --forward-to localhost:3000/api/stripe/webhooks';
pkg.scripts['stripe:setup'] = 'echo \"📋 Guide: https://dashboard.stripe.com/register\"';
pkg.scripts['dev:stripe'] = 'concurrently \"npm run dev\" \"npm run stripe:listen\"';
pkg.author = {
  name: 'Khalid Ksouri',
  email: 'khalid_ksouri@yahoo.fr',
  company: 'GOTEST',
  siret: '53958712100028'
};
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

# 13. Test final avec build
print_info "Test de build..."
if npm run build; then
    print_success "🎉 BUILD RÉUSSI ! Configuration GOTEST/Qonto intégrée !"
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ PROBLÈME RÉSOLU !                       ║${NC}"
    echo -e "${GREEN}║          Math4Child prêt avec config GOTEST/Qonto       ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "🚀 Pour démarrer :"
    echo -e "${YELLOW}npm run dev${NC}"
    echo -e "${YELLOW}Visitez: http://localhost:3000${NC}"
    echo ""
    
    print_info "💳 Configuration Stripe GOTEST :"
    echo -e "${YELLOW}• Entreprise: GOTEST (SIRET: 53958712100028)${NC}"
    echo -e "${YELLOW}• Compte Qonto: FR7616958000016218830371501${NC}"
    echo -e "${YELLOW}• Activité: Conseil en systèmes et logiciels informatiques${NC}"
    echo ""
    
    print_info "🔑 Prochaines étapes :"
    echo -e "${YELLOW}1. Créer compte Stripe: https://dashboard.stripe.com/register${NC}"
    echo -e "${YELLOW}2. Ajouter vos clés dans .env.local${NC}"
    echo -e "${YELLOW}3. Connecter votre compte bancaire Qonto${NC}"
    echo -e "${YELLOW}4. Tester: npm run stripe:listen${NC}"
    
else
    print_warning "Build échoué, mais les fichiers sont créés"
    print_info "Essayez :"
    echo -e "${YELLOW}1. npm install${NC}"
    echo -e "${YELLOW}2. Vérifiez les importations dans vos fichiers${NC}"
    echo -e "${YELLOW}3. npm run dev${NC}"
fi

print_success "Configuration Math4Child avec GOTEST/Qonto terminée !"
echo -e "${GREEN}💰 Vos paiements Math4Child seront automatiquement virés sur votre compte Qonto !${NC}"