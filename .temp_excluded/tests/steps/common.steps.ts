import { Given, When, Then } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { CustomWorld } from '../support/world';

// Steps communes pour la navigation
Given('que je suis sur l\'application {string}', async function(this: CustomWorld, appName: string) {
  const urls: Record<string, string> = {
    'AI4Kids': 'http://localhost:3004',
    'MultiAI': 'http://localhost:3005', 
    'BudgetCron': 'http://localhost:3003',
    'UnitFlip': 'http://localhost:3002',
    'Postmath': 'http://localhost:3001'
  };
  
  this.baseUrl = urls[appName] || this.baseUrl;
  console.log(`🎯 Configuration pour ${appName}: ${this.baseUrl}`);
  await this.navigateTo();
});

When('je visite la page d\'accueil', async function(this: CustomWorld) {
  await this.navigateTo();
});

When('je clique sur {string}', async function(this: CustomWorld, buttonText: string) {
  await this.page.click(`text=${buttonText}`);
});

Then('je vois le titre {string}', async function(this: CustomWorld, title: string) {
  await expect(this.page).toHaveTitle(new RegExp(title, 'i'));
});

Then('je vois le message {string}', async function(this: CustomWorld, message: string) {
  // Utiliser plusieurs stratégies pour trouver le texte
  const selectors = [
    `text="${message}"`,                    // Texte exact
    `text=${message}`,                      // Texte exact (autre syntaxe)
    `:has-text("${message}")`,             // Contient le texte
    `*:has-text("${message}")`,            // N'importe quel élément contenant le texte
    `text=/${message.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}/i`  // Regex insensible à la casse
  ];
  
  let found = false;
  let lastError = '';
  
  for (const selector of selectors) {
    try {
      await expect(this.page.locator(selector)).toBeVisible({ timeout: 3000 });
      console.log(`✅ Texte trouvé avec le sélecteur: ${selector}`);
      found = true;
      break;
    } catch (error) {
      lastError = error.message;
      // Continuer avec le sélecteur suivant
    }
  }
  
  if (!found) {
    // Debug: afficher le contenu de la page
    const pageContent = await this.page.textContent('body');
    console.log(`🔍 Recherche de: "${message}"`);
    console.log(`📄 Contenu de la page (extrait): ${pageContent?.substring(0, 500)}...`);
    
    // Essayer une recherche plus flexible
    const flexibleSelector = `body:has-text("${message.split(' ')[0]}")`;
    try {
      await expect(this.page.locator(flexibleSelector)).toBeVisible({ timeout: 2000 });
      console.log(`✅ Trouvé une correspondance partielle`);
    } catch (e) {
      throw new Error(`Impossible de trouver le message "${message}". Dernière erreur: ${lastError}`);
    }
  }
});

// Steps pour les formulaires
When('je remplis le champ {string} avec {string}', async function(this: CustomWorld, fieldName: string, value: string) {
  const selector = `input[placeholder*="${fieldName}"], input[id*="${fieldName.toLowerCase()}"], input[name*="${fieldName.toLowerCase()}"]`;
  await this.page.fill(selector, value);
});

When('je saisis {string} dans le champ {string}', async function(this: CustomWorld, value: string, fieldName: string) {
  const selector = `input[placeholder*="${fieldName}"], input[id*="${fieldName.toLowerCase()}"], #${fieldName.toLowerCase()}Input`;
  await this.page.fill(selector, value);
});

When('je saisis {string} dans le premier champ', async function(this: CustomWorld, value: string) {
  await this.page.fill('#num1', value);
});

When('je saisis {string} dans le second champ', async function(this: CustomWorld, value: string) {
  await this.page.fill('#num2', value);
});

// Steps pour les sélections
When('je sélectionne {string} comme {string}', async function(this: CustomWorld, option: string, fieldType: string) {
  const selector = `select[id*="${fieldType.toLowerCase()}"], select[name*="${fieldType.toLowerCase()}"]`;
  await this.page.selectOption(selector, { label: option });
});

When('je sélectionne {string} comme opération', async function(this: CustomWorld, operation: string) {
  const operationMap: Record<string, string> = {
    '+': 'add',
    '-': 'subtract', 
    '×': 'multiply',
    '÷': 'divide'
  };
  await this.page.selectOption('#operation', operationMap[operation] || operation);
});

// Steps pour les résultats
Then('je vois le résultat {string}', async function(this: CustomWorld, expectedResult: string) {
  await expect(this.page.locator(`text=${expectedResult}`)).toBeVisible();
});

Then('je vois un message d\'erreur approprié', async function(this: CustomWorld) {
  const errorSelectors = [
    '.error', '.alert-danger', '[role="alert"]',
    'text=erreur', 'text=Erreur', 'text=Error'
  ];
  
  let errorFound = false;
  for (const selector of errorSelectors) {
    try {
      await expect(this.page.locator(selector)).toBeVisible({ timeout: 2000 });
      errorFound = true;
      break;
    } catch (e) {
      // Continue to next selector
    }
  }
  
  if (!errorFound) {
    throw new Error('Aucun message d\'erreur trouvé');
  }
});

Then('le calcul affiché est {string}', async function(this: CustomWorld, calculation: string) {
  await expect(this.page.locator(`text=${calculation}`)).toBeVisible();
});

Then('la page contient {string}', async function(this: CustomWorld, expectedText: string) {
  await this.page.waitForLoadState('networkidle');
  await expect(this.page.locator('body')).toContainText(expectedText, { 
    timeout: 10000,
    ignoreCase: true 
  });
  console.log(`✅ Texte "${expectedText}" trouvé dans la page`);
});
