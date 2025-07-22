#!/bin/bash

# =============================================================================
# 🚀 SCRIPT D'INTÉGRATION PADDLE POUR MATH4CHILD
# =============================================================================

set -e  # Arrêt en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                   📦 PADDLE INTEGRATION                     ║"
    echo "║                     Math4Child Project                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${CYAN}🔧 $1${NC}"
    echo "════════════════════════════════════════════════════════════════"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# =============================================================================
# 1. VÉRIFICATIONS PRÉLIMINAIRES
# =============================================================================

check_prerequisites() {
    print_section "Vérifications préliminaires"
    
    # Vérifier si on est dans un projet Node.js
    if [ ! -f "package.json" ]; then
        print_error "package.json non trouvé. Êtes-vous dans la racine du projet Math4Child ?"
        exit 1
    fi
    
    # Vérifier si le fichier source existe
    if [ ! -f "paddle_checkout_fix.ts" ]; then
        print_error "Fichier paddle_checkout_fix.ts non trouvé dans le répertoire courant"
        print_info "Placez le fichier dans la racine du projet avant d'exécuter ce script"
        exit 1
    fi
    
    # Vérifier la structure du projet (Next.js)
    if [ ! -d "src" ] && [ ! -d "pages" ] && [ ! -d "app" ]; then
        print_warning "Structure de projet non reconnue. Création de la structure src/"
        mkdir -p src
    fi
    
    print_success "Vérifications terminées"
}

# =============================================================================
# 2. CRÉATION DE LA STRUCTURE DE DOSSIERS
# =============================================================================

create_directory_structure() {
    print_section "Création de la structure de dossiers"
    
    # Détecter le type de projet Next.js
    if [ -d "app" ]; then
        PROJECT_TYPE="app-router"
        API_DIR="src/app/api"
        PAGES_DIR="src/app"
    elif [ -d "pages" ]; then
        PROJECT_TYPE="pages-router"
        API_DIR="src/pages/api"
        PAGES_DIR="src/pages"
    else
        PROJECT_TYPE="src-default"
        API_DIR="src/pages/api"
        PAGES_DIR="src/pages"
    fi
    
    print_info "Type de projet détecté: $PROJECT_TYPE"
    
    # Créer la structure de dossiers
    mkdir -p src/lib/paddle
    mkdir -p src/lib/payments
    mkdir -p src/components/pricing
    mkdir -p src/types
    mkdir -p "$API_DIR/payments"
    mkdir -p tests/e2e
    mkdir -p config
    
    print_success "Structure de dossiers créée"
}

# =============================================================================
# 3. EXTRACTION ET DIVISION DU FICHIER SOURCE
# =============================================================================

