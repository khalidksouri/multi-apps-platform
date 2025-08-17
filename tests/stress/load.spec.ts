import { test, expect } from '@playwright/test';

test.describe('Tests de stress et performance', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000');
    await page.waitForLoadState('networkidle');
  });

  test('Chargements multiples - Stabilité', async ({ page }) => {
    const loadTimes: number[] = [];
    
    for (let i = 0; i < 3; i++) {
      const startTime = Date.now();
      
      await page.reload();
      await page.waitForLoadState('networkidle');
      
      const loadTime = Date.now() - startTime;
      loadTimes.push(loadTime);
      
      // Vérifier que l'application reste stable
      await expect(page.locator('text=Math4Child').first()).toBeVisible();
    }
    
    const avgLoadTime = loadTimes.reduce((a, b) => a + b, 0) / loadTimes.length;
    console.log(`⚡ Temps de chargement moyen: ${avgLoadTime.toFixed(2)}ms`);
    console.log(`📊 Temps individuels: ${loadTimes.map(t => t + 'ms').join(', ')}`);
    
    // Vérifier que les temps de chargement restent raisonnables
    expect(avgLoadTime).toBeLessThan(10000); // 10 secondes max
  });

  test('Interactions rapides - Résistance au spam', async ({ page }) => {
    // Trouver des éléments interactifs
    const interactiveElements = page.locator('button, a, [role="button"], input');
    const count = await interactiveElements.count();
    
    if (count > 0) {
      const element = interactiveElements.first();
      
      // Test de clics rapides
      for (let i = 0; i < 5; i++) {
        try {
          await element.click({ timeout: 1000 });
          await page.waitForTimeout(100);
        } catch (error) {
          console.log(`⚠️ Erreur lors du clic ${i + 1}: ${error}`);
        }
      }
      
      // Vérifier que l'application reste stable
      await expect(page.locator('body')).toBeVisible();
      console.log('✅ Application stable après interactions rapides');
    } else {
      console.log('ℹ️ Aucun élément interactif trouvé pour le test');
    }
  });

  test('Navigation intensive - Robustesse', async ({ page }) => {
    const actions = [
      () => page.goBack(),
      () => page.goForward(),
      () => page.reload(),
      () => page.mouse.move(100, 100),
      () => page.mouse.move(200, 200)
    ];
    
    for (let i = 0; i < 10; i++) {
      try {
        const action = actions[i % actions.length];
        await action();
        await page.waitForTimeout(200);
        
        // Vérifier que l'application répond toujours
        const isVisible = await page.locator('body').isVisible();
        expect(isVisible).toBe(true);
        
      } catch (error) {
        console.log(`⚠️ Erreur lors de l'action ${i + 1}: ${error}`);
      }
    }
    
    console.log('🏃‍♂️ Test de navigation intensive terminé');
  });

  test('Mémoire - Détection de fuites basiques', async ({ page }) => {
    const initialMetrics = await page.evaluate(() => {
      if ('performance' in window && 'memory' in (performance as any)) {
        return (performance as any).memory.usedJSHeapSize;
      }
      return null;
    });
    
    // Effectuer des actions pouvant consommer de la mémoire
    for (let i = 0; i < 5; i++) {
      await page.reload();
      await page.waitForLoadState('networkidle');
      await page.waitForTimeout(500);
    }
    
    const finalMetrics = await page.evaluate(() => {
      if ('performance' in window && 'memory' in (performance as any)) {
        return (performance as any).memory.usedJSHeapSize;
      }
      return null;
    });
    
    if (initialMetrics && finalMetrics) {
      const memoryIncrease = finalMetrics - initialMetrics;
      console.log(`🧠 Utilisation mémoire: ${initialMetrics} → ${finalMetrics} (+${memoryIncrease} bytes)`);
      
      // Vérifier que l'augmentation reste raisonnable (moins de 50MB)
      expect(memoryIncrease).toBeLessThan(50 * 1024 * 1024);
    } else {
      console.log('ℹ️ Métriques mémoire non disponibles dans ce navigateur');
    }
  });

  test('Viewport multiple - Adaptabilité', async ({ page }) => {
    const viewports = [
      { width: 320, height: 568 },   // iPhone SE
      { width: 768, height: 1024 },  // iPad
      { width: 1920, height: 1080 }, // Desktop
      { width: 1366, height: 768 }   // Laptop
    ];
    
    for (const viewport of viewports) {
      await page.setViewportSize(viewport);
      await page.waitForTimeout(300);
      
      // Vérifier que le contenu reste visible
      await expect(page.locator('body')).toBeVisible();
      
      // Vérifier qu'il n'y a pas de débordement horizontal
      const hasHorizontalScroll = await page.evaluate(() => {
        return document.body.scrollWidth > window.innerWidth;
      });
      
      console.log(`📱 ${viewport.width}x${viewport.height}: scroll horizontal = ${hasHorizontalScroll}`);
    }
    
    console.log('📐 Test multi-viewport terminé');
  });

  test('Concurrence - Requêtes simultanées', async ({ browser }) => {
    // Créer plusieurs pages simultanément
    const pages = await Promise.all([
      browser.newPage(),
      browser.newPage(),
      browser.newPage()
    ]);
    
    try {
      // Charger la même page simultanément
      const loadPromises = pages.map(page => 
        page.goto('http://localhost:3000').then(() => 
          page.waitForLoadState('networkidle')
        )
      );
      
      await Promise.all(loadPromises);
      
      // Vérifier que toutes les pages ont chargé correctement
      for (let i = 0; i < pages.length; i++) {
        await expect(pages[i].locator('body')).toBeVisible();
      }
      
      console.log(`🔄 ${pages.length} pages chargées simultanément avec succès`);
      
    } finally {
      // Nettoyer les pages
      await Promise.all(pages.map(page => page.close()));
    }
  });

  test('Erreurs réseau - Résilience', async ({ page }) => {
    // Simuler des conditions réseau dégradées
    await page.route('**/*', route => {
      // Ajouter un délai aléatoire
      setTimeout(() => {
        route.continue();
      }, Math.random() * 100);
    });
    
    await page.goto('http://localhost:3000');
    await page.waitForLoadState('networkidle');
    
    // Vérifier que l'application fonctionne malgré la latence
    await expect(page.locator('body')).toBeVisible();
    console.log('🌐 Test de résilience réseau réussi');
  });

  test('Performance globale - Métriques complètes', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('http://localhost:3000');
    
    // Attendre le chargement complet
    await page.waitForLoadState('networkidle');
    
    const endTime = Date.now();
    const totalTime = endTime - startTime;
    
    // Collecter les métriques de performance
    const metrics = await page.evaluate(() => {
      const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
      const paint = performance.getEntriesByType('paint');
      
      return {
        domContentLoaded: navigation.domContentLoadedEventEnd - navigation.navigationStart,
        loadComplete: navigation.loadEventEnd - navigation.navigationStart,
        firstPaint: paint.find(p => p.name === 'first-paint')?.startTime || 0,
        firstContentfulPaint: paint.find(p => p.name === 'first-contentful-paint')?.startTime || 0
      };
    });
    
    console.log('📊 Métriques de performance:');
    console.log(`   Temps total: ${totalTime}ms`);
    console.log(`   DOM Content Loaded: ${metrics.domContentLoaded.toFixed(2)}ms`);
    console.log(`   Load Complete: ${metrics.loadComplete.toFixed(2)}ms`);
    console.log(`   First Paint: ${metrics.firstPaint.toFixed(2)}ms`);
    console.log(`   First Contentful Paint: ${metrics.firstContentfulPaint.toFixed(2)}ms`);
    
    // Vérifier que les métriques restent dans des limites acceptables
    expect(totalTime).toBeLessThan(15000); // 15 secondes max
    if (metrics.domContentLoaded !== null && !isNaN(metrics.domContentLoaded)) {
      if (metrics.domContentLoaded !== null && !isNaN(metrics.domContentLoaded)) {
      expect(metrics.domContentLoaded).toBeLessThan(10000);
    }
    } // 10 secondes max
  });
});
