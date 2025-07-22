// =============================================================================
// 💳 CONFIGURATION STRIPE MATH4CHILD
// =============================================================================

import Stripe from 'stripe'

// Configuration Stripe avec version API compatible
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || 'sk_test_default', {
  apiVersion: '2024-06-20', // Version API compatible
  typescript: true,
})

export default stripe
