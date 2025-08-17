import { test, expect } from '@playwright/test';

test.describe('Math4Child v4.2.0 - Tests de Performance', () => {
  test('Performance métriques - Chargement initial', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('http://localhost:3000');
    await page.waitForLoadState('networkidle');
    
    const endTime = Date.now();
    const loadTime = endTime - startTime;
    
    // Vérifier que le chargement est rapide
    expect(loadTime).toBeLessThan(5000); // Moins de 5 secondes
    
    // Métriques de performance via Performance API
    const performanceMetrics = await page.evaluate(() => {
      const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
      
      return {
        // Utilisation de fetchStart au lieu de navigationStart (propriété obsolète)
        domContentLoaded: navigation.domContentLoadedEventEnd - navigation.fetchStart,
        loadComplete: navigation.loadEventEnd - navigation.fetchStart,
        firstPaint: performance.getEntriesByType('paint').find(entry => entry.name === 'first-paint')?.startTime || 0,
        firstContentfulPaint: performance.getEntriesByType('paint').find(entry => entry.name === 'first-contentful-paint')?.startTime || 0
      };
    });
    
    // Vérifications des métriques (avec vérifications NaN)
    if (!isNaN(performanceMetrics.domContentLoaded)) {
      expect(performanceMetrics.domContentLoaded).toBeLessThan(3000);
    }
    
    if (!isNaN(performanceMetrics.loadComplete)) {
      expect(performanceMetrics.loadComplete).toBeLessThan(4000);
    }
    
    console.log('📊 Métriques Performance:', performanceMetrics);
  });
  
  test('Performance - Page Exercises avec composants', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('http://localhost:3000/exercises');
    await page.waitForLoadState('networkidle');
    
    const endTime = Date.now();
    const loadTime = endTime - startTime;
    
    // La page exercises avec composants handwriting/voice doit rester rapide
    expect(loadTime).toBeLessThan(6000); // Moins de 6 secondes
    
    // Vérifier que les composants sont visibles
    await expect(page.locator('text=Mode Manuscrit')).toBeVisible();
    await expect(page.locator('text=Assistant Vocal IA')).toBeVisible();
    
    console.log('📊 Page Exercises chargée en:', loadTime, 'ms');
  });
  
  test('Performance - Tests de stress navigation', async ({ page }) => {
    // Test de navigation rapide entre les pages
    const pages = [
      'http://localhost:3000',
      'http://localhost:3000/exercises', 
      'http://localhost:3000/pricing'
    ];
    
    for (const url of pages) {
      const startTime = Date.now();
      await page.goto(url);
      await page.waitForLoadState('networkidle');
      const loadTime = Date.now() - startTime;
      
      expect(loadTime).toBeLessThan(4000);
      console.log(`📊 ${url} chargé en: ${loadTime}ms`);
    }
  });
});
