// ===================================================================
// TESTS RESPONSIVE MATH4CHILD
// Tests de base pour le design responsive
// ===================================================================

import { test, expect } from '../utils/test-fixtures';

test.describe('Math4Child - Design Responsive', () => {

  test('Interface mobile portrait @mobile', async ({ math4childApp }) => {
    await math4childApp.setMobileViewport();
    
    // Vérifier que l'interface principale est visible
    await expect(math4childApp.page.locator('h1')).toBeVisible();
    
    // Vérifier l'adaptation des grilles
    const statsGrid = math4childApp.page.locator('[data-testid="stats"]');
    if (await statsGrid.isVisible()) {
      const boundingBox = await statsGrid.boundingBox();
      expect(boundingBox?.width).toBeLessThan(400); // Largeur mobile
    }
    
    // Vérifier que les boutons sont suffisamment grands pour le tactile
    const buttons = await math4childApp.page.locator('button').all();
    for (const button of buttons.slice(0, 3)) { // Tester les 3 premiers
      if (await button.isVisible()) {
        const box = await button.boundingBox();
        if (box) {
          expect(box.height).toBeGreaterThanOrEqual(44); // Taille minimale tactile
        }
      }
    }
  });

  test('Interface tablette paysage @tablet', async ({ math4childApp }) => {
    await math4childApp.setTabletViewport();
    
    // Vérifier l'utilisation optimale de l'espace
    const mainContainer = math4childApp.page.locator('main, .container').first();
    const containerBox = await mainContainer.boundingBox();
    
    if (containerBox) {
      expect(containerBox.width).toBeGreaterThan(600);
      expect(containerBox.width).toBeLessThan(1000); // Pas trop large
    }
  });

  test('Interface desktop large écran', async ({ math4childApp }) => {
    await math4childApp.setDesktopViewport();
    
    const mainContent = math4childApp.page.locator('.container, main').first();
    const contentBox = await mainContent.boundingBox();
    
    if (contentBox) {
      // Le contenu ne devrait pas être trop étiré
      expect(contentBox.width).toBeLessThan(1400);
    }
  });

});
