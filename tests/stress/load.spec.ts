import { test, expect } from '@playwright/test';

test.describe('Tests de stress et performance', () => {
  test('Changements de langue rapides - Stress test', async ({ page }) => {
    await page.goto('/');
    
    // Effectuer 20 changements de langue rapides
    for (let i = 0; i < 20; i++) {
      await page.click('button:has-text("Français")');
      await page.click('text=English');
      await page.click('button:has-text("English")');
      await page.click('text=Français');
    }
    
    // Vérifier que l'application reste stable
    await expect(page.locator('text=Math4Child')).toBeVisible();
  });

  test('Navigation intensive entre sections', async ({ page }) => {
    await page.goto('/');
    
    // Navigation intensive
    for (let i = 0; i < 10; i++) {
      await page.hover('text=Fonctionnalités Révolutionnaires');
      await page.hover('text=Système de Progression');
      await page.hover('text=Tarification');
      await page.hover('text=Contact');
    }
    
    await expect(page.locator('text=Math4Child')).toBeVisible();
  });
});
