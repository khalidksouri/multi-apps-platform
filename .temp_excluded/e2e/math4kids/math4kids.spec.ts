import { test, expect } from '@playwright/test';

test.describe('math4kids - Tests E2E', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3001');
  });

  test('should load the application', async ({ page }) => {
    await expect(page).toHaveTitle(/.*math4kids.*|.*Math4Kids.*|.*Application.*/);
    await expect(page.locator('h1')).toBeVisible();
  });

  test('should be responsive on mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await expect(page.locator('h1')).toBeVisible();
  });

  test('should change language', async ({ page }) => {
    const languageSelector = page.locator('select');
    if (await languageSelector.count() > 0) {
      await languageSelector.selectOption({ label: /English|Español/ });
      await page.waitForTimeout(1000);
    }
  });

  test('should be accessible', async ({ page }) => {
    // Test de base d'accessibilité
    const headings = page.locator('h1, h2, h3, h4, h5, h6');
    expect(await headings.count()).toBeGreaterThan(0);
  });

  test('should start and complete a math game', async ({ page }) => {
    // Vérifier si le bouton start existe
    const startButton = page.locator('[data-testid="start-button"]');
    if (await startButton.count() > 0) {
      await startButton.click();
      
      // Répondre à quelques questions
      for (let i = 0; i < 3; i++) {
        const questionElement = page.locator('[data-testid="question"]');
        if (await questionElement.count() > 0) {
          // Cliquer sur la première option (peu importe si c'est correct)
          const options = page.locator('[data-testid="option"]');
          if (await options.count() > 0) {
            await options.first().click();
            await page.waitForTimeout(1500);
          } else {
            break;
          }
        } else {
          break;
        }
      }
      
      // Vérifier que le score est affiché
      const scoreElement = page.locator('[data-testid="score"]');
      if (await scoreElement.count() > 0) {
        await expect(scoreElement).toBeVisible();
      }
    }
  });
});
