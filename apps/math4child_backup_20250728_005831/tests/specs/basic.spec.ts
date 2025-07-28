import { test, expect } from '@playwright/test';

test.describe('Math4Child - Tests basiques', () => {
  test('✅ Page d\'accueil se charge correctement', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/Math4Child/);
  });

  test('✅ Navigation fonctionne', async ({ page }) => {
    await page.goto('/');
    // Ajouter tests de navigation spécifiques
  });
});
