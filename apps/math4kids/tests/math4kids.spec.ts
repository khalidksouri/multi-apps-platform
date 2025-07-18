import { test, expect } from '@playwright/test';

test.describe('Math4Kids Enhanced', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('should display the Math4Kids title', async ({ page }) => {
    await expect(page.locator('h1')).toContainText('Math4Kids');
  });

  test('should start a new game', async ({ page }) => {
    const startButton = page.getByRole('button', { name: /start/i });
    await expect(startButton).toBeVisible();
    await startButton.click();
    
    await expect(page.locator('text=🧮')).toBeVisible();
  });

  test('should change language', async ({ page }) => {
    // Cliquer sur le sélecteur de langue
    await page.getByRole('button', { name: /français/i }).click();
    
    // Sélectionner l'anglais
    await page.getByText('English').click();
    
    // Vérifier que l'interface a changé
    await expect(page.getByText('Start Game')).toBeVisible();
  });
});
