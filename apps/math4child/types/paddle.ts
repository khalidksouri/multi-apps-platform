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
