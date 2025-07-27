import { test, expect } from '@playwright/test';

test.describe('Parcours utilisateur complet', () => {
  
  test('🎯 Parcours découverte → sélection plan', async ({ page }) => {
    // 1. Arrivée sur la page d'accueil
    await page.goto('/');
    await expect(page.locator('text=Math pour enfants')).toBeVisible();
    
    // 2. Exploration des fonctionnalités
    const featureCards = page.locator('.group.relative.bg-white.rounded-2xl');
    await featureCards.first().hover();
    
    // 3. Changement de langue
    await page.click('button[aria-label="Sélectionner une langue"]');
    await page.click('button:has-text("English")');
    
    // 4. Consultation des prix
    await page.click('button:has-text("View pricing")');
    
    // 5. Comparaison des plans
    await page.click('button:has-text("Annual")');
    await expect(page.locator('text=6.99€')).toBeVisible();
    
    // 6. Sélection du plan Premium
    const premiumCard = page.locator('.border-purple-500');
    await expect(premiumCard).toBeVisible();
    await premiumCard.locator('button').click();
    
    // 7. Vérification que le modal se ferme
    await expect(page.locator('text=Choose your plan')).not.toBeVisible();
  });
});
