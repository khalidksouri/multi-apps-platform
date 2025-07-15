import { test, expect } from '@playwright/test';

test.describe('PostMath Application', () => {
  
  test('should load the homepage', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier le titre
    await expect(page).toHaveTitle(/PostMath/);
    
    // Vérifier les éléments principaux - utiliser des sélecteurs plus spécifiques
    await expect(page.getByRole('heading', { name: 'PostMath Pro' })).toBeVisible();
    await expect(page.getByRole('heading', { name: 'Calculateur d\'Expédition' })).toBeVisible();
    await expect(page.getByText('Calculez et comparez les frais d\'expédition')).toBeVisible();
  });

  test('should display shipping calculator form', async ({ page }) => {
    await page.goto('/');
    
    // Utiliser des sélecteurs basés sur les placeholders ou data-testid
    await expect(page.getByPlaceholder('Paris')).toBeVisible();
    await expect(page.getByPlaceholder('Lyon')).toBeVisible();
    await expect(page.getByPlaceholder('2.5')).toBeVisible();
    await expect(page.getByPlaceholder('30x20x15')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Calculer les frais' })).toBeVisible();
  });

  test('should calculate shipping costs', async ({ page }) => {
    await page.goto('/');
    
    // Utiliser des sélecteurs basés sur les placeholders
    await page.getByPlaceholder('Paris').fill('Paris');
    await page.getByPlaceholder('Lyon').fill('Lyon');
    await page.getByPlaceholder('2.5').fill('2.5');
    await page.getByPlaceholder('30x20x15').fill('30x20x15');
    
    // Cliquer sur calculer
    await page.getByRole('button', { name: 'Calculer les frais' }).click();
    
    // Attendre les résultats - augmenter le timeout pour le calcul
    await expect(page.getByText('Résultats du calcul')).toBeVisible({ timeout: 10000 });
    
    // Vérifier les transporteurs par nom (plus robuste)
    await expect(page.getByRole('heading', { name: 'Colissimo' })).toBeVisible();
    await expect(page.getByRole('heading', { name: 'Chronopost' })).toBeVisible();
    await expect(page.getByRole('heading', { name: 'DHL Express' })).toBeVisible();
    
    // Vérifier qu'il y a exactement 3 transporteurs affichés
    const transporterHeadings = page.getByRole('heading', { level: 4 });
    await expect(transporterHeadings).toHaveCount(3);
    
    // Vérifier qu'il y a des prix affichés (3 prix)
    await expect(page.locator('text=/\\d+[.,]\\d{2}€/')).toHaveCount(3);
    
    // Vérifier les informations de livraison
    await expect(page.getByText('Livraison: 2-3 jours')).toBeVisible();
    await expect(page.getByText('Livraison: 24h')).toBeVisible();
    await expect(page.getByText('Livraison: 24-48h')).toBeVisible();
    
    // Vérifier que le suivi est inclus pour tous
    await expect(page.getByText('Suivi inclus')).toHaveCount(3);
  });

  test('should show validation errors for empty form', async ({ page }) => {
    await page.goto('/');
    
    // Cliquer sur calculer sans remplir
    await page.getByRole('button', { name: 'Calculer les frais' }).click();
    
    // Vérifier les messages d'erreur
    await expect(page.getByText('Ville de départ requise')).toBeVisible();
    await expect(page.getByText('Ville de destination requise')).toBeVisible();
    await expect(page.getByText('Poids requis')).toBeVisible();
    await expect(page.getByText('Dimensions requises')).toBeVisible();
  });

  test('should display carrier information correctly', async ({ page }) => {
    await page.goto('/');
    
    // Remplir le formulaire
    await page.getByPlaceholder('Paris').fill('Paris');
    await page.getByPlaceholder('Lyon').fill('Lyon');
    await page.getByPlaceholder('2.5').fill('2.5');
    await page.getByPlaceholder('30x20x15').fill('30x20x15');
    
    // Calculer
    await page.getByRole('button', { name: 'Calculer les frais' }).click();
    
    // Attendre les résultats
    await expect(page.getByText('Résultats du calcul')).toBeVisible({ timeout: 10000 });
    
    // Vérifier les détails de chaque transporteur
    // Colissimo
    await expect(page.getByText('6.50€')).toBeVisible();
    
    // Chronopost
    await expect(page.getByText('12.50€')).toBeVisible();
    
    // DHL Express
    await expect(page.getByText('18.00€')).toBeVisible();
    
    // Vérifier que les étoiles de fiabilité sont affichées
    await expect(page.getByText('Fiabilité: ★ ★ ★ ★ ★')).toHaveCount(3);
  });

});