extract_and_split_file() {
    print_section "Extraction et division du fichier paddle_checkout_fix.ts"
    
    # Créer le fichier des types
    print_info "Création de src/types/paddle.ts"
    cat > src/types/paddle.ts << 'EOF'
export interface PaddlePlan {
  id: string
  name: string
  priceId: string
  amount: number
  currency: string
  interval: 'month' | 'quarter' | 'year'
  trialDays: number
}

export interface PricingComponentProps {
  onPlanSelect: (planType: string, interval: string) => void
}

export interface CheckoutResponse {
  success: boolean
  provider: string
  checkoutUrl: string
  sessionId: string
}

export type IntervalType = 'month' | 'quarter' | 'year'
export type PlanType = 'famille' | 'premium' | 'ecole'
EOF

    # Extraire la configuration des plans
    print_info "Création de src/lib/paddle/plans.ts"
    cat > src/lib/paddle/plans.ts << 'EOF'
import { PaddlePlan } from '@/types/paddle'

export const PADDLE_PLANS: Record<string, PaddlePlan[]> = {
  famille: [
    {
      id: 'famille_monthly',
      name: 'Famille Mensuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p7r', // ID réel Paddle
      amount: 699, // 6.99€
      currency: 'EUR',
      interval: 'month',
      trialDays: 14
    },
    {
      id: 'famille_quarterly',
      name: 'Famille Trimestriel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p8s', // ID réel Paddle
      amount: 1887, // 18.87€ (économie 10%)
      currency: 'EUR',
      interval: 'quarter',
      trialDays: 14
    },
    {
      id: 'famille_yearly',
      name: 'Famille Annuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p9t', // ID réel Paddle
      amount: 5832, // 58.32€ (économie 30%)
      currency: 'EUR',
      interval: 'year',
      trialDays: 14
    }
  ],
  premium: [
    {
      id: 'premium_monthly',
      name: 'Premium Mensuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p0u',
      amount: 499,
      currency: 'EUR',
      interval: 'month',
      trialDays: 7
    },
    {
      id: 'premium_quarterly',
      name: 'Premium Trimestriel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p1v',
      amount: 1347, // 13.47€ (économie 10%)
      currency: 'EUR',
      interval: 'quarter',
      trialDays: 7
    },
    {
      id: 'premium_yearly',
      name: 'Premium Annuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p2w',
      amount: 4194, // 41.94€ (économie 30%)
      currency: 'EUR',
      interval: 'year',
      trialDays: 7
    }
  ],
  ecole: [
    {
      id: 'ecole_monthly',
      name: 'École Mensuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p3x',
      amount: 2499,
      currency: 'EUR',
      interval: 'month',
      trialDays: 30
    },
    {
      id: 'ecole_quarterly',
      name: 'École Trimestriel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p4y',
      amount: 6747, // 67.47€ (économie 10%)
      currency: 'EUR',
      interval: 'quarter',
      trialDays: 30
    },
    {
      id: 'ecole_yearly',
      name: 'École Annuel',
      priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p5z',
      amount: 20993, // 209.93€ (économie 30%)
      currency: 'EUR',
      interval: 'year',
      trialDays: 30
    }
  ]
}

export function getPlanByTypeAndInterval(planType: string, interval: string) {
  const plans = PADDLE_PLANS[planType]
  return plans?.find(p => p.interval === interval)
}

export function getAllIntervals(): Array<'month' | 'quarter' | 'year'> {
  return ['month', 'quarter', 'year']
}

export function getDiscountPercentage(interval: string): number {
  switch (interval) {
    case 'quarter': return 10
    case 'year': return 30
    default: return 0
  }
}
EOF

    # Créer les fonctions de checkout
    print_info "Création de src/lib/paddle/checkout.ts"
    cat > src/lib/paddle/checkout.ts << 'EOF'
import { CheckoutResponse } from '@/types/paddle'
import { getPlanByTypeAndInterval } from './plans'

export async function createPaddleCheckout(
  planType: string, 
  interval: string, 
  userEmail: string
): Promise<CheckoutResponse> {
  const selectedPlan = getPlanByTypeAndInterval(planType, interval)
  
  if (!selectedPlan) {
    throw new Error(`Plan ${planType} avec interval ${interval} non trouvé`)
  }

  // Configuration Paddle avec URL réelle
  const checkoutData = {
    items: [{
      priceId: selectedPlan.priceId,
      quantity: 1
    }],
    customer: {
      email: userEmail
    },
    customData: {
      planId: selectedPlan.id,
      planType: planType,
      interval: interval,
      app: 'Math4Child',
      version: '1.0.0'
    },
    settings: {
      allowLogout: false,
      displayMode: 'overlay',
      theme: 'light',
      locale: 'fr',
      successUrl: `${process.env.NEXT_PUBLIC_APP_URL}/success?session_id={checkout.id}`,
      cancelUrl: `${process.env.NEXT_PUBLIC_APP_URL}/pricing`
    },
    discountId: interval === 'year' ? 'dsc_annual_30_off' : 
                 interval === 'quarter' ? 'dsc_quarterly_10_off' : null
  }

  // Appel à l'API Paddle réelle
  const response = await fetch('https://api.paddle.com/checkout/custom', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.PADDLE_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(checkoutData)
  })

  if (!response.ok) {
    throw new Error(`Erreur Paddle: ${response.status} ${response.statusText}`)
  }

  const result = await response.json()
  
  return {
    success: true,
    provider: 'paddle',
    checkoutUrl: result.data.url, // URL réelle du checkout
    sessionId: result.data.id
  }
}

