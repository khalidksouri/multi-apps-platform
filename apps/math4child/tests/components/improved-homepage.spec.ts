import { test, expect } from '@playwright/test';

test.describe('Page d\'accueil améliorée - Math4Child', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
  });

  test('✅ Header et navigation', async ({ page }) => {
    // Vérifier le logo et le titre
    await expect(page.locator('text=Math pour enfants')).toBeVisible();
    await expect(page.locator('text=L\'app n°1 des familles')).toBeVisible();
    
    // Vérifier les statistiques dans le header
    await expect(page.locator('text=100k+ familles')).toBeVisible();
    await expect(page.locator('text=47+ langues')).toBeVisible();
  });

  test('✅ Sélecteur de langue amélioré', async ({ page }) => {
    // Ouvrir le sélecteur de langue
    const languageButton = page.locator('button[aria-label="Sélectionner une langue"]');
    await expect(languageButton).toBeVisible();
    await languageButton.click();
    
    // Vérifier que le dropdown s'ouvre
    await expect(page.locator('input[placeholder="Rechercher une langue..."]')).toBeVisible();
    
    // Tester la recherche
    await page.fill('input[placeholder="Rechercher une langue..."]', 'English');
    await expect(page.locator('text=English')).toBeVisible();
    
    // Sélectionner une langue
    await page.click('button:has-text("English")');
    await expect(page.locator('input[placeholder="Rechercher une langue..."]')).not.toBeVisible();
  });

  test('✅ Modal de pricing', async ({ page }) => {
    // Ouvrir le modal
    await page.click('button:has-text("Voir les prix")');
    
    // Vérifier que le modal s'ouvre
    await expect(page.locator('text=Choisissez votre plan')).toBeVisible();
    
    // Tester la sélection de période
    await page.click('button:has-text("Trimestriel")');
    await expect(page.locator('text=8.99€')).toBeVisible();
    
    // Fermer avec Escape
    await page.keyboard.press('Escape');
    await expect(page.locator('text=Choisissez votre plan')).not.toBeVisible();
  });

  test('✅ Fonctionnalités et animations', async ({ page }) => {
    // Vérifier les cartes de fonctionnalités
    const featureCards = page.locator('.group.relative.bg-white.rounded-2xl');
    await expect(featureCards).toHaveCount(3);
    
    // Tester l'effet hover
    const firstCard = featureCards.first();
    await firstCard.hover();
  });

  test('✅ Accessibilité', async ({ page }) => {
    // Vérifier les labels ARIA
    await expect(page.locator('button[aria-label="Sélectionner une langue"]')).toBeVisible();
    
    // Tester la navigation clavier
    await page.keyboard.press('Tab');
    
    // Vérifier les rôles dans le modal
    await page.click('button:has-text("Voir les prix")');
    await expect(page.locator('[role="dialog"]')).toBeVisible();
    await expect(page.locator('[aria-modal="true"]')).toBeVisible();
  });
});
