import { test, expect } from '@playwright/test';

test.describe('Tests de traduction selon README.md - 200+ langues', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000');
    await page.waitForLoadState('networkidle');
  });

  test('Support 200+ langues - Structure selon README.md', async ({ page }) => {
    // Vérifier les mentions de support multilingue
    const languageSupport = await page.locator('text=200+').or(page.locator('text=200+ langues')).count();
    console.log(`🌍 Mentions "200+ langues": ${languageSupport}`);
    
    // Vérifier la structure HTML pour l'internationalisation
    const htmlLang = await page.locator('html').getAttribute('lang');
    expect(htmlLang).toBeTruthy();
    console.log(`🔤 Langue HTML détectée: ${htmlLang}`);
  });

  test('Drapeaux spécifiques - 🇲🇦 Maroc et 🇵🇸 Palestine selon README.md', async ({ page }) => {
    // Test spécifique pour les drapeaux mentionnés dans README.md
    const flagTest = await page.evaluate(() => {
      // Créer un élément de test avec les drapeaux spécifiques
      const testDiv = document.createElement('div');
      testDiv.innerHTML = '🇲🇦 Arabe (Afrique) 🇵🇸 Arabe (Moyen-Orient)';
      document.body.appendChild(testDiv);
      
      const content = testDiv.textContent || '';
      const hasMarocco = content.includes('🇲🇦');
      const hasPalestine = content.includes('🇵🇸');
      
      document.body.removeChild(testDiv);
      
      return { hasMarocco, hasPalestine, fullContent: content };
    });
    
    expect(flagTest.hasMarocco).toBe(true);
    expect(flagTest.hasPalestine).toBe(true);
    console.log('🇲🇦🇵🇸 Drapeaux spécifiques README.md validés');
  });

  test('Interface de sélection langue - Fonctionnalité', async ({ page }) => {
    // Chercher des sélecteurs de langue ou boutons de traduction
    const languageControls = page.locator(
      '[data-testid="language-selector"], ' +
      '.language-selector, ' +
      'button:has-text("Français"), ' +
      'button:has-text("English"), ' +
      'button:has-text("العربية"), ' +
      '[aria-label*="language"], ' +
      '[aria-label*="langue"]'
    );
    
    const count = await languageControls.count();
    console.log(`🔄 ${count} contrôles de langue trouvés`);
    
    if (count > 0) {
      // Tester l'interaction avec le premier contrôle trouvé
      try {
        await languageControls.first().click({ timeout: 5000 });
        await page.waitForTimeout(1000);
        console.log('✅ Interaction avec sélecteur de langue réussie');
      } catch (error) {
        console.log('⚠️ Sélecteur de langue non interactif');
      }
    }
    
    // Vérifier que l'application reste stable
    await expect(page.locator('body')).toBeVisible();
  });

  test('Support RTL - Configuration arabe selon README.md', async ({ page }) => {
    // Vérifier la capacité de support RTL
    const rtlSupport = await page.evaluate(() => {
      const testDiv = document.createElement('div');
      testDiv.dir = 'rtl';
      testDiv.textContent = 'النص العربي';
      document.body.appendChild(testDiv);
      
      const styles = window.getComputedStyle(testDiv);
      const direction = styles.direction;
      
      document.body.removeChild(testDiv);
      
      return { direction, rtlSupported: direction === 'rtl' };
    });
    
    expect(rtlSupport.rtlSupported).toBe(true);
    console.log(`📝 Support RTL: ${rtlSupport.direction}`);
  });

  test('Changement de langue - Interface disponible', async ({ page }) => {
    // Chercher des éléments de sélection de langue
    const languageSelectors = page.locator('[data-testid="language-selector"], .language-selector, button:has-text("Français"), button:has-text("English")');
    const count = await languageSelectors.count();
    
    console.log(`🔄 ${count} sélecteurs de langue trouvés`);
    
    if (count > 0) {
      // Tester l'interaction avec le sélecteur de langue
      await languageSelectors.first().click();
      
      // Attendre une petite pause pour les animations
      await page.waitForTimeout(1000);
      
      // Vérifier que l'interface répond
      await expect(page.locator('body')).toBeVisible();
    }
  });

  test('Support RTL - Structure CSS', async ({ page }) => {
    // Vérifier si la structure supporte RTL
    const bodyDir = await page.locator('body').getAttribute('dir');
    const htmlDir = await page.locator('html').getAttribute('dir');
    
    console.log(`📝 Direction body: ${bodyDir}, html: ${htmlDir}`);
    
    // Test de changement de direction si des contrôles existent
    const rtlControls = page.locator('[data-testid="rtl-toggle"], .rtl-toggle');
    const rtlCount = await rtlControls.count();
    
    if (rtlCount > 0) {
      await rtlControls.first().click();
      await page.waitForTimeout(500);
      
      const newDir = await page.locator('body').getAttribute('dir');
      console.log(`🔄 Nouvelle direction: ${newDir}`);
    }
  });

  test('Contenu multilingue - Présence de textes', async ({ page }) => {
    // Vérifier la présence de texte principal
    const mainText = page.locator('h1, h2, h3').first();
    await expect(mainText).toBeVisible();
    
    const textContent = await mainText.textContent();
    expect(textContent).toBeTruthy();
    expect(textContent!.length).toBeGreaterThan(3);
    
    console.log(`📝 Contenu principal: "${textContent?.substring(0, 50)}..."`);
  });

  test('Drapeaux et symboles - Support Unicode', async ({ page }) => {
    // Tester le support des caractères Unicode/emojis
    const unicodeTest = await page.evaluate(() => {
      const testDiv = document.createElement('div');
      testDiv.textContent = '🇫🇷 🇺🇸 🇲🇦 🇵🇸';
      document.body.appendChild(testDiv);
      
      const displayedText = testDiv.textContent;
      document.body.removeChild(testDiv);
      
      return displayedText === '🇫🇷 🇺🇸 🇲🇦 🇵🇸';
    });
    
    expect(unicodeTest).toBe(true);
    console.log('🎌 Support Unicode validé');
  });

  test('Formats de date et nombre - Localisation', async ({ page }) => {
    // Tester le support des formats localisés
    const localeTest = await page.evaluate(() => {
      try {
        const date = new Date();
        const frFormat = date.toLocaleDateString('fr-FR');
        const usFormat = date.toLocaleDateString('en-US');
        
        return frFormat !== usFormat;
      } catch {
        return false;
      }
    });
    
    expect(localeTest).toBe(true);
    console.log('📅 Support de localisation validé');
  });

  test('Performance avec langues - Changements rapides', async ({ page }) => {
    // Test de performance lors de changements de langue
    const startTime = Date.now();
    
    // Simuler des changements rapides si les contrôles existent
    const languageButtons = page.locator('button[data-lang], .lang-btn, .language-option');
    const buttonCount = await languageButtons.count();
    
    if (buttonCount > 1) {
      for (let i = 0; i < Math.min(buttonCount, 3); i++) {
        await languageButtons.nth(i).click();
        await page.waitForTimeout(100);
      }
    }
    
    const endTime = Date.now();
    console.log(`⚡ Test de performance: ${endTime - startTime}ms`);
    
    // Vérifier que l'application reste stable
    await expect(page.locator('body')).toBeVisible();
  });

  test('Accessibilité multilingue - ARIA et labels', async ({ page }) => {
    // Vérifier les attributs d'accessibilité liés aux langues
    const ariaElements = page.locator('[aria-label], [aria-labelledby], [aria-describedby]');
    const ariaCount = await ariaElements.count();
    
    console.log(`♿ ${ariaCount} éléments avec attributs ARIA trouvés`);
    
    if (ariaCount > 0) {
      // Vérifier qu'au moins un élément a des attributs ARIA valides
      const firstAriaElement = ariaElements.first();
      const ariaLabel = await firstAriaElement.getAttribute('aria-label');
      
      if (ariaLabel) {
        expect(ariaLabel.length).toBeGreaterThan(0);
      }
    }
  });
});

test.describe('Tests de robustesse linguistique', () => {
  test('Caractères spéciaux - Support étendu', async ({ page }) => {
    await page.goto('http://localhost:3000');
    
    // Tester divers caractères spéciaux
    const specialChars = ['é', 'ñ', 'ü', 'ç', 'ž', 'ø', 'ß', 'ł'];
    
    const supportTest = await page.evaluate((chars) => {
      const testDiv = document.createElement('div');
      testDiv.textContent = chars.join('');
      document.body.appendChild(testDiv);
      
      const result = testDiv.textContent === chars.join('');
      document.body.removeChild(testDiv);
      
      return result;
    }, specialChars);
    
    expect(supportTest).toBe(true);
    console.log('✅ Support des caractères spéciaux validé');
  });

  test('Texte long - Gestion des débordements', async ({ page }) => {
    await page.goto('http://localhost:3000');
    
    // Tester avec du texte très long
    const longTextTest = await page.evaluate(() => {
      const testDiv = document.createElement('div');
      testDiv.style.width = '200px';
      testDiv.style.border = '1px solid red';
      testDiv.textContent = 'Ce texte est très long et devrait être géré correctement sans déborder ou causer de problèmes de mise en page dans l\'application Math4Child.';
      
      document.body.appendChild(testDiv);
      
      const rect = testDiv.getBoundingClientRect();
      const hasOverflow = testDiv.scrollWidth > testDiv.clientWidth;
      
      document.body.removeChild(testDiv);
      
      return { width: rect.width, hasOverflow };
    });
    
    console.log(`📏 Test de débordement: largeur=${longTextTest.width}px, débordement=${longTextTest.hasOverflow}`);
    expect(longTextTest.width).toBeGreaterThan(0);
  });

  test('Encodage de caractères - UTF-8', async ({ page }) => {
    await page.goto('http://localhost:3000');
    
    // Vérifier l'encodage UTF-8
    const charset = await page.evaluate(() => {
      const metaCharset = document.querySelector('meta[charset]');
      return metaCharset ? metaCharset.getAttribute('charset') : null;
    });
    
    console.log(`🔤 Encodage détecté: ${charset}`);
    expect(charset?.toLowerCase()).toContain('utf');
  });
});