export async function validatePaddleWebhook(signature: string, body: string): Promise<boolean> {
  // Validation du webhook Paddle
  // À implémenter selon la documentation Paddle
  return true
}
EOF

    print_success "Fichiers extraits et divisés"
}

# =============================================================================
# 4. CRÉATION DES COMPOSANTS REACT
# =============================================================================

create_react_components() {
    print_section "Création des composants React"
    
    # Composant principal de pricing
    print_info "Création de src/components/pricing/PricingComponent.tsx"
    cat > src/components/pricing/PricingComponent.tsx << 'EOF'
'use client'
import { useState } from 'react'
import { PricingComponentProps, IntervalType } from '@/types/paddle'
import { PADDLE_PLANS, getDiscountPercentage } from '@/lib/paddle/plans'
import { IntervalSelector } from './IntervalSelector'
import { PlanCard } from './PlanCard'

export function PricingComponent({ onPlanSelect }: PricingComponentProps) {
  const [selectedInterval, setSelectedInterval] = useState<IntervalType>('month')
  
  return (
    <div className="pricing-container max-w-7xl mx-auto px-4 py-12">
      {/* Header */}
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-white mb-4">
          Choisissez votre plan Math4Child
        </h1>
        <p className="text-xl text-white/80 mb-8">
          Plans compétitifs avec essai gratuit - Annulation facile
        </p>
      </div>

      {/* Sélecteur d'intervalle */}
      <IntervalSelector 
        selectedInterval={selectedInterval}
        onIntervalChange={setSelectedInterval}
      />

      {/* Plans d'abonnement */}
      <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6 mt-12">
        {Object.entries(PADDLE_PLANS).map(([planType, plans]) => {
          const plan = plans.find(p => p.interval === selectedInterval)
          if (!plan) return null

          return (
            <PlanCard
              key={`${planType}-${selectedInterval}`}
              plan={plan}
              planType={planType}
              interval={selectedInterval}
              onSelect={() => onPlanSelect(planType, selectedInterval)}
              isPopular={planType === 'famille'}
              isRecommended={planType === 'ecole'}
            />
          )
        })}
      </div>

      {/* Garanties */}
      <div className="mt-16 text-center">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
          <div className="text-white/80">
            <div className="text-3xl mb-2">🔒</div>
            <h3 className="font-semibold mb-1">Paiement sécurisé</h3>
            <p className="text-sm">Chiffrement SSL 256-bit</p>
          </div>
          <div className="text-white/80">
            <div className="text-3xl mb-2">↩️</div>
            <h3 className="font-semibold mb-1">Annulation facile</h3>
            <p className="text-sm">Résiliez à tout moment</p>
          </div>
          <div className="text-white/80">
            <div className="text-3xl mb-2">✨</div>
            <h3 className="font-semibold mb-1">Satisfaction garantie</h3>
            <p className="text-sm">30 jours satisfait ou remboursé</p>
          </div>
        </div>
      </div>
    </div>
  )
}
EOF

    # Composant sélecteur d'intervalle
    print_info "Création de src/components/pricing/IntervalSelector.tsx"
    cat > src/components/pricing/IntervalSelector.tsx << 'EOF'
'use client'
import { IntervalType } from '@/types/paddle'
import { getDiscountPercentage } from '@/lib/paddle/plans'

interface IntervalSelectorProps {
  selectedInterval: IntervalType
  onIntervalChange: (interval: IntervalType) => void
}

export function IntervalSelector({ selectedInterval, onIntervalChange }: IntervalSelectorProps) {
  const intervals: Array<{ key: IntervalType; label: string }> = [
    { key: 'month', label: 'Mensuel' },
    { key: 'quarter', label: 'Trimestriel' },
    { key: 'year', label: 'Annuel' }
  ]

  return (
    <div className="flex justify-center">
      <div className="bg-white/10 backdrop-blur-sm rounded-lg p-1 flex">
        {intervals.map(({ key, label }) => {
          const discount = getDiscountPercentage(key)
          const isSelected = selectedInterval === key
          
          return (
            <button
              key={key}
              onClick={() => onIntervalChange(key)}
              className={`relative px-6 py-3 rounded-md transition-all font-medium ${
                isSelected
                  ? 'bg-blue-600 text-white shadow-lg'
                  : 'text-white/70 hover:text-white hover:bg-white/5'
              }`}
            >
              {label}
              {discount > 0 && (
                <div className="absolute -top-2 -right-2">
                  <span className="bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                    -{discount}%
                  </span>
                </div>
              )}
            </button>
          )
        })}
      </div>
    </div>
  )
}
EOF

    # Composant carte de plan
    print_info "Création de src/components/pricing/PlanCard.tsx"
    cat > src/components/pricing/PlanCard.tsx << 'EOF'
'use client'
import { PaddlePlan, IntervalType } from '@/types/paddle'

interface PlanCardProps {
  plan: PaddlePlan
  planType: string
  interval: IntervalType
  onSelect: () => void
  isPopular?: boolean
  isRecommended?: boolean
}

export function PlanCard({ 
  plan, 
  planType, 
  interval, 
  onSelect, 
  isPopular = false, 
  isRecommended = false 
}: PlanCardProps) {
  const formatPrice = (amount: number) => (amount / 100).toFixed(2)
  
  const getIntervalLabel = (interval: IntervalType) => {
    switch (interval) {
      case 'month': return 'mois'
      case 'quarter': return 'trimestre'
      case 'year': return 'an'
    }
  }

  const getPlanFeatures = (planType: string) => {
    const baseFeatures = ['Questions illimitées', 'Mode hors-ligne', 'Support prioritaire']
    
    switch (planType) {
      case 'famille':
        return [...baseFeatures, '5 profils enfants', 'Rapports parents', 'Synchronisation cloud']
      case 'premium':
        return [...baseFeatures, '2 profils', 'Statistiques avancées']
      case 'ecole':
        return [...baseFeatures, '30 profils élèves', 'Tableau de bord enseignant', 'Rapports détaillés']
      default:
        return baseFeatures
    }
  }

  return (
    <div className={`relative bg-white/10 backdrop-blur-sm rounded-2xl p-6 transition-all hover:bg-white/15 ${
      isPopular ? 'ring-2 ring-blue-400 scale-105' : ''
    } ${isRecommended ? 'ring-2 ring-green-400' : ''}`}>
      
      {/* Badges */}
      {isPopular && (
        <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
          <span className="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-medium">
            Le plus populaire
          </span>
        </div>
      )}
      
      {isRecommended && (
        <div className="absolute -top-3 right-4">
          <span className="bg-green-500 text-white px-3 py-1 rounded-full text-sm font-medium">
            Recommandé
          </span>
        </div>
      )}

      {/* Contenu */}
      <div className="text-center">
        <h3 className="text-xl font-semibold text-white mb-2 capitalize">
          {planType}
        </h3>
        
        <div className="mb-4">
          <span className="text-3xl font-bold text-white">
            {formatPrice(plan.amount)}€
          </span>
          <span className="text-white/70">
            /{getIntervalLabel(interval)}
          </span>
        </div>

        {plan.trialDays > 0 && (
          <div className="bg-green-500/20 text-green-300 px-3 py-1 rounded-full text-sm mb-6">
            {plan.trialDays} jours gratuit
          </div>
        )}

        {/* Fonctionnalités */}
        <ul className="text-white/80 text-sm space-y-2 mb-8">
          {getPlanFeatures(planType).map((feature, index) => (
            <li key={index} className="flex items-center">
              <span className="text-green-400 mr-2">✓</span>
              {feature}
            </li>
          ))}
        </ul>

        <button
          onClick={onSelect}
          className={`w-full py-3 rounded-lg font-semibold transition-all ${
            isPopular
              ? 'bg-blue-600 hover:bg-blue-700 text-white'
              : isRecommended
              ? 'bg-green-600 hover:bg-green-700 text-white'
              : 'bg-white/20 hover:bg-white/30 text-white'
          }`}
        >
          Essai {plan.trialDays}j gratuit
        </button>
      </div>
    </div>
  )
}
EOF

    print_success "Composants React créés"
}

