import { test, expect } from '@playwright/test';

test.describe('Math4Child - Corrections Appliquées', () => {
  
  test('Vérifie que chaque langue n\'apparaît qu\'une seule fois', async ({ page }) => {
    await page.goto('/');
    
    await page.click('[data-testid="language-selector"]');
    
    const languageElements = await page.locator('[data-testid="language-option"]').all();
    const languageCodes = [];
    
    for (const element of languageElements) {
      const code = await element.getAttribute('data-language-code');
      languageCodes.push(code);
    }
    
    const uniqueLanguages = [...new Set(languageCodes)];
    expect(uniqueLanguages.length).toBe(languageCodes.length);
    
    const expectedLanguages = ['fr', 'en', 'es', 'de', 'it', 'pt', 'ar', 'zh', 'ja'];
    for (const lang of expectedLanguages) {
      const count = languageCodes.filter(code => code === lang).length;
      expect(count).toBe(1);
    }
  });

  test('Vérifie les profils corrects Premium (3) et Famille (5)', async ({ page }) => {
    await page.goto('/pricing');
    
    const premiumCard = page.locator('[data-plan="premium"]');
    await expect(premiumCard.locator('text=3 profils')).toBeVisible();
    
    const familyCard = page.locator('[data-plan="family"]');
    await expect(familyCard.locator('text=5 profils')).toBeVisible();
    
    await expect(premiumCard.locator('text=/3 profils enfants/i')).toBeVisible();
    await expect(familyCard.locator('text=/5 profils enfants/i')).toBeVisible();
  });

  test('Vérifie les options trimestrielles et annuelles', async ({ page }) => {
    await page.goto('/pricing');
    
    await expect(page.locator('text=/mensuel/i')).toBeVisible();
    await expect(page.locator('text=/trimestriel/i')).toBeVisible();
    await expect(page.locator('text=/annuel/i')).toBeVisible();
    
    await page.click('text=/trimestriel/i');
    await expect(page.locator('text=/26\.97€|40\.47€/').first()).toBeVisible({ timeout: 5000 });
    await expect(page.locator('text=/10%/').first()).toBeVisible();
    
    await page.click('text=/annuel/i');
    await expect(page.locator('text=/83\.93€|125\.93€/').first()).toBeVisible({ timeout: 5000 });
    await expect(page.locator('text=/30%/').first()).toBeVisible();
  });

  test('Teste les traductions sur la homepage', async ({ page }) => {
    await page.goto('/');
    
    await expect(page.locator('text=Apprends les maths en t\'amusant')).toBeVisible();
    
    await page.click('[data-testid="language-selector"]');
    await page.click('[data-language-code="en"]');
    
    await expect(page.locator('text=Learn math while having fun')).toBeVisible({ timeout: 3000 });
    await expect(page.locator('text=#1 Educational App in France')).toBeVisible();
    
    await page.click('[data-testid="language-selector"]');
    await page.click('[data-language-code="es"]');
    
    await expect(page.locator('text=¡Aprende matemáticas divirtiéndote!')).toBeVisible({ timeout: 3000 });
    
    await page.click('[data-testid="language-selector"]');
    await page.click('[data-language-code="ar"]');
    
    await expect(page.locator('text=تعلم الرياضيات بالمرح!')).toBeVisible({ timeout: 3000 });
    await expect(page.locator('html')).toHaveClass(/rtl/);
  });

  test('Teste les traductions dans les modaux', async ({ page }) => {
    await page.goto('/');
    
    await page.click('[data-testid="language-selector"]');
    await expect(page.locator('text=Sélectionner une langue')).toBeVisible();
    await expect(page.locator('placeholder=Rechercher une langue...')).toBeVisible();
    
    await page.click('[data-language-code="en"]');
    await page.click('[data-testid="language-selector"]');
    
    await expect(page.locator('text=Select a language')).toBeVisible();
    await expect(page.locator('placeholder=Search for a language...')).toBeVisible();
    
    await page.press('body', 'Escape');
  });
});
