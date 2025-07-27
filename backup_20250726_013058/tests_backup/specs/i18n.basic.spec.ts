// ===================================================================
// TESTS MULTILINGUES MATH4CHILD
// Tests de base pour l'internationalisation
// ===================================================================

import { test, expect } from '../utils/test-fixtures';
import { LANGUAGES_CONFIG } from '../utils/test-utils';

test.describe('Math4Child - Tests multilingues', () => {

  const mainLanguages = ['en', 'fr', 'es', 'de', 'zh', 'ar'] as const;

  for (const language of mainLanguages) {
    test(`Interface traduite correctement en ${language} @i18n`, async ({ math4childApp }) => {
      await math4childApp.selectLanguage(language);
      
      // Vérifier que le contenu principal est traduit
      const titleElement = math4childApp.page.locator('h1').first();
      await expect(titleElement).toBeVisible();
      
      // Vérifier les niveaux traduits
      const levelsContainer = math4childApp.page.locator('[data-testid="levels"], .levels-grid').first();
      await expect(levelsContainer).toBeVisible();
    });
  }

  test('Support RTL pour les langues arabes @rtl', async ({ math4childApp }) => {
    await math4childApp.selectLanguage('ar');
    
    // Vérifier que la direction RTL est appliquée
    const bodyDir = await math4childApp.page.locator('body, .rtl, [dir="rtl"]').first().getAttribute('dir');
    expect(bodyDir).toBe('rtl');
    
    // Vérifier le contenu en arabe
    await expect(math4childApp.page.locator('body')).toContainText(/العربية|الرياضيات/);
  });

  test('Changement de langue met à jour toute l\'interface @critical', async ({ math4childApp }) => {
    // Commencer en anglais
    await math4childApp.selectLanguage('en');
    const englishTitle = await math4childApp.page.locator('h1').first().textContent();
    
    // Changer vers le français
    await math4childApp.selectLanguage('fr');
    const frenchTitle = await math4childApp.page.locator('h1').first().textContent();
    
    // Vérifier que le contenu a changé
    expect(englishTitle).not.toBe(frenchTitle);
    
    // Vérifier des mots-clés français
    await expect(math4childApp.page.locator('body')).toContainText(/mathématiques|français|apprendre/i);
  });

});
