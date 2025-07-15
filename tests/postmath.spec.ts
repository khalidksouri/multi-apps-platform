import { test, expect } from '@playwright/test';

test.describe('PostMath Application', () => {
  
  test('should load the homepage', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier le titre
    await expect(page).toHaveTitle(/PostMath/);
    
    // Vérifier les éléments principaux
    await expect(page.locator('h1')).toContainText('PostMath Pro');
    await expect(page.locator('text=Calculateur intelligent')).toBeVisible();
  });

  test('should display shipping calculator form', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier que le formulaire est présent
    await expect(page.locator('[data-testid="departure-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="destination-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="weight-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="dimensions-input"]')).toBeVisible();
    await expect(page.locator('[data-testid="calculate-button"]')).toBeVisible();
  });

  test('should calculate shipping costs', async ({ page }) => {
    await page.goto('/');
    
    // Remplir le formulaire
    await page.fill('[data-testid="departure-input"]', 'Paris');
    await page.fill('[data-testid="destination-input"]', 'Lyon');
    await page.fill('[data-testid="weight-input"]', '2.5');
    await page.fill('[data-testid="dimensions-input"]', '30x20x15');
    
    // Cliquer sur calculer
    await page.click('[data-testid="calculate-button"]');
    
    // Attendre les résultats
    await expect(page.locator('[data-testid="results-container"]')).toBeVisible({ timeout: 5000 });
    
    // Vérifier qu'au moins un transporteur est affiché
    await expect(page.locator('[data-testid^="carrier-"]')).toHaveCount(2);
    await expect(page.locator('[data-testid="carrier-name"]').first()).toBeVisible();
    await expect(page.locator('[data-testid="carrier-price"]').first()).toBeVisible();
  });

  test('should show validation errors for empty form', async ({ page }) => {
    await page.goto('/');
    
    // Cliquer sur calculer sans remplir
    await page.click('[data-testid="calculate-button"]');
    
    // Vérifier les messages d'erreur
    await expect(page.locator('text=Ville de départ requise')).toBeVisible();
    await expect(page.locator('text=Ville de destination requise')).toBeVisible();
    await expect(page.locator('text=Poids requis')).toBeVisible();
    await expect(page.locator('text=Dimensions requises')).toBeVisible();
  });

});
