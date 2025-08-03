import { test, expect } from '@playwright/test';

/**
 * Tests E2E Complet Math4Child
 */
test.describe('Math4Child - Tests Complets E2E', () => {
  
  test('Parcours utilisateur complet @e2e', async ({ page }) => {
    await page.goto('/');
    
    // 1. Vérifier chargement
    await expect(page.locator('h1')).toBeVisible();
    
    // 2. Chercher boutons d'action
    const actionButtons = [
      'Commencer', 'Essai', 'Gratuit', 'Jouer', 'Niveau',
      'Premium', 'Démarrer', 'Start', 'Begin'
    ];
    
    let buttonFound = false;
    for (const buttonText of actionButtons) {
      const button = page.locator(`text=${buttonText}`);
      if (await button.isVisible()) {
        await button.click();
        buttonFound = true;
        console.log(`✅ Bouton "${buttonText}" trouvé et cliqué`);
        break;
      }
    }
    
    if (!buttonFound) {
      console.log('⚠️ Aucun bouton d\'action trouvé');
    }
    
    // 3. Vérifier que nous sommes toujours sur Math4Child
    const pageContent = await page.textContent('body');
    const hasOtherApps = /postmath|unitflip|budgetcron|ai4kids|multiai/i.test(pageContent);
    
    expect(hasOtherApps).toBeFalsy();
    console.log('✅ Aucune autre application détectée dans le parcours');
  });
});
