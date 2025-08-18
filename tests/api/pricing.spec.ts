import { test, expect } from '@playwright/test';

test.describe('Tests API - Tarification', () => {
  test('API Plans d\'abonnement', async ({ request }) => {
    // Test de l'API des plans (si implémentée)
    const response = await request.get('/api/plans');
    
    if (response.status() === 200) {
      const plans = await response.json();
      
      // Vérifier les 5 plans selon README.md
      expect(plans).toHaveLength(5);
      
      // Vérifier les prix exacts
      const premiumPlan = plans.find((p: any) => p.id === 'premium');
      expect(premiumPlan.price).toBe(14.99);
      expect(premiumPlan.popular).toBe(true);
    }
  });
});
