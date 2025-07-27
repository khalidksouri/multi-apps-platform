export interface PricingPlan {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  savings?: string;
  period: 'monthly' | 'quarterly' | 'annual';
  profiles: number;
  features: string[];
  button: string;
  color: string;
  popular?: boolean;
  freeTrial?: string;
}

export interface PlanSelection {
  planId: string;
  period: 'monthly' | 'quarterly' | 'annual';
  price: number;
}
