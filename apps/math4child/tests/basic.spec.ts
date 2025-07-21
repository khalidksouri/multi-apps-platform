import { test, expect } from '@playwright/test';

test.describe('Math4Child - Tests de Base', () => {
  
  test('Page principale se charge', async ({ page }) => {
    await page.goto('/');
    await expect(page.locator('h1')).toBeVisible();
    await expect(page.locator('text=Math4Child')).toBeVisible();
  });
  
  test('Navigation fonctionne', async ({ page }) => {
    await page.goto('/');
    
    // Test essai gratuit
    await page.click('text=🎁 Essai Gratuit');
    await expect(page.locator('text=Version Web')).toBeVisible();
  });
  
  test('Pas d\'erreurs critiques', async ({ page }) => {
    const errors: string[] = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Filtrer erreurs acceptables
    const criticalErrors = errors.filter(error => 
      !error.includes('favicon') &&
      !error.includes('Extension')
    );
    
    expect(criticalErrors).toHaveLength(0);
  });
});
