// =============================================================================
// 💳 API CHECKOUT - PAGES ROUTER [CORRIGÉ]
// =============================================================================

import { NextApiRequest, NextApiResponse } from 'next'
import { stripe, getPlanById, DEMO_MODE, formatPrice } from '@/lib/stripe'
import { CheckoutSessionRequest, CheckoutSessionResponse } from '@/types/stripe'

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse<CheckoutSessionResponse>
) {
  // Seule méthode POST autorisée
  if (req.method !== 'POST') {
    return res.status(405).json({
      success: false,
      error: 'Seule la méthode POST est autorisée'
    })
  }

  try {
    // Validation et parsing sécurisé du body
    let body: CheckoutSessionRequest
    if (typeof req.body === 'string') {
      try {
        body = JSON.parse(req.body)
      } catch (parseError) {
        return res.status(400).json({
          success: false,
          error: 'JSON invalide dans la requête'
        })
      }
    } else if (typeof req.body === 'object') {
      body = req.body
    } else {
      return res.status(400).json({
        success: false,
        error: 'Corps de requête invalide'
      })
    }

    const { planId, email, successUrl, cancelUrl, metadata } = body

    console.log(`[PAGES] Demande checkout pour plan: ${planId}`)

    // Validation du planId
    if (!planId || typeof planId !== 'string') {
      return res.status(400).json({
        success: false,
        error: 'planId requis et doit être une chaîne de caractères'
      })
    }

    // Validation du plan
    const plan = getPlanById(planId)
    if (!plan) {
      console.error(`[PAGES] Plan non trouvé: ${planId}`)
      return res.status(400).json({
        success: false,
        error: `Plan "${planId}" non trouvé`
      })
    }

    // URLs par défaut
    const protocol = req.headers['x-forwarded-proto'] || 'http'
    const host = req.headers.host
    const origin = `${protocol}://${host}`
    const defaultSuccessUrl = successUrl || `${origin}/success?session_id={CHECKOUT_SESSION_ID}`
    const defaultCancelUrl = cancelUrl || `${origin}/pricing`

    console.log(`[PAGES] Plan sélectionné: ${plan.name} - ${formatPrice(plan.price, plan.currency)}`)

    // Mode démo
    if (DEMO_MODE) {
      console.log(`[DEMO] Simulation checkout Pages Router`)
      return res.status(200).json({
        success: true,
        sessionId: `demo_pages_${planId}_${Date.now()}`,
        url: `${origin}/demo-success?plan=${planId}&amount=${plan.price}&name=${encodeURIComponent(plan.name)}`,
        demoMode: true
      })
    }

    // Mode production - Stripe réel
    console.log('[STRIPE] Création session via Pages Router...')

    const sessionParams: any = {
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: plan.currency,
            product_data: {
              name: `Math4Child ${plan.name}`,
              description: plan.description,
            },
            unit_amount: plan.price,
            recurring: { interval: plan.interval },
          },
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: defaultSuccessUrl,
      cancel_url: defaultCancelUrl,
      metadata: {
        planId: planId,
        profiles: plan.profiles.toString(),
        source: 'math4child-pages',
        ...metadata
      }
    }

    // Ajouter email si fourni
    if (email && typeof email === 'string') {
      sessionParams.customer_email = email
    }

    const session = await stripe.checkout.sessions.create(sessionParams)

    console.log(`[PAGES] Session créée: ${session.id}`)

    res.status(200).json({
      success: true,
      sessionId: session.id,
      url: session.url || defaultSuccessUrl
    })

  } catch (error) {
    console.error('[PAGES] Erreur:', error)
    res.status(500).json({
      success: false,
      error: error instanceof Error ? error.message : 'Erreur serveur'
    })
  }
}
