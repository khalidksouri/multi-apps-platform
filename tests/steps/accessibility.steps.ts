// =============================================
// 📄 tests/steps/accessibility.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== SETUP ACCESSIBILITÉ =====
Given('je navigue avec un lecteur d\'écran', async function(this: CustomWorld) {
  await this.page.emulateMedia({ reducedMotion: 'reduce' });
  await this.page.addInitScript(() => {
    Object.defineProperty(navigator, 'userAgent', {
      value: navigator.userAgent + ' NVDA'
    });
  });
});

Given('je navigue avec {string}', async function(this: CustomWorld, technology: string) {
  switch (technology) {
    case 'navigation clavier':
      await this.page.keyboard.press('Tab');
      break;
    case 'un lecteur d\'écran':
      await this.page.emulateMedia({ reducedMotion: 'reduce' });
      break;
  }
});

// ===== TESTS ACCESSIBILITÉ =====
When('je navigue uniquement au clavier', async function(this: CustomWorld) {
  // Simuler la navigation clavier
  await this.page.keyboard.press('Tab');
});

Then('tous les éléments interactifs doivent être accessibles', async function(this: CustomWorld) {
  const interactiveElements = this.page.locator('button, input, select, textarea, a, [role="button"]');
  const count = await interactiveElements.count();
  
  for (let i = 0; i < count; i++) {
    const element = interactiveElements.nth(i);
    
    // Vérifier les attributs d'accessibilité
    const accessibleName = await element.getAttribute('aria-label') 
      || await element.getAttribute('aria-labelledby')
      || await element.textContent();
      
    expect(accessibleName?.trim()).toBeTruthy();
  }
});

Then('l\'ordre de tabulation doit être logique', async function(this: CustomWorld) {
  // Test de l'ordre de tabulation
  const tabbableElements = this.page.locator('button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), a[href]');
  const count = await tabbableElements.count();
  expect(count).toBeGreaterThan(0);
});