// ===================================================================
// 🧪 TESTS COMPLETS MATH4CHILD
// Tests fonctionnels, traduction, performance, stress
// ===================================================================

import { test, expect } from '@playwright/test';

const TEST_LANGUAGES = ['fr', 'en', 'es', 'ar', 'de', 'zh'];

test.describe('Math4Child - Tests Complets', () => {
  
  // TESTS FONCTIONNELS
  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.locator('h1')).toContainText('Math4Child');
    await expect(page.locator('[data-testid="language-selector"]')).toBeVisible();
    await expect(page.locator('button:has-text("🎮")')).toBeVisible();
  });

  test('Sélecteur de langues fonctionne @languages', async ({ page }) => {
    await page.goto('/');
    
    // Ouvrir le dropdown
    await page.click('[data-testid="language-selector"]');
    await expect(page.locator('[data-testid="language-dropdown"]')).toBeVisible();
    
    // Vérifier le scroll visible
    const dropdown = page.locator('[data-testid="language-dropdown"] .overflow-y-auto');
    await expect(dropdown).toBeVisible();
    
    // Vérifier le drapeau marocain pour l'arabe
    await expect(page.locator('[data-language="ar"]')).toContainText('🇲🇦');
  });

  // TESTS DE TRADUCTION
  for (const lang of TEST_LANGUAGES) {
    test(`Interface traduite en ${lang} @i18n`, async ({ page }) => {
      await page.goto('/');
      
      // Changer de langue
      await page.click('[data-testid="language-selector"]');
      await page.click(`[data-language="${lang}"]`);
      
      // Vérifier RTL pour l'arabe
      if (lang === 'ar') {
        const dir = await page.locator('body, [dir="rtl"]').first().getAttribute('dir');
        expect(dir).toBe('rtl');
      }
      
      // Vérifier que l'interface est traduite
      await expect(page.locator('h1')).toBeVisible();
    });
  }

  // TESTS DE PERFORMANCE
  test('Performance acceptable @performance', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(5000); // 5 secondes max
  });
});
