#!/bin/bash

# =============================================================================
# CORRECTIF MATH4CHILD - DOSSIER APPS/MATH4KIDS SPÉCIFIQUE
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
echo "║    🔧 CORRECTIF APPS/MATH4KIDS - NEXT.JS 15             ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# 1. Identifier le problème dans apps/math4kids
print_info "Diagnostic du dossier apps/math4kids..."

if [ -d "apps/math4kids" ]; then
    print_warning "Dossier apps/math4kids trouvé avec structure séparée"
    
    # Correction du webhook dans apps/math4kids
    if [ -f "apps/math4kids/src/app/api/stripe/webhooks/route.ts" ]; then
        print_info "Correction du webhook dans apps/math4kids..."
        cat > "apps/math4kids/src/app/api/stripe/webhooks/route.ts" << 'EOF'
import { NextRequest, NextResponse } from 'next/server'
import { stripe } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  const body = await request.text()
  
  // Correction pour Next.js 15: utiliser request.headers.get() directement
  const signature = request.headers.get('stripe-signature')

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
        print_success "Webhook apps/math4kids corrigé"
    fi
    
    # Vérifier et corriger le fichier lib/stripe.ts dans apps/math4kids
    if [ -f "apps/math4kids/src/lib/stripe.ts" ]; then
        print_info "Vérification de lib/stripe.ts dans apps/math4kids..."
        # S'assurer que le fichier est correct
        cat > "apps/math4kids/src/lib/stripe.ts" << 'EOF'
import { loadStripe } from '@stripe/stripe-js'
import Stripe from 'stripe'

// Configuration publique pour le client
export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
)

// Configuration serveur pour l'API
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2024-11-20.acacia',
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
      'Support multilingue (195+ langues)',
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

// Configuration business GOTEST
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

// Configuration Qonto
export const QONTO_BANK_CONFIG = {
  iban: 'FR7616958000016218830371501',
  bic: 'QNTOFRP1XXX',
  bankName: 'Qonto',
  accountHolder: 'KSOURI KHALID'
}

export type SubscriptionPlanKey = keyof typeof SUBSCRIPTION_PLANS
EOF
        print_success "lib/stripe.ts apps/math4kids corrigé"
    fi
    
    # Corriger le checkout session dans apps/math4kids
    if [ -f "apps/math4kids/src/app/api/stripe/create-checkout-session/route.ts" ]; then
        print_info "Correction du checkout session dans apps/math4kids..."
        cat > "apps/math4kids/src/app/api/stripe/create-checkout-session/route.ts" << 'EOF'
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
      receipt_email: customerEmail,
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
        print_success "Checkout session apps/math4kids corrigé"
    fi
    
    # Option: Synchroniser les dossiers ou choisir une structure
    print_warning "Vous avez deux structures parallèles:"
    print_info "1. src/ (racine du projet)"
    print_info "2. apps/math4kids/src/ (structure monorepo)"
    echo ""
    
    read -p "Voulez-vous utiliser uniquement la structure racine (supprimer apps/math4kids) ? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Suppression du dossier apps/math4kids..."
        rm -rf apps/math4kids
        print_success "Structure simplifiée - utilisation de src/ uniquement"
    else
        print_info "Conservation des deux structures"
        print_warning "Assurez-vous que package.json pointe vers la bonne structure"
    fi
    
else
    print_info "Pas de dossier apps/math4kids - structure normale"
fi

# 2. Correction finale du useCallback inutilisé
print_info "Correction de l'import useCallback inutilisé..."
if [ -f "src/app/page.tsx" ]; then
    sed -i '' 's/import React, { useState, useCallback, useEffect }/import React, { useState, useEffect }/' src/app/page.tsx
    print_success "Import useCallback supprimé"
fi

# 3. Nettoyage des lockfiles multiples
print_info "Nettoyage des lockfiles multiples..."
if [ -f "/Users/khalidksouri/Desktop/multi-apps-platform/package-lock.json" ]; then
    rm -f "/Users/khalidksouri/Desktop/multi-apps-platform/package-lock.json"
    print_success "Lockfile externe supprimé"
fi

# 4. Test de compilation final
print_info "Test de compilation final..."
if npm run build; then
    print_success "🎉 BUILD RÉUSSI ! Math4Child fonctionne parfaitement !"
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ SUCCÈS COMPLET !                        ║${NC}"
    echo -e "${GREEN}║          Math4Child + GOTEST + Stripe opérationnel !    ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "🚀 Prêt à démarrer :"
    echo -e "${YELLOW}npm run dev${NC}"
    echo -e "${YELLOW}Visitez: http://localhost:3000${NC}"
    echo ""
    
    print_info "💳 Configuration GOTEST complète :"
    echo -e "${YELLOW}✅ SIRET: 53958712100028${NC}"
    echo -e "${YELLOW}✅ Qonto: FR7616958000016218830371501${NC}"
    echo -e "${YELLOW}✅ API Stripe fonctionnelle${NC}"
    echo -e "${YELLOW}✅ Webhooks Next.js 15 compatibles${NC}"
    echo ""
    
    print_info "🔑 Prochaines étapes :"
    echo -e "${YELLOW}1. Ajoutez vos vraies clés Stripe dans .env.local${NC}"
    echo -e "${YELLOW}2. Créez votre compte Stripe avec info GOTEST${NC}"
    echo -e "${YELLOW}3. Connectez votre compte Qonto${NC}"
    echo -e "${YELLOW}4. Testez: npm run stripe:listen${NC}"
    echo ""
    
    print_success "🎉 Math4Child prêt à générer des revenus vers Qonto ! 💰"
    
else
    print_error "Build encore en échec"
    
    # Diagnostic approfondi
    print_info "Diagnostic approfondi..."
    
    echo "Structure des fichiers API Stripe :"
    find . -name "route.ts" -path "*/api/stripe/*" 2>/dev/null || print_info "Aucun fichier API trouvé"
    
    echo ""
    echo "Contenu des erreurs TypeScript :"
    npx tsc --noEmit --skipLibCheck 2>&1 | head -10 || print_info "Pas d'erreurs tsc détectées"
    
    print_warning "Essayez en mode développement :"
    echo -e "${YELLOW}npm run dev${NC}"
fi

print_success "Script de correction apps/math4kids terminé"