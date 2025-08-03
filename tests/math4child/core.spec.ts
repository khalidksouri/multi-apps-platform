import { test, expect } from '@playwright/test';

/**
 * Tests Math4Child Core - Application Principale
 * UNIQUEMENT Math4Child - Autres apps supprimées
 */
test.describe('Math4Child - Application Principale', () => {
  
  test('Math4Child se charge correctement @smoke', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier éléments Math4Child
    await expect(page.locator('h1')).toContainText(/Math4Child|Mathématiques/i);
    
    console.log('✅ Math4Child chargé avec succès');
  });

  test('Navigation Math4Child fonctionnelle @critical', async ({ page }) => {
    await page.goto('/');
    
    // Interface Math4Child spécifique
    const elements = await page.locator('*').allTextContents();
    const hasOnlyMath4Child = !elements.some(text => 
      /postmath|unitflip|budgetcron|ai4kids|multiai/i.test(text)
    );
    
    expect(hasOnlyMath4Child).toBeTruthy();
    console.log('✅ Aucune autre application détectée');
  });

  test('Jeu mathématique disponible @game', async ({ page }) => {
    await page.goto('/');
    
    // Chercher éléments de jeu mathématique
    const gameElements = [
      'niveau', 'addition', 'soustraction', 'multiplication', 'division',
      'exercice', 'question', 'réponse', 'score', 'progression'
    ];
    
    let foundGameElements = 0;
    for (const element of gameElements) {
      const found = await page.locator(`text=${element}`).count() > 0;
      if (found) foundGameElements++;
    }
    
    expect(foundGameElements).toBeGreaterThan(0);
    console.log(`✅ ${foundGameElements} éléments de jeu détectés`);
  });
});
