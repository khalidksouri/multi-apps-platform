'use client'

import { useState } from 'react'

export function useStripe() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const createCheckout = async (planId: string) => {
    setLoading(true)
    setError(null)

    try {
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ planId }),
      })

      const data = await response.json()
      if (data.url) {
        window.location.href = data.url
      }
    } catch (err) {
      setError('Erreur de paiement')
    } finally {
      setLoading(false)
    }
  }

  return { loading, error, createCheckout }
}
