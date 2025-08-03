import { test, expect } from '@playwright/test';

/**
 * Tests RTL Math4Child UNIQUEMENT
 */
test.describe('Math4Child - Support RTL', () => {
  
  test('Interface RTL Math4Child @rtl', async ({ page }) => {
    await page.goto('/');
    
    // Chercher et activer arabe
    const langSelector = page.locator('[data-testid="language-selector"], .language-selector');
    
    if (await langSelector.isVisible()) {
      await langSelector.click();
      await page.click('text=العربية');
      
      // Vérifier RTL
      await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
      
      console.log('✅ RTL Math4Child fonctionnel');
    } else {
      console.log('⚠️ Sélecteur de langue non trouvé');
    }
  });
});
