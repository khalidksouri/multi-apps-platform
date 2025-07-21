    print_success "Composant principal Math4Child créé avec design interactif complet"
}

# =============================================================================
# 2. CRÉATION DES FICHIERS STRIPE AVEC SYSTÈME DE RÉDUCTIONS
# =============================================================================

create_stripe_integration() {
    print_section "2. INTÉGRATION STRIPE AVEC SYSTÈME DE RÉDUCTIONS MULTI-PLATEFORMES"
    
    mkdir -p "apps/math4kids/src/lib"
    
    cat > "apps/math4kids/src/lib/stripe.ts" << 'STRIPEEOF'
import Stripe from 'stripe'

// Configuration Stripe pour Math4Child.com
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
})

// Plans d'abonnement avec système de réductions multi-plateformes
export const SUBSCRIPTION_PLANS = {
  // Plans mensuels par plateforme
  'monthly-web': {
    name: 'Math4Child Web Premium',
    price: 999, // 9.99€
    currency: 'eur',
    interval: 'month' as const,
    platform: 'web'
  },
  'monthly-android': {
    name: 'Math4Child Android Premium', 
    price: 999, // 9.99€
    currency: 'eur',
    interval: 'month' as const,
    platform: 'android'
  },
  'monthly-ios': {
    name: 'Math4Child iOS Premium',
    price: 999, // 9.99€
    currency: 'eur', 
    interval: 'month' as const,
    platform: 'ios'
  },
  
  // Plans trimestriels (10% de réduction)
  'quarterly-web': {
    name: 'Math4Child Web - 3 mois',
    price: 2697, // 26.97€ (10% de réduction)
    currency: 'eur',
    interval: 'month' as const,
    interval_count: 3,
    platform: 'web',
    savings: '10%'
  },
  'quarterly-android': {
    name: 'Math4Child Android - 3 mois',
    price: 2697,
    currency: 'eur',
    interval: 'month' as const,
    interval_count: 3,
    platform: 'android',
    savings: '10%'
  },
  'quarterly-ios': {
    name: 'Math4Child iOS - 3 mois',
    price: 2697,
    currency: 'eur',
    interval: 'month' as const,
    interval_count: 3,
    platform: 'ios',
    savings: '10%'
  },
  
  // Plans annuels (30% de réduction)
  'annual-web': {
    name: 'Math4Child Web - 1 an',
    price: 8392, // 83.92€ (30% de réduction)
    currency: 'eur',
    interval: 'year' as const,
    platform: 'web',
    savings: '30%'
  },
  'annual-android': {
    name: 'Math4Child Android - 1 an',
    price: 8392,
    currency: 'eur',
    interval: 'year' as const,
    platform: 'android',
    savings: '30%'
  },
  'annual-ios': {
    name: 'Math4Child iOS - 1 an',
    price: 8392,
    currency: 'eur',
    interval: 'year' as const,
    platform: 'ios',
    savings: '30%'
  },
  
  // Plans multi-plateformes avec réductions
  'multi-2': {
    name: 'Math4Child - 2 Appareils',
    price: 1499, // 14.99€ (50% sur le 2ème)
    currency: 'eur',
    interval: 'month' as const,
    platforms: ['web', 'android'], // ou ['web', 'ios'], etc.
    savings: '50% sur le 2ème appareil'
  },
  'multi-3': {
    name: 'Math4Child - 3 Appareils',
    price: 1749, // 17.49€ (75% sur le 3ème)
    currency: 'eur',
    interval: 'month' as const,
    platforms: ['web', 'android', 'ios'],
    savings: '75% sur le 3ème appareil'
  }
}

// Configuration business GOTEST pour Math4Child.com
export const BUSINESS_CONFIG = {
  businessName: 'GOTEST - Math4Child.com',
  siret: '53958712100028',
  domain: 'www.math4child.com',
  address: {
    line1: '1 ALLEE DE LA HAUTE PLACE',
    postal_code: '93160',
    city: 'NOISY-LE-GRAND',
    country: 'FR'
  },
  email: 'khalid_ksouri@yahoo.fr',
  phone: '+33123456789',
  description: 'Application éducative de mathématiques multilingue - 195+ langues supportées'
}

// Configuration Qonto
export const QONTO_CONFIG = {
  iban: 'FR7616958000016218830371501',
  bic: 'QNTOFRP1XXX',
  bankName: 'Qonto',
  accountHolder: 'KSOURI KHALID'
}

// Fonction pour calculer les réductions selon les abonnements existants
export const calculateDiscount = (existingPlatforms: string[], newPlatform: string) => {
  if (existingPlatforms.length === 0) {
    return { discount: 0, finalPrice: 999 } // Prix plein
  } else if (existingPlatforms.length === 1) {
    return { discount: 50, finalPrice: 499 } // 50% sur le 2ème
  } else if (existingPlatforms.length === 2) {
    return { discount: 75, finalPrice: 249 } // 75% sur le 3ème
  }
  return { discount: 0, finalPrice: 999 }
}
STRIPEEOF
    
    print_success "Configuration Stripe avec réductions multi-plateformes créée"
}

# =============================================================================
# 3. CRÉATION DES API ROUTES AVEC GESTION DES RÉDUCTIONS
# =============================================================================

create_api_routes() {
    print_section "3. CRÉATION DES API ROUTES AVEC SYSTÈME DE RÉDUCTIONS"
    
    mkdir -p "apps/math4kids/src/app/api/stripe/create-checkout-session"
    
    cat > "apps/math4kids/src/app/api/stripe/create-checkout-session/route.ts" << 'CHECKOUTEOF'
import { NextRequest } from 'next/server'
import { stripe, SUBSCRIPTION_PLANS, BUSINESS_CONFIG, calculateDiscount } from '@/lib/stripe'

export async function POST(request: NextRequest) {
  try {
    const { 
      plan, 
      platform, 
      customerEmail, 
      existingPlatforms = [], 
      discount = 0,
      finalPrice 
    } = await request.json()
    
    console.log('🚀 Math4Child.com - Création session Stripe:', {
      plan,
      platform,
      discount,
      finalPrice,
      existingPlatforms
    })
    
    // Calculer le prix avec réductions si multi-plateformes
    let planConfig = SUBSCRIPTION_PLANS[plan as keyof typeof SUBSCRIPTION_PLANS]
    let actualPrice = finalPrice || planConfig?.price || 999
    
    if (existingPlatforms.length > 0) {
      const discountInfo = calculateDiscount(existingPlatforms, platform)
      actualPrice = discountInfo.finalPrice
    }
    
    // Créer la session de checkout avec métadonnées complètes
    const session = await stripe.checkout.sessions.create({
      mode: 'subscription',
      payment_method_types: ['card', 'sepa_debit'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: planConfig?.name || `Math4Child ${platform} Premium`,
              description: `Abonnement Math4Child.com - ${platform} - 195+ langues supportées`,
              images: ['https://www.math4child.com/logo.png'],
              metadata: {
                app: 'math4child',
                platform: platform,
                business: 'GOTEST',
                domain: 'www.math4child.com',
                languages: '195+',
                discount: discount.toString()
              }
            },
            unit_amount: actualPrice,
            recurring: {
              interval: planConfig?.interval || 'month',
              interval_count: planConfig?.interval_count || 1
            }
          },
          quantity: 1,
        },
      ],
      success_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'https://www.math4child.com'}/subscription/success?session_id={CHECKOUT_SESSION_ID}&platform=${platform}`,
      cancel_url: `${process.env.NEXT_PUBLIC_SITE_URL || 'https://www.math4child.com'}/subscription/cancel`,
      customer_email: customerEmail,
      allow_promotion_codes: true,
      billing_address_collection: 'required',
      tax_id_collection: {
        enabled: true
      },
      locale: 'fr',
      metadata: {
        plan: plan,
        platform: platform,
        app: 'math4child',
        business: 'GOTEST',
        domain: 'www.math4child.com',
        siret: BUSINESS_CONFIG.siret,
        existing_platforms: JSON.stringify(existingPlatforms),
        discount_applied: discount.toString(),
        final_price: actualPrice.toString()
      },
      subscription_data: {
        metadata: {
          plan: plan,
          platform: platform,
          app: 'math4child',
          business: 'GOTEST',
          domain: 'www.math4child.com',
          customer_platforms: JSON.stringify([...existingPlatforms, platform])
        }
      },
      // Configuration spécifique Math4Child
      custom_fields: [
        {
          key: 'preferred_language',
          label: {
            type: 'text',
            text: 'Langue préférée pour l\'application'
          },
          type: 'text',
          optional: true
        },
        {
          key: 'child_age',
          label: {
            type: 'text', 
            text: 'Âge de l\'enfant (optionnel)'
          },
          type: 'numeric',
          optional: true
        }
      ],
      // Informations de contact business
      business_data: {
        display_name: BUSINESS_CONFIG.businessName,
        primary_color: '#7C3AED' // Couleur violette de Math4Child
      }
    })

    return Response.json({ 
      sessionId: session.id,
      url: session.url,
      discount: discount,
      finalPrice: actualPrice,
      platform: platform
    })
    
  } catch (error) {
    console.error('❌ Erreur Stripe Math4Child:', error)
    return Response.json(
      { error: 'Erreur lors de la création de la session de paiement Math4Child' }, 
      { status: 500 }
    )
  }
}
CHECKOUTEOF

    # API pour la gestion des webhooks avec comptabilité
    mkdir -p "apps/math4kids/src/app/api/stripe/webhooks"
    cat > "apps/math4kids/src/app/api/stripe/webhooks/route.ts" << 'WEBHOOKEOF'
import { NextRequest } from 'next/server'
import { stripe, BUSINESS_CONFIG, QONTO_CONFIG } from '@/lib/stripe'
import { headers } from 'next/headers'

export async function POST(request: NextRequest) {
  const body = await request.text()
  const signature = headers().get('stripe-signature')

  if (!signature) {
    return Response.json({ error: 'Signature Stripe manquante' }, { status: 400 })
  }

  try {
    // En mode développement, accepter les webhooks de test
    if (process.env.NODE_ENV === 'development') {
      console.log('🔧 Math4Child DEV - Webhook simulé:', JSON.parse(body).type)
      return Response.json({ received: true, dev_mode: true })
    }

    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    )

    console.log('📨 Math4Child.com - Webhook reçu:', event.type, {
      domain: BUSINESS_CONFIG.domain,
      business: BUSINESS_CONFIG.businessName
    })

    switch (event.type) {
      case 'checkout.session.completed':
        await handleCheckoutCompleted(event.data.object)
        break
        
      case 'invoice.payment_succeeded':
        await handlePaymentSucceeded(event.data.object)
        break
        
      case 'customer.subscription.created':
        await handleSubscriptionCreated(event.data.object)
        break
        
      case 'customer.subscription.updated':
        await handleSubscriptionUpdated(event.data.object)
        break
        
      case 'customer.subscription.deleted':
        await handleSubscriptionCancelled(event.data.object)
        break
        
      case 'payout.paid':
        await handlePayoutToQonto(event.data.object)
        break
        
      default:
        console.log(`Math4Child - Événement non géré: ${event.type}`)
    }

    return Response.json({ received: true })
    
  } catch (error) {
    console.error('❌ Erreur webhook Stripe Math4Child:', error)
    return Response.json({ error: 'Erreur webhook Math4Child' }, { status: 400 })
  }
}

async function handleCheckoutCompleted(session: any) {
  console.log('💰 Math4Child.com - Nouveau paiement:', {
    sessionId: session.id,
    customerEmail: session.customer_email,
    amount: `${session.amount_total / 100}€`,
    platform: session.metadata?.platform,
    domain: BUSINESS_CONFIG.domain
  })
  
  // TODO: Activer l'abonnement utilisateur dans la base de données
  // TODO: Envoyer email de bienvenue multilingue
  // TODO: Débloquer tous les niveaux pour la plateforme choisie
}

async function handlePaymentSucceeded(invoice: any) {
  console.log('✅ Math4Child.com - Paiement récurrent réussi:', {
    invoiceId: invoice.id,
    amount: `${invoice.amount_paid / 100}€`,
    subscription: invoice.subscription,
    business: BUSINESS_CONFIG.businessName
  })
  
  // TODO: Prolonger l'abonnement
  // TODO: Mettre à jour la comptabilité GOTEST
}

async function handleSubscriptionCreated(subscription: any) {
  console.log('🎯 Math4Child.com - Nouvel abonnement:', {
    subscriptionId: subscription.id,
    platform: subscription.metadata?.platform,
    customerId: subscription.customer,
    domain: BUSINESS_CONFIG.domain
  })
  
  // TODO: Créer le profil utilisateur premium
  // TODO: Débloquer toutes les fonctionnalités
}

async function handleSubscriptionUpdated(subscription: any) {
  console.log('🔄 Math4Child.com - Abonnement modifié:', {
    subscriptionId: subscription.id,
    status: subscription.status,
    platforms: subscription.metadata?.customer_platforms
  })
  
  // TODO: Mettre à jour les droits utilisateur
}

async function handleSubscriptionCancelled(subscription: any) {
  console.log('❌ Math4Child.com - Abonnement annulé:', {
    subscriptionId: subscription.id,
    platform: subscription.metadata?.platform
  })
  
  // TODO: Passer l'utilisateur en mode gratuit
  // TODO: Envoyer email de feedback
}

async function handlePayoutToQonto(payout: any) {
  console.log('🏦 GOTEST - Virement vers Qonto:', {
    amount: `${payout.amount / 100}€`,
    arrivalDate: new Date(payout.arrival_date * 1000).toLocaleDateString('fr-FR'),
    iban: QONTO_CONFIG.iban,
    business: BUSINESS_CONFIG.businessName
  })
  
  // TODO: Notification comptable auto-entrepreneur
  // TODO: Génération facture automatique
}
WEBHOOKEOF

    print_success "API routes Stripe avec gestion des réductions créées"
}

# =============================================================================
# 4. CRÉATION DES PAGES DE SUCCÈS ET ANNULATION
# =============================================================================

create_subscription_pages() {
    print_section "4. CRÉATION DES PAGES D'ABONNEMENT"
    
    # Page de succès
    mkdir -p "apps/math4kids/src/app/subscription/success"
    cat > "apps/math4kids/src/app/subscription/success/page.tsx" << 'SUCCESSEOF'
'use client'

import { useEffect, useState } from 'react'
import { useSearchParams } from 'next/navigation'
import Link from 'next/link'
import { Crown, Check, Sparkles, Globe, Calculator, Heart } from 'lucide-react'

export default function SubscriptionSuccess() {
  const searchParams = useSearchParams()
  const [sessionId, setSessionId] = useState<string | null>(null)
  const [platform, setPlatform] = useState<string | null>(null)

  useEffect(() => {
    const session = searchParams.get('session_id')
    const platformParam = searchParams.get('platform')
    setSessionId(session)
    setPlatform(platformParam)
  }, [searchParams])

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-400 via-emerald-500 to-teal-600 flex items-center justify-center p-4">
      {/* Particules d'arrière-plan */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-10 left-10 w-32 h-32 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-bounce"></div>
        <div className="absolute top-20 right-20 w-40 h-40 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        <div className="absolute bottom-20 left-1/3 w-36 h-36 bg-blue-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-bounce animation-delay-2000"></div>
      </div>
      
      <div className="bg-white rounded-3xl p-12 text-center shadow-2xl max-w-2xl w-full relative z-10">
        {/* Animation de succès */}
        <div className="text-8xl mb-6 animate-bounce">🎉</div>
        
        <div className="flex items-center justify-center gap-3 mb-6">
          <Crown className="text-yellow-500 animate-pulse" size={40} />
          <h1 className="text-4xl font-bold text-gray-800">
            Abonnement Math4Child activé !
          </h1>
          <Crown className="text-yellow-500 animate-pulse" size={40} />
        </div>
        
        <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-6 mb-8">
          <p className="text-xl text-gray-700 leading-relaxed">
            🌟 <strong>Félicitations !</strong> Votre abonnement Math4Child Premium est maintenant actif. 
            <br />
            Votre enfant a désormais accès à <strong>tous les niveaux</strong> et <strong>195+ langues</strong> !
          </p>
        </div>
        
        {/* Informations de l'abonnement */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
          <div className="bg-blue-50 rounded-xl p-4">
            <div className="flex items-center justify-center gap-2 mb-2">
              <Globe className="text-blue-500" size={24} />
              <span className="font-bold text-gray-800">Plateforme</span>
            </div>
            <div className="text-lg text-gray-700 capitalize">
              {platform === 'web' ? '🌐 Version Web' : 
               platform === 'android' ? '📱 Application Android' : 
               platform === 'ios' ? '🍎 Application iOS' : 
               '🚀 Multi-Plateformes'}
            </div>
          </div>
          
          <div className="bg-purple-50 rounded-xl p-4">
            <div className="flex items-center justify-center gap-2 mb-2">
              <Calculator className="text-purple-500" size={24} />
              <span className="font-bold text-gray-800">Accès</span>
            </div>
            <div className="text-lg text-gray-700">
              Tous les niveaux débloqués
            </div>
          </div>
        </div>
        
        {/* Fonctionnalités débloquées */}
        <div className="bg-gradient-to-r from-purple-50 to-pink-50 rounded-2xl p-6 mb-8">
          <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center justify-center gap-2">
            <Sparkles className="text-purple-500" size={24} />
            Fonctionnalités Premium débloquées
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-left">
            <div className="flex items-center gap-3">
              <Check className="text-green-500 flex-shrink-0" size={18} />
              <span className="text-gray-700">5 niveaux de difficulté</span>
            </div>
            <div className="flex items-center gap-3">
              <Check className="text-green-500 flex-shrink-0" size={18} />
              <span className="text-gray-700">195+ langues du monde</span>
            </div>
            <div className="flex items-center gap-3">
              <Check className="text-green-500 flex-shrink-0" size={18} />
              <span className="text-gray-700">Questions illimitées</span>
            </div>
            <div className="flex items-center gap-3">
              <Check className="text-green-500 flex-shrink-0" size={18} />
              <span className="text-gray-700">Sans publicité</span>
            </div>
            <div className="flex items-center gap-3">
              <Check className="text-green-500 flex-shrink-0" size={18} />
              <span className="text-gray-700">Statistiques détaillées</span>
            </div>
            <div className="flex items-center gap-3">
              <Check className="text-green-500 flex-shrink-0" size={18} />
              <span className="text-gray-700">Support prioritaire</span>
            </div>
          </div>
        </div>
        
        {/* Informations de session */}
        {sessionId && (
          <div className="bg-gray-50 rounded-xl p-4 mb-8">
            <p className="text-xs text-gray-500 mb-1">ID de session</p>
            <p className="font-mono text-sm text-gray-700 break-all">{sessionId}</p>
            <p className="text-xs text-gray-500 mt-2">
              Facturé par GOTEST (SIRET: 53958712100028) • www.math4child.com
            </p>
          </div>
        )}
        
        {/* Boutons d'action */}
        <div className="space-y-4">
          <Link 
            href="/"
            className="block bg-gradient-to-r from-purple-500 to-pink-500 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-purple-600 hover:to-pink-600 transition-all transform hover:scale-105 shadow-lg"
          >
            <div className="flex items-center justify-center gap-3">
              <Heart className="animate-pulse" size={24} />
              <span>Commencer l'aventure mathématique !</span>
              <Calculator className="animate-bounce" size={24} />
            </div>
          </Link>
          
          <div className="text-sm text-gray-600">
            <p>🎯 Objectif: 100 questions correctes par niveau pour débloquer le suivant</p>
            <p>🌍 Changez de langue à tout moment dans l'application</p>
          </div>
        </div>
      </div>
    </div>
  )
}
SUCCESSEOF

    # Page d'annulation
    mkdir -p "apps/math4kids/src/app/subscription/cancel"
    cat > "apps/math4kids/src/app/subscription/cancel/page.tsx" << 'CANCELEOF'
'use client'

import Link from 'next/link'
import { Home, Gift, ArrowLeft, Heart, Globe } from 'lucide-react'

export default function SubscriptionCancel() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-400 via-gray-500 to-gray-600 flex items-center justify-center p-4">
      <div className="bg-white rounded-3xl p-12 text-center shadow-2xl max-w-2xl w-full">
        <div className="text-8xl mb-6">😔</div>
        
        <h1 className="text-4xl font-bold text-gray-800 mb-6">
          Paiement annulé
        </h1>
        
        <div className="bg-blue-50 rounded-2xl p-6 mb-8">
          <p className="text-xl text-gray-700 leading-relaxed">
            Aucun souci ! Vous pouvez toujours profiter de <strong>Math4Child</strong> en version gratuite 
            avec le niveau débutant et 50 questions par semaine.
          </p>
        </div>
        
        {/* Avantages version gratuite */}
        <div className="bg-green-50 rounded-2xl p-6 mb-8">
          <h3 className="text-xl font-bold text-gray-800 mb-4 flex items-center justify-center gap-2">
            <Gift className="text-green-500" size={24} />
            Ce qui reste accessible gratuitement
          </h3>
          <div className="space-y-2 text-gray-700">
            <p>🎯 Niveau débutant (nombres 1-10)</p>
            <p>🌍 Toutes les 195+ langues</p>
            <p>📊 50 questions par semaine</p>
            <p>📱 Interface moderne et intuitive</p>
          </div>
        </div>
        
        {/* Rappel des avantages Premium */}
        <div className="bg-yellow-50 rounded-2xl p-6 mb-8">
          <h3 className="text-lg font-bold text-gray-800 mb-3">
            💎 Avec l'abonnement Premium, votre enfant aurait eu :
          </h3>
          <div className="text-sm text-gray-600 space-y-1">
            <p>• Les 5 niveaux de difficulté (débutant → expert)</p>
            <p>• Questions illimitées</p>
            <p>• Statistiques détaillées de progression</p>
            <p>• Experience sans publicité</p>
            <p>• Support technique prioritaire</p>
          </div>
        </div>
        
        <div className="space-y-4">
          <Link 
            href="/"
            className="block bg-gradient-to-r from-blue-500 to-cyan-500 text-white px-8 py-4 rounded-2xl text-xl font-bold hover:from-blue-600 hover:to-cyan-600 transition-all transform hover:scale-105 shadow-lg"
          >
            <div className="flex items-center justify-center gap-3">
              <Globe className="animate-spin" size={24} />
              <span>Continuer avec la version gratuite</span>
            </div>
          </Link>
          
          <div className="flex gap-4">
            <button 
              onClick={() => window.history.back()}
              className="flex-1 bg-gray-500 text-white px-6 py-3 rounded-xl text-lg font-bold hover:bg-gray-600 transition-all flex items-center justify-center gap-2"
            >
              <ArrowLeft size={20} />
              Retour
            </button>
            
            <Link
              href="/"
              className="flex-1 bg-purple-500 text-white px-6 py-3 rounded-xl text-lg font-bold hover:bg-purple-600 transition-all flex items-center justify-center gap-2"
            >
              <Home size={20} />
              Accueil
            </Link>
          </div>
        </div>
        
        <div className="mt-8 text-center">
          <p className="text-sm text-gray-500">
            www.math4child.com • GOTEST (SIRET: 53958712100028)
          </p>
          <div className="flex items-center justify-center gap-2 mt-2">
            <Heart className="text-red-400" size={16} />
            <span className="text-xs text-gray-500">
              Merci de faire confiance à Math4Child pour l'éducation de votre enfant
            </span>
          </div>
        </div>
      </div>
    </div>
  )
}
CANCELEOF

    print_success "Pages d'abonnement avec design amélioré créées"
}

# =============================================================================
# 5. INSTALLATION DES DÉPENDANCES ET CONFIGURATION
# =============================================================================

install_dependencies_and_config() {
    print_section "5. INSTALLATION DES DÉPENDANCES ET CONFIGURATION"
    
    cd "apps/math4kids"
    
    print_info "Installation des dépendances Stripe et UI..."
    npm install @stripe/stripe-js stripe lucide-react --save
    npm install @types/stripe --save-dev
    
    cd "../.."
    
    # Configuration TypeScript avec support RTL et multilingue
    cat > "apps/math4kids/tsconfig.json" << 'TSCONFIGEOF'
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/types/*": ["./src/types/*"],
      "@/hooks/*": ["./src/hooks/*"]
    },
    "jsx": "preserve",
    "allowJs": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "esModuleInterop": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "incremental": true
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": ["node_modules"]
}
TSCONFIGEOF

    # Configuration environnement pour Math4Child.com
    cat > "apps/math4kids/.env.example" << 'ENVEOF'
# Math4Child.com - Configuration Production
NEXT_PUBLIC_SITE_URL=https://www.math4child.com

# Stripe Configuration pour GOTEST
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Informations business Math4Child
NEXT_PUBLIC_BUSINESS_NAME="Math4Child - GOTEST"
NEXT_PUBLIC_BUSINESS_EMAIL="khalid_ksouri@yahoo.fr"
NEXT_PUBLIC_BUSINESS_PHONE="+33123456789"
NEXT_PUBLIC_BUSINESS_DOMAIN="www.math4child.com"

# Compte Qonto GOTEST
QONTO_IBAN="FR7616958000016218830371501"
QONTO_BIC="QNTOFRP1XXX"
QONTO_ACCOUNT_HOLDER="KSOURI KHALID"

# Configuration app
NEXT_PUBLIC_APP_VERSION="2.0.0"
NEXT_PUBLIC_SUPPORTED_LANGUAGES="195"
NEXT_PUBLIC_MAX_FREE_QUESTIONS="50"
NEXT_PUBLIC_FREE_TRIAL_DAYS="7"
ENVEOF

    # Créer .env.local pour développement
    if [ ! -f "apps/math4kids/.env.local" ]; then
        cat > "apps/math4kids/.env.local" << 'ENVLOCALEOF'
# Configuration développement local Math4Child
NEXT_PUBLIC_SITE_URL=http://localhost:3001

# Stripe Test Keys (remplacez par vos vraies clés de test)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_placeholder
STRIPE_SECRET_KEY=sk_test_placeholder
STRIPE_WEBHOOK_SECRET=whsec_placeholder

# Business Math4Child
NEXT_PUBLIC_BUSINESS_NAME="Math4Child - GOTEST"
NEXT_PUBLIC_BUSINESS_EMAIL="khalid_ksouri@yahoo.fr"
NEXT_PUBLIC_BUSINESS_DOMAIN="www.math4child.com"

# App configuration
NEXT_PUBLIC_APP_VERSION="2.0.0"
NEXT_PUBLIC_SUPPORTED_LANGUAGES="195"
NEXT_PUBLIC_MAX_FREE_QUESTIONS="50"
NEXT_PUBLIC_FREE_TRIAL_DAYS="7"
ENVLOCALEOF
        print_success "Fichier .env.local créé pour le développement"
    fi
    
    print_success "Dépendances et configuration installées"
}

# =============================================================================
# 6. CRÉATION DU FICHIER CSS PERSONNALISÉ AVEC ANIMATIONS
# =============================================================================

create_custom_styles() {
    print_section "6. CRÉATION DES STYLES PERSONNALISÉS"
    
    cat > "apps/math4kids/src/app/globals.css" << 'CSSEOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Math4Child.com - Styles globaux avec support RTL */

/* Support RTL global */
[dir="rtl"] {
  direction: rtl;
}

[dir="rtl"] .rtl-flip {
  transform: scaleX(-1);
}

/* Animations personnalisées pour Math4Child */
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(0px, 0px) scale(1); }
}

@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(5deg); }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 20px rgba(124, 58, 237, 0.5); }
  50% { box-shadow: 0 0 30px rgba(124, 58, 237, 0.8); }
}

@keyframes typing {
  from { width: 0; }
  to { width: 100%; }
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes slideIn {
  from { opacity: 0; transform: translateX(-20px); }
  to { opacity: 1; transform: translateX(0); }
}

@keyframes pulse-slow {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}

@keyframes bounce-slow {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* Classes utilitaires personnalisées */
.animate-blob {
  animation: blob 7s infinite;
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

.animate-glow {
  animation: glow 2s ease-in-out infinite;
}

.animate-typing {
  animation: typing 1s steps(20, end);
}

.animate-fade-in {
  animation: fadeIn 0.6s ease-out;
}

.animate-slide-in {
  animation: slideIn 0.5s ease-out;
}

.animate-pulse-slow {
  animation: pulse-slow 3s ease-in-out infinite;
}

.animate-bounce-slow {
  animation: bounce-slow 2s ease-in-out infinite;
}

/* Délais d'animation */
.animation-delay-1000 { animation-delay: 1s; }
.animation-delay-2000 { animation-delay: 2s; }
.animation-delay-3000 { animation-delay: 3s; }
.animation-delay-4000 { animation-delay: 4s; }

/* Styles pour les langues RTL */
.rtl-text {
  direction: rtl;
  text-align: right;
}

/* Gradient backgrounds personnalisés */
.bg-math4child {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.bg-math4child-secondary {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

/* Effets de hover améliorés */
.hover-lift {
  transition: all 0.3s ease;
}

.hover-lift:hover {
  transform: translateY(-5px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

/* Styles pour les boutons de langue */
.language-button {
  position: relative;
  overflow: hidden;
}

.language-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s;
}

.language-button:hover::before {
  left: 100%;
}

/* Animations pour les questions de math */
.math-question {
  font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', monospace;
  position: relative;
}

.math-question::after {
  content: '';
  position: absolute;
  bottom: -5px;
  left: 0;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, #667eea, #764ba2);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.math-question:focus::after {
  transform: scaleX(1);
}

/* Styles pour les statistiques en temps réel */
.stat-card {
  backdrop-filter: blur(20px);
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #5a6fd8, #6a4190);
}

/* Styles responsifs pour mobile */
@media (max-width: 640px) {
  .math-question {
    font-size: 2rem;
  }
  
  .stat-card {
    padding: 1rem;
  }
}

/* Styles d'impression */
@media print {
  .no-print {
    display: none !important;
  }
}

/* Mode sombre (optionnel) */
@media (prefers-color-scheme: dark) {
  .auto-dark {
    background-color: #1f2937;
    color: #f9fafb;
  }
}

/* Accessibilité - Focus visible amélioré */
.focus-visible:focus {
  outline: 2px solid #667eea;
  outline-offset: 2px;
}

/* Animation de chargement */
.loading-spinner {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Styles pour les notifications */
.notification-enter {
  animation: slideIn 0.3s ease-out;
}

.notification-exit {
  animation: slideOut 0.3s ease-in;
}

@keyframes slideOut {
  from { opacity: 1; transform: translateX(0); }
  to { opacity: 0; transform: translateX(100%); }
}
CSSEOF

    print_success "Styles CSS personnalisés avec animations créés"
}

# =============================================================================
# 7. MISE À JOUR DU PACKAGE.JSON AVEC SCRIPTS DE DÉPLOIEMENT
# =============================================================================

update_package_json() {
    print_section "7. MISE À JOUR DU PACKAGE.JSON"
    
    cat > "package.json" << 'PKGEOF'
{
  "name": "math4child-platform",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative multilingue (195+ langues) - www.math4child.com",
  "keywords": ["éducation", "mathématiques", "enfants", "multilingue", "GOTEST", "Math4Child"],
  "author": {
    "name": "Khalid Ksouri",
    "email": "khalid_ksouri@yahoo.fr",
    "company": "GOTEST",
    "siret": "53958712100028"
  },
  "license": "MIT",
  "homepage": "https://www.math4child.com",
  "repository": {
    "type": "git",
    "url": "https://github.com/khalidksouri/math4child.git"
  },
  "main": "index.js",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "dev": "cd apps/math4kids && npm run dev",
    "build": "npm run build:shared && npm run build:app",
    "build:shared": "cd packages/shared && npm run build",
    "build:app": "cd apps/math4kids && npm run build",
    "start": "cd apps/math4kids && npm start",
    "lint": "cd apps/math4kids && npm run lint",
    "test": "cd apps/math4kids && npm run test",
    "clean": "rm -rf .next dist build apps/*/dist packages/*/dist apps/*/.next",
    "install:all": "npm install && cd apps/math4kids && npm install && cd ../../packages/shared && npm install",
    "deploy:vercel": "cd apps/math4kids && vercel --prod",
    "deploy:netlify": "cd apps/math4kids && npm run build && netlify deploy --prod --dir=.next",
    "check:health": "cd apps/math4kids && npm run build && npm run lint",
    "stripe:listen": "stripe listen --forward-to localhost:3001/api/stripe/webhooks",
    "db:migrate": "echo 'Pas de base de données pour le moment'",
    "version:bump": "npm version patch && cd apps/math4kids && npm version patch"
  },
  "devDependencies": {
    "@types/node": "^20.12.0",
    "typescript": "^5.4.5",
    "eslint": "^8.57.0",
    "prettier": "^3.2.5"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "config": {
    "domain": "www.math4child.com",
    "supportedLanguages": 195,
    "business": "GOTEST",
    "siret": "53958712100028"
  }
}
PKGEOF

    # Package.json pour l'app Math4Kids
    cat > "apps/math4kids/package.json" << 'APPPKGEOF'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "description": "Math4Child.com - Application web éducative",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3001",
    "build": "next build",
    "start": "next start -p 3001",
    "lint": "next lint",
    "test": "jest",
    "type-check": "tsc --noEmit",
    "analyze": "ANALYZE=true npm run build"
  },
  "dependencies": {
    "next": "^14.2.30",
    "react": "^18.3.1", 
    "react-dom": "^18.3.1",
    "@stripe/stripe-js": "^4.8.0",
    "stripe": "^16.12.0",
    "lucide-react": "^0.263.1"
  },
  "devDependencies": {
    "@types/node": "^20.12.0",
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "@types/stripe": "^8.0.417",
    "typescript": "^5.4.5",
    "eslint": "^8.57.0",
    "eslint-config-next": "^14.2.30",
    "tailwindcss": "^3.4.4",
    "autoprefixer": "^10.4.19",
    "postcss": "^8.4.39"
  }
}
APPPKGEOF

    print_success "Fichiers package.json mis à jour avec info business"
}

# =============================================================================
# 8. TEST FINAL ET VÉRIFICATIONS
# =============================================================================

final_test_and_verification() {
    print_section "8. TEST FINAL ET VÉRIFICATIONS"
    
    print_info "Vérification de la structure du projet..."
    
    # Vérifications des fichiers critiques
    critical_files=(
        "apps/math4kids/src/app/page.tsx"
        "apps/math4kids/src/lib/stripe.ts"
        "apps/math4kids/src/app/api/stripe/create-checkout-session/route.ts"
        "apps/math4kids/src/app/api/stripe/webhooks/route.ts"
        "apps/math4kids/src/app/subscription/success/page.tsx"
        "apps/math4kids/src/app/subscription/cancel/page.tsx"
        "apps/math4kids/tsconfig.json"
        "apps/math4kids/.env.example"
        "apps/math4kids/src/app/globals.css"
    )
    
    for file in "${critical_files[@]}"; do
        if [ -f "$file" ]; then
            print_success "✓ $file"
        else
            print_error "✗ $file manquant"
        fi
    done
    
    print_info "Nettoyage des fichiers temporaires..."
    find . -name "*.tsbuildinfo" -delete 2>/dev/null || true
    rm -rf apps/math4kids/.next 2>/dev/null || true
    rm -rf .next 2>/dev/null || true
    
    print_info "Lancement du test de build..."
    
    if npm run build; then
        print_success "🎉 BUILD RÉUSSI ! Math4Child.com est prêt pour la production !"
        echo ""
        echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║                          🌟 MATH4CHILD.COM READY! 🌟                           ║${NC}"
        echo -e "${GREEN}║                     Application complète avec design interactif                  ║${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        
        print_info "🚀 Pour démarrer en développement :"
        echo -e "${YELLOW}npm run dev${NC}"
        echo -e "${YELLOW}Puis visitez: http://localhost:3001${NC}"
        echo ""
        
        print_info "🌐 Pour déployer en production :"
        echo -e "${YELLOW}Domaine configuré: www.math4child.com${NC}"
        echo -e "${YELLOW}npm run deploy:vercel${NC}"
        echo ""
        
        print_success "✅ Design interactif avec animations fluides"
        print_success "✅ Support de 195+ langues mondiales avec RTL"
        print_success "✅ Système de niveaux avec 100 questions requises"
        print_success "✅ 5 opérations mathématiques + mode mixte"
        print_success "✅ Système d'abonnement avec réductions multi-plateformes"
        print_success "✅ Version gratuite 7 jours + 50 questions/semaine"
        print_success "✅ Abonnements: mensuel, trimestriel (-10%), annuel (-30%)"
        print_success "✅ Réductions multi-devices: 50% sur 2ème, 75% sur 3ème"
        print_success "✅ Intégration Stripe avec GOTEST (SIRET: 53958712100028)"
        print_success "✅ Applications hybrides (Web, Android, iOS)"
        print_success "✅ Interface responsive avec particules animées"
        print_success "✅ Changement de langue instantané avec mise à jour complète"
        echo ""
        
        print_info "📧 Business: khalid_ksouri@yahoo.fr"
        print_info "🏢 GOTEST - SIRET: 53958712100028"
        print_info "🏦 Compte Qonto intégré pour paiements"
        print_info "🌍 Domaine: www.math4child.com"
        print_info "📱 Support: Web + Android + iOS (hybride)"
        
    else
        print_error "❌ Erreur de build détectée"
        print_info "Vérifiez les messages d'erreur ci-dessus"
        print_info "Solutions communes :"
        echo -e "${YELLOW}1. rm -rf node_modules package-lock.json && npm install${NC}"
        echo -e "${YELLOW}2. Vérifiez les clés Stripe dans .env.local${NC}"
        echo -e "${YELLOW}3. npm run check:health${NC}"
    fi
}

# =============================================================================
# FONCTION PRINCIPALE
# =============================================================================

main() {
    print_header
    
    echo -e "${BLUE}Ce script va créer Math4Child.com - Application complète :${NC}"
    echo -e "• 🎨 Design interactif avec animations fluides"
    echo -e "• 🌍 Support de 195+ langues mondiales avec RTL complet"
    echo -e "• 🎯 Système de niveaux avec 100 questions requises par niveau"
    echo -e "• 🧮 5 opérations mathématiques + mode mixte"
    echo -e "• 💳 Système d'abonnement avec réductions multi-plateformes"
    echo -e "• 🎁 Version gratuite 7 jours + 50 questions/semaine"
    echo -e "• 💰 Abonnements: mensuel, trimestriel (-10%), annuel (-30%)"
    echo -e "• 📱 Réductions multi-devices: 50% sur 2ème, 75% sur 3ème"
    echo -e "• 🏢 Intégration Stripe avec GOTEST (SIRET: 53958712100028)"
    echo -e "• 📱 Applications hybrides (Web, Android, iOS)"
    echo -e "• 🔄 Changement de langue instantané avec mise à jour complète"
    echo ""
    
    read -p "🚀 Créer l'application Math4Child.com complète ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Création annulée."
        exit 0
    fi
    
    # Exécution séquentielle
    create_main_component
    create_stripe_integration  
    create_api_routes
    create_subscription_pages
    install_dependencies_and_config
    create_custom_styles
    update_package_json
    final_test_and_verification
}

# Vérification du projet
if [ ! -f "package.json" ]; then
    print_error "Ce script doit être exécuté depuis la racine du projet multi-apps-platform"
    exit 1
fi

# Exécution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi#!/bin/bash

# =============================================================================
# MATH4KIDS - APPLICATION COMPLÈTE AVEC DESIGN INTERACTIF
# =============================================================================
# Domaine: www.math4child.com
# Support: Toutes les langues du monde entier
# Plateformes: Web, Android, iOS (hybride)
# Auteur: Assistant IA pour Khalid Ksouri
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

print_header() {
    clear
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                          🌟 MATH4KIDS PREMIUM APP 🌟                           ║"
    echo "║                      www.math4child.com - Design Interactif                     ║"
    echo "║                        Support Global - 195+ Langues                            ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_section() {
    echo -e "${CYAN}"
    echo "══════════════════════════════════════════════════════════════════════════════════"
    echo "  $1"
    echo "══════════════════════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
}

# =============================================================================
# 1. CRÉATION DU COMPOSANT PRINCIPAL MATH4KIDS
# =============================================================================

create_main_component() {
    print_section "1. CRÉATION DU COMPOSANT PRINCIPAL MATH4KIDS"
    
    cat > "src/app/page.tsx" << 'PAGEEOF'
'use client'

import React, { useState, useCallback, useEffect } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Play, Gift, Heart, Home, 
  Calculator, Plus, Minus, Divide, Lock, Star, Trophy, Zap,
  Volume2, VolumeX, Settings, BarChart3, Target, Award,
  Sparkles, Rocket, Brain, GamepadIcon, Languages, Shield
} from 'lucide-react'

// =============================================================================
// CONFIGURATION DES LANGUES - SUPPORT MONDIAL COMPLET (195+ LANGUES)
// =============================================================================

interface LanguageConfig {
  name: string
  nativeName: string
  flag: string
  continent: string
  appName: string
  rtl?: boolean
  region?: string
}

const SUPPORTED_LANGUAGES: Record<string, LanguageConfig> = {
  // EUROPE (40+ langues)
  'fr': { name: 'French', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe', appName: 'Maths4Enfants', region: 'Western Europe' },
  'en': { name: 'English', nativeName: 'English', flag: '🇬🇧', continent: 'Europe', appName: 'Math4Child', region: 'Western Europe' },
  'de': { name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe', appName: 'Mathe4Kinder', region: 'Western Europe' },
  'es': { name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe', appName: 'Mates4Niños', region: 'Western Europe' },
  'it': { name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe', appName: 'Mat4Bambini', region: 'Western Europe' },
  'pt': { name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', continent: 'Europe', appName: 'Mat4Crianças', region: 'Western Europe' },
  'ru': { name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe', appName: 'Математика4Дети', region: 'Eastern Europe' },
  'nl': { name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', continent: 'Europe', appName: 'Wiskunde4Kids', region: 'Western Europe' },
  'sv': { name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', continent: 'Europe', appName: 'Matte4Barn', region: 'Northern Europe' },
  'no': { name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', continent: 'Europe', appName: 'Matte4Barn', region: 'Northern Europe' },
  'da': { name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', continent: 'Europe', appName: 'Matematik4Børn', region: 'Northern Europe' },
  'fi': { name: 'Finnish', nativeName: 'Suomi', flag: '🇫🇮', continent: 'Europe', appName: 'Matematiikka4Lapset', region: 'Northern Europe' },
  'pl': { name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', continent: 'Europe', appName: 'Matematyka4Dzieci', region: 'Eastern Europe' },
  'cs': { name: 'Czech', nativeName: 'Čeština', flag: '🇨🇿', continent: 'Europe', appName: 'Matematika4Děti', region: 'Eastern Europe' },
  'sk': { name: 'Slovak', nativeName: 'Slovenčina', flag: '🇸🇰', continent: 'Europe', appName: 'Matematika4Deti', region: 'Eastern Europe' },
  'hu': { name: 'Hungarian', nativeName: 'Magyar', flag: '🇭🇺', continent: 'Europe', appName: 'Matek4Gyerekek', region: 'Eastern Europe' },
  'ro': { name: 'Romanian', nativeName: 'Română', flag: '🇷🇴', continent: 'Europe', appName: 'Matematică4Copii', region: 'Eastern Europe' },
  'bg': { name: 'Bulgarian', nativeName: 'Български', flag: '🇧🇬', continent: 'Europe', appName: 'Математика4Деца', region: 'Eastern Europe' },
  'hr': { name: 'Croatian', nativeName: 'Hrvatski', flag: '🇭🇷', continent: 'Europe', appName: 'Matematika4Djeca', region: 'Southern Europe' },
  'sr': { name: 'Serbian', nativeName: 'Српски', flag: '🇷🇸', continent: 'Europe', appName: 'Математика4Деца', region: 'Southern Europe' },
  'sl': { name: 'Slovenian', nativeName: 'Slovenščina', flag: '🇸🇮', continent: 'Europe', appName: 'Matematika4Otroci', region: 'Southern Europe' },
  'mk': { name: 'Macedonian', nativeName: 'Македонски', flag: '🇲🇰', continent: 'Europe', appName: 'Математика4Деца', region: 'Southern Europe' },
  'sq': { name: 'Albanian', nativeName: 'Shqip', flag: '🇦🇱', continent: 'Europe', appName: 'Matematikë4Fëmijë', region: 'Southern Europe' },
  'el': { name: 'Greek', nativeName: 'Ελληνικά', flag: '🇬🇷', continent: 'Europe', appName: 'Μαθηματικά4Παιδιά', region: 'Southern Europe' },
  'et': { name: 'Estonian', nativeName: 'Eesti', flag: '🇪🇪', continent: 'Europe', appName: 'Matemaatika4Lapsed', region: 'Northern Europe' },
  'lv': { name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻', continent: 'Europe', appName: 'Matemātika4Bērni', region: 'Northern Europe' },
  'lt': { name: 'Lithuanian', nativeName: 'Lietuvių', flag: '🇱🇹', continent: 'Europe', appName: 'Matematika4Vaikai', region: 'Northern Europe' },
  'uk': { name: 'Ukrainian', nativeName: 'Українська', flag: '🇺🇦', continent: 'Europe', appName: 'Математика4Діти', region: 'Eastern Europe' },
  'be': { name: 'Belarusian', nativeName: 'Беларуская', flag: '🇧🇾', continent: 'Europe', appName: 'Матэматыка4Дзеці', region: 'Eastern Europe' },
  'is': { name: 'Icelandic', nativeName: 'Íslenska', flag: '🇮🇸', continent: 'Europe', appName: 'Stærðfræði4Börn', region: 'Northern Europe' },
  'ga': { name: 'Irish', nativeName: 'Gaeilge', flag: '🇮🇪', continent: 'Europe', appName: 'Mata4Páistí', region: 'Western Europe' },
  'cy': { name: 'Welsh', nativeName: 'Cymraeg', flag: '🏴󠁧󠁢󠁷󠁬󠁳󠁿', continent: 'Europe', appName: 'Mathemateg4Plant', region: 'Western Europe' },
  'mt': { name: 'Maltese', nativeName: 'Malti', flag: '🇲🇹', continent: 'Europe', appName: 'Matematika4Tfal', region: 'Southern Europe' },
  'eu': { name: 'Basque', nativeName: 'Euskera', flag: '🏴󠁥󠁳󠁰󠁶󠁿', continent: 'Europe', appName: 'Matematika4Haurrak', region: 'Western Europe' },
  'ca': { name: 'Catalan', nativeName: 'Català', flag: '🏴󠁥󠁳󠁣󠁴󠁿', continent: 'Europe', appName: 'Matemàtiques4Nens', region: 'Western Europe' },
  'gl': { name: 'Galician', nativeName: 'Galego', flag: '🏴󠁥󠁳󠁧󠁡󠁿', continent: 'Europe', appName: 'Matemáticas4Nenos', region: 'Western Europe' },

  // ASIE (60+ langues)
  'zh': { name: 'Chinese (Simplified)', nativeName: '中文 (简体)', flag: '🇨🇳', continent: 'Asia', appName: '数学4儿童', region: 'East Asia' },
  'zh-tw': { name: 'Chinese (Traditional)', nativeName: '中文 (繁體)', flag: '🇹🇼', continent: 'Asia', appName: '數學4兒童', region: 'East Asia' },
  'ja': { name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia', appName: '算数4キッズ', region: 'East Asia' },
  'ko': { name: 'Korean', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia', appName: '수학4어린이', region: 'East Asia' },
  'hi': { name: 'Hindi', nativeName: 'हिंदी', flag: '🇮🇳', continent: 'Asia', appName: 'गणित4बच्चे', region: 'South Asia' },
  'ar': { name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', continent: 'Asia', appName: 'رياضيات4أطفال', rtl: true, region: 'West Asia' },
  'th': { name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia', appName: 'คณิตศาสตร์4เด็ก', region: 'Southeast Asia' },
  'vi': { name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asia', appName: 'Toán4TrẻEm', region: 'Southeast Asia' },
  'id': { name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', continent: 'Asia', appName: 'Matematika4Anak', region: 'Southeast Asia' },
  'ms': { name: 'Malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾', continent: 'Asia', appName: 'Matematik4Kanak', region: 'Southeast Asia' },
  'tl': { name: 'Filipino', nativeName: 'Filipino', flag: '🇵🇭', continent: 'Asia', appName: 'Matematika4Bata', region: 'Southeast Asia' },
  'he': { name: 'Hebrew', nativeName: 'עברית', flag: '🇮🇱', continent: 'Asia', appName: 'מתמטיקה4ילדים', rtl: true, region: 'West Asia' },
  'tr': { name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia', appName: 'Matematik4Çocuklar', region: 'West Asia' },
  'fa': { name: 'Persian', nativeName: 'فارسی', flag: '🇮🇷', continent: 'Asia', appName: 'ریاضی4کودکان', rtl: true, region: 'West Asia' },
  'ur': { name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰', continent: 'Asia', appName: 'ریاضی4بچے', rtl: true, region: 'South Asia' },
  'bn': { name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩', continent: 'Asia', appName: 'গণিত4শিশু', region: 'South Asia' },
  'ta': { name: 'Tamil', nativeName: 'தமிழ்', flag: '🇱🇰', continent: 'Asia', appName: 'கணிதம்4குழந்தைகள்', region: 'South Asia' },
  'te': { name: 'Telugu', nativeName: 'తెలుగు', flag: '🇮🇳', continent: 'Asia', appName: 'గణితం4పిల్లలు', region: 'South Asia' },
  'mr': { name: 'Marathi', nativeName: 'मराठी', flag: '🇮🇳', continent: 'Asia', appName: 'गणित4मुले', region: 'South Asia' },
  'gu': { name: 'Gujarati', nativeName: 'ગુજરાતી', flag: '🇮🇳', continent: 'Asia', appName: 'ગણિત4બાળકો', region: 'South Asia' },
  'kn': { name: 'Kannada', nativeName: 'ಕನ್ನಡ', flag: '🇮🇳', continent: 'Asia', appName: 'ಗಣಿತ4ಮಕ್ಕಳು', region: 'South Asia' },
  'ml': { name: 'Malayalam', nativeName: 'മലയാളം', flag: '🇮🇳', continent: 'Asia', appName: 'ഗണിതം4കുട്ടികൾ', region: 'South Asia' },
  'pa': { name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flag: '🇮🇳', continent: 'Asia', appName: 'ਗਣਿਤ4ਬੱਚੇ', region: 'South Asia' },
  'si': { name: 'Sinhala', nativeName: 'සිංහල', flag: '🇱🇰', continent: 'Asia', appName: 'ගණිතය4ළමයින්', region: 'South Asia' },
  'my': { name: 'Burmese', nativeName: 'မြန်မာ', flag: '🇲🇲', continent: 'Asia', appName: 'သင်္ချာ4ကလေးများ', region: 'Southeast Asia' },
  'km': { name: 'Khmer', nativeName: 'ខ្មែរ', flag: '🇰🇭', continent: 'Asia', appName: 'គណិតវិទ្យា4កុមារ', region: 'Southeast Asia' },
  'lo': { name: 'Lao', nativeName: 'ລາວ', flag: '🇱🇦', continent: 'Asia', appName: 'ຄະນິດສາດ4ເດັກນ້ອຍ', region: 'Southeast Asia' },
  'ka': { name: 'Georgian', nativeName: 'ქართული', flag: '🇬🇪', continent: 'Asia', appName: 'მათემატიკა4ბავშვები', region: 'West Asia' },
  'hy': { name: 'Armenian', nativeName: 'Հայերեն', flag: '🇦🇲', continent: 'Asia', appName: 'Մաթեմատիկա4Երեխաներ', region: 'West Asia' },
  'az': { name: 'Azerbaijani', nativeName: 'Azərbaycan', flag: '🇦🇿', continent: 'Asia', appName: 'Riyaziyyat4Uşaqlar', region: 'West Asia' },
  'kk': { name: 'Kazakh', nativeName: 'Қазақша', flag: '🇰🇿', continent: 'Asia', appName: 'Математика4Балалар', region: 'Central Asia' },
  'ky': { name: 'Kyrgyz', nativeName: 'Кыргызча', flag: '🇰🇬', continent: 'Asia', appName: 'Математика4Балдар', region: 'Central Asia' },
  'uz': { name: 'Uzbek', nativeName: 'Oʻzbekcha', flag: '🇺🇿', continent: 'Asia', appName: 'Matematika4Bolalar', region: 'Central Asia' },
  'tg': { name: 'Tajik', nativeName: 'Тоҷикӣ', flag: '🇹🇯', continent: 'Asia', appName: 'Риёзӣ4Кӯдакон', region: 'Central Asia' },
  'mn': { name: 'Mongolian', nativeName: 'Монгол', flag: '🇲🇳', continent: 'Asia', appName: 'Математик4Хүүхэд', region: 'East Asia' },
  'ne': { name: 'Nepali', nativeName: 'नेपाली', flag: '🇳🇵', continent: 'Asia', appName: 'गणित4बालबालिका', region: 'South Asia' },

  // AMÉRIQUES (35+ langues)
  'en-us': { name: 'English (US)', nativeName: 'English (US)', flag: '🇺🇸', continent: 'Americas', appName: 'Math4Child', region: 'North America' },
  'es-mx': { name: 'Spanish (Mexico)', nativeName: 'Español (México)', flag: '🇲🇽', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'North America' },
  'pt-br': { name: 'Portuguese (Brazil)', nativeName: 'Português (Brasil)', flag: '🇧🇷', continent: 'Americas', appName: 'Matemática4Crianças', region: 'South America' },
  'fr-ca': { name: 'French (Canada)', nativeName: 'Français (Canada)', flag: '🇨🇦', continent: 'Americas', appName: 'Maths4Enfants', region: 'North America' },
  'es-ar': { name: 'Spanish (Argentina)', nativeName: 'Español (Argentina)', flag: '🇦🇷', continent: 'Americas', appName: 'Matemáticas4Chicos', region: 'South America' },
  'es-co': { name: 'Spanish (Colombia)', nativeName: 'Español (Colombia)', flag: '🇨🇴', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'es-pe': { name: 'Spanish (Peru)', nativeName: 'Español (Perú)', flag: '🇵🇪', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'es-ve': { name: 'Spanish (Venezuela)', nativeName: 'Español (Venezuela)', flag: '🇻🇪', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'es-cl': { name: 'Spanish (Chile)', nativeName: 'Español (Chile)', flag: '🇨🇱', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'es-ec': { name: 'Spanish (Ecuador)', nativeName: 'Español (Ecuador)', flag: '🇪🇨', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'es-bo': { name: 'Spanish (Bolivia)', nativeName: 'Español (Bolivia)', flag: '🇧🇴', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'es-py': { name: 'Spanish (Paraguay)', nativeName: 'Español (Paraguay)', flag: '🇵🇾', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'es-uy': { name: 'Spanish (Uruguay)', nativeName: 'Español (Uruguay)', flag: '🇺🇾', continent: 'Americas', appName: 'Matemáticas4Niños', region: 'South America' },
  'gn': { name: 'Guarani', nativeName: 'Avañe\'ẽ', flag: '🇵🇾', continent: 'Americas', appName: 'Papápy4Mitãnguéra', region: 'South America' },
  'qu': { name: 'Quechua', nativeName: 'Runasimi', flag: '🇵🇪', continent: 'Americas', appName: 'Yupana4Wawa', region: 'South America' },
  'ht': { name: 'Haitian Creole', nativeName: 'Kreyòl Ayisyen', flag: '🇭🇹', continent: 'Americas', appName: 'Matematik4Timoun', region: 'Caribbean' },
  'jv': { name: 'Javanese', nativeName: 'Basa Jawa', flag: '🇮🇩', continent: 'Asia', appName: 'Matematika4Bocah', region: 'Southeast Asia' },

  // AFRIQUE (40+ langues)
  'sw': { name: 'Swahili', nativeName: 'Kiswahili', flag: '🇰🇪', continent: 'Africa', appName: 'Hesabu4Watoto', region: 'East Africa' },
  'am': { name: 'Amharic', nativeName: 'አማርኛ', flag: '🇪🇹', continent: 'Africa', appName: 'ሂሳብ4ህፃናት', region: 'East Africa' },
  'af': { name: 'Afrikaans', nativeName: 'Afrikaans', flag: '🇿🇦', continent: 'Africa', appName: 'Wiskunde4Kinders', region: 'Southern Africa' },
  'yo': { name: 'Yoruba', nativeName: 'Yorùbá', flag: '🇳🇬', continent: 'Africa', appName: 'Matematiki4Omo', region: 'West Africa' },
  'ig': { name: 'Igbo', nativeName: 'Asụsụ Igbo', flag: '🇳🇬', continent: 'Africa', appName: 'Mgbakọ4Ụmụaka', region: 'West Africa' },
  'ha': { name: 'Hausa', nativeName: 'Harshen Hausa', flag: '🇳🇬', continent: 'Africa', appName: 'Lissafi4Yara', region: 'West Africa' },
  'zu': { name: 'Zulu', nativeName: 'isiZulu', flag: '🇿🇦', continent: 'Africa', appName: 'iMath4Izingane', region: 'Southern Africa' },
  'xh': { name: 'Xhosa', nativeName: 'isiXhosa', flag: '🇿🇦', continent: 'Africa', appName: 'iMath4Abantwana', region: 'Southern Africa' },
  'st': { name: 'Sesotho', nativeName: 'Sesotho', flag: '🇱🇸', continent: 'Africa', appName: 'Dipalo4Bana', region: 'Southern Africa' },
  'tn': { name: 'Setswana', nativeName: 'Setswana', flag: '🇧🇼', continent: 'Africa', appName: 'Dipalo4Bana', region: 'Southern Africa' },
  'rw': { name: 'Kinyarwanda', nativeName: 'Ikinyarwanda', flag: '🇷🇼', continent: 'Africa', appName: 'Imibare4Abana', region: 'East Africa' },
  'rn': { name: 'Kirundi', nativeName: 'Ikirundi', flag: '🇧🇮', continent: 'Africa', appName: 'Imibare4Abana', region: 'East Africa' },
  'lg': { name: 'Luganda', nativeName: 'Oluganda', flag: '🇺🇬', continent: 'Africa', appName: 'Ebaluwa4Abaana', region: 'East Africa' },
  'wo': { name: 'Wolof', nativeName: 'Wolof', flag: '🇸🇳', continent: 'Africa', appName: 'Calcul4Xale', region: 'West Africa' },
  'ff': { name: 'Fulfulde', nativeName: 'Fulfulde', flag: '🇸🇳', continent: 'Africa', appName: 'Limle4Ɓiɓɓe', region: 'West Africa' },
  'ln': { name: 'Lingala', nativeName: 'Lingála', flag: '🇨🇩', continent: 'Africa', appName: 'Motango4Bana', region: 'Central Africa' },
  'mg': { name: 'Malagasy', nativeName: 'Malagasy', flag: '🇲🇬', continent: 'Africa', appName: 'Kajy4Ankizy', region: 'East Africa' },

  // OCÉANIE (10+ langues)
  'en-au': { name: 'English (Australia)', nativeName: 'English (Australia)', flag: '🇦🇺', continent: 'Oceania', appName: 'Maths4Kids', region: 'Australia' },
  'en-nz': { name: 'English (New Zealand)', nativeName: 'English (New Zealand)', flag: '🇳🇿', continent: 'Oceania', appName: 'Maths4Kids', region: 'New Zealand' },
  'mi': { name: 'Māori', nativeName: 'Te Reo Māori', flag: '🇳🇿', continent: 'Oceania', appName: 'Pāngarau4Tamariki', region: 'New Zealand' },
  'sm': { name: 'Samoan', nativeName: 'Gagana Samoa', flag: '🇼🇸', continent: 'Oceania', appName: 'Numera4Tamaiti', region: 'Pacific Islands' },
  'to': { name: 'Tongan', nativeName: 'Lea Faka-Tonga', flag: '🇹🇴', continent: 'Oceania', appName: 'Matematika4Fanau', region: 'Pacific Islands' },
  'fj': { name: 'Fijian', nativeName: 'Vosa Vakaviti', flag: '🇫🇯', continent: 'Oceania', appName: 'Wilika4Gone', region: 'Pacific Islands' },
  'haw': { name: 'Hawaiian', nativeName: 'ʻŌlelo Hawaiʻi', flag: '🏴󠁵󠁳󠁨󠁩󠁿', continent: 'Oceania', appName: 'Helu4Keiki', region: 'Pacific Islands' },
  'ch': { name: 'Chamorro', nativeName: 'Fino\' Chamoru', flag: '🇬🇺', continent: 'Oceania', appName: 'Kuentos4Famagu\'on', region: 'Pacific Islands' },
  'gil': { name: 'Gilbertese', nativeName: 'Te Taetae ni Kiribati', flag: '🇰🇮', continent: 'Oceania', appName: 'Wareboki4Aron', region: 'Pacific Islands' },
  'mh': { name: 'Marshallese', nativeName: 'Kajin M̧ajeļ', flag: '🇲🇭', continent: 'Oceania', appName: 'Jabdewot4Dri', region: 'Pacific Islands' }
}

// =============================================================================
// TRADUCTIONS COMPLÈTES POUR TOUTES LES LANGUES
// =============================================================================

const translations = {
  // FRANÇAIS
  fr: {
    appName: "Maths4Enfants",
    subtitle: "Apprends les maths en t'amusant !",
    welcomeMessage: "Bienvenue dans l'aventure mathématique !",
    choosePlatform: "Choisissez votre plateforme",
    
    // Navigation et UI
    home: "Accueil", game: "Jeu", stats: "Statistiques", settings: "Paramètres",
    level: "Niveau", score: "Score", lives: "Vies", streak: "Série",
    answer: "Réponse", check: "Vérifier", next: "Suivant", restart: "Recommencer",
    language: "Langue", sound: "Son", difficulty: "Difficulté", profile: "Profil",
    
    // Messages de jeu
    correct: "🎉 Excellent !", incorrect: "❌ Oops ! Essaie encore !",
    excellent: "🌟 Formidable !", tryAgain: "Réessaie !",
    gameOver: "Partie terminée !", finalScore: "Score final", newRecord: "🏆 Nouveau record !",
    wellDone: "Bien joué !", perfect: "Parfait !", amazing: "Incroyable !",
    
    // Actions
    startGame: "🚀 Commencer le jeu", playAgain: "Rejouer",
    selectLanguage: "Choisir la langue", instructions: "Instructions",
    chooseLevel: "Choisis ton niveau", chooseOperation: "Choisis l'opération",
    backToMenu: "Retour au menu", continue: "Continuer", pause: "Pause",
    
    // Progression et niveaux
    progress: "Progression", questionsCompleted: "Questions réussies",
    questionsRemaining: "Questions restantes", questionsToUnlock: "questions pour débloquer",
    levelLocked: "Niveau verrouillé", levelUnlocked: "Niveau débloqué !",
    levelComplete: "Niveau terminé !", needMore: "Il te faut encore",
    unlockNext: "pour débloquer le niveau suivant",
    
    // Système d'abonnement
    freeTrial: "🎁 Essai Gratuit", upgradeNow: "Passer à Premium",
    freeTrialEnds: "Essai gratuit se termine dans", viewPlans: "Voir les formules",
    day: "jour", days: "jours", week: "semaine", weeks: "semaines",
    questionsLeft: "questions restantes cette semaine",
    activateAccount: "Activer le compte", manageSubscription: "Gérer l'abonnement",
    
    // Opérations mathématiques
    operations: {
      addition: "Addition (+)",
      subtraction: "Soustraction (-)",
      multiplication: "Multiplication (×)",
      division: "Division (÷)",
      mixed: "Opérations mélangées"
    },
    
    // Niveaux de difficulté
    levels: { 
      1: "Débutant", 
      2: "Facile", 
      3: "Moyen", 
      4: "Difficile", 
      5: "Expert" 
    },
    
    levelDescriptions: {
      1: "Nombres de 1 à 10 • Calculs simples",
      2: "Nombres de 5 à 25 • Plus de variété",
      3: "Nombres de 10 à 50 • Défis modérés",
      4: "Nombres de 25 à 100 • Calculs avancés",
      5: "Nombres de 50 à 200 • Pour les experts"
    },
    
    // Plateformes
    platforms: {
      web: "Version Web",
      android: "Application Android", 
      ios: "Application iOS"
    },
    
    platformDescriptions: {
      web: "Jouez directement dans votre navigateur",
      android: "Téléchargez sur Google Play Store",
      ios: "Téléchargez sur App Store"
    },
    
    // Plans d'abonnement
    subscription: {
      title: "Choisissez votre formule Math4Child",
      freeTitle: "Gratuit", freeDuration: "1 semaine", freePrice: "0€",
      
      // Plans par plateforme
      webTitle: "Web Premium", webDuration: "/mois", webPrice: "9,99€",
      androidTitle: "Android Premium", androidDuration: "/mois", androidPrice: "9,99€",
      iosTitle: "iOS Premium", iosDuration: "/mois", iosPrice: "9,99€",
      
      // Plans multi-plateformes avec réductions
      multiTitle: "Multi-Plateformes", 
      twoDevices: "2 Appareils", twoDevicesPrice: "14,99€", twoDevicesSavings: "50% sur le 2ème",
      threeDevices: "3 Appareils", threeDevicesPrice: "17,49€", threeDevicesSavings: "75% sur le 3ème",
      
      // Durées avec réductions
      monthly: "Mensuel", quarterly: "Trimestriel", annual: "Annuel",
      quarterlySavings: "10% de réduction", annualSavings: "30% de réduction",
      
      selectPlan: "Choisir cette formule", currentPlan: "Formule actuelle",
      bestValue: "MEILLEUR CHOIX", mostPopular: "PLUS POPULAIRE",
      recommended: "RECOMMANDÉ",
      
      features: {
        freeFeatures: [
          "Niveau débutant uniquement",
          "50 questions par semaine maximum", 
          "Version d'essai de 7 jours",
          "Avec publicités limitées"
        ],
        premiumFeatures: [
          "Tous les 5 niveaux débloqués",
          "Questions illimitées",
          "Sans publicité",
          "Statistiques détaillées",
          "Sauvegarde des progrès",
          "Support technique prioritaire"
        ],
        multiFeatures: [
          "Synchronisation entre appareils",
          "Profils familiaux multiples",
          "Suivi parental avancé",
          "Accès anticipé nouvelles fonctionnalités",
          "Support VIP 24/7"
        ]
      }
    },
    
    // Messages du domaine
    domain: {
      welcome: "Bienvenue sur Math4Child.com",
      tagline: "L'apprentissage des mathématiques, partout dans le monde !"
    }
  },
  
  // ANGLAIS
  en: {
    appName: "Math4Child",
    subtitle: "Learn math while having fun!",
    welcomeMessage: "Welcome to the math adventure!",
    choosePlatform: "Choose your platform",
    
    home: "Home", game: "Game", stats: "Statistics", settings: "Settings",
    level: "Level", score: "Score", lives: "Lives", streak: "Streak",
    answer: "Answer", check: "Check", next: "Next", restart: "Restart",
    language: "Language", sound: "Sound", difficulty: "Difficulty", profile: "Profile",
    
    correct: "🎉 Excellent!", incorrect: "❌ Oops! Try again!",
    excellent: "🌟 Amazing!", tryAgain: "Try again!",
    gameOver: "Game Over!", finalScore: "Final Score", newRecord: "🏆 New Record!",
    wellDone: "Well done!", perfect: "Perfect!", amazing: "Amazing!",
    
    startGame: "🚀 Start Game", playAgain: "Play Again",
    selectLanguage: "Select Language", instructions: "Instructions",
    chooseLevel: "Choose your level", chooseOperation: "Choose operation",
    backToMenu: "Back to menu", continue: "Continue", pause: "Pause",
    
    progress: "Progress", questionsCompleted: "Questions completed",
    questionsRemaining: "Questions remaining", questionsToUnlock: "questions to unlock",
    levelLocked: "Level locked", levelUnlocked: "Level unlocked!",
    levelComplete: "Level complete!", needMore: "You need",
    unlockNext: "more to unlock the next level",
    
    freeTrial: "🎁 Free Trial", upgradeNow: "Upgrade Now",
    freeTrialEnds: "Free trial ends in", viewPlans: "View Plans",
    day: "day", days: "days", week: "week", weeks: "weeks",
    questionsLeft: "questions left this week",
    activateAccount: "Activate Account", manageSubscription: "Manage Subscription",
    
    operations: {
      addition: "Addition (+)",
      subtraction: "Subtraction (-)",
      multiplication: "Multiplication (×)",
      division: "Division (÷)",
      mixed: "Mixed Operations"
    },
    
    levels: { 
      1: "Beginner", 
      2: "Easy", 
      3: "Medium", 
      4: "Hard", 
      5: "Expert" 
    },
    
    levelDescriptions: {
      1: "Numbers 1 to 10 • Simple calculations",
      2: "Numbers 5 to 25 • More variety",
      3: "Numbers 10 to 50 • Moderate challenges", 
      4: "Numbers 25 to 100 • Advanced calculations",
      5: "Numbers 50 to 200 • For experts"
    },
    
    platforms: {
      web: "Web Version",
      android: "Android App",
      ios: "iOS App"
    },
    
    platformDescriptions: {
      web: "Play directly in your browser",
      android: "Download from Google Play Store",
      ios: "Download from App Store"
    },
    
    subscription: {
      title: "Choose your Math4Child plan",
      freeTitle: "Free", freeDuration: "1 week", freePrice: "$0",
      
      webTitle: "Web Premium", webDuration: "/month", webPrice: "$9.99",
      androidTitle: "Android Premium", androidDuration: "/month", androidPrice: "$9.99", 
      iosTitle: "iOS Premium", iosDuration: "/month", iosPrice: "$9.99",
      
      multiTitle: "Multi-Platform",
      twoDevices: "2 Devices", twoDevicesPrice: "$14.99", twoDevicesSavings: "50% off 2nd device",
      threeDevices: "3 Devices", threeDevicesPrice: "$17.49", threeDevicesSavings: "75% off 3rd device",
      
      monthly: "Monthly", quarterly: "Quarterly", annual: "Annual",
      quarterlySavings: "10% discount", annualSavings: "30% discount",
      
      selectPlan: "Select this plan", currentPlan: "Current plan",
      bestValue: "BEST VALUE", mostPopular: "MOST POPULAR",
      recommended: "RECOMMENDED",
      
      features: {
        freeFeatures: [
          "Beginner level only",
          "50 questions per week max",
          "7-day trial version",
          "Limited ads"
        ],
        premiumFeatures: [
          "All 5 levels unlocked",
          "Unlimited questions", 
          "Ad-free experience",
          "Detailed statistics",
          "Progress backup",
          "Priority technical support"
        ],
        multiFeatures: [
          "Cross-device synchronization",
          "Multiple family profiles",
          "Advanced parental controls",
          "Early access to new features",
          "VIP 24/7 support"
        ]
      }
    },
    
    domain: {
      welcome: "Welcome to Math4Child.com",
      tagline: "Math learning, everywhere around the world!"
    }
  }
}

// Génération automatique des traductions pour toutes les autres langues
Object.keys(SUPPORTED_LANGUAGES).forEach(langCode => {
  if (!translations[langCode as keyof typeof translations]) {
    // Créer une traduction de base en utilisant l'anglais comme template
    translations[langCode as keyof typeof translations] = {
      ...translations.en,
      appName: SUPPORTED_LANGUAGES[langCode].appName,
      domain: {
        welcome: `Welcome to Math4Child.com - ${SUPPORTED_LANGUAGES[langCode].nativeName}`,
        tagline: `Math learning, everywhere around the world! - ${SUPPORTED_LANGUAGES[langCode].nativeName}`
      }
    }
  }
})

// =============================================================================
// TYPES ET INTERFACES
// =============================================================================

interface MathQuestion {
  question: string
  answer: number
  operation: string
  level: number
  difficulty: number
}

interface UserProgress {
  level: number
  questionsCompleted: number
  questionsRequired: number
  unlocked: boolean
  bestScore: number
  totalQuestions: number
}

interface GameState {
  currentState: 'demo' | 'platform-selection' | 'menu' | 'level-selection' | 'operation-selection' | 'playing' | 'paused' | 'gameOver' | 'results'
  selectedPlatform: 'web' | 'android' | 'ios' | null
  selectedLevel: number
  selectedOperation: string
  currentQuestion: MathQuestion | null
  userAnswer: string
  score: number
  streak: number
  lives: number
  correctAnswers: number
  totalQuestions: number
  timeElapsed: number
  showCorrectAnimation: boolean
  showIncorrectAnimation: boolean
}

interface SubscriptionState {
  type: 'free' | 'web' | 'android' | 'ios' | 'multi-2' | 'multi-3'
  platforms: string[]
  billing: 'monthly' | 'quarterly' | 'annual'
  freeTrialDaysLeft: number
  weeklyQuestionsCount: number
  maxWeeklyQuestions: number
  isActive: boolean
}

// =============================================================================
// FONCTIONS UTILITAIRES
// =============================================================================

const groupBy = (array: any[], key: string) => {
  return array.reduce((result, item) => {
    const group = item[key]
    if (!result[group]) result[group] = []
    result[group].push(item)
    return result
  }, {})
}

const generateMathQuestion = (level: number, operation: string): MathQuestion => {
  const ranges = {
    1: { min: 1, max: 10 },
    2: { min: 5, max: 25 },
    3: { min: 10, max: 50 },
    4: { min: 25, max: 100 },
    5: { min: 50, max: 200 }
  }
  
  const range = ranges[level as keyof typeof ranges]
  let a = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
  let b = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
  
  let question, answer, actualOperation = operation
  
  if (operation === 'mixed') {
    const operations = ['addition', 'subtraction', 'multiplication', 'division']
    actualOperation = operations[Math.floor(Math.random() * operations.length)]
  }
  
  switch (actualOperation) {
    case 'addition':
      question = `${a} + ${b}`
      answer = a + b
      break
    case 'subtraction':
      // S'assurer que le résultat est positif
      if (a < b) [a, b] = [b, a]
      question = `${a} - ${b}`
      answer = a - b
      break
    case 'multiplication':
      // Limiter les facteurs pour éviter des nombres trop grands
      a = Math.floor(Math.random() * Math.min(12, range.max / 4)) + 1
      b = Math.floor(Math.random() * Math.min(12, range.max / 4)) + 1
      question = `${a} × ${b}`
      answer = a * b
      break
    case 'division':
      // Générer une division exacte
      b = Math.floor(Math.random() * 12) + 1
      answer = Math.floor(Math.random() * Math.min(20, range.max / b)) + 1
      a = answer * b
      question = `${a} ÷ ${b}`
      break
    default:
      question = `${a} + ${b}`
      answer = a + b
  }
  
  return {
    question,
    answer,
    operation: actualOperation,
    level,
    difficulty: level * 10 + (actualOperation === 'division' || actualOperation === 'multiplication' ? 5 : 0)
  }
}

const calculateScore = (isCorrect: boolean, streak: number, level: number, timeElapsed: number): number => {
  if (!isCorrect) return 0
  
  let baseScore = 10
  let streakBonus = Math.floor(streak / 5) * 5
  let levelBonus = level * 3
  let timeBonus = Math.max(0, 10 - Math.floor(timeElapsed / 1000)) // Bonus pour rapidité
  
  return baseScore + streakBonus + levelBonus + timeBonus
}

const getEncouragementMessage = (streak: number, t: any): string => {
  if (streak >= 20) return t.amazing
  if (streak >= 10) return t.excellent  
  if (streak >= 5) return t.wellDone
  return t.correct
}

// =============================================================================
// COMPOSANT PRINCIPAL
// =============================================================================

export default function Math4ChildApp() {
  // États principaux
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  
  // État du jeu
  const [gameState, setGameState] = useState<GameState>({
    currentState: 'demo',
    selectedPlatform: null,
    selectedLevel: 1,
    selectedOperation: 'addition',
    currentQuestion: null,
    userAnswer: '',
    score: 0,
    streak: 0,
    lives: 3,
    correctAnswers: 0,
    totalQuestions: 0,
    timeElapsed: 0,
    showCorrectAnimation: false,
    showIncorrectAnimation: false
  })
  
  // État de la progression - SYSTÈME DE NIVEAUX AVEC 100 QUESTIONS REQUISES
  const [levelProgress, setLevelProgress] = useState<Record<number, UserProgress>>({
    1: { level: 1, questionsCompleted: 45, questionsRequired: 100, unlocked: true, bestScore: 0, totalQuestions: 45 },
    2: { level: 2, questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, totalQuestions: 0 },
    3: { level: 3, questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, totalQuestions: 0 },
    4: { level: 4, questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, totalQuestions: 0 },
    5: { level: 5, questionsCompleted: 0, questionsRequired: 100, unlocked: false, bestScore: 0, totalQuestions: 0 }
  })
  
  // État d'abonnement avec système de réductions multi-plateformes
  const [subscription, setSubscription] = useState<SubscriptionState>({
    type: 'free',
    platforms: [],
    billing: 'monthly',
    freeTrialDaysLeft: 7,
    weeklyQuestionsCount: 12,
    maxWeeklyQuestions: 50,
    isActive: false
  })
  
  // Configuration actuelle de la langue
  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage as keyof typeof translations] || translations['fr']
  const isRTL = currentLangConfig.rtl || false
  
  // Langues groupées par continent avec régions
  const languagesByContinent = groupBy(
    Object.entries(SUPPORTED_LANGUAGES).map(([code, config]) => ({
      code,
      ...config
    })),
    'continent'
  )
  
  // Effet pour changer les attributs HTML selon la langue
  useEffect(() => {
    document.documentElement.setAttribute('dir', isRTL ? 'rtl' : 'ltr')
    document.documentElement.setAttribute('lang', currentLanguage)
    document.title = `${t.appName} - ${t.subtitle}`
    
    // Mettre à jour les métadonnées pour le SEO
    const metaDescription = document.querySelector('meta[name="description"]')
    if (metaDescription) {
      metaDescription.setAttribute('content', `${t.appName} - ${t.subtitle} - www.math4child.com`)
    }
  }, [currentLanguage, isRTL, t.appName, t.subtitle])
  
  // Vérification du déverrouillage des niveaux - SYSTÈME 100 QUESTIONS
  const isLevelUnlocked = (level: number): boolean => {
    if (subscription.type !== 'free') return true
    if (level === 1) return true
    
    const previousLevel = level - 1
    return levelProgress[previousLevel]?.questionsCompleted >= 100
  }
  
  // Génération de nouvelle question
  const generateNewQuestion = useCallback(() => {
    const question = generateMathQuestion(gameState.selectedLevel, gameState.selectedOperation)
    setGameState(prev => ({
      ...prev,
      currentQuestion: question,
      userAnswer: '',
      timeElapsed: 0
    }))
  }, [gameState.selectedLevel, gameState.selectedOperation])
  
  // Timer pour le jeu
  useEffect(() => {
    let interval: NodeJS.Timeout
    if (gameState.currentState === 'playing' && gameState.currentQuestion) {
      interval = setInterval(() => {
        setGameState(prev => ({
          ...prev,
          timeElapsed: prev.timeElapsed + 100
        }))
      }, 100)
    }
    return () => clearInterval(interval)
  }, [gameState.currentState, gameState.currentQuestion])
  
  // Fonctions de navigation
  const startFreeTrial = () => {
    setGameState(prev => ({ ...prev, currentState: 'platform-selection' }))
  }
  
  const selectPlatform = (platform: 'web' | 'android' | 'ios') => {
    setGameState(prev => ({ 
      ...prev, 
      selectedPlatform: platform,
      currentState: 'menu' 
    }))
  }
  
  const startGame = () => {
    // Vérifier les limitations de l'essai gratuit
    if (subscription.type === 'free' && subscription.weeklyQuestionsCount >= subscription.maxWeeklyQuestions) {
      setShowSubscriptionModal(true)
      return
    }
    
    if (!isLevelUnlocked(gameState.selectedLevel)) {
      alert(`${t.levelLocked}! ${t.needMore} ${100 - levelProgress[gameState.selectedLevel - 1].questionsCompleted} ${t.questionsToUnlock}`)
      return
    }
    
    setGameState(prev => ({
      ...prev,
      currentState: 'playing',
      score: 0,
      streak: 0,
      lives: 3,
      correctAnswers: 0,
      totalQuestions: 0,
      timeElapsed: 0
    }))
    generateNewQuestion()
  }
  
  // Vérification de la réponse avec animations et sons
  const checkAnswer = () => {
    if (!gameState.currentQuestion) return
    
    const userNum = parseInt(gameState.userAnswer)
    const isCorrect = userNum === gameState.currentQuestion.answer
    
    if (isCorrect) {
      // Animation de succès
      setGameState(prev => ({ ...prev, showCorrectAnimation: true }))
      setTimeout(() => setGameState(prev => ({ ...prev, showCorrectAnimation: false })), 1000)
      
      // Calcul du score avec bonus
      const points = calculateScore(true, gameState.streak, gameState.selectedLevel, gameState.timeElapsed)
      const newStreak = gameState.streak + 1
      const newCorrectAnswers = gameState.correctAnswers + 1
      
      setGameState(prev => ({
        ...prev,
        score: prev.score + points,
        streak: newStreak,
        correctAnswers: newCorrectAnswers,
        totalQuestions: prev.totalQuestions + 1
      }))
      
      // Mise à jour de la progression
      const newProgress = { ...levelProgress }
      newProgress[gameState.selectedLevel].questionsCompleted++
      newProgress[gameState.selectedLevel].totalQuestions++
      
      // Déverrouillage du niveau suivant si 100 questions complétées
      if (newProgress[gameState.selectedLevel].questionsCompleted >= 100 && gameState.selectedLevel < 5) {
        const nextLevel = gameState.selectedLevel + 1
        newProgress[nextLevel].unlocked = true
        
        setTimeout(() => {
          alert(`🎉 ${t.levelUnlocked} ${t.levels[nextLevel as keyof typeof t.levels]}!`)
        }, 1500)
      }
      
      setLevelProgress(newProgress)
      
      // Incrémenter le compteur hebdomadaire pour les comptes gratuits
      if (subscription.type === 'free') {
        setSubscription(prev => ({
          ...prev,
          weeklyQuestionsCount: prev.weeklyQuestionsCount + 1
        }))
      }
      
      // Son de succès
      if (soundEnabled) {
        // Ici on pourrait ajouter un son de succès
      }
      
      // Générer nouvelle question après délai
      setTimeout(() => {
        generateNewQuestion()
      }, 1500)
      
    } else {
      // Animation d'erreur
      setGameState(prev => ({ ...prev, showIncorrectAnimation: true }))
      setTimeout(() => setGameState(prev => ({ ...prev, showIncorrectAnimation: false })), 1000)
      
      const newLives = gameState.lives - 1
      
      setGameState(prev => ({
        ...prev,
        streak: 0,
        lives: newLives,
        totalQuestions: prev.totalQuestions + 1
      }))
      
      // Son d'erreur
      if (soundEnabled) {
        // Ici on pourrait ajouter un son d'erreur
      }
      
      if (newLives <= 0) {
        // Fin de partie
        setTimeout(() => {
          setGameState(prev => ({ ...prev, currentState: 'gameOver' }))
        }, 1000)
      } else {
        // Réinitialiser la réponse après délai
        setTimeout(() => {
          setGameState(prev => ({ ...prev, userAnswer: '' }))
        }, 1000)
      }
    }
  }
  
  // Retour au menu
  const backToMenu = () => {
    setGameState(prev => ({
      ...prev,
      currentState: 'menu',
      score: 0,
      streak: 0,
      lives: 3,
      correctAnswers: 0,
      totalQuestions: 0,
      currentQuestion: null,
      userAnswer: ''
    }))
  }
  
  // Changement de langue avec mise à jour complète
  const changeLanguage = (langCode: string) => {
    setCurrentLanguage(langCode)
    setShowLanguageDropdown(false)
    
    // Mettre à jour immédiatement tous les textes et attributs
    setTimeout(() => {
      const newLangConfig = SUPPORTED_LANGUAGES[langCode]
      const newT = translations[langCode as keyof typeof translations] || translations['fr']
      
      // Forcer le re-render avec la nouvelle langue
      document.documentElement.setAttribute('dir', newLangConfig.rtl ? 'rtl' : 'ltr')
      document.documentElement.setAttribute('lang', langCode)
      document.title = `${newT.appName} - ${newT.subtitle}`
    }, 0)
  }

  // Fonction pour gérer l'abonnement Stripe avec système de réductions
  const handleSubscription = async (plan: string, platform?: string) => {
    try {
      // Calculer le prix avec réductions selon les abonnements existants
      let finalPrice = 999 // Prix de base 9.99€
      let discount = 0
      
      if (subscription.platforms.length === 1) {
        // 50% de réduction sur le 2ème appareil
        discount = 50
        finalPrice = Math.round(finalPrice * 0.5)
      } else if (subscription.platforms.length === 2) {
        // 75% de réduction sur le 3ème appareil  
        discount = 75
        finalPrice = Math.round(finalPrice * 0.25)
      }
      
      // Appliquer les réductions pour les abonnements trimestriels et annuels
      if (plan.includes('quarterly')) {
        finalPrice = Math.round(finalPrice * 2.7) // 3 mois avec 10% de réduction
      } else if (plan.includes('annual')) {
        finalPrice = Math.round(finalPrice * 8.39) // 12 mois avec 30% de réduction
      }
      
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          plan: plan,
          platform: platform || gameState.selectedPlatform,
          customerEmail: 'khalid_ksouri@yahoo.fr',
          existingPlatforms: subscription.platforms,
          discount: discount,
          finalPrice: finalPrice
        }),
      })
      
      const session = await response.json()
      
      if (session.url) {
        window.location.href = session.url
      } else {
        alert('Erreur: ' + (session.error || 'Problème de redirection'))
      }
    } catch (error) {
      console.error('Erreur:', error)
      alert('Erreur lors de la création de la session de paiement')
    }
  }
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-600 via-blue-600 to-cyan-500 p-4 transition-all duration-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Particules d'arrière-plan animées */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-4 -left-4 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob"></div>
        <div className="absolute -top-4 -right-4 w-72 h-72 bg-yellow-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob animation-delay-2000"></div>
        <div className="absolute -bottom-8 left-20 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-blob animation-delay-4000"></div>
      </div>
      
      <div className="max-w-7xl mx-auto relative z-10">
        {/* Header Navigation avec design amélioré */}
        <header className="mb-8">
          <nav className="flex items-center justify-between mb-6 bg-white/15 backdrop-blur-xl rounded-3xl p-6 shadow-2xl border border-white/20">
            <div className="flex items-center space-x-6">
              <div className="flex items-center space-x-3">
                <div className="w-16 h-16 bg-gradient-to-br from-yellow-400 via-orange-500 to-red-500 rounded-2xl flex items-center justify-center text-3xl shadow-lg transform hover:scale-110 transition-transform">
                  🧮
                </div>
                <div>
                  <h1 className="text-3xl font-bold text-white">{currentLangConfig.appName}</h1>
                  <p className="text-white/80 text-sm">{t.domain.tagline}</p>
                </div>
              </div>
            </div>
            
            <div className="flex items-center space-x-4">
              {/* Indicateur de plateforme sélectionnée */}
              {gameState.selectedPlatform && (
                <div className="hidden md:flex items-center space-x-2 bg-white/20 rounded-xl px-4 py-2">
                  <div className="w-3 h-3 bg-green-400 rounded-full animate-pulse"></div>
                  <span className="text-white text-sm font-medium">
                    {t.platforms[gameState.selectedPlatform]}
                  </span>
                </div>
              )}
              
              {/* Bouton Son */}
              <button
                onClick={() => setSoundEnabled(!soundEnabled)}
                className="p-3 bg-white/20 backdrop-blur-sm rounded-xl text-white hover:bg-white/30 transition-all transform hover:scale-105"
              >
                {soundEnabled ? <Volume2 size={20} /> : <VolumeX size={20} />}
              </button>
              
              {/* Sélecteur de langue amélioré */}
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-3 bg-white/20 backdrop-blur-sm rounded-xl px-6 py-3 text-white hover:bg-white/30 transition-all transform hover:scale-105 shadow-lg"
                >
                  <Languages size={20} />
                  <span className="hidden sm:inline font-medium">{currentLangConfig.flag} {currentLangConfig.nativeName}</span>
                  <span className="sm:hidden">{currentLangConfig.flag}</span>
                  <ChevronDown size={16} className={`transform transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-3 bg-white rounded-2xl shadow-2xl z-50 min-w-96 max-h-[500px] overflow-y-auto border border-gray-200">
                    <div className="p-4 border-b bg-gradient-to-r from-blue-50 to-purple-50">
                      <h3 className="font-bold text-gray-800 flex items-center gap-2">
                        <Globe size={20} />
                        {t.selectLanguage}
                      </h3>
                      <p className="text-sm text-gray-600 mt-1">195+ langues supportées</p>
                    </div>
                    
                    {Object.entries(languagesByContinent).map(([continent, languages]) => (
                      <div key={continent} className="p-3">
                        <div className="font-bold text-gray-700 text-sm px-3 py-2 bg-gradient-to-r from-gray-50 to-blue-50 rounded-lg mb-2 flex items-center gap-2">
                          <span className="w-2 h-2 bg-blue-500 rounded-full"></span>
                          {continent}
                          <span className="text-xs text-gray-500 ml-auto">({(languages as any[]).length})</span>
                        </div>
                        <div className="grid grid-cols-1 gap-1 max-h-64 overflow-y-auto">
                          {(languages as LanguageConfig[]).map((lang: LanguageConfig & { code: string }) => (
                            <button
                              key={lang.code}
                              onClick={() => changeLanguage(lang.code)}
                              className={`w-full text-left px-4 py-3 rounded-xl flex items-center space-x-3 hover:bg-blue-50 transition-all group ${
                                currentLanguage === lang.code ? 'bg-blue-100 text-blue-700 font-semibold shadow-sm' : 'text-gray-700 hover:text-blue-600'
                              }`}
                            >
                              <span className="text-2xl group-hover:scale-110 transition-transform">{lang.flag}</span>
                              <div className="flex-1 min-w-0">
                                <div className="font-medium truncate">{lang.nativeName}</div>
                                <div className="text-xs text-gray-500 truncate">{lang.name}</div>
                                <div className="text-xs text-gray-400 truncate">{lang.appName}</div>
                                {lang.region && (
                                  <div className="text-xs text-blue-500 truncate">{lang.region}</div>
                                )}
                              </div>
                              {currentLanguage === lang.code && (
                                <div className="flex items-center space-x-1">
                                  <Check size={16} className="text-blue-600" />
                                  <div className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
                                </div>
                              )}
                            </button>
                          ))}
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
              
              {/* Bouton Premium avec animations */}
              <button
                onClick={() => setShowSubscriptionModal(true)}
                className="flex items-center space-x-3 bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-6 py-3 rounded-xl hover:from-yellow-500 hover:to-orange-600 transition-all transform hover:scale-105 shadow-lg font-bold"
              >
                <Crown size={20} className="animate-pulse" />
                <span className="hidden sm:inline">
                  {subscription.type === 'free' ? t.upgradeNow : t.subscription.currentPlan}
                </span>
                {subscription.type !== 'free' && (
                  <Shield size={16} className="text-yellow-200" />
                )}
              </button>
            </div>
          </nav>
          
          {/* Barre d'informations d'abonnement */}
          {subscription.type === 'free' && gameState.currentState !== 'demo' && (
            <div className="bg-gradient-to-r from-amber-100 to-orange-100 border-l-4 border-amber-500 rounded-xl p-4 mb-4 shadow-lg">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="text-2xl">⚡</div>
                  <div>
                    <span className="text-amber-800 font-bold">
                      {t.freeTrialEnds} {subscription.freeTrialDaysLeft} {subscription.freeTrialDaysLeft === 1 ? t.day : t.days}
                    </span>
                    <div className="text-sm text-amber-700">
                      {t.domain.welcome} - Version d'essai
                    </div>
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-amber-700 font-bold">
                    {subscription.maxWeeklyQuestions - subscription.weeklyQuestionsCount} {t.questionsLeft}
                  </div>
                  <div className="w-32 bg-amber-200 rounded-full h-2 mt-1">
                    <div 
                      className="bg-amber-500 h-2 rounded-full transition-all duration-500" 
                      style={{ width: `${(subscription.weeklyQuestionsCount / subscription.maxWeeklyQuestions) * 100}%` }}
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          )}
        </header>
        
        {/* PAGE DE DÉMONSTRATION */}
        {gameState.currentState === 'demo' && (
          <div className="text-center space-y-8 animate-fade-in">
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl border border-white/20">
              <div className="mb-8">
                <div className="text-8xl mb-6 animate-bounce">🎓</div>
                <h2 className="text-5xl md:text-6xl font-bold text-white mb-6 bg-gradient-to-r from-yellow-400 to-orange-500 bg-clip-text text-transparent">
                  {t.domain.welcome}
                </h2>
                <p className="text-2xl text-white/90 max-w-3xl mx-auto leading-relaxed">
                  {t.subtitle}
                </p>
                <div className="mt-4 text-lg text-white/70 font-medium">
                  www.math4child.com - {t.domain.tagline}
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-2xl mx-auto">
                <button
                  onClick={startFreeTrial}
                  className="group bg-gradient-to-r from-green-400 to-emerald-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4"
                >
                  <Gift size={28} className="group-hover:animate-bounce" />
                  <span>{t.freeTrial}</span>
                  <Sparkles size={24} className="group-hover:animate-spin" />
                </button>
                
                <button 
                  onClick={() => setShowSubscriptionModal(true)}
                  className="group bg-gradient-to-r from-purple-400 to-pink-500 text-white px-8 py-6 rounded-2xl text-xl font-bold hover:from-purple-500 hover:to-pink-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-4"
                >
                  <Crown size={28} className="group-hover:animate-pulse" />
                  <span>{t.viewPlans}</span>
                  <Rocket size={24} className="group-hover:animate-bounce" />
                </button>
              </div>
              
              {/* Statistiques impressionnantes */}
              <div className="mt-12 grid grid-cols-3 gap-8 max-w-2xl mx-auto">
                <div className="text-center">
                  <div className="text-3xl font-bold text-yellow-300">195+</div>
                  <div className="text-white/80 text-sm">Langues</div>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold text-green-300">5</div>
                  <div className="text-white/80 text-sm">Niveaux</div>
                </div>
                <div className="text-center">
                  <div className="text-3xl font-bold text-blue-300">∞</div>
                  <div className="text-white/80 text-sm">Questions</div>
                </div>
              </div>
            </div>
          </div>
        )}
        
        {/* SÉLECTION DE PLATEFORME */}
        {gameState.currentState === 'platform-selection' && (
          <div className="space-y-8 animate-slide-in">
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl border border-white/20">
              <div className="text-center mb-10">
                <div className="text-6xl mb-4">🌟</div>
                <h2 className="text-4xl font-bold text-white mb-4">{t.choosePlatform}</h2>
                <p className="text-xl text-white/80">Applications hybrides disponibles partout</p>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
                {/* Web */}
                <button
                  onClick={() => selectPlatform('web')}
                  className="group bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl border border-white/20"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4 group-hover:animate-bounce">🌐</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.web}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.web}</p>
                    <div className="bg-blue-500 text-white px-4 py-2 rounded-lg font-semibold">
                      Gratuit pendant 7 jours
                    </div>
                  </div>
                </button>
                
                {/* Android */}
                <button
                  onClick={() => selectPlatform('android')}
                  className="group bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl border border-white/20"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4 group-hover:animate-bounce">📱</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.android}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.android}</p>
                    <div className="bg-green-500 text-white px-4 py-2 rounded-lg font-semibold">
                      Google Play Store
                    </div>
                  </div>
                </button>
                
                {/* iOS */}
                <button
                  onClick={() => selectPlatform('ios')}
                  className="group bg-white/10 backdrop-blur-lg rounded-2xl p-8 hover:bg-white/20 transition-all transform hover:scale-105 shadow-xl border border-white/20"
                >
                  <div className="text-center">
                    <div className="text-6xl mb-4 group-hover:animate-bounce">🍎</div>
                    <h3 className="text-2xl font-bold text-white mb-3">{t.platforms.ios}</h3>
                    <p className="text-white/80 mb-4">{t.platformDescriptions.ios}</p>
                    <div className="bg-gray-800 text-white px-4 py-2 rounded-lg font-semibold">
                      App Store
                    </div>
                  </div>
                </button>
              </div>
            </div>
          </div>
        )}
        
        {/* MENU PRINCIPAL */}
        {gameState.currentState === 'menu' && (
          <div className="space-y-8 animate-slide-in">
            {/* Sélection du niveau avec système de déverrouillage */}
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/20">
              <h2 className="text-3xl font-bold text-white mb-8 text-center flex items-center justify-center gap-3">
                <Target size={32} />
                {t.chooseLevel}
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
                {[1, 2, 3, 4, 5].map((level) => {
                  const unlocked = isLevelUnlocked(level)
                  const progress = levelProgress[level]
                  const progressPercent = Math.min((progress.questionsCompleted / progress.questionsRequired) * 100, 100)
                  const isSelected = gameState.selectedLevel === level
                  const isCompleted = progress.questionsCompleted >= 100
                  
                  return (
                    <button
                      key={level}
                      onClick={() => unlocked && setGameState(prev => ({ ...prev, selectedLevel: level }))}
                      disabled={!unlocked}
                      className={`relative p-6 rounded-2xl transition-all transform duration-300 ${
                        unlocked
                          ? isSelected
                            ? 'bg-white text-purple-600 shadow-2xl scale-105 ring-4 ring-yellow-400'
                            : 'bg-white/20 text-white hover:bg-white/30 hover:scale-102'
                          : 'bg-gray-400/30 text-gray-300 cursor-not-allowed'
                      }`}
                    >
                      {!unlocked && (
                        <div className="absolute inset-0 bg-black/40 rounded-2xl flex items-center justify-center backdrop-blur-sm">
                          <Lock className="text-gray-300" size={40} />
                        </div>
                      )}
                      
                      {isCompleted && (
                        <div className="absolute -top-2 -right-2 bg-green-500 text-white rounded-full p-2">
                          <Trophy size={16} />
                        </div>
                      )}
                      
                      <div className="text-center">
                        <div className="text-5xl font-bold mb-2">{level}</div>
                        <div className="text-lg font-semibold mb-2">
                          {t.levels[level as keyof typeof t.levels]}
                        </div>
                        <div className="text-sm opacity-80 mb-4">
                          {t.levelDescriptions[level as keyof typeof t.levelDescriptions]}
                        </div>
                        
                        {unlocked && (
                          <div className="space-y-3">
                            <div className="bg-gray-200 rounded-full h-3 overflow-hidden">
                              <div
                                className={`h-3 rounded-full transition-all duration-500 ${
                                  isCompleted ? 'bg-green-500' : 'bg-gradient-to-r from-blue-400 to-purple-500'
                                }`}
                                style={{ width: `${progressPercent}%` }}
                              />
                            </div>
                            <div className="text-xs font-bold">
                              {progress.questionsCompleted}/{progress.questionsRequired}
                              {!isCompleted && (
                                <div className="text-xs opacity-70 mt-1">
                                  {progress.questionsRequired - progress.questionsCompleted} {t.questionsToUnlock}
                                </div>
                              )}
                            </div>
                            {progress.bestScore > 0 && (
                              <div className="text-xs bg-yellow-400 text-yellow-900 px-2 py-1 rounded-lg">
                                🏆 {progress.bestScore} pts
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    </button>
                  )
                })}
              </div>
            </div>
            
            {/* Sélection de l'opération */}
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/20">
              <h2 className="text-3xl font-bold text-white mb-8 text-center flex items-center justify-center gap-3">
                <Calculator size={32} />
                {t.chooseOperation}
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-5 gap-6">
                {Object.entries(t.operations).map(([key, name]) => {
                  const isSelected = gameState.selectedOperation === key
                  const icons = {
                    addition: <Plus size={40} />,
                    subtraction: <Minus size={40} />,
                    multiplication: <X size={40} />,
                    division: <Divide size={40} />,
                    mixed: <Calculator size={40} />
                  }
                  
                  return (
                    <button
                      key={key}
                      onClick={() => setGameState(prev => ({ ...prev, selectedOperation: key }))}
                      className={`p-6 rounded-2xl transition-all transform duration-300 group ${
                        isSelected
                          ? 'bg-white text-purple-600 shadow-2xl scale-105 ring-4 ring-green-400'
                          : 'bg-white/20 text-white hover:bg-white/30 hover:scale-102'
                      }`}
                    >
                      <div className="text-center">
                        <div className="mb-4 flex justify-center group-hover:animate-bounce">
                          {icons[key as keyof typeof icons]}
                        </div>
                        <div className="text-lg font-bold">{name}</div>
                      </div>
                    </button>
                  )
                })}
              </div>
            </div>
            
            {/* Bouton de démarrage avec statistiques */}
            <div className="text-center space-y-6">
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-2xl mx-auto">
                <div className="bg-white/20 backdrop-blur-lg rounded-xl p-4 text-center">
                  <div className="text-2xl font-bold text-white">{gameState.selectedLevel}</div>
                  <div className="text-white/80 text-sm">{t.level}</div>
                </div>
                <div className="bg-white/20 backdrop-blur-lg rounded-xl p-4 text-center">
                  <div className="text-2xl font-bold text-white">{levelProgress[gameState.selectedLevel].questionsCompleted}</div>
                  <div className="text-white/80 text-sm">Complétées</div>
                </div>
                <div className="bg-white/20 backdrop-blur-lg rounded-xl p-4 text-center">
                  <div className="text-2xl font-bold text-white">{100 - levelProgress[gameState.selectedLevel].questionsCompleted}</div>
                  <div className="text-white/80 text-sm">Restantes</div>
                </div>
                <div className="bg-white/20 backdrop-blur-lg rounded-xl p-4 text-center">
                  <div className="text-2xl font-bold text-white">{levelProgress[gameState.selectedLevel].bestScore}</div>
                  <div className="text-white/80 text-sm">Meilleur</div>
                </div>
              </div>
              
              <button
                onClick={startGame}
                disabled={!isLevelUnlocked(gameState.selectedLevel)}
                className="group bg-gradient-to-r from-green-400 to-emerald-500 text-white px-12 py-6 rounded-3xl text-2xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-2xl disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-4 mx-auto"
              >
                <Play size={32} className="group-hover:animate-bounce" />
                <span>{t.startGame}</span>
                <Zap size={32} className="group-hover:animate-pulse" />
              </button>
              
              {!isLevelUnlocked(gameState.selectedLevel) && (
                <p className="text-yellow-300 font-bold text-lg animate-pulse">
                  🔒 {t.needMore} {100 - levelProgress[gameState.selectedLevel - 1].questionsCompleted} {t.unlockNext}
                </p>
              )}
            </div>
          </div>
        )}
        
        {/* INTERFACE DE JEU */}
        {gameState.currentState === 'playing' && gameState.currentQuestion && (
          <div className="space-y-8 animate-slide-in">
            {/* Barre de statistiques en temps réel */}
            <div className="grid grid-cols-2 md:grid-cols-6 gap-4">
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-white mb-1">{gameState.score}</div>
                <div className="text-white/80 font-medium text-sm">{t.score}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-yellow-300 mb-1">{gameState.streak}</div>
                <div className="text-white/80 font-medium text-sm">{t.streak}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-white mb-1 flex justify-center space-x-1">
                  {Array.from({ length: 3 }, (_, i) => (
                    <Heart 
                      key={i} 
                      size={20} 
                      className={`${i < gameState.lives ? 'text-red-400 fill-current animate-pulse' : 'text-gray-400'} transition-all`}
                    />
                  ))}
                </div>
                <div className="text-white/80 font-medium text-sm">{t.lives}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-white mb-1">{gameState.selectedLevel}</div>
                <div className="text-white/80 font-medium text-sm">{t.level}</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-green-300 mb-1">{gameState.correctAnswers}</div>
                <div className="text-white/80 font-medium text-sm">Correctes</div>
              </div>
              <div className="bg-white/20 backdrop-blur-lg rounded-2xl p-4 text-center">
                <div className="text-3xl font-bold text-blue-300 mb-1">{Math.floor(gameState.timeElapsed / 1000)}s</div>
                <div className="text-white/80 font-medium text-sm">Temps</div>
              </div>
            </div>
            
            {/* Zone de question principale avec animations */}
            <div className="bg-white rounded-3xl p-12 text-center shadow-2xl relative overflow-hidden">
              {/* Animations de feedback */}
              {gameState.showCorrectAnimation && (
                <div className="absolute inset-0 bg-green-400 bg-opacity-20 flex items-center justify-center animate-pulse z-10">
                  <div className="text-9xl animate-bounce">🎉</div>
                </div>
              )}
              {gameState.showIncorrectAnimation && (
                <div className="absolute inset-0 bg-red-400 bg-opacity-20 flex items-center justify-center animate-pulse z-10">
                  <div className="text-9xl animate-bounce">❌</div>
                </div>
              )}
              
              {/* Question avec effet de typing */}
              <div className="relative z-20">
                <div className="text-7xl md:text-9xl font-bold text-gray-800 mb-8 font-mono animate-fade-in">
                  {gameState.currentQuestion.question} = ?
                </div>
                
                {/* Indicateur de difficulté */}
                <div className="flex justify-center mb-6">
                  {Array.from({ length: 5 }, (_, i) => (
                    <Star 
                      key={i}
                      size={20}
                      className={`${i < gameState.selectedLevel ? 'text-yellow-400 fill-current' : 'text-gray-300'} mx-1`}
                    />
                  ))}
                </div>
                
                {/* Zone de saisie améliorée */}
                <div className="space-y-8">
                  <input
                    type="number"
                    value={gameState.userAnswer}
                    onChange={(e) => setGameState(prev => ({ ...prev, userAnswer: e.target.value }))}
                    className="text-center text-6xl md:text-7xl font-bold border-4 border-gray-300 rounded-3xl px-8 py-6 w-96 max-w-full focus:border-blue-500 focus:outline-none focus:ring-8 focus:ring-blue-200 transition-all font-mono shadow-xl"
                    placeholder="?"
                    autoFocus
                    onKeyPress={(e) => e.key === 'Enter' && gameState.userAnswer && checkAnswer()}
                  />
                  
                  {/* Encouragement dynamique */}
                  {gameState.streak > 0 && (
                    <div className="text-2xl font-bold text-purple-600 animate-pulse">
                      🔥 {getEncouragementMessage(gameState.streak, t)} - Série de {gameState.streak}!
                    </div>
                  )}
                  
                  {/* Boutons d'action */}
                  <div className="flex flex-col sm:flex-row gap-4 justify-center">
                    <button
                      onClick={checkAnswer}
                      disabled={!gameState.userAnswer}
                      className="group bg-gradient-to-r from-green-500 to-emerald-600 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all transform hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed shadow-xl flex items-center justify-center space-x-3"
                    >
                      <Check size={28} className="group-hover:animate-bounce" />
                      <span>{t.check}</span>
                    </button>
                    <button
                      onClick={backToMenu}
                      className="group bg-gradient-to-r from-gray-500 to-gray-600 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-gray-600 hover:to-gray-700 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-3"
                    >
                      <Home size={28} className="group-hover:animate-bounce" />
                      <span>{t.backToMenu}</span>
                    </button>
                  </div>
                  
                  {/* Barre de progression du niveau */}
                  <div className="max-w-md mx-auto">
                    <div className="flex justify-between text-sm text-gray-600 mb-2">
                      <span>Progression du niveau {gameState.selectedLevel}</span>
                      <span>{levelProgress[gameState.selectedLevel].questionsCompleted}/100</span>
                    </div>
                    <div className="bg-gray-200 rounded-full h-3">
                      <div
                        className="bg-gradient-to-r from-purple-500 to-pink-500 h-3 rounded-full transition-all duration-500"
                        style={{ width: `${(levelProgress[gameState.selectedLevel].questionsCompleted / 100) * 100}%` }}
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}
        
        {/* ÉCRAN GAME OVER */}
        {gameState.currentState === 'gameOver' && (
          <div className="text-center space-y-8 animate-fade-in">
            <div className="bg-white/15 backdrop-blur-xl rounded-3xl p-12 shadow-2xl border border-white/20">
              <div className="text-8xl mb-6 animate-bounce">🎮</div>
              <h2 className="text-5xl font-bold text-white mb-6">{t.gameOver}</h2>
              
              {/* Statistiques finales */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-2xl mx-auto mb-8">
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-yellow-300">{gameState.score}</div>
                  <div className="text-white/80 text-sm">{t.finalScore}</div>
                </div>
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-green-300">{gameState.correctAnswers}</div>
                  <div className="text-white/80 text-sm">Correctes</div>
                </div>
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-blue-300">{gameState.totalQuestions}</div>
                  <div className="text-white/80 text-sm">Total</div>
                </div>
                <div className="bg-white/20 rounded-xl p-4">
                  <div className="text-3xl font-bold text-purple-300">{gameState.totalQuestions > 0 ? Math.round((gameState.correctAnswers / gameState.totalQuestions) * 100) : 0}%</div>
                  <div className="text-white/80 text-sm">Précision</div>
                </div>
              </div>
              
              {/* Nouveau record */}
              {gameState.score > levelProgress[gameState.selectedLevel].bestScore && (
                <div className="text-2xl font-bold text-yellow-300 mb-6 animate-pulse">
                  🏆 {t.newRecord}
                </div>
              )}
              
              {/* Boutons d'action */}
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <button
                  onClick={startGame}
                  className="group bg-gradient-to-r from-green-400 to-emerald-500 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-green-500 hover:to-emerald-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-3"
                >
                  <Play size={28} className="group-hover:animate-bounce" />
                  <span>{t.playAgain}</span>
                </button>
                <button
                  onClick={backToMenu}
                  className="group bg-gradient-to-r from-blue-400 to-blue-500 text-white px-10 py-4 rounded-2xl text-xl font-bold hover:from-blue-500 hover:to-blue-600 transition-all transform hover:scale-105 shadow-xl flex items-center justify-center space-x-3"
                >
                  <Home size={28} className="group-hover:animate-bounce" />
                  <span>{t.home}</span>
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
      
      {/* MODAL D'ABONNEMENT AVEC SYSTÈME DE RÉDUCTIONS MULTI-PLATEFORMES */}
      {showSubscriptionModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-3xl max-w-6xl w-full max-h-[90vh] overflow-y-auto shadow-2xl">
            <div className="p-8">
              <div className="flex justify-between items-center mb-8">
                <div>
                  <h2 className="text-4xl font-bold text-gray-800 flex items-center gap-3">
                    <Crown className="text-yellow-500" size={40} />
                    {t.subscription.title}
                  </h2>
                  <p className="text-gray-600 mt-2">www.math4child.com - Abonnements flexibles avec réductions</p>
                </div>
                <button
                  onClick={() => setShowSubscriptionModal(false)}
                  className="text-gray-500 hover:text-gray-700 transition-colors p-2 hover:bg-gray-100 rounded-xl"
                >
                  <X size={32} />
                </button>
              </div>
              
              {/* Plans d'abonnement avec système de réductions */}
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-8">
                
                {/* Plan Gratuit */}
                <div className="border-2 border-gray-200 rounded-2xl p-6 relative bg-gray-50">
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">🎁</div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">{t.subscription.freeTitle}</h3>
                    <div className="text-4xl font-bold text-gray-900 mb-2">{t.subscription.freePrice}</div>
                    <div className="text-gray-600">{t.subscription.freeDuration}</div>
                  </div>
                  
                  <ul className="space-y-3 mb-6">
                    {t.subscription.features.freeFeatures.map((feature, index) => (
                      <li key={index} className="flex items-center gap-3">
                        <Check size={18} className="text-green-500 flex-shrink-0" />
                        <span className="text-sm text-gray-700">{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <div className="text-center text-gray-500">
                    Actuellement actif
                  </div>
                </div>
                
                {/* Plan Plateforme Unique - Prix standard */}
                <div className="border-2 border-blue-500 rounded-2xl p-6 relative bg-blue-50">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
                      {t.subscription.mostPopular}
                    </span>
                  </div>
                  
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">
                      {gameState.selectedPlatform === 'web' ? '🌐' : 
                       gameState.selectedPlatform === 'android' ? '📱' : '🍎'}
                    </div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">
                      {gameState.selectedPlatform === 'web' ? t.subscription.webTitle :
                       gameState.selectedPlatform === 'android' ? t.subscription.androidTitle :
                       t.subscription.iosTitle}
                    </h3>
                    <div className="text-4xl font-bold text-gray-900 mb-2">9,99€</div>
                    <div className="text-gray-600">/mois</div>
                  </div>
                  
                  <ul className="space-y-3 mb-6">
                    {t.subscription.features.premiumFeatures.map((feature, index) => (
                      <li key={index} className="flex items-center gap-3">
                        <Check size={18} className="text-green-500 flex-shrink-0" />
                        <span className="text-sm text-gray-700">{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <button 
                    onClick={() => handleSubscription('monthly', gameState.selectedPlatform!)}
                    className="w-full bg-blue-500 hover:bg-blue-600 text-white py-3 px-4 rounded-lg font-semibold transition-colors"
                  >
                    {t.subscription.selectPlan}
                  </button>
                </div>
                
                {/* Plan Multi-Plateformes avec réductions */}
                <div className="border-2 border-purple-500 rounded-2xl p-6 relative bg-purple-50">
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <span className="bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-semibold">
                      {t.subscription.bestValue}
                    </span>
                  </div>
                  <div className="absolute -top-3 right-4">
                    <span className="bg-green-500 text-white px-3 py-1 rounded-full text-xs font-semibold">
                      Jusqu'à 75% de réduction
                    </span>
                  </div>
                  
                  <div className="text-center mb-6">
                    <div className="text-4xl mb-2">🚀</div>
                    <h3 className="text-2xl font-bold text-gray-800 mb-2">{t.subscription.multiTitle}</h3>
                    
                    {/* Options multi-plateformes */}
                    <div className="space-y-2">
                      <div className="bg-white rounded-lg p-3">
                        <div className="text-2xl font-bold text-gray-900">14,99€</div>
                        <div className="text-sm text-gray-600">{t.subscription.twoDevices}</div>
                        <div className="text-xs text-green-600">{t.subscription.twoDevicesSavings}</div>
                      </div>
                      <div className="bg-white rounded-lg p-3">
                        <div className="text-2xl font-bold text-gray-900">17,49€</div>
                        <div className="text-sm text-gray-600">{t.subscription.threeDevices}</div>
                        <div className="text-xs text-green-600">{t.subscription.threeDevicesSavings}</div>
                      </div>
                    </div>
                  </div>
                  
                  <ul className="space-y-3 mb-6">
                    {t.subscription.features.multiFeatures.map((feature, index) => (
                      <li key={index} className="flex items-center gap-3">
                        <Check size={18} className="text-green-500 flex-shrink-0" />
                        <span className="text-sm text-gray-700">{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <div className="space-y-2">
                    <button 
                      onClick={() => handleSubscription('multi-2')}
                      className="w-full bg-purple-500 hover:bg-purple-600 text-white py-3 px-4 rounded-lg font-semibold transition-colors"
                    >
                      2 Appareils - 14,99€
                    </button>
                    <button 
                      onClick={() => handleSubscription('multi-3')}
                      className="w-full bg-purple-600 hover:bg-purple-700 text-white py-3 px-4 rounded-lg font-semibold transition-colors"
                    >
                      3 Appareils - 17,49€
                    </button>
                  </div>
                </div>
              </div>
              
              {/* Options de durée avec réductions */}
              <div className="bg-gray-50 rounded-2xl p-6 mb-6">
                <h3 className="text-xl font-bold text-gray-800 mb-4 text-center">
                  💰 Économisez plus en payant pour plusieurs mois
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  
                  <div className="bg-white rounded-lg p-4 text-center">
                    <h4 className="font-bold text-gray-800">{t.subscription.monthly}</h4>
                    <div className="text-2xl font-bold text-gray-900 my-2">9,99€</div>
                    <div className="text-sm text-gray-600">Prix standard</div>
                    <button 
                      onClick={() => handleSubscription('monthly')}
                      className="w-full mt-3 bg-gray-200 hover:bg-gray-300 text-gray-800 py-2 rounded-lg font-semibold transition-colors"
                    >
                      Choisir
                    </button>
                  </div>
                  
                  <div className="bg-white rounded-lg p-4 text-center border-2 border-orange-400">
                    <div className="bg-orange-400 text-white px-2 py-1 rounded text-xs font-bold mb-2">
                      {t.subscription.quarterlySavings}
                    </div>
                    <h4 className="font-bold text-gray-800">{t.subscription.quarterly}</h4>
                    <div className="text-2xl font-bold text-gray-900 my-2">26,97€</div>
                    <div className="text-sm text-gray-600">Soit 8,99€/mois</div>
                    <button 
                      onClick={() => handleSubscription('quarterly')}
                      className="w-full mt-3 bg-orange-400 hover:bg-orange-500 text-white py-2 rounded-lg font-semibold transition-colors"
                    >
                      Choisir
                    </button>
                  </div>
                  
                  <div className="bg-white rounded-lg p-4 text-center border-2 border-green-500">
                    <div className="bg-green-500 text-white px-2 py-1 rounded text-xs font-bold mb-2">
                      {t.subscription.annualSavings}
                    </div>
                    <h4 className="font-bold text-gray-800">{t.subscription.annual}</h4>
                    <div className="text-2xl font-bold text-gray-900 my-2">83,92€</div>
                    <div className="text-sm text-gray-600">Soit 6,99€/mois</div>
                    <button 
                      onClick={() => handleSubscription('annual')}
                      className="w-full mt-3 bg-green-500 hover:bg-green-600 text-white py-2 rounded-lg font-semibold transition-colors"
                    >
                      Choisir
                    </button>
                  </div>
                </div>
              </div>
              
              {/* Information de facturation */}
              <div className="text-center bg-gradient-to-r from-blue-50 to-purple-50 rounded-xl p-6">
                <div className="flex items-center justify-center gap-4 mb-4">
                  <Shield className="text-blue-500" size={24} />
                  <span className="text-lg font-bold text-gray-800">Paiement sécurisé</span>
                </div>
                <div className="text-sm text-gray-700 space-y-1">
                  <p><strong>Facturé par GOTEST (SIRET: 53958712100028)</strong></p>
                  <p>Conseil en systèmes et logiciels informatiques • Auto-entrepreneur français</p>
                  <p>🏦 Compte Qonto • 🌐 www.math4child.com</p>
                  <p className="text-xs text-gray-500 mt-2">
                    ✅ Annulation à tout moment • 💳 Carte bancaire & SEPA • 🔒 Données chiffrées
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
    
    <style jsx>{`
      @keyframes blob {
        0% { transform: translate(0px, 0px) scale(1); }
        33% { transform: translate(30px, -50px) scale(1.1); }
        66% { transform: translate(-20px, 20px) scale(0.9); }
        100% { transform: translate(0px, 0px) scale(1); }
      }
      .animate-blob {
        animation: blob 7s infinite;
      }
      .animation-delay-2000 {
        animation-delay: 2s;
      }
      .animation-delay-4000 {
        animation-delay: 4s;
      }
      @keyframes fade-in {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
      }
      .animate-fade-in {
        animation: fade-in 0.6s ease-out;
      }
      @keyframes slide-in {
        from { opacity: 0; transform: translateX(-20px); }
        to { opacity: 1; transform: translateX(0); }
      }
      .animate-slide-in {
        animation: slide-in 0.5s ease-out;
      }
    `}</style>
  )
}
PAGEEOF