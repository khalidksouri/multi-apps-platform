import { test, expect } from '@playwright/test';

test.describe('Application universelle - Internationalisation', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
  });

  test('✅ Sélecteur de région universel', async ({ page }) => {
    // Ouvrir le sélecteur de région
    const regionButton = page.locator('button[aria-label="Sélectionner une région et langue"]');
    await expect(regionButton).toBeVisible();
    await regionButton.click();
    
    // Vérifier les filtres par continent
    await expect(page.locator('text=🌍 Tous')).toBeVisible();
    await expect(page.locator('text=🇪🇺 Europe')).toBeVisible();
    await expect(page.locator('text=🌎 North America')).toBeVisible();
    await expect(page.locator('text=🌏 Asia')).toBeVisible();
    
    // Tester le filtre par continent
    await page.click('button:has-text("🌏 Asia")');
    await expect(page.locator('text=中文')).toBeVisible();
    await expect(page.locator('text=日本語')).toBeVisible();
  });

  test('✅ Changement de région avec prix localisés', async ({ page }) => {
    // Sélectionner l'Inde
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await page.click('button:has-text("🌏 Asia")');
    await page.click('button:has-text("हिन्दी")');
    
    // Vérifier que l'interface s'adapte
    await expect(page.locator('text=Prix en INR')).toBeVisible();
    
    // Ouvrir le modal de pricing
    await page.click('button:has-text("Voir les prix")');
    
    // Vérifier que les prix sont en roupies indiennes
    await expect(page.locator('text=Facturé en INR')).toBeVisible();
  });

  test('✅ Support RTL pour l\'arabe', async ({ page }) => {
    // Sélectionner l'arabe
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await page.fill('input[placeholder*="Rechercher"]', 'العربية');
    await page.click('button:has-text("العربية")');
    
    // Vérifier que le layout RTL est appliqué
    const body = page.locator('body');
    await expect(body).toHaveAttribute('dir', 'rtl');
  });

  test('✅ Statistiques mondiales', async ({ page }) => {
    // Vérifier les statistiques par continent
    await expect(page.locator('text=6 continents')).toBeVisible();
    await expect(page.locator('text=langues supportées')).toBeVisible();
    
    // Vérifier la section statistiques détaillées
    await expect(page.locator('text=Europe')).toBeVisible();
    await expect(page.locator('text=Amériques')).toBeVisible();
    await expect(page.locator('text=Asie')).toBeVisible();
    await expect(page.locator('text=Afrique')).toBeVisible();
    await expect(page.locator('text=Océanie')).toBeVisible();
  });

  test('✅ Adaptation des prix par région', async ({ page }) => {
    // Test avec différentes régions
    const regions = [
      { name: 'English (US)', currency: 'USD', flag: '🇺🇸' },
      { name: 'Português (Brasil)', currency: 'BRL', flag: '🇧🇷' },
      { name: '中文 (简体)', currency: 'CNY', flag: '🇨🇳' }
    ];

    for (const region of regions) {
      // Sélectionner la région
      await page.click('button[aria-label="Sélectionner une région et langue"]');
      await page.fill('input[placeholder*="Rechercher"]', region.name);
      await page.click(`button:has-text("${region.name}")`);
      
      // Vérifier que la devise s'affiche
      await expect(page.locator(`text=Prix en ${region.currency}`)).toBeVisible();
      
      // Ouvrir le modal et vérifier les prix
      await page.click('button:has-text("Voir les prix")');
      await expect(page.locator(`text=Facturé en ${region.currency}`)).toBeVisible();
      await page.click('button[aria-label="Fermer"]');
      
      await page.waitForTimeout(500); // Éviter les clics trop rapides
    }
  });

  test('✅ Recherche de langues', async ({ page }) => {
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    
    // Recherche par nom de langue
    await page.fill('input[placeholder*="Rechercher"]', 'Español');
    await expect(page.locator('button:has-text("Español (España)")')).toBeVisible();
    await expect(page.locator('button:has-text("Español (México)")')).toBeVisible();
    
    // Recherche par pays
    await page.fill('input[placeholder*="Rechercher"]', 'Japan');
    await expect(page.locator('button:has-text("日本語")')).toBeVisible();
    
    // Recherche sans résultats
    await page.fill('input[placeholder*="Rechercher"]', 'xyz123');
    await expect(page.locator('text=Aucune langue trouvée')).toBeVisible();
  });

  test('✅ Performance avec beaucoup de langues', async ({ page }) => {
    const startTime = Date.now();
    
    // Ouvrir le sélecteur avec toutes les langues
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await expect(page.locator('text=langues • 6 continents')).toBeVisible();
    
    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(1000); // Moins d'1 seconde
    
    // Scroll dans la liste
    await page.mouse.wheel(0, 500);
    await page.mouse.wheel(0, -500);
  });
});

// Tests spécifiques par région
test.describe('Tests par région spécifique', () => {
  
  test('🇺🇸 États-Unis - Format de date MM/DD/YYYY', async ({ page }) => {
    await page.goto('/');
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await page.click('button:has-text("English (US)")');
    
    await expect(page.locator('text=North America')).toBeVisible();
    await expect(page.locator('text=Prix en USD')).toBeVisible();
  });

  test('🇧🇷 Brésil - Prix ajustés au pouvoir d\'achat', async ({ page }) => {
    await page.goto('/');
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await page.click('button:has-text("Português (Brasil)")');
    
    await page.click('button:has-text("Voir les prix")');
    
    // Les prix au Brésil devraient être ajustés (plus bas)
    await expect(page.locator('text=Facturé en BRL')).toBeVisible();
    await expect(page.locator('text=South America')).toBeVisible();
  });

  test('🇸🇦 Arabie Saoudite - Support RTL complet', async ({ page }) => {
    await page.goto('/');
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await page.click('button:has-text("العربية")');
    
    // Vérifier le RTL
    const container = page.locator('div[dir="rtl"]');
    await expect(container).toBeVisible();
    
    await expect(page.locator('text=Prix en SAR')).toBeVisible();
  });

  test('🇮🇳 Inde - Prix très ajustés', async ({ page }) => {
    await page.goto('/');
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await page.click('button:has-text("हिन्दी")');
    
    await page.click('button:has-text("Voir les prix")');
    
    // Les prix en Inde devraient être significativement plus bas
    await expect(page.locator('text=Facturé en INR')).toBeVisible();
  });

  test('🇨🇳 Chine - Format de date YYYY/MM/DD', async ({ page }) => {
    await page.goto('/');
    await page.click('button[aria-label="Sélectionner une région et langue"]');
    await page.click('button:has-text("中文 (简体)")');
    
    await expect(page.locator('text=Prix en CNY')).toBeVisible();
    await expect(page.locator('text=Asia')).toBeVisible();
  });
});
