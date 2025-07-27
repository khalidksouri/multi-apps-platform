import { PricingPlan } from '@/types/pricing';
import { OPTIMAL_PRICING_PLANS } from '@/lib/constants';

export class PricingPageHelper {
  constructor(private page: any) {}
  
  async selectPlan(planId: string, period: 'monthly' | 'quarterly' | 'annual' = 'monthly') {
    // Sélectionner la période
    const periodButton = this.page.locator('button').filter({ 
      hasText: new RegExp(period === 'monthly' ? 'mensuel' : period === 'quarterly' ? 'trimestriel' : 'annuel', 'i') 
    });
    
    if (await periodButton.isVisible()) {
      await periodButton.click();
      await this.page.waitForTimeout(500);
    }
    
    // Sélectionner le plan
    const planButton = this.page.locator(`[data-plan="${planId}"] button, [data-testid="plan-${planId}"] button`).first();
    
    if (await planButton.isVisible()) {
      await planButton.click();
    } else {
      // Fallback: chercher par texte du bouton
      const fallbackButton = this.page.locator('button').filter({ 
        hasText: /choisir ce plan|essai gratuit/i 
      }).first();
      await fallbackButton.click();
    }
  }
  
  async getPlanPrice(planId: string): Promise<number> {
    const planElement = this.page.locator(`[data-plan="${planId}"], [data-testid="plan-${planId}"]`).first();
    const priceText = await planElement.locator('.price, [data-testid="price"]').textContent();
    const match = priceText?.match(/(\d+\.?\d*)€/);
    return match ? parseFloat(match[1]) : 0;
  }
  
  async verifyPlanFeatures(planId: string, expectedFeatures: string[]) {
    const planElement = this.page.locator(`[data-plan="${planId}"], [data-testid="plan-${planId}"]`).first();
    
    for (const feature of expectedFeatures) {
      await expect(planElement.locator(`text=${feature}`)).toBeVisible();
    }
  }
}

// Fonctions utilitaires pour le pricing
export const calculateSavings = (monthlyPrice: number, periodPrice: number, months: number): number => {
  const totalMonthlyPrice = monthlyPrice * months;
  return Math.round(((totalMonthlyPrice - periodPrice) / totalMonthlyPrice) * 100);
};

export const formatPrice = (price: number, currency: string = '€'): string => {
  return `${price.toFixed(2)}${currency}`;
};

export const getPeriodMultiplier = (period: 'monthly' | 'quarterly' | 'annual'): number => {
  switch (period) {
    case 'monthly': return 1;
    case 'quarterly': return 3;
    case 'annual': return 12;
    default: return 1;
  }
};
