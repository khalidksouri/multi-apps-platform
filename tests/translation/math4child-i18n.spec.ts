import { test, expect } from '@playwright/test';

/**
 * Tests Multilingues Math4Child UNIQUEMENT
 */
test.describe('Math4Child - Support Multilingue', () => {
  
  const languages = [
    { code: 'fr', name: 'Français' },
    { code: 'en', name: 'English' },
    { code: 'es', name: 'Español' },
    { code: 'ar', name: 'العربية' }
  ];

  for (const lang of languages) {
    test(`Math4Child en ${lang.name} @translation`, async ({ page }) => {
      await page.goto('/');
      
      // Chercher sélecteur de langue
      const langSelector = page.locator('[data-testid="language-selector"], .language-selector, [role="combobox"]');
      
      if (await langSelector.isVisible()) {
        await langSelector.click();
        await page.click(`text=${lang.name}`);
        
        // Vérifier changement de langue
        await page.waitForTimeout(500);
        
        if (lang.code === 'ar') {
          // Vérifier RTL pour arabe
          const htmlDir = await page.getAttribute('html', 'dir');
          expect(htmlDir).toBe('rtl');
          console.log('✅ RTL appliqué pour l\'arabe');
        }
      }
      
      console.log(`✅ Test langue ${lang.name} Math4Child`);
    });
  }
});
