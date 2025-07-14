// =============================================
// 📄 tests/steps/error-handling.steps.ts
// =============================================
import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// ===== SIMULATION D'ERREURS =====
Given('le serveur ne répond pas', async function(this: CustomWorld) {
  await this.page.route('**/api/**', route => {
    route.abort('failed');
  });
});

Given('l\'API retourne des données corrompues', async function(this: CustomWorld) {
  await this.page.route('**/api/**', route => {
    route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: '{"invalid": json}'
    });
  });
});

Given('la connexion réseau est interrompue', async function(this: CustomWorld) {
  await this.page.route('**/*', route => {
    route.abort('internetdisconnected');
  });
});

// ===== VÉRIFICATION DES ERREURS =====
When('j\'essaie de charger la page', async function(this: CustomWorld) {
  try {
    await this.page.reload();
  } catch (error) {
    // Erreur attendue
  }
});

Then('je dois voir un message d\'erreur adapté aux enfants', async function(this: CustomWorld) {
  const errorMessages = [
    'Oups! Quelque chose s\'est mal passé',
    'Vérifie ta connexion internet',
    'Réessaie dans quelques instants'
  ];
  
  let found = false;
  for (const message of errorMessages) {
    try {
      await expect(this.page.getByText(message)).toBeVisible();
      found = true;
      break;
    } catch {
      continue;
    }
  }
  
  expect(found).toBeTruthy();
});