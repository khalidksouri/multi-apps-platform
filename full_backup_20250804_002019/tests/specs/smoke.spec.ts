import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper } from '../utils/test-utils';

test.beforeEach(async ({ page }) => {
  await page.goto('/', { 
    waitUntil: 'domcontentloaded', 
    timeout: 45000 
  });
  await page.waitForSelector('body', { timeout: 15000 });
});

test.describe('Math4Child - Tests de Fumée', () => {
  
  test('Application se charge et fonctionne @smoke', async ({ page }) => {
    const helper = new Math4ChildTestHelper(page);
    
    // Vérifier que l'application est fonctionnelle
    const isWorking = await helper.verifyAppIsWorking();
    expect(isWorking).toBeTruthy();
    
    // Vérifier qu'il y a du contenu
    await expect(page.locator('body')).not.toBeEmpty();
    
    // Vérifier qu'il y a des éléments interactifs
    const hasInteractiveElements = await page.locator('button, a, select, input').count() > 0;
    expect(hasInteractiveElements).toBeTruthy();
    
    console.log('✅ Application fonctionnelle');
  });

  test('Page titre et contenu de base @smoke', async ({ page }) => {
    // Vérifier le titre de la page
    const title = await page.title();
    expect(title).toBeTruthy();
    
    // Vérifier qu'il y a des headings
    const headings = await page.locator('h1, h2, h3').count();
    expect(headings).toBeGreaterThan(0);
    
    console.log(`✅ Page titre: "${title}", ${headings} headings trouvés`);
  });

  test('Navigation principale présente @smoke', async ({ page }) => {
    // Vérifier la présence d'éléments de navigation
    const navElements = await page.locator('nav, header, .navigation, [role="navigation"]').count();
    console.log(`📝 Éléments de navigation: ${navElements}`);
    
    // Vérifier la présence de liens ou boutons
    const interactiveElements = await page.locator('a, button').count();
    expect(interactiveElements).toBeGreaterThan(0);
    
    console.log('✅ Navigation fonctionnelle');
  });
});

test.setTimeout(60000);
test.describe.configure({ retries: 2 });
