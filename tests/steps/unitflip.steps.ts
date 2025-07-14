/ =============================================
// 📄 tests/steps/unitflip.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== CATÉGORIES =====
Given('je suis sur la catégorie {string}', async function(this: CustomWorld, category: string) {
  await this.page.getByTestId(`category-${category}`).click();
  await expect(this.page.getByTestId(`category-${category}`)).toHaveClass(/border-indigo-500/);
});

// ===== CONVERSIONS =====
When('je saisis {string} dans le champ de valeur', async function(this: CustomWorld, value: string) {
  await this.page.getByTestId('value-input').fill(value);
});

Then('je dois voir le résultat {string}', async function(this: CustomWorld, result: string) {
  await expect(this.page.getByTestId('result-display')).toHaveValue(result);
});

Then('je dois voir l\'explication {string}', async function(this: CustomWorld, explanation: string) {
  await expect(this.page.getByTestId('explanation')).toContainText(explanation);
});

Then('la conversion doit être instantanée', async function(this: CustomWorld) {
  // Vérifier que la conversion s'affiche rapidement
  const startTime = Date.now();
  await this.page.getByTestId('result-display').waitFor({ state: 'visible' });
  const conversionTime = Date.now() - startTime;
  expect(conversionTime).toBeLessThan(500); // Moins de 500ms
});

// ===== ÉCHANGE D'UNITÉS =====
When('je clique sur le bouton d\'échange', async function(this: CustomWorld) {
  await this.page.getByTestId('swap-button').click();
});

Then('l\'unité source doit devenir {string}', async function(this: CustomWorld, unit: string) {
  await expect(this.page.getByTestId('from-unit-selector')).toHaveValue(unit);
});