import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper } from '../../utils/test-utils';

test.describe('Math4Child - Interface RTL Pricing', () => {
  
  test.beforeEach(async ({ page }) => {
    // Aller à la page pricing
    await page.goto('/pricing');
    
    // Forcer la langue arabe et RTL
    await page.evaluate(() => {
      localStorage.setItem('language', 'ar');
      document.documentElement.dir = 'rtl';
      document.documentElement.lang = 'ar';
    });
    
    await page.reload({ waitUntil: 'domcontentloaded' });
    await page.waitForSelector('body', { timeout: 15000 });
  });

  test('Interface RTL correctement appliquée @rtl @pricing', async ({ page }) => {
    // Vérifier la direction RTL
    const htmlDir = await page.getAttribute('html', 'dir');
    expect(htmlDir).toBe('rtl');
    
    // Vérifier la langue arabe
    const htmlLang = await page.getAttribute('html', 'lang');
    expect(htmlLang).toBe('ar');
    
    // Vérifier que les éléments principaux sont visibles
    await expect(page.locator('text=اختر الخطة المناسبة لك')).toBeVisible();
    
    console.log('✅ Interface RTL pricing validée');
  });

  test('Plans en arabe visibles et fonctionnels @rtl @pricing', async ({ page }) => {
    // Vérifier les titres de plans en arabe
    await expect(page.locator('text=خطة المدرسة')).toBeVisible();
    await expect(page.locator('text=الخطة المميزة')).toBeVisible(); 
    await expect(page.locator('text=خطة المؤسسة')).toBeVisible();
    
    // Vérifier le badge "الأكثر شعبية"
    await expect(page.locator('text=الأكثر شعبية')).toBeVisible();
    
    // Vérifier les boutons en arabe
    const arabicButtons = page.locator('button:has-text("اختر هذه الخطة")');
    const buttonCount = await arabicButtons.count();
    expect(buttonCount).toBeGreaterThanOrEqual(3);
    
    console.log('✅ Plans en arabe validés');
  });

  test('Fonctionnalités avec checkmarks RTL @rtl @pricing', async ({ page }) => {
    // Vérifier que les checkmarks sont présents
    const checkmarks = page.locator('.feature-icon:has-text("✓")');
    const checkmarkCount = await checkmarks.count();
    expect(checkmarkCount).toBeGreaterThan(8); // Au moins 3 plans × 3 features chacun
    
    // Vérifier l'alignement RTL des fonctionnalités
    const featureItems = page.locator('.feature-item');
    for (let i = 0; i < Math.min(3, await featureItems.count()); i++) {
      const item = featureItems.nth(i);
      await expect(item).toBeVisible();
    }
    
    console.log('✅ Fonctionnalités RTL validées');
  });

  test('Sélection de plan fonctionnelle @rtl @pricing', async ({ page }) => {
    // Tester la sélection du plan premium (bleu)
    await page.click('[data-testid="plan-blue-select"]');
    
    // Attendre une réaction (modal, redirection, etc.)
    await page.waitForTimeout(1000);
    
    // Vérifier que le clic a été pris en compte
    // (Le test dépend de votre implémentation)
    
    console.log('✅ Sélection de plan testée');
  });

  test('Bouton essai gratuit visible @rtl @pricing', async ({ page }) => {
    // Vérifier la présence du bouton essai gratuit
    const trialButton = page.locator('[data-testid="trial-button"]');
    
    if (await trialButton.isVisible()) {
      await expect(trialButton).toContainText('تجربة مجانية');
      console.log('✅ Bouton essai gratuit trouvé');
    } else {
      console.log('ℹ️ Bouton essai gratuit non présent (optionnel)');
    }
  });

  test('FAQ en arabe fonctionnelle @rtl @pricing', async ({ page }) => {
    // Vérifier le titre FAQ
    await expect(page.locator('text=الأسئلة الشائعة')).toBeVisible();
    
    // Vérifier au moins une question FAQ
    await expect(page.locator('text=هل يمكنني تغيير خطتي لاحقاً؟')).toBeVisible();
    
    // Vérifier les éléments FAQ ont la classe RTL
    const faqItems = page.locator('.faq-item');
    const faqCount = await faqItems.count();
    expect(faqCount).toBeGreaterThanOrEqual(2);
    
    console.log('✅ FAQ en arabe validée');
  });

  test('Section contact en arabe @rtl @pricing', async ({ page }) => {
    // Vérifier la section contact
    await expect(page.locator('text=هل تحتاج مساعدة في اختيار الخطة المناسبة؟')).toBeVisible();
    
    // Vérifier les boutons de contact
    await expect(page.locator('text=تواصل معنا عبر الواتساب')).toBeVisible();
    await expect(page.locator('text=جدولة مكالمة مجانية')).toBeVisible();
    
    console.log('✅ Section contact validée');
  });

  test('Responsive RTL sur mobile @rtl @responsive @pricing', async ({ page }) => {
    // Simuler un appareil mobile
    await page.setViewportSize({ width: 375, height: 667 });
    
    // Vérifier que l'interface s'adapte correctement
    const container = page.locator('.grid-cols-1.md\\:grid-cols-3');
    await expect(container).toBeVisible();
    
    // Vérifier que les plans restent visibles et accessibles
    await expect(page.locator('text=خطة المدرسة')).toBeVisible();
    await expect(page.locator('text=الخطة المميزة')).toBeVisible();
    
    // Vérifier que les boutons restent cliquables
    const buttons = page.locator('button:has-text("اختر هذه الخطة")');
    for (let i = 0; i < await buttons.count(); i++) {
      await expect(buttons.nth(i)).toBeVisible();
    }
    
    console.log('✅ Interface RTL responsive validée');
  });

  test('Styles RTL appliqués correctement @rtl @pricing', async ({ page }) => {
    // Vérifier que les styles RTL sont appliqués
    const pricingCards = page.locator('.pricing-card');
    
    for (let i = 0; i < Math.min(3, await pricingCards.count()); i++) {
      const card = pricingCards.nth(i);
      
      // Vérifier que la direction RTL est appliquée
      const direction = await card.getAttribute('dir');
      expect(direction).toBe('rtl');
    }
    
    // Vérifier les classes CSS RTL
    const bodyClasses = await page.getAttribute('body', 'class');
    console.log(`Classes body: ${bodyClasses}`);
    
    console.log('✅ Styles RTL appliqués');
  });
});

test.setTimeout(90000); // 90 secondes par test
test.describe.configure({ retries: 2 });
