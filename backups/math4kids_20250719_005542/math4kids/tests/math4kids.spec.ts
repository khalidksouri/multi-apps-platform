import { test, expect } from '@playwright/test';

test.describe('Math4Kids Enhanced', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('should display the application', async ({ page }) => {
    await expect(page.getByRole('heading', { name: 'Math4Kids Enhanced' })).toBeVisible();
  });

  test('should be responsive', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await expect(page.getByRole('heading')).toBeVisible();
  });
});
