// =============================================
// 📄 tests/steps/multiai.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== SERVICES IA =====
Given('j\'ai sélectionné le service {string}', async function(this: CustomWorld, service: string) {
  await this.page.getByText(service).click();
  await expect(this.page.getByText(`Service sélectionné: ${service}`)).toBeVisible();
});

When('je consulte la liste des services', async function(this: CustomWorld) {
  await this.page.waitForSelector('[data-testid^="service-"]', { state: 'visible' });
});

Then('je dois voir le service {string} avec l\'icône {string}', async function(this: CustomWorld, service: string, icon: string) {
  const serviceCard = this.page.locator(`text=${service}`).locator('..');
  await expect(serviceCard).toBeVisible();
  await expect(serviceCard.locator(`text=${icon}`)).toBeVisible();
});

Then('je dois voir exactement {int} services avec le statut {string}', async function(this: CustomWorld, count: number, status: string) {
  const statusElements = this.page.getByText(status);
  await expect(statusElements).toHaveCount(count);
});

When('je survole une carte de service', async function(this: CustomWorld) {
  const serviceCard = this.page.locator('.transition-all').first();
  await serviceCard.hover();
});

// ===== CONFIGURATION =====
Then('la configuration doit s\'afficher', async function(this: CustomWorld) {
  await expect(this.page.locator('[data-testid="service-config"]')).toBeVisible();
});