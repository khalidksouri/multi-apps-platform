// =============================================================================
// 🎣 HOOK STRIPE - MATH4CHILD v4.2.0
// =============================================================================

'use client'

import { useState, useCallback } from 'react'
import { CheckoutSessionRequest, CheckoutSessionResponse, Math4ChildPlan } from '@/types/stripe'
import { MATH4CHILD_PLANS } from '@/lib/stripe'

interface UseStripeReturn {
  loading: boolean
  error: string | null
  success: boolean
  createCheckout: (request: CheckoutSessionRequest) => Promise<CheckoutSessionResponse | null>
  createCheckoutForPlan: (planId: string, email?: string) => Promise<CheckoutSessionResponse | null>
  clearError: () => void
  clearSuccess: () => void
}

export function useStripe(): UseStripeReturn {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  const createCheckout = useCallback(async (request: CheckoutSessionRequest): Promise<CheckoutSessionResponse | null> => {
    setLoading(true)
    setError(null)
    setSuccess(false)

    try {
      console.log('🛒 [HOOK] Création checkout pour plan:', request.planId)

      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(request),
      })

      const data: CheckoutSessionResponse = await response.json()

      if (!response.ok) {
        throw new Error(data.error || `Erreur HTTP ${response.status}`)
      }

      if (!data.success) {
        throw new Error(data.error || 'Erreur inconnue')
      }

      console.log('✅ [HOOK] Checkout créé:', data.sessionId)

      // Redirection automatique si URL fournie
      if (data.url) {
        if (data.demoMode) {
          console.log('🧪 [HOOK] Redirection démo vers:', data.url)
        } else {
          console.log('💳 [HOOK] Redirection Stripe vers:', data.url)
        }
        
        window.location.href = data.url
      }

      setSuccess(true)
      return data

    } catch (err) {
      const message = err instanceof Error ? err.message : 'Erreur de réseau'
      console.error('💥 [HOOK] Erreur checkout:', message)
      setError(message)
      return null

    } finally {
      setLoading(false)
    }
  }, [])

  const createCheckoutForPlan = useCallback(async (planId: string, email?: string) => {
    return createCheckout({ planId, email })
  }, [createCheckout])

  const clearError = useCallback(() => {
    setError(null)
  }, [])

  const clearSuccess = useCallback(() => {
    setSuccess(false)
  }, [])

  return {
    loading,
    error,
    success,
    createCheckout,
    createCheckoutForPlan,
    clearError,
    clearSuccess
  }
}

// Hook pour les informations des plans
export function usePlans() {
  const [plans] = useState<Math4ChildPlan[]>(MATH4CHILD_PLANS)

  const getPlan = useCallback((planId: string) => {
    return plans.find(plan => plan.id === planId)
  }, [plans])

  const getPopularPlan = useCallback(() => {
    return plans.find(plan => plan.popular === true)
  }, [plans])

  const getPlansByProfileCount = useCallback((minProfiles: number) => {
    return plans.filter(plan => plan.profiles >= minProfiles)
  }, [plans])

  return {
    plans,
    getPlan,
    getPopularPlan,
    getPlansByProfileCount
  }
}

// Hook pour les statistiques
export function useStripeStats() {
  const [stats, setStats] = useState({
    totalCheckouts: 0,
    successfulCheckouts: 0,
    failedCheckouts: 0,
    mostPopularPlan: 'premium'
  })

  const recordCheckoutAttempt = useCallback(() => {
    setStats(prev => ({
      ...prev,
      totalCheckouts: prev.totalCheckouts + 1
    }))
  }, [])

  const recordCheckoutSuccess = useCallback(() => {
    setStats(prev => ({
      ...prev,
      successfulCheckouts: prev.successfulCheckouts + 1
    }))
  }, [])

  const recordCheckoutFailure = useCallback(() => {
    setStats(prev => ({
      ...prev,
      failedCheckouts: prev.failedCheckouts + 1
    }))
  }, [])

  return {
    stats,
    recordCheckoutAttempt,
    recordCheckoutSuccess,
    recordCheckoutFailure
  }
}
