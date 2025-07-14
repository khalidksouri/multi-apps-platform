/ =============================================
// 📄 tests/steps/ai4kids.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== MODULES D'APPRENTISSAGE =====
When('je consulte les modules disponibles', async function(this: CustomWorld) {
  await this.page.waitForSelector('[data-testid^="module-"]', { state: 'visible' });
});

Then('je dois voir exactement {int} modules', async function(this: CustomWorld, count: number) {
  const modules = this.page.locator('[data-testid^="module-"]');
  await expect(modules).toHaveCount(count);
});

Then('je dois voir le module {string} avec l\'emoji {string}', async function(this: CustomWorld, module: string, emoji: string) {
  const moduleCard = this.page.locator(`text=${module}`).locator('..');
  await expect(moduleCard).toBeVisible();
  await expect(moduleCard.locator(`text=${emoji}`)).toBeVisible();
});

Given('j\'ai sélectionné {string}', async function(this: CustomWorld, module: string) {
  await this.page.getByText(module).click();
  await expect(this.page.getByText(`Tu as choisi: ${module}`)).toBeVisible();
});

Then('le bouton doit être visible et activé', async function(this: CustomWorld) {
  const button = this.page.getByRole('button', { name: 'Commencer' });
  await expect(button).toBeVisible();
  await expect(button).toBeEnabled();
});

// ===== GAMIFICATION =====
Then('il doit recevoir {string}', async function(this: CustomWorld, reward: string) {
  await expect(this.page.getByText(reward)).toBeVisible();
});

Then('voir {string}', async function(this: CustomWorld, feedback: string) {
  await expect(this.page.locator(`[data-animation="${feedback}"]`)).toBeVisible();
});