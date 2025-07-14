// =============================================
// 📄 tests/steps/performance.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== TESTS DE PERFORMANCE =====
When('j\'accède à l\'application {string} sur {string}', async function(this: CustomWorld, app: string, url: string) {
  const startTime = Date.now();
  await this.page.goto(url);
  await this.page.waitForLoadState('networkidle');
  this.performance.set('pageLoadTime', Date.now() - startTime);
});

Then('la page doit se charger en moins de {string} secondes', async function(this: CustomWorld, maxTime: string) {
  const loadTime = this.performance.get('pageLoadTime') || 0;
  expect(loadTime).toBeLessThan(parseInt(maxTime) * 1000);
});

When('j\'effectue {int} conversions consécutives', async function(this: CustomWorld, count: number) {
  const startTime = Date.now();
  
  for (let i = 0; i < count; i++) {
    await this.page.getByTestId('value-input').fill(String(Math.random() * 100));
    await this.page.waitForSelector('[data-testid="result-display"]');
  }
  
  this.performance.set('batchTime', Date.now() - startTime);
});

Then('les performances doivent rester constantes', async function(this: CustomWorld) {
  const batchTime = this.performance.get('batchTime') || 0;
  const averageTime = batchTime / 1000;
  expect(averageTime).toBeLessThan(100);
});