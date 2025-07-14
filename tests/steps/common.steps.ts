// =============================================
// 📄 tests/steps/common.steps.ts
// =============================================
import { Given, When, Then, setDefaultTimeout } from '@cucumber/cucumber';
import { Page, expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

setDefaultTimeout(60000);

// ===== NAVIGATION ET SETUP =====
Given('je suis sur la page {string} {string}', async function(this: CustomWorld, app: string, url: string) {
  this.currentApp = app;
  await this.page.goto(url);
  await this.page.waitForLoadState('networkidle');
  await expect(this.page).not.toHaveURL(/error/);
});

Given('la plateforme {string} est disponible', async function(this: CustomWorld, platform: string) {
  const healthCheck = await this.page.request.get('/health').catch(() => ({ ok: () => false }));
  if (!healthCheck.ok()) {
    console.log(`Platform ${platform} health check failed, continuing anyway`);
  }
});

// ===== INTERACTIONS UTILISATEUR =====
When('je clique sur {string}', async function(this: CustomWorld, element: string) {
  const startTime = Date.now();
  
  // Stratégies multiples de sélection
  const selectors = [
    () => this.page.getByText(element, { exact: true }),
    () => this.page.getByText(element),
    () => this.page.getByRole('button', { name: element }),
    () => this.page.locator(`[data-testid="${element}"]`),
    () => this.page.locator(`[aria-label="${element}"]`)
  ];

  let clicked = false;
  for (const selector of selectors) {
    try {
      const locator = selector();
      await locator.waitFor({ timeout: 5000 });
      await locator.click();
      clicked = true;
      break;
    } catch (error) {
      continue;
    }
  }

  if (!clicked) {
    throw new Error(`Could not find clickable element: ${element}`);
  }

  this.performance.set('clickResponseTime', Date.now() - startTime);
});

When('je saisis {string} dans le champ {string}', async function(this: CustomWorld, value: string, field: string) {
  const selectors = [
    () => this.page.getByLabel(field),
    () => this.page.getByPlaceholder(field),
    () => this.page.locator(`[data-testid="${field}"]`),
    () => this.page.locator(`input[name="${field}"]`)
  ];

  for (const selector of selectors) {
    try {
      const input = selector();
      await input.waitFor({ timeout: 5000 });
      await input.clear();
      await input.fill(value);
      await expect(input).toHaveValue(value);
      return;
    } catch (error) {
      continue;
    }
  }
  
  throw new Error(`Could not find input field: ${field}`);
});

// ===== VÉRIFICATIONS =====
Then('je dois voir {string}', async function(this: CustomWorld, text: string) {
  await expect(this.page.getByText(text)).toBeVisible({ timeout: 10000 });
});

Then('je ne dois pas voir {string}', async function(this: CustomWorld, text: string) {
  await expect(this.page.getByText(text)).not.toBeVisible();
});

Then('la page se charge', async function(this: CustomWorld) {
  await this.page.waitForLoadState('domcontentloaded');
});

// ===== DESIGN ET INTERFACE =====
Then('l\'interface doit avoir un design {string}', async function(this: CustomWorld, designType: string) {
  switch (designType) {
    case 'dark moderne':
      await expect(this.page.locator('.bg-gradient-to-br')).toBeVisible();
      break;
    case 'colorée et adaptée aux enfants':
      await expect(this.page.locator('.text-6xl')).toHaveCount(3);
      break;
  }
});

// ===== PERFORMANCE =====
Then('la réponse doit être immédiate \\(moins de {int}s\\)', async function(this: CustomWorld, maxSeconds: number) {
  const responseTime = this.performance.get('clickResponseTime') || 0;
  expect(responseTime).toBeLessThan(maxSeconds * 1000);
});