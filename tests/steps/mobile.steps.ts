// =============================================
// 📄 tests/steps/mobile.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== SETUP MOBILE =====
Given('je suis sur un appareil mobile', async function(this: CustomWorld) {
  await this.page.setViewportSize({ width: 375, height: 667 });
  await this.page.emulateMedia({ reducedMotion: 'no-preference' });
});

Given('je suis sur une tablette de {int} pouces', async function(this: CustomWorld, size: number) {
  const viewportSizes = {
    7: { width: 600, height: 960 },
    10: { width: 768, height: 1024 },
    12: { width: 1024, height: 1366 }
  };
  
  const viewport = viewportSizes[size] || viewportSizes[10];
  await this.page.setViewportSize(viewport);
});

Given('je suis sur l\'application {string}', async function(this: CustomWorld, app: string) {
  const urls = {
    'AI4Kids': 'http://localhost:3004',
    'MultiAI': 'http://localhost:3005',
    'BudgetCron': 'http://localhost:3003',
    'UnitFlip': 'http://localhost:3002',
    'Postmath': 'http://localhost:3001'
  };
  
  const url = urls[app];
  if (url) {
    await this.page.goto(url);
  }
});

// ===== TESTS RESPONSIVE =====
Then('l\'interface doit s\'adapter à la taille d\'écran', async function(this: CustomWorld) {
  // Vérifier que l'interface est responsive
  const viewport = this.page.viewportSize();
  if (viewport && viewport.width < 768) {
    await expect(this.page.locator('.mobile-menu')).toBeVisible();
  }
});

Then('les boutons doivent être assez grands pour les petits doigts', async function(this: CustomWorld) {
  const buttons = this.page.locator('button');
  const count = await buttons.count();
  
  for (let i = 0; i < count; i++) {
    const button = buttons.nth(i);
    const boundingBox = await button.boundingBox();
    if (boundingBox) {
      expect(boundingBox.height).toBeGreaterThanOrEqual(44); // 44px minimum touch target
    }
  }
});
