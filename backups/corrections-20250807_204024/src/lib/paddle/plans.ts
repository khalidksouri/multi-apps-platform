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
