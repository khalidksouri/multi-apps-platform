// ===================================================================
// TESTS DE PERFORMANCE MATH4CHILD
// Tests de base pour la performance
// ===================================================================

import { test, expect } from '../utils/test-fixtures';

test.describe('Math4Child - Performance', () => {

  test('Temps de chargement initial acceptable @performance', async ({ page }) => {
    const { Math4ChildTestHelper } = await import('../utils/test-utils');
    const loadTime = await new Math4ChildTestHelper(page).measurePageLoadTime();
    
    // Moins de 5 secondes en développement, 3 secondes en production
    const maxLoadTime = process.env.NODE_ENV === 'production' ? 3000 : 5000;
    expect(loadTime).toBeLessThan(maxLoadTime);
  });

  test('Changement de langue fluide @performance', async ({ math4childApp }) => {
    const startTime = Date.now();
    await math4childApp.selectLanguage('fr');
    const switchTime = Date.now() - startTime;
    
    expect(switchTime).toBeLessThan(2000); // Changement rapide
  });

  test('Navigation entre vues fluide @performance', async ({ math4childApp }) => {
    // Tester navigation accueil -> jeu -> abonnement -> accueil
    await math4childApp.startGame('beginner', 'addition');
    await math4childApp.page.locator('button:has-text("Back"), button:has-text("Retour")').first().click();
    await math4childApp.navigateToSubscription();
    await math4childApp.page.locator('button:has-text("Back"), button:has-text("Retour")').first().click();
    
    // Vérifier qu'on est revenu à l'accueil
    await expect(math4childApp.page.locator('h1')).toContainText(/Math4Child/i);
  });

});
