import { test, expect } from '@playwright/test';

test.describe('Math4Child - Corrections Appliquées', () => {
  
  test('Vérifie que chaque langue n\'apparaît qu\'une seule fois', async ({ page }) => {
    await page.goto('/');
    
    // Ouvrir le dropdown de langues
    await page.click('[data-testid="language-selector"]');
    
    // Récupérer tous les éléments de langue
    const languageElements = await page.locator('[data-testid="language-option"]').all();
    const languageCodes: string[] = [];
    
    for (const element of languageElements) {
      const code = await element.getAttribute('data-language-code');
      if (code) languageCodes.push(code);
    }
    
    // Vérifier qu'il n'y a pas de doublons
    const uniqueLanguages = [...new Set(languageCodes)];
    expect(uniqueLanguages.length).toBe(languageCodes.length);
    
    // Vérifier que les langues principales sont présentes une seule fois
    const expectedLanguages = ['fr', 'en', 'es', 'de', 'it', 'pt', 'ar', 'zh', 'ja'];
    for (const lang of expectedLanguages) {
      const count = languageCodes.filter(code => code === lang).length;
      expect(count).toBe(1);
    }
    
    console.log(`✅ ${uniqueLanguages.length} langues uniques trouvées`);
  });

  test('Vérifie les profils corrects Premium (3) et Famille (5)', async ({ page }) => {
    await page.goto('/');
    
    // Scroll vers la section pricing
    await page.evaluate(() => {
      const pricingSection = document.getElementById('pricing-section');
      if (pricingSection) {
        pricingSection.scrollIntoView({ behavior: 'smooth' });
      }
    });
    
    await page.waitForTimeout(1000);
    
    // Vérifier les profils Premium (3)
    const premiumCard = page.locator('[data-plan="premium"]').first();
    await expect(premiumCard.locator('text=3 profils')).toBeVisible({ timeout: 5000 });
    
    // Vérifier les profils Famille (5)  
    const familyCard = page.locator('[data-plan="family"]').first();
    await expect(familyCard.locator('text=5 profils')).toBeVisible({ timeout: 5000 });
    
    console.log('✅ Profils Premium (3) et Famille (5) corrects');
  });

  test('Vérifie les options trimestrielles et annuelles', async ({ page }) => {
    await page.goto('/');
    
    // Scroll vers pricing
    await page.evaluate(() => {
      const pricingSection = document.getElementById('pricing-section');
      if (pricingSection) {
        pricingSection.scrollIntoView({ behavior: 'smooth' });
      }
    });
    
    await page.waitForTimeout(1000);
    
    // Vérifier présence des options
    await expect(page.locator('text=/[Mm]ensuel/').first()).toBeVisible({ timeout: 5000 });
    await expect(page.locator('text=/[Tt]rimestriel/').first()).toBeVisible({ timeout: 5000 });
    await expect(page.locator('text=/[Aa]nnuel/').first()).toBeVisible({ timeout: 5000 });
    
    // Test option trimestrielle
    await page.click('text=/[Tt]rimestriel/');
    await page.waitForTimeout(500);
    await expect(page.locator('text=/10%/').first()).toBeVisible({ timeout: 3000 });
    
    // Test option annuelle
    await page.click('text=/[Aa]nnuel/');
    await page.waitForTimeout(500);
    await expect(page.locator('text=/30%/').first()).toBeVisible({ timeout: 3000 });
    
    console.log('✅ Options billing fonctionnelles');
  });

  test('Vérifie les boutons interactifs fonctionnels', async ({ page }) => {
    await page.goto('/');
    
    // Test bouton "Commencer gratuitement"
    await page.click('text=Commencer gratuitement');
    await expect(page.locator('text=Démarrage de la version gratuite')).toBeVisible({ timeout: 5000 });
    
    // Fermer le modal
    await page.click('text=OK');
    await page.waitForTimeout(500);
    
    // Test bouton "Voir les plans"  
    await page.click('text=Voir les plans');
    await page.waitForTimeout(1000);
    
    // Vérifier que la section pricing est visible
    const pricingSection = page.locator('#pricing-section');
    await expect(pricingSection).toBeInViewport({ timeout: 5000 });
    
    console.log('✅ Boutons interactifs fonctionnels');
  });
  
  test('Teste les traductions sur la homepage', async ({ page }) => {
    await page.goto('/');
    
    // Français par défaut
    await expect(page.locator('text=Apprends les maths en t\'amusant')).toBeVisible({ timeout: 5000 });
    
    // Changement vers anglais
    await page.click('[data-testid="language-selector"]');
    await page.click('[data-language-code="en"]');
    await page.waitForTimeout(1000);
    
    await expect(page.locator('text=Learn math while having fun')).toBeVisible({ timeout: 5000 });
    await expect(page.locator('text=#1 Educational App in France')).toBeVisible({ timeout: 3000 });
    
    // Changement vers espagnol
    await page.click('[data-testid="language-selector"]');
    await page.click('[data-language-code="es"]');
    await page.waitForTimeout(1000);
    
    await expect(page.locator('text=¡Aprende matemáticas divirtiéndote!')).toBeVisible({ timeout: 5000 });
    
    // Changement vers arabe avec RTL
    await page.click('[data-testid="language-selector"]');
    await page.click('[data-language-code="ar"]');
    await page.waitForTimeout(1000);
    
    await expect(page.locator('text=تعلم الرياضيات بالمرح')).toBeVisible({ timeout: 5000 });
    await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
    
    console.log('✅ Traductions homepage fonctionnelles');
  });

  test('Teste les modaux traduits', async ({ page }) => {
    await page.goto('/');
    
    // Test en français
    await page.click('[data-testid="language-selector"]');
    await expect(page.locator('text=Rechercher une langue')).toBeVisible({ timeout: 3000 });
    await page.press('body', 'Escape');
    
    // Changer vers anglais
    await page.click('[data-testid="language-selector"]');
    await page.click('[data-language-code="en"]');
    await page.waitForTimeout(1000);
    
    // Test modal en anglais
    await page.click('[data-testid="language-selector"]');
    await expect(page.locator('placeholder=Search for a language...')).toBeVisible({ timeout: 3000 });
    
    console.log('✅ Modaux traduits fonctionnels');
  });
});
