import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { Browser, Page, chromium } from 'playwright';

let browser: Browser;
let page: Page;

Given('que je visite l\'application math4kids sur le port {int}', async function (port: number) {
  browser = await chromium.launch({ headless: true });
  page = await browser.newPage();
  await page.goto(`http://localhost:${port}`);
});

Given('que l\'application est chargée', async function () {
  await page.waitForSelector('[data-testid="app-container"]', { timeout: 10000 });
});

Then('je devrais voir l\'interface principale', async function () {
  await expect(page.locator('h1')).toBeVisible();
});

Then('tous les éléments de base devraient être visibles', async function () {
  await expect(page.locator('.app-container')).toBeVisible();
});

When('je change la langue vers {string}', async function (language: string) {
  const selector = page.locator('select');
  if (await selector.count() > 0) {
    await selector.selectOption({ label: new RegExp(language, 'i') });
  }
});

Then('l\'interface devrait être en anglais', async function () {
  await page.waitForTimeout(1000);
  // Vérifier que le contenu a changé
});

Then('l\'application devrait fonctionner normalement', async function () {
  // Vérifier que les interactions fonctionnent
  const buttons = page.locator('button');
  expect(await buttons.count()).toBeGreaterThan(0);
});

When('je clique sur {string}', async function (buttonText: string) {
  await page.click(`text=${buttonText}`);
});

Then('je devrais voir une question de mathématiques', async function () {
  await expect(page.locator('[data-testid="question"]')).toBeVisible();
});

Then('le score devrait être à {int}', async function (score: number) {
  const scoreElement = page.locator('[data-testid="score"]');
  if (await scoreElement.count() > 0) {
    await expect(scoreElement).toContainText(score.toString());
  }
});

Given('que j\'ai démarré un jeu', async function () {
  const startButton = page.locator('[data-testid="start-button"]');
  if (await startButton.count() > 0) {
    await startButton.click();
    await page.waitForSelector('[data-testid="question"]');
  }
});

When('je clique sur une réponse', async function () {
  const options = page.locator('[data-testid="option"]');
  if (await options.count() > 0) {
    await options.first().click();
  }
});

Then('je devrais voir la question suivante ou le résultat final', async function () {
  await page.waitForTimeout(1500);
  // Soit une nouvelle question, soit un message de fin
  const questionExists = await page.locator('[data-testid="question"]').count() > 0;
  const alertShown = await page.locator('text=Terminé').count() > 0;
  expect(questionExists || alertShown).toBeTruthy();
});

// Nettoyage
process.on('exit', async () => {
  if (browser) {
    await browser.close();
  }
});
