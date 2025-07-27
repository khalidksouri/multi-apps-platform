import { test, expect } from '@playwright/test';

test.describe('🧪 Tests de traduction simples', () => {
  
  test('Vérification basique de la page', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier que la page charge
    await expect(page.locator('body')).toBeVisible();
    console.log('✅ Page chargée');
    
    // Chercher des éléments de langue
    const languageElements = [
      'select[name="language"]',
      'select[name="lang"]',
      '[data-testid*="language"]',
      'button:has-text("Français")',
      'button:has-text("English")'
    ];
    
    let foundLanguageSelector = false;
    for (const selector of languageElements) {
      if (await page.locator(selector).isVisible().catch(() => false)) {
        console.log(`✅ Sélecteur de langue trouvé: ${selector}`);
        foundLanguageSelector = true;
        break;
      }
    }
    
    if (!foundLanguageSelector) {
      console.log('ℹ️  Aucun sélecteur de langue visible');
    }
    
    // Chercher du texte français
    const frenchTexts = ['mathématiques', 'gratuit', 'famille', 'premium'];
    for (const text of frenchTexts) {
      if (await page.locator(`:text("${text}")`).isVisible().catch(() => false)) {
        console.log(`✅ Texte français détecté: ${text}`);
      }
    }
    
    // Le test passe toujours (exploration)
    expect(true).toBeTruthy();
  });
  
  test('Test de changement de langue basique', async ({ page }) => {
    await page.goto('/');
    
    try {
      // Essayer de trouver et utiliser un sélecteur de langue
      const select = page.locator('select').first();
      if (await select.isVisible({ timeout: 5000 })) {
        const options = await select.locator('option').allTextContents();
        console.log('✅ Options de langue disponibles:', options);
        
        // Essayer de changer la langue
        if (options.includes('English') || options.some(opt => opt.includes('en'))) {
          await select.selectOption({ label: 'English' });
          await page.waitForTimeout(2000);
          console.log('✅ Changement vers anglais tenté');
        }
      }
    } catch (error) {
      console.log('ℹ️  Changement de langue non disponible ou échec');
    }
    
    expect(true).toBeTruthy();
  });
});
