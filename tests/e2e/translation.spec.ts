import { test, expect } from '@playwright/test';

test.describe('Tests de traduction en temps réel', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('Changement de langue français vers anglais', async ({ page }) => {
    // Vérifier français par défaut
    await expect(page.locator('text=Commencer l\'Apprentissage')).toBeVisible();
    
    // Changer vers anglais
    await page.click('button:has-text("Français")');
    await page.click('text=English');
    
    // Vérifier la traduction
    await expect(page.locator('text=Start Learning')).toBeVisible();
    await expect(page.locator('text=Global Educational Revolution')).toBeVisible();
  });

  test('Support RTL pour l\'arabe', async ({ page }) => {
    // Changer vers arabe
    await page.click('button:has-text("Français")');
    await page.click('text=🇲🇦');
    
    // Vérifier RTL
    const body = page.locator('body');
    await expect(body).toHaveClass(/rtl/);
  });

  test('Drapeaux spécifiques selon README.md', async ({ page }) => {
    await page.click('button:has-text("Français")');
    
    // Vérifier drapeau marocain pour l'arabe Afrique
    await expect(page.locator('text=🇲🇦')).toBeVisible();
    
    // Vérifier drapeau palestinien pour l'arabe Moyen-Orient
    await expect(page.locator('text=🇵🇸')).toBeVisible();
  });
});
