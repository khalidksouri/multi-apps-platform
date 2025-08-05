// Analytics pour Math4Child - GOTEST
export const analytics = {
  // Track conversion funnel
  trackFunnelStep: (step: string, plan?: string) => {
    if (typeof window !== 'undefined' && window.gtag) {
      window.gtag('event', 'funnel_step', {
        step_name: step,
        subscription_plan: plan,
        company: 'GOTEST'
      })
    }
  },

  // Track math game events
  trackMathGame: (level: number, operation: string, correct: boolean) => {
    if (typeof window !== 'undefined' && window.gtag) {
      window.gtag('event', 'math_question', {
        level: level,
        operation: operation,
        correct: correct,
        app_name: 'Math4Child'
      })
    }
  },

  // Track language changes
  trackLanguageChange: (from: string, to: string) => {
    if (typeof window !== 'undefined' && window.gtag) {
      window.gtag('event', 'language_change', {
        previous_language: from,
        new_language: to,
        feature: 'multilingual'
      })
    }
  },

  // Track subscription events
  trackSubscriptionStart: (plan: string) => {
    if (typeof window !== 'undefined' && window.gtag) {
      window.gtag('event', 'begin_checkout', {
        currency: 'EUR',
        value: plan === 'monthly' ? 9.99 : plan === 'quarterly' ? 26.97 : 83.93,
        items: [{
          item_id: plan,
          item_name: `Math4Child ${plan}`,
          category: 'Subscription',
          price: plan === 'monthly' ? 9.99 : plan === 'quarterly' ? 26.97 : 83.93
        }]
      })
    }
  }
}
