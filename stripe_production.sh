#!/bin/bash

# =============================================================================
# CONFIGURATION STRIPE PRODUCTION - MATH4CHILD
# =============================================================================

echo "🎯 Configuration Stripe Production pour Math4Child"
echo "=================================================="

# Vérifier si nous sommes dans le bon répertoire
if [[ ! -f "package.json" ]]; then
    echo "❌ Erreur: package.json non trouvé"
    echo "Assurez-vous d'être dans le répertoire de l'application"
    exit 1
fi

# Créer l'API route pour Stripe
mkdir -p src/app/api/stripe/create-checkout-session

cat > src/app/api/stripe/create-checkout-session/route.ts << 'EOF'
import { NextRequest, NextResponse } from 'next/server'
import { stripe, SUBSCRIPTION_PLANS } from '@/lib/stripe'

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

    // Créer la session Stripe Checkout
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      customer_email: customerEmail,
      line_items: [
        {
          price_data: {
            currency: selectedPlan.currency,
            product_data: {
              name: selectedPlan.name,
              description: `Math4Child - Application éducative GOTEST`,
              images: ['https://www.math4child.com/images/logo.png'],
              metadata: {
                platform: platform || 'web',
                business: 'GOTEST',
                siret: '53958712100028'
              }
            },
            recurring: selectedPlan.interval_count && selectedPlan.interval_count > 1
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
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL}/cancel`,
      metadata: {
        plan: plan,
        platform: platform || 'web',
        business: 'GOTEST - Math4Child',
        contact: 'gotesttech@gmail.com',
        siret: '53958712100028'
      },
      subscription_data: {
        metadata: {
          plan: plan,
          platform: platform || 'web',
          business: 'GOTEST'
        }
      }
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

export async function GET() {
  return NextResponse.json({ 
    message: 'API Stripe Math4Child - GOTEST',
    contact: 'gotesttech@gmail.com',
    siret: '53958712100028'
  })
}
EOF

echo "✅ API route Stripe créée"

# Mettre à jour la configuration Stripe dans lib/stripe.ts
cat > src/lib/stripe.ts << 'EOF'
import { loadStripe } from '@stripe/stripe-js'
import Stripe from 'stripe'

// Configuration publique pour le client
export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
)

// Configuration serveur pour l'API
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-06-20',
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

// Configuration des plans d'abonnement Math4Child - GOTEST
export const SUBSCRIPTION_PLANS: Record<string, SubscriptionPlan> = {
  free: {
    name: 'Math4Child Explorer',
    price: 0, // Gratuit
    currency: 'eur',
    interval: 'month',
    features: [
      '50 questions totales',
      'Niveau 1 seulement',
      '1 profil enfant',
      'Support communautaire'
    ]
  },
  monthly: {
    name: 'Math4Child Aventurier',
    price: 999, // 9.99€ en centimes
    currency: 'eur',
    interval: 'month',
    features: [
      'Questions illimitées',
      'Tous les 5 niveaux',
      '3 profils enfants',
      'IA adaptative',
      'Support prioritaire'
    ]
  },
  quarterly: {
    name: 'Math4Child Champion',
    price: 2697, // 26.97€ en centimes (10% de réduction)
    currency: 'eur',
    interval: 'month',
    interval_count: 3,
    features: [
      'Tout du plan Aventurier',
      '10% de réduction',
      '5 profils enfants',
      'Mode multijoueur',
      'Défis exclusifs',
      'Statistiques avancées'
    ]
  },
  annual: {
    name: 'Math4Child Maître',
    price: 8393, // 83.93€ en centimes (30% de réduction)
    currency: 'eur',
    interval: 'year',
    features: [
      'Tout du plan Champion',
      '30% de réduction',
      '10 profils enfants',
      'Accès anticipé aux nouvelles fonctionnalités',
      'Mode tournoi',
      'Support téléphonique',
      'Certificats de progression'
    ]
  }
}

// Configuration business GOTEST
export const STRIPE_BUSINESS_CONFIG = {
  businessName: 'GOTEST',
  siret: '53958712100028',
  address: {
    line1: 'Adresse GOTEST',
    postal_code: '75000',
    city: 'Paris',
    country: 'FR'
  },
  email: 'gotesttech@gmail.com',
  phone: '+33123456789',
  website: 'https://www.math4child.com'
}

export type SubscriptionPlanKey = keyof typeof SUBSCRIPTION_PLANS
EOF

echo "✅ Configuration Stripe mise à jour"

# Créer les pages de succès et d'annulation
mkdir -p src/app/success src/app/cancel

cat > src/app/success/page.tsx << 'EOF'
'use client'

import { useEffect, useState } from 'react'
import { useSearchParams } from 'next/navigation'

export default function SuccessPage() {
  const searchParams = useSearchParams()
  const [sessionId, setSessionId] = useState<string | null>(null)

  useEffect(() => {
    const id = searchParams.get('session_id')
    setSessionId(id)
  }, [searchParams])

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 flex items-center justify-center p-4">
      <div className="max-w-md w-full bg-white rounded-2xl shadow-xl p-8 text-center">
        <div className="w-16 h-16 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-6">
          <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        
        <h1 className="text-2xl font-bold text-gray-900 mb-4">
          🎉 Paiement Réussi !
        </h1>
        
        <p className="text-gray-600 mb-6">
          Félicitations ! Votre abonnement Math4Child a été activé avec succès.
        </p>
        
        <div className="bg-gray-50 rounded-lg p-4 mb-6">
          <p className="text-sm text-gray-500">ID de session</p>
          <p className="text-xs text-gray-700 font-mono break-all">{sessionId}</p>
        </div>
        
        <div className="space-y-4">
          <button
            onClick={() => window.location.href = '/'}
            className="w-full bg-gradient-to-r from-blue-500 to-purple-600 text-white font-bold py-3 px-6 rounded-xl hover:from-blue-600 hover:to-purple-700 transition-all duration-200"
          >
            Commencer l'Aventure Math4Child
          </button>
          
          <p className="text-xs text-gray-500">
            Développé par GOTEST (SIRET: 53958712100028)<br/>
            📧 gotesttech@gmail.com
          </p>
        </div>
      </div>
    </div>
  )
}
EOF

cat > src/app/cancel/page.tsx << 'EOF'
'use client'

export default function CancelPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-red-50 to-orange-50 flex items-center justify-center p-4">
      <div className="max-w-md w-full bg-white rounded-2xl shadow-xl p-8 text-center">
        <div className="w-16 h-16 bg-orange-500 rounded-full flex items-center justify-center mx-auto mb-6">
          <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </div>
        
        <h1 className="text-2xl font-bold text-gray-900 mb-4">
          Paiement Annulé
        </h1>
        
        <p className="text-gray-600 mb-6">
          Aucun problème ! Vous pouvez toujours essayer Math4Child gratuitement.
        </p>
        
        <div className="space-y-4">
          <button
            onClick={() => window.location.href = '/'}
            className="w-full bg-gradient-to-r from-blue-500 to-purple-600 text-white font-bold py-3 px-6 rounded-xl hover:from-blue-600 hover:to-purple-700 transition-all duration-200"
          >
            Retour à Math4Child
          </button>
          
          <button
            onClick={() => window.location.href = '/?pricing=true'}
            className="w-full bg-gray-100 hover:bg-gray-200 text-gray-800 font-bold py-3 px-6 rounded-xl transition-all duration-200"
          >
            Voir les Plans d'Abonnement
          </button>
          
          <p className="text-xs text-gray-500">
            Besoin d'aide ? Contactez-nous<br/>
            📧 gotesttech@gmail.com<br/>
            GOTEST (SIRET: 53958712100028)
          </p>
        </div>
      </div>
    </div>
  )
}
EOF

echo "✅ Pages de succès et d'annulation créées"

# Mettre à jour la page principale pour intégrer Stripe
sed -i.bak 's/alert.*Stripe à venir.*!/initiateStripeCheckout(key)/g' src/app/page.tsx 2>/dev/null || true

# Ajouter la fonction Stripe à la page principale
cat >> src/app/page.tsx << 'EOF'

// Fonction pour initier le checkout Stripe
const initiateStripeCheckout = async (planKey: string) => {
  try {
    const response = await fetch('/api/stripe/create-checkout-session', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        plan: planKey,
        platform: 'web',
        customerEmail: 'customer@example.com' // À remplacer par l'email réel
      }),
    })

    const { url } = await response.json()
    
    if (url) {
      window.location.href = url
    } else {
      alert('Erreur lors de la création de la session de paiement')
    }
  } catch (error) {
    console.error('Erreur Stripe:', error)
    alert('Erreur lors de la redirection vers Stripe')
  }
}
EOF

echo "✅ Intégration Stripe dans la page principale"

# Créer le fichier d'environnement exemple
cat > .env.example << 'EOF'
# Configuration Math4Child - GOTEST

# Site
NEXT_PUBLIC_SITE_URL=https://www.math4child.com
NODE_ENV=production

# GOTEST Business
COMPANY=GOTEST
CONTACT=gotesttech@gmail.com
SIRET=53958712100028

# Stripe (Production)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Stripe (Test - pour développement)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Langue par défaut
DEFAULT_LANGUAGE=fr
EOF

echo "✅ Fichier d'environnement exemple créé"

echo ""
echo "🎯 Configuration Stripe terminée !"
echo "=================================="
echo ""
echo "📋 Prochaines étapes :"
echo "1. Créer un compte Stripe sur https://stripe.com"
echo "2. Récupérer vos clés API (test puis production)"
echo "3. Créer un fichier .env.local avec vos vraies clés"
echo "4. Tester les paiements en mode test"
echo "5. Activer le mode production"
echo ""
echo "📧 Support GOTEST : gotesttech@gmail.com"
echo "🏢 SIRET : 53958712100028"
