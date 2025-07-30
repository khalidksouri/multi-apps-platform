import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper } from '../utils/test-utils';

const viewports = [
  { name: 'mobile', width: 375, height: 667 },
  { name: 'tablet', width: 768, height: 1024 },
  { name: 'desktop', width: 1280, height: 720 }
];

test.describe('Math4Child - Tests Responsive', () => {
  
  for (const viewport of viewports) {
    test(`Interface responsive ${viewport.name} @responsive`, async ({ page }) => {
      // Définir la taille du viewport
      await page.setViewportSize({ width: viewport.width, height: viewport.height });
      
      // Aller à la page d'accueil
      await page.goto('/', { 
        waitUntil: 'domcontentloaded', 
        timeout: 45000 
      });
      
      await page.waitForSelector('body', { timeout: 15000 });
      
      const helper = new Math4ChildTestHelper(page);
      
      console.log(`📱 Test responsive: ${viewport.name} (${viewport.width}x${viewport.height})`);
      
      // Vérifier que l'application fonctionne
      const isWorking = await helper.verifyAppIsWorking();
      expect(isWorking).toBeTruthy();
      
      // Prendre une capture d'écran
      await helper.takeScreenshot(`responsive-${viewport.name}`);
      
      // Vérifier qu'il n'y a pas de débordement horizontal
      const bodyWidth = await page.evaluate(() => document.body.scrollWidth);
      expect(bodyWidth).toBeLessThanOrEqual(viewport.width + 20); // Marge de 20px
      
      console.log(`✅ Test responsive ${viewport.name} réussi`);
    });
  }
});

test.setTimeout(60000);
test.describe.configure({ retries: 2 });
