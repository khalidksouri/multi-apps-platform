const { test, expect } = require('@playwright/test');

test.describe('Math4Kids Basic Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
  });

  test('loads correctly', async ({ page }) => {
    await expect(page.locator('h1')).toContainText('Math4Kids');
    await expect(page.locator('input[type="number"]')).toBeVisible();
    await expect(page.getByText('Validate')).toBeVisible();
  });

  test('can change language to French', async ({ page }) => {
    await page.selectOption('select', 'fr');
    await expect(page.locator('text=Question')).toBeVisible();
    await expect(page.getByText('Valider')).toBeVisible();
  });

  test('can input answer and submit', async ({ page }) => {
    await page.fill('input[type="number"]', '5');
    await page.click('text=Validate');
    
    await expect(page.locator('text=/Excellent|Oops/i')).toBeVisible({ timeout: 5000 });
  });
});
