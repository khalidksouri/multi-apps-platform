import { test, expect } from '@playwright/test';

/**
 * Tests Capacitor avancés pour Math4Child
 * Simulation complète des environnements natifs
 */

test.describe('Math4Child - Tests Capacitor Avancés', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
  });

  test.describe('Environnements Natifs', () => {
    
    test('Android - Simulation complète', async ({ page }) => {
      await page.addInitScript(() => {
        (window as any).Capacitor = {
          isNativePlatform: () => true,
          getPlatform: () => 'android',
          Plugins: {
            StatusBar: {
              setBackgroundColor: () => Promise.resolve(),
              setStyle: () => Promise.resolve(),
            },
            SplashScreen: {
              hide: () => Promise.resolve(),
            },
            Keyboard: {
              addListener: () => ({ remove: () => {} }),
            }
          }
        };
      });
      
      await page.reload();
      await page.waitForLoadState('networkidle');
      
      // Vérifier adaptation Android
      await expect(page.locator('h1')).toBeVisible();
      
      // Test jeu en environnement natif
      await page.click('text=🎁 Essai Gratuit');
      await page.click('text=Version Web');
      await page.click('[data-level="1"]');
      await page.click('text=🚀 Commencer le jeu');
      
      // Interface de jeu doit fonctionner
      await expect(page.locator('[data-testid="math-question"]')).toBeVisible();
    });

    test('iOS - Simulation avec safe areas', async ({ page }) => {
      await page.addInitScript(() => {
        // Simuler iPhone avec notch
        document.documentElement.style.setProperty('--safe-area-inset-bottom', '34px');
        document.documentElement.style.setProperty('--safe-area-inset-top', '47px');
        
        (window as any).Capacitor = {
          isNativePlatform: () => true,
          getPlatform: () => 'ios',
          Plugins: {
            StatusBar: {
              setStyle: () => Promise.resolve(),
            }
          }
        };
      });
      
      await page.setViewportSize({ width: 390, height: 844 }); // iPhone 12 Pro
      await page.reload();
      
      // Vérifier adaptation iOS
      await expect(page.locator('h1')).toBeVisible();
      
      // Test navigation avec safe areas
      const navigation = page.locator('[data-testid="mobile-navigation"], [data-testid="mobile-web-navigation"]');
      if (await navigation.isVisible()) {
        const paddingBottom = await navigation.evaluate(el => 
          window.getComputedStyle(el).paddingBottom
        );
        // Doit avoir padding pour safe areas
        expect(parseInt(paddingBottom)).toBeGreaterThan(16);
      }
    });
  });

  test.describe('Fonctionnalités Cross-Platform', () => {
    
    test('RTL - Arabe en environnement natif', async ({ page }) => {
      // Simuler Capacitor + RTL
      await page.addInitScript(() => {
        (window as any).Capacitor = {
          isNativePlatform: () => true,
          getPlatform: () => 'android'
        };
      });
      
      await page.reload();
      
      // Changer vers arabe
      await page.click('[data-testid="language-selector"]');
      await page.click('text=العربية');
      
      // Vérifier RTL appliqué
      await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
      await expect(page.locator('text=رياضيات4أطفال')).toBeVisible();
      
      // Test navigation RTL native
      await page.click('text=🎁');
      const buttons = page.locator('button');
      await expect(buttons.first()).toBeVisible();
    });

    test('Performance native - Temps de réponse', async ({ page }) => {
      // Simuler environnement mobile natif
      await page.addInitScript(() => {
        (window as any).Capacitor = {
          isNativePlatform: () => true,
          getPlatform: () => 'android'
        };
      });
      
      await page.reload();
      
      // Test réactivité interface
      const startTime = Date.now();
      
      await page.click('text=🎁 Essai Gratuit');
      await page.click('text=Version Web');
      await page.click('[data-level="1"]');
      await page.click('text=🚀 Commencer le jeu');
      
      await expect(page.locator('[data-testid="math-question"]')).toBeVisible();
      
      const responseTime = Date.now() - startTime;
      expect(responseTime).toBeLessThan(3000); // 3s max en natif
      
      console.log(`⚡ Temps de réponse natif: ${responseTime}ms`);
    });
  });

  test.describe('Intégration Stripe Native', () => {
    
    test('Paiement en environnement Capacitor', async ({ page }) => {
      // Mock API + simulation Capacitor
      await page.route('/api/stripe/create-checkout-session', route => {
        const postData = route.request().postData();
        expect(postData).toContain('platform');
        
        route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify({
            url: 'https://checkout.stripe.com/c/pay/capacitor_session'
          })
        });
      });
      
      await page.addInitScript(() => {
        (window as any).Capacitor = {
          isNativePlatform: () => true,
          getPlatform: () => 'ios'
        };
      });
      
      await page.reload();
      
      // Test flow premium natif
      await page.click('text=Premium');
      await expect(page.locator('text=GOTEST - SIRET: 53958712100028')).toBeVisible();
      
      const responsePromise = page.waitForResponse('/api/stripe/create-checkout-session');
      await page.click('text=Commencer Premium - 9,99€/mois');
      
      const response = await responsePromise;
      expect(response.status()).toBe(200);
    });
  });

  test.describe('Tests de Stress', () => {
    
    test('Navigation répétée - Stabilité', async ({ page }) => {
      // Simuler usage intensif
      for (let i = 0; i < 10; i++) {
        await page.click('[data-testid="nav-game"]');
        await page.waitForTimeout(100);
        await page.click('[data-testid="nav-home"]');
        await page.waitForTimeout(100);
      }
      
      // App doit rester stable
      await expect(page.locator('h1')).toBeVisible();
      
      console.log('✅ Test de stress navigation: OK');
    });

    test('Jeux multiples - Gestion mémoire', async ({ page }) => {
      // Simuler plusieurs parties
      for (let game = 0; game < 3; game++) {
        await page.click('text=🎁 Essai Gratuit');
        await page.click('text=Version Web');
        await page.click('[data-level="1"]');
        await page.click('text=🚀 Commencer le jeu');
        
        // Jouer quelques questions
        for (let q = 0; q < 3; q++) {
          const questionText = await page.locator('[data-testid="math-question"]').textContent();
          const match = questionText?.match(/(\d+)\s*\+\s*(\d+)/);
          
          if (match) {
            const result = parseInt(match[1]) + parseInt(match[2]);
            await page.fill('[data-testid="answer-input"]', result.toString());
            await page.click('text=Vérifier');
            await page.waitForTimeout(1000);
          }
        }
        
        // Retour menu
        await page.click('[data-testid="nav-home"]');
      }
      
      // Vérifier stabilité
      await expect(page.locator('h1')).toBeVisible();
      console.log('✅ Test gestion mémoire: OK');
    });
  });
});