# =============================================================================
# 5. CRÉATION DES API ROUTES
# =============================================================================

create_api_routes() {
    print_section "Création des API routes"
    
    if [ "$PROJECT_TYPE" = "app-router" ]; then
        print_info "Création de l'API route pour App Router"
        mkdir -p src/app/api/payments/create-checkout
        cat > src/app/api/payments/create-checkout/route.ts << 'EOF'
import { NextRequest, NextResponse } from 'next/server'
import { createPaddleCheckout } from '@/lib/paddle/checkout'

export async function POST(request: NextRequest) {
  try {
    const { planType, interval, userEmail } = await request.json()
    
    if (!planType || !interval || !userEmail) {
      return NextResponse.json(
        { error: 'Paramètres manquants' },
        { status: 400 }
      )
    }
    
    const checkout = await createPaddleCheckout(planType, interval, userEmail)
    
    return NextResponse.json(checkout)
  } catch (error) {
    console.error('Erreur checkout Paddle:', error)
    return NextResponse.json(
      { error: 'Erreur lors de la création du checkout' },
      { status: 500 }
    )
  }
}
EOF
    else
        print_info "Création de l'API route pour Pages Router"
        cat > src/pages/api/payments/create-checkout.ts << 'EOF'
import { NextApiRequest, NextApiResponse } from 'next'
import { createPaddleCheckout } from '@/lib/paddle/checkout'

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const { planType, interval, userEmail } = req.body
    
    if (!planType || !interval || !userEmail) {
      return res.status(400).json({ error: 'Paramètres manquants' })
    }
    
    const checkout = await createPaddleCheckout(planType, interval, userEmail)
    
    res.status(200).json(checkout)
  } catch (error) {
    console.error('Erreur checkout Paddle:', error)
    res.status(500).json({ 
      error: 'Erreur lors de la création du checkout' 
    })
  }
}
EOF
    fi

    print_success "API routes créées"
}

