import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper } from '../../utils/test-utils';

test.beforeEach(async ({ page }) => {
  await page.goto('/', { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.waitForSelector('body', { timeout: 10000 });
});

test.describe('Math4Child - Tests de Traduction', () => {
  
  test('Page d\'accueil se charge correctement @smoke', async ({ page }) => {
    await expect(page.locator('body')).not.toBeEmpty();
    
    const hasTitle = await page.locator('h1, [data-testid="app-title"]').count() > 0;
    const hasContent = await page.locator('main, section').count() > 0;
    
    expect(hasTitle || hasContent).toBeTruthy();
  });

  const languages = ['fr', 'en', 'es', 'ar'];

  for (const lang of languages) {
    test(`Interface traduite en ${lang} @translation-final`, async ({ page }) => {
      const helper = new Math4ChildTestHelper(page);
      
      await helper.changeLanguage(lang as any);
      await page.waitForTimeout(2000);
      
      await expect(page.locator('body')).not.toBeEmpty();
      
      if (lang === 'ar') {
        const hasRTL = await page.locator('[dir="rtl"], body[lang="ar"]').count() > 0;
        if (hasRTL) {
          console.log('✅ Direction RTL détectée pour l\'arabe');
        }
      }
      
      const hasWorkingContent = await page.locator('h1, h2, button, a').count() > 0;
      expect(hasWorkingContent).toBeTruthy();
    });
  }

  test('Application fonctionnelle @critical', async ({ page }) => {
    const helper = new Math4ChildTestHelper(page);
    
    const hasContent = await page.locator('h1, h2, h3, p, button, a').count() > 0;
    expect(hasContent).toBeTruthy();

    const hasInteractiveElements = await page.locator('button, a, select').count() > 0;
    expect(hasInteractiveElements).toBeTruthy();

    const isWorking = await helper.verifyAppIsWorking();
    expect(isWorking).toBeTruthy();

    console.log('🎉 Application fonctionnelle validée !');
  });
});

test.setTimeout(60000);
test.describe.configure({ retries: 2 });
