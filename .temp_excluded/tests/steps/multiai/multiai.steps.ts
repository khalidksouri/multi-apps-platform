import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../../support/world';

Given('que je suis sur l\'application MultiAI', async function(this: CustomWorld) {
  this.baseUrl = 'http://localhost:3005';
  await this.navigateTo();
});

Then('je vois {int} modèles d\'IA disponibles', async function(this: CustomWorld, count: number) {
  const models = await this.page.locator('.model-card').count();
  expect(models).toBe(count);
});

Then('chaque modèle affiche son statut', async function(this: CustomWorld) {
  const statusElements = await this.page.locator('.status').count();
  expect(statusElements).toBeGreaterThan(0);
});

When('je clique sur le modèle {string}', async function(this: CustomWorld, modelName: string) {
  await this.page.locator(`.model-card:has-text("${modelName}")`).click();
});

Then('le modèle est sélectionné visuellement', async function(this: CustomWorld) {
  await expect(this.page.locator('.model-card.selected')).toBeVisible();
});

Then('le chat devient actif', async function(this: CustomWorld) {
  await expect(this.page.locator('#messageInput:not([disabled])')).toBeVisible();
  await expect(this.page.locator('#sendButton:not([disabled])')).toBeVisible();
});

Given('que j\'ai sélectionné le modèle {string}', async function(this: CustomWorld, modelName: string) {
  await this.page.locator(`.model-card:has-text("${modelName}")`).click();
  await expect(this.page.locator('.model-card.selected')).toBeVisible();
});

When('j\'envoie le message {string}', async function(this: CustomWorld, message: string) {
  await this.page.fill('#messageInput', message);
  await this.page.click('button:has-text("Envoyer")');
});

Then('je reçois une réponse de l\'assistant', async function(this: CustomWorld) {
  await expect(this.page.locator('.message.ai').last()).toBeVisible({ timeout: 10000 });
});

Then('la réponse contient des exemples de code', async function(this: CustomWorld) {
  const lastResponse = this.page.locator('.message.ai').last();
  await expect(lastResponse).toContainText('function');
});