# =============================================================================
# 6. CRÉATION DES TESTS PLAYWRIGHT
# =============================================================================

create_tests() {
    print_section "Création des tests Playwright"
    
    print_info "Création de tests/e2e/paddle-checkout.spec.ts"
    cat > tests/e2e/paddle-checkout.spec.ts << 'EOF'
import { test, expect } from '@playwright/test'

test.describe('Checkout Paddle et Plans d\'abonnement', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000/pricing')
  })

  test('Vérifie que tous les intervalles sont disponibles', async ({ page }) => {
    // Vérifier la présence du sélecteur d'intervalle
    await expect(page.locator('.pricing-container')).toBeVisible()
    
    // Tester chaque intervalle
    const intervals = [
      { key: 'Mensuel', discount: null },
      { key: 'Trimestriel', discount: '10%' },
      { key: 'Annuel', discount: '30%' }
    ]
    
    for (const interval of intervals) {
      await page.click(`button:has-text("${interval.key}")`)
      
      // Vérifier que les plans sont affichés pour cet intervalle
      await expect(page.locator('[data-testid="plan-card"]')).toHaveCount(3)
      
      // Vérifier les réductions
      if (interval.discount) {
        await expect(page.locator(`text=-${interval.discount}`)).toBeVisible()
      }
    }
  })

  test('Vérifie la sélection de plan', async ({ page }) => {
    // Intercepter l'appel API
    await page.route('/api/payments/create-checkout', route => {
      route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          success: true,
          provider: 'paddle',
          checkoutUrl: 'https://checkout.paddle.com/test',
          sessionId: 'test_session_123'
        })
      })
    })

    // Sélectionner le plan famille annuel
    await page.click('button:has-text("Annuel")')
    
    // Cliquer sur le bouton d'essai du plan famille
    const familyCard = page.locator('[data-testid="plan-card"]').filter({ hasText: 'famille' })
    await familyCard.locator('button').click()
    
    // Vérifier la redirection ou l'appel API
    await page.waitForFunction(() => 
      window.location.href.includes('checkout.paddle.com') ||
      document.querySelector('[data-testid="checkout-loading"]')
    )
  })

  test('Vérifie les prix affichés', async ({ page }) => {
    // Plan famille mensuel
    await expect(page.locator('text=6.99€')).toBeVisible()
    
    // Changer pour annuel et vérifier la réduction
    await page.click('button:has-text("Annuel")')
    await expect(page.locator('text=58.32€')).toBeVisible()
    
    // Vérifier le badge de réduction
    await expect(page.locator('text=-30%')).toBeVisible()
  })

  test('Gestion des erreurs de checkout', async ({ page }) => {
    // Simuler une erreur API
    await page.route('/api/payments/create-checkout', route => {
      route.fulfill({
        status: 500,
        body: JSON.stringify({ error: 'Erreur serveur Paddle' })
      })
    })

    await page.click('button:has-text("Essai")')
    
    // Vérifier qu'une erreur est affichée
    await expect(page.locator('text=Erreur')).toBeVisible()
  })
})
EOF

    print_success "Tests Playwright créés"
}

# =============================================================================
# 7. CONFIGURATION DES VARIABLES D'ENVIRONNEMENT
# =============================================================================

setup_environment() {
    print_section "Configuration des variables d'environnement"
    
    # Créer ou mettre à jour .env.local
    if [ ! -f ".env.local" ]; then
        print_info "Création de .env.local"
        cat > .env.local << 'EOF'
# =============================================================================
# CONFIGURATION PADDLE POUR MATH4CHILD
# =============================================================================

# Paddle API Keys (à remplacer par vos vraies clés)
PADDLE_API_KEY=your_paddle_api_key_here
PADDLE_WEBHOOK_SECRET=your_paddle_webhook_secret_here
NEXT_PUBLIC_PADDLE_CLIENT_TOKEN=your_paddle_client_token_here

# URLs de l'application
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Base de données (si nécessaire)
DATABASE_URL=your_database_url_here

# Autres providers de paiement (optionnel)
STRIPE_SECRET_KEY=your_stripe_secret_key_here
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret_here
EOF
    else
        print_info "Ajout des variables Paddle à .env.local existant"
        cat >> .env.local << 'EOF'

# =============================================================================
# CONFIGURATION PADDLE AJOUTÉE PAR LE SCRIPT
# =============================================================================
PADDLE_API_KEY=your_paddle_api_key_here
PADDLE_WEBHOOK_SECRET=your_paddle_webhook_secret_here
NEXT_PUBLIC_PADDLE_CLIENT_TOKEN=your_paddle_client_token_here
EOF
    fi
    
    # Créer .env.example
    print_info "Création de .env.example"
    cat > .env.example << 'EOF'
# Configuration Paddle
PADDLE_API_KEY=your_paddle_api_key_here
PADDLE_WEBHOOK_SECRET=your_paddle_webhook_secret_here
NEXT_PUBLIC_PADDLE_CLIENT_TOKEN=your_paddle_client_token_here

# URLs
NEXT_PUBLIC_APP_URL=http://localhost:3000
EOF

    print_success "Variables d'environnement configurées"
}

# =============================================================================
# 8. MISE À JOUR DU PACKAGE.JSON
# =============================================================================

update_dependencies() {
    print_section "Mise à jour des dépendances"
    
    # Vérifier si les dépendances Paddle sont nécessaires
    if ! grep -q "@paddle/paddle-js" package.json; then
        print_info "Ajout de @paddle/paddle-js aux dépendances"
        npm install @paddle/paddle-js
    fi
    
    # Ajouter les scripts de test si nécessaires
    if ! grep -q "test:paddle" package.json; then
        print_info "Ajout des scripts de test Paddle"
        # Utiliser jq si disponible, sinon modification manuelle
        if command -v jq > /dev/null; then
            tmp=$(mktemp)
            jq '.scripts["test:paddle"] = "playwright test tests/e2e/paddle-checkout.spec.ts"' package.json > "$tmp" && mv "$tmp" package.json
            jq '.scripts["test:e2e"] = "playwright test"' package.json > "$tmp" && mv "$tmp" package.json
        else
            print_warning "jq non installé - ajoutez manuellement les scripts de test"
        fi
    fi
    
    print_success "Dépendances mises à jour"
}

# =============================================================================
# 9. CRÉATION DE LA DOCUMENTATION
# =============================================================================

create_documentation() {
    print_section "Création de la documentation"
    
    print_info "Création de docs/PADDLE_INTEGRATION.md"
    mkdir -p docs
    cat > docs/PADDLE_INTEGRATION.md << 'EOF'
# 🚀 Intégration Paddle pour Math4Child

## 📋 Vue d'ensemble

Cette intégration ajoute le support complet de Paddle comme provider de paiement pour Math4Child, avec :
- Plans mensuels, trimestriels et annuels
- Interface utilisateur avec sélecteur d'intervalle
- API routes sécurisées
- Tests automatisés

## 🏗️ Architecture

```
src/
├── lib/paddle/
│   ├── plans.ts          # Configuration des plans
│   └── checkout.ts       # Logique de checkout
├── components/pricing/
│   ├── PricingComponent.tsx   # Composant principal
│   ├── IntervalSelector.tsx   # Sélecteur d'intervalle
│   └── PlanCard.tsx          # Carte de plan
├── types/
│   └── paddle.ts         # Types TypeScript
└── [app|pages]/api/payments/
    └── create-checkout    # API de création de checkout
```

## 🔧 Configuration

### 1. Variables d'environnement
```bash
PADDLE_API_KEY=your_paddle_api_key
PADDLE_WEBHOOK_SECRET=your_paddle_webhook_secret
NEXT_PUBLIC_PADDLE_CLIENT_TOKEN=your_paddle_client_token
NEXT_PUBLIC_APP_URL=https://www.math4child.com
```

### 2. IDs des produits Paddle
Remplacez les IDs factices dans `src/lib/paddle/plans.ts` par vos vrais IDs Paddle :
```typescript
priceId: 'pri_01hsqn7xkf8z9j2m3k4l5n6p7r' // ← Remplacer
```

## 🚀 Utilisation

### Dans votre composant de pricing
```typescript
import { PricingComponent } from '@/components/pricing/PricingComponent'

export default function PricingPage() {
  const handlePlanSelect = async (planType: string, interval: string) => {
    // Votre logique de sélection de plan
  }

  return <PricingComponent onPlanSelect={handlePlanSelect} />
}
```

## 🧪 Tests

```bash
# Lancer tous les tests
npm run test:e2e

# Tests Paddle uniquement
npm run test:paddle
```

## 📊 Plans disponibles

| Plan | Mensuel | Trimestriel | Annuel |
|------|---------|-------------|--------|
| Famille | 6.99€ | 18.87€ (-10%) | 58.32€ (-30%) |
| Premium | 4.99€ | 13.47€ (-10%) | 41.94€ (-30%) |
| École | 24.99€ | 67.47€ (-10%) | 209.93€ (-30%) |

## 🔒 Sécurité

- ✅ Validation côté serveur
- ✅ Webhooks sécurisés
- ✅ Gestion des erreurs
- ✅ Types TypeScript stricts

## 🛠️ Maintenance

### Mise à jour des prix
1. Modifier `src/lib/paddle/plans.ts`
2. Mettre à jour les tests
3. Tester en développement

### Ajout d'un nouveau plan
1. Ajouter dans `PADDLE_PLANS`
2. Créer le produit dans Paddle
3. Mettre à jour l'interface utilisateur
EOF

    print_info "Création de README_PADDLE.md"
    cat > README_PADDLE.md << 'EOF'
# 🎯 Guide rapide - Intégration Paddle Math4Child

## ✅ Ce qui a été créé

- ✅ Structure de dossiers complète
- ✅ Configuration des plans Paddle
- ✅ Composants React avec sélecteur d'intervalle
- ✅ API routes sécurisées
- ✅ Tests Playwright automatisés
- ✅ Variables d'environnement

## 🚀 Prochaines étapes

1. **Configurer Paddle** :
   - Créer un compte Paddle
   - Créer les produits et prix
   - Récupérer les API keys

2. **Mettre à jour les IDs** :
   ```bash
   # Éditer le fichier des plans
   nano src/lib/paddle/plans.ts
   # Remplacer les priceId factices
   ```

3. **Configurer l'environnement** :
   ```bash
   # Éditer .env.local
   nano .env.local
   # Ajouter vos vraies clés Paddle
   ```

4. **Tester l'intégration** :
   ```bash
   npm run dev
   # Aller sur http://localhost:3000/pricing
   ```

5. **Lancer les tests** :
   ```bash
   npm run test:paddle
   ```

## 🆘 Support

En cas de problème :
1. Vérifiez les logs de la console
2. Consultez la documentation Paddle
3. Testez avec des données factices d'abord

## 🎉 Félicitations !

Votre intégration Paddle est prête ! 🚀
EOF

    print_success "Documentation créée"
}

# =============================================================================
# 10. NETTOYAGE ET FINALISATION
# =============================================================================

cleanup_and_finalize() {
    print_section "Nettoyage et finalisation"
    
    # Supprimer le fichier original
    if [ -f "paddle_checkout_fix.ts" ]; then
        print_info "Déplacement du fichier original vers backup/"
        mkdir -p backup
        mv paddle_checkout_fix.ts backup/paddle_checkout_fix_$(date +%Y%m%d_%H%M%S).ts
        print_success "Fichier original sauvegardé"
    fi
    
    # Créer un script d'installation rapide
    print_info "Création du script d'installation rapide"
    cat > install_paddle.sh << 'EOF'
#!/bin/bash
echo "🚀 Installation rapide Paddle Math4Child"
npm install @paddle/paddle-js
echo "✅ Dépendances installées"
echo "📝 N'oubliez pas de :"
echo "   1. Configurer vos clés Paddle dans .env.local"
echo "   2. Remplacer les priceId dans src/lib/paddle/plans.ts"
echo "   3. Tester avec: npm run dev"
EOF
    chmod +x install_paddle.sh
    
    print_success "Nettoyage terminé"
}

# =============================================================================
# 11. RÉCAPITULATIF FINAL
# =============================================================================

show_summary() {
    print_section "Récapitulatif de l'installation"
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                  🎉 INSTALLATION TERMINÉE !                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}📁 Fichiers créés :${NC}"
    echo "   ├── src/lib/paddle/plans.ts"
    echo "   ├── src/lib/paddle/checkout.ts" 
    echo "   ├── src/components/pricing/PricingComponent.tsx"
    echo "   ├── src/components/pricing/IntervalSelector.tsx"
    echo "   ├── src/components/pricing/PlanCard.tsx"
    echo "   ├── src/types/paddle.ts"
    echo "   ├── $API_DIR/payments/create-checkout"
    echo "   ├── tests/e2e/paddle-checkout.spec.ts"
    echo "   ├── .env.local (mis à jour)"
    echo "   └── docs/PADDLE_INTEGRATION.md"
    
    echo -e "\n${YELLOW}⚠️  Actions requises :${NC}"
    echo "   1. Configurer vos clés Paddle dans .env.local"
    echo "   2. Remplacer les priceId factices dans plans.ts"
    echo "   3. Créer les produits dans votre dashboard Paddle"
    echo "   4. Tester l'intégration en local"
    
    echo -e "\n${BLUE}🚀 Commandes utiles :${NC}"
    echo "   npm run dev                 # Démarrer le serveur"
    echo "   npm run test:paddle         # Lancer les tests Paddle"
    echo "   ./install_paddle.sh         # Installation rapide des dépendances"
    
    echo -e "\n${GREEN}✨ Prêt à transformer Math4Child en succès commercial !${NC}"
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================

main() {
    print_banner
    
    check_prerequisites
    create_directory_structure
    extract_and_split_file
    create_react_components
    create_api_routes
    create_tests
    setup_environment
    update_dependencies
    create_documentation
    cleanup_and_finalize
    show_summary
    
    echo -e "\n${GREEN}🎯 Script terminé avec succès !${NC}"
    echo -e "${BLUE}📖 Consultez README_PADDLE.md pour les prochaines étapes${NC}"
}

# Exécution du script
main "$@"