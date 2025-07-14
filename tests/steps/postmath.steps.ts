// =============================================
// 📄 tests/steps/postmath.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== SETUP EXPÉDITION =====
Given('je suis sur la page de calcul d\'expédition', async function(this: CustomWorld) {
  await this.page.goto('http://localhost:3001');
  await this.page.waitForLoadState('networkidle');
});

Given('l\'API des transporteurs est disponible', async function(this: CustomWorld) {
  // Mock ou vérification de l'API
  await this.page.route('**/api/carriers', route => {
    route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({ status: 'available', carriers: 3 })
    });
  });
});

// ===== SAISIE DES DONNÉES =====
Given('je saisis {string} comme {string}', async function(this: CustomWorld, value: string, fieldType: string) {
  const fieldMap = {
    'ville de départ': 'departure-city',
    'ville de destination': 'destination-city', 
    'poids en kg': 'weight',
    'dimensions en cm': 'dimensions'
  };
  
  const testId = fieldMap[fieldType];
  if (testId) {
    await this.page.getByTestId(testId).fill(value);
  } else {
    throw new Error(`Unknown field type: ${fieldType}`);
  }
});

// ===== CALCUL ET RÉSULTATS =====
When('je clique sur le bouton {string}', async function(this: CustomWorld, buttonText: string) {
  await this.page.getByRole('button', { name: buttonText }).click();
});

Then('je dois voir les résultats de calcul', async function(this: CustomWorld) {
  await expect(this.page.getByTestId('shipping-results')).toBeVisible();
});

Then('je dois voir au moins {string} transporteurs', async function(this: CustomWorld, minCount: string) {
  const carriers = this.page.locator('[data-testid^="carrier-"]');
  const count = await carriers.count();
  expect(count).toBeGreaterThanOrEqual(parseInt(minCount));
});

Then('chaque transporteur doit afficher un prix valide', async function(this: CustomWorld) {
  const priceElements = this.page.locator('[data-testid$="-price"]');
  const count = await priceElements.count();
  
  for (let i = 0; i < count; i++) {
    const price = await priceElements.nth(i).textContent();
    expect(price).toMatch(/\d+[.,]\d{2}\s*€/);
  }
});

// ===== ERREURS =====
Then('je dois voir l\'erreur {string}', async function(this: CustomWorld, errorMessage: string) {
  await expect(this.page.getByTestId('error-message')).toContainText(errorMessage);
});

Then('les résultats ne doivent pas s\'afficher', async function(this: CustomWorld) {
  await expect(this.page.getByTestId('shipping-results')).not.toBeVisible();
});

