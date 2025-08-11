import { test, expect } from '@playwright/test';

test.describe('Math4Child - Plans d\'abonnement optimaux', () => {
  
  test('Vérifie la présence des 4 plans optimaux', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier la présence des plans par leur nom
    await expect(page.locator('text=/gratuit|famille|premium|école/i')).toHaveCount(4, { timeout: 10000 });
    
    // Vérifier les prix spécifiques des plans optimaux
    await expect(page.locator('text=/6\.99€|4\.99€|24\.99€/').first()).toBeVisible();
    
    // Vérifier les économies affichées
    await expect(page.locator('text=/économisez|économies/i').first()).toBeVisible();
  });

  test('Teste les sélecteurs de période (mensuel, trimestriel, annuel)', async ({ page }) => {
    await page.goto('/');
    
    // Chercher les boutons de période
    const monthlyButton = page.locator('button').filter({ hasText: /mensuel|monthly/i }).first();
    const quarterlyButton = page.locator('button').filter({ hasText: /trimestriel|quarterly/i }).first();
    const annualButton = page.locator('button').filter({ hasText: /annuel|annual/i }).first();
    
    // Test changement vers trimestriel
    if (await quarterlyButton.isVisible()) {
      await quarterlyButton.click();
      await expect(page.locator('text=/18\.87€|13\.47€|67\.47€/').first()).toBeVisible({ timeout: 5000 });
    }
    
    // Test changement vers annuel
    if (await annualButton.isVisible()) {
      await annualButton.click();
      await expect(page.locator('text=/58\.32€|41\.94€|209\.93€/').first()).toBeVisible({ timeout: 5000 });
    }
  });

  test('Vérifie les fonctionnalités du plan Famille (populaire)', async ({ page }) => {
    await page.goto('/');
    
    // Chercher le plan famille
    const familyPlan = page.locator('[data-plan="famille"], [data-testid="plan-famille"]').first();
    
    if (await familyPlan.isVisible()) {
      // Vérifier les fonctionnalités spécifiques du plan famille
      await expect(familyPlan.locator('text=/5 profils enfants/i')).toBeVisible();
      await expect(familyPlan.locator('text=/tous les niveaux/i')).toBeVisible();
      await expect(familyPlan.locator('text=/exercices illimités/i')).toBeVisible();
      
      // Vérifier le badge "populaire" ou "recommandé"
      await expect(familyPlan.locator('text=/populaire|recommandé|popular/i')).toBeVisible();
    }
  });

  test('Teste la fonctionnalité de sélection de plan', async ({ page }) => {
    await page.goto('/');
    
    // Mock des appels API pour éviter les vrais paiements
    await page.route('/api/payments/create-checkout', route => {
      route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          success: true,
          checkoutUrl: 'https://checkout.test.com/session',
          planId: 'famille'
        })
      });
    });
    
    // Cliquer sur le bouton du plan famille
    const familyButton = page.locator('button').filter({ 
      hasText: /choisir ce plan|choisir|essai/i 
    }).first();
    
    if (await familyButton.isVisible()) {
      await familyButton.click();
      
      // Vérifier qu'une action s'est produite (redirection ou modal)
      await page.waitForTimeout(1000);
      
      // Vérifier soit une redirection, soit l'ouverture d'une modal
      const hasModal = await page.locator('[role="dialog"], .modal, [data-testid="checkout-modal"]').isVisible();
      const currentUrl = page.url();
      
      expect(hasModal || currentUrl.includes('/checkout') || currentUrl.includes('/payment')).toBeTruthy();
    }
  });
});
