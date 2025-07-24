import { test, expect } from '@playwright/test';

test.describe('Vérification suppression mentions France', () => {
  
  const languages = [
    { code: 'es', mention: '' },
    { code: 'ar', mention: '' },
    { code: 'en', mention: '' },
    { code: 'fr', mention: '' },
    { code: 'de', mention: '' },
    { code: 'it', mention: '' }
  ];

  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  for (const lang of languages) {
    test(`Vérifier ${lang.code} - pas de "${lang.mention}"`, async ({ page }) => {
      // Changer de langue
      try {
        await page.click('[data-testid="language-dropdown-button"]');
        await page.waitForTimeout(500);
        await page.click(`[data-testid="language-option-${lang.code}"]`);
        await page.waitForTimeout(1500);
      } catch (error) {
        console.log(`⚠️ Impossible de changer vers ${lang.code}`);
      }

      // Vérifier qu'aucune mention n'apparaît
      const pageContent = await page.textContent('body');
      
      if (pageContent && pageContent.includes(lang.mention)) {
        console.log(`❌ TROUVÉ "${lang.mention}" en ${lang.code}`);
        await page.screenshot({ 
          path: `test-results/france-mention-${lang.code}.png`,
          fullPage: true 
        });
      } else {
        console.log(`✅ Aucune mention "${lang.mention}" en ${lang.code}`);
      }
      
      expect(pageContent).not.toContain(lang.mention);
    });
  }
});
