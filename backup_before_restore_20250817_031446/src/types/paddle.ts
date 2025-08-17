// Types pour le système de paiement Paddle selon spécifications Math4Child

export interface PaddlePlan {
  id: string;
  name: string;
  price: number;
  amount: number; // Prix en centimes
  profiles: number;
  currency: string;
  features: string[];
  popular?: boolean;
  badge?: string;
  priceId: string; // ID Paddle
  interval: IntervalType;
  trialDays: number;
}

export type IntervalType = 'monthly' | 'quarterly' | 'yearly';

export interface PricingComponentProps {
  plans: PaddlePlan[];
  selectedInterval: IntervalType;
  onIntervalChange: (interval: IntervalType) => void;
  onPlanSelect: (planId: string) => void;
}

export interface CheckoutResponse {
  success: boolean;
  checkoutUrl?: string;
  error?: string;
  provider?: string;
}
