/ =============================================
// 📄 tests/steps/budgetcron.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== SETUP FINANCIER =====
Given('mes données financières sont synchronisées', async function(this: CustomWorld) {
  await this.page.waitForSelector('[data-testid="sync-status"][data-status="synced"]');
});

Given('je suis connecté à mon compte', async function(this: CustomWorld) {
  // Simuler la connexion ou vérifier l'état
  await expect(this.page.locator('[data-testid="user-menu"]')).toBeVisible();
});

// ===== TABLEAU DE BORD =====
When('j\'accède au tableau de bord', async function(this: CustomWorld) {
  await this.page.getByTestId('dashboard').scrollIntoViewIfNeeded();
});

Then('je dois voir le budget total de {string}', async function(this: CustomWorld, amount: string) {
  await expect(this.page.getByTestId('total-budget')).toContainText(amount);
});

// ===== CATÉGORIES BUDGÉTAIRES =====
When('je consulte les catégories budgétaires', async function(this: CustomWorld) {
  await this.page.getByTestId('budget-categories').scrollIntoViewIfNeeded();
});

Then('je dois voir la catégorie {string}', async function(this: CustomWorld, category: string) {
  await expect(this.page.getByTestId(`category-${category.toLowerCase()}`)).toBeVisible();
});

// ===== COMPTES BANCAIRES =====
When('je consulte mes comptes bancaires', async function(this: CustomWorld) {
  await this.page.getByTestId('bank-accounts').scrollIntoViewIfNeeded();
});

Then('je dois voir {string} avec le solde {string}', async function(this: CustomWorld, bank: string, balance: string) {
  const bankCard = this.page.locator(`[data-testid="bank-${bank.toLowerCase().replace(/\s+/g, '-')}"]`);
  await expect(bankCard).toBeVisible();
  await expect(bankCard.getByTestId('balance')).toContainText(balance);
});

// ===== IA ET INSIGHTS =====
When('je consulte la section insights', async function(this: CustomWorld) {
  await this.page.getByTestId('ai-insights').scrollIntoViewIfNeeded();
});