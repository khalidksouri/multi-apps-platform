import { test, expect } from '@playwright/test';

test.describe('Math4Child - Tests de base', () => {
  
  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier le titre Math4Child
    await expect(page.locator('h1')).toContainText(/Math4Child/i);
    
    // Vérifier les statistiques
    await expect(page.locator(':text("10K+")')).toBeVisible();
    await expect(page.locator(':text("500+")')).toBeVisible();
    await expect(page.locator(':text("20")')).toBeVisible();
    await expect(page.locator(':text("98%")')).toBeVisible();
  });
  
  test('Changement de langue vers le français @i18n', async ({ page }) => {
    await page.goto('/');
    
    // Ouvrir le sélecteur de langues
    await page.click('button:has-text("English")');
    
    // Cliquer sur Français
    await page.click('button:has-text("Français")');
    
    // Vérifier la traduction
    await expect(page.locator('body')).toContainText(/mathématiques|français/i);
  });
  
  test('Navigation vers les niveaux', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier la présence des 5 niveaux
    await expect(page.locator(':text("Beginner")')).toBeVisible();
    await expect(page.locator(':text("Elementary")')).toBeVisible();
    await expect(page.locator(':text("Intermediate")')).toBeVisible();
    await expect(page.locator(':text("Advanced")')).toBeVisible();
    await expect(page.locator(':text("Expert")')).toBeVisible();
  });

  test('Boutons Call-to-Action visibles', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.locator('button:has-text("Subscribe Now")')).toBeVisible();
    await expect(page.locator('button:has-text("Free Trial")')).toBeVisible();
  });

});
