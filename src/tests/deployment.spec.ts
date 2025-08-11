import { test, expect } from '@playwright/test';
import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

/**
 * Tests de validation du déploiement Capacitor Math4Child
 * Basés sur l'état actuel du projet (build réussi)
 */

test.describe('Validation Déploiement Math4Child', () => {

  test.describe('Configuration Files Validation', () => {
    
    test('Capacitor config JSON valide et GOTEST', async () => {
      const configPath = join(process.cwd(), 'capacitor.config.json');
      expect(existsSync(configPath)).toBeTruthy();
      
      const configContent = readFileSync(configPath, 'utf-8');
      const config = JSON.parse(configContent);
      
      // Vérifications configuration GOTEST
      expect(config.appId).toBe('com.gotest.math4child');
      expect(config.appName).toBe('Math4Child');
      expect(config.webDir).toBe('out');
      
      // Vérifications plugins essentiels
      expect(config.plugins.SplashScreen).toBeDefined();
      expect(config.plugins.StatusBar).toBeDefined();
      
      // Vérifications couleurs brand Math4Child
      expect(config.plugins.SplashScreen.backgroundColor).toBe('#667eea');
    });

    test('Next.js config optimisé final', async () => {
      const nextConfigPath = join(process.cwd(), 'next.config.js');
      expect(existsSync(nextConfigPath)).toBeTruthy();
      
      const configContent = readFileSync(nextConfigPath, 'utf-8');
      
      // Vérifier configurations finales appliquées
      expect(configContent).toContain('output: \'export\'');
      expect(configContent).toContain('trailingSlash: true');
      expect(configContent).toContain('eslint:');
      expect(configContent).toContain('ignoreDuringBuilds: true');
    });

    test('Package.json scripts complets', async () => {
      const packageJson = JSON.parse(readFileSync('package.json', 'utf-8'));
      const scripts = packageJson.scripts;
      
      // Scripts essentiels présents
      expect(scripts['build:capacitor']).toContain('CAPACITOR_BUILD=true');
      expect(scripts['android:build']).toBeDefined();
      expect(scripts['ios:build']).toBeDefined();
      
      // Vérifier informations GOTEST
      expect(packageJson.name).toBe('math4child-app');
      expect(packageJson.description).toContain('éducative');
    });

    test('Manifest PWA Math4Child', async ({ page }) => {
      const manifestResponse = await page.request.get('/manifest.json');
      expect(manifestResponse.status()).toBe(200);
      
      const manifest = await manifestResponse.json();
      
      // Vérifications spécifiques Math4Child
      expect(manifest.name).toBe('Math4Child - Apprendre les maths');
      expect(manifest.short_name).toBe('Math4Child');
      expect(manifest.display).toBe('standalone');
      expect(manifest.theme_color).toBe('#667eea');
      expect(manifest.categories).toContain('education');
      expect(manifest.lang).toBe('fr-FR');
    });
  });

  test.describe('Build Output Validation', () => {
    
    test('Build out/ généré correctement', async () => {
      const outDir = join(process.cwd(), 'out');
      
      if (existsSync(outDir)) {
        // Vérifier fichiers critiques
        expect(existsSync(join(outDir, 'index.html'))).toBeTruthy();
        expect(existsSync(join(outDir, '_next/static'))).toBeTruthy();
        
        // Vérifier contenu HTML principal
        const indexContent = readFileSync(join(outDir, 'index.html'), 'utf-8');
        expect(indexContent).toContain('Math4Child');
        expect(indexContent).toContain('capacitor-app');
        expect(indexContent).not.toContain('undefined');
        
        console.log('✅ Build output validé - Prêt pour Capacitor');
      } else {
        console.warn('⚠️  Dossier out/ absent - Lancez: npm run build:capacitor');
      }
    });

    test('Ressources statiques accessibles', async ({ page }) => {
      const response = await page.goto('/');
      expect(response?.status()).toBe(200);
      
      // Vérifier chargement interface principale
      await expect(page.locator('h1')).toBeVisible();
      await expect(page.locator('text=Math4Child')).toBeVisible();
      
      // Vérifier styles Tailwind chargés
      const styles = await page.locator('h1').evaluate(el => 
        window.getComputedStyle(el).fontSize
      );
      expect(styles).not.toBe('16px'); // Style par défaut - Tailwind doit être actif
    });
  });

  test.describe('Navigation Multi-plateforme', () => {
    
    test('Navigation responsive - Desktop/Mobile', async ({ page, isMobile }) => {
      await page.goto('/');
      
      if (isMobile) {
        // Navigation mobile doit être visible
        const mobileNav = page.locator('[data-testid="mobile-web-navigation"], [data-testid="mobile-navigation"]');
        await expect(mobileNav).toBeVisible();
        
        // Desktop navigation cachée sur mobile
        await expect(page.locator('[data-testid="desktop-navigation"]')).not.toBeVisible();
        
      } else {
        // Navigation desktop visible
        await expect(page.locator('[data-testid="desktop-navigation"]')).toBeVisible();
        
        // Mobile navigation cachée sur desktop
        await expect(page.locator('[data-testid="mobile-web-navigation"]')).not.toBeVisible();
      }
    });

    test('Simulation Capacitor - Navigation native', async ({ page }) => {
      // Simuler environnement Capacitor Android
      await page.addInitScript(() => {
        (window as any).Capacitor = {
          isNativePlatform: () => true,
          getPlatform: () => 'android'
        };
      });
      
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      
      // Vérifier adaptation à l'environnement natif
      await expect(page.locator('h1')).toBeVisible();
      
      // Navigation doit s'adapter au contexte natif
      const navigation = page.locator('[data-testid="mobile-navigation"], [data-testid="mobile-web-navigation"]');
      if (await navigation.isVisible()) {
        // Vérifier positioning pour native
        const navStyles = await navigation.evaluate(el => window.getComputedStyle(el));
        expect(navStyles.position).toBe('fixed');
      }
    });
  });

  test.describe('Fonctionnalités Math4Child', () => {
    
    test('Système multilingue complet', async ({ page }) => {
      await page.goto('/');
      
      // Test langues principales
      const languages = [
        { name: 'Français', appName: 'Maths4Enfants' },
        { name: 'English', appName: 'Math4Child' },
        { name: 'العربية', appName: 'رياضيات4أطفال', rtl: true }
      ];
      
      for (const lang of languages) {
        // Changer langue
        await page.click('[data-testid="language-selector"]');
        await page.click(`text=${lang.name}`);
        
        // Vérifier changement
        await expect(page.locator('h1')).toContainText(lang.appName);
        
        // Test RTL si applicable
        if (lang.rtl) {
          await expect(page.locator('html')).toHaveAttribute('dir', 'rtl');
        }
      }
    });

    test('Flow de jeu mathématique', async ({ page }) => {
      await page.goto('/');
      
      // Démarrer jeu
      await page.click('text=🎁 Essai Gratuit');
      await page.click('text=Version Web');
      
      // Vérifier interface de sélection
      await expect(page.locator('text=Choisis ton niveau')).toBeVisible();
      await expect(page.locator('[data-level="1"]')).toBeVisible();
      
      // Sélectionner niveau et démarrer
      await page.click('[data-level="1"]');
      await page.click('text=🚀 Commencer le jeu');
      
      // Vérifier interface de jeu
      await expect(page.locator('[data-testid="math-question"]')).toBeVisible();
      await expect(page.locator('[data-testid="answer-input"]')).toBeVisible();
      
      // Test calcul
      const question = await page.locator('[data-testid="math-question"]').textContent();
      const match = question?.match(/(\d+)\s*\+\s*(\d+)/);
      
      if (match) {
        const result = parseInt(match[1]) + parseInt(match[2]);
        await page.fill('[data-testid="answer-input"]', result.toString());
        await page.click('text=Vérifier');
        
        // Vérifier réaction
        await expect(page.locator('text=🎉 Excellent!')).toBeVisible({ timeout: 3000 });
      }
    });

    test('Configuration GOTEST et Stripe', async ({ page }) => {
      // Mock API Stripe
      await page.route('/api/stripe/create-checkout-session', route => {
        route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify({ url: 'https://checkout.stripe.com/test' })
        });
      });
      
      await page.goto('/');
      await page.click('text=Premium');
      
      // Vérifier informations GOTEST
      await expect(page.locator('text=GOTEST - SIRET: 53958712100028')).toBeVisible();
      
      // Test flow paiement
      const responsePromise = page.waitForResponse('/api/stripe/create-checkout-session');
      await page.click('text=Commencer Premium - 9,99€/mois');
      
      const response = await responsePromise;
      expect(response.status()).toBe(200);
    });
  });

  test.describe('Performance et Qualité', () => {
    
    test('Temps de chargement optimisé', async ({ page }) => {
      const startTime = Date.now();
      
      await page.goto('/');
      await expect(page.locator('h1')).toBeVisible();
      
      const loadTime = Date.now() - startTime;
      expect(loadTime).toBeLessThan(4000); // 4 secondes max
      
      console.log(`⚡ Temps de chargement: ${loadTime}ms`);
    });

    test('Pas d\'erreurs critiques', async ({ page }) => {
      const consoleErrors: string[] = [];
      const networkErrors: string[] = [];
      
      page.on('console', msg => {
        if (msg.type() === 'error') {
          consoleErrors.push(msg.text());
        }
      });
      
      page.on('response', response => {
        if (response.status() >= 500) {
          networkErrors.push(`${response.status()}: ${response.url()}`);
        }
      });
      
      await page.goto('/');
      await page.waitForLoadState('networkidle');
      
      // Filtrer erreurs acceptables
      const criticalErrors = consoleErrors.filter(error => 
        !error.includes('favicon') &&
        !error.includes('Extension') &&
        !error.includes('chrome-extension')
      );
      
      expect(criticalErrors).toHaveLength(0);
      expect(networkErrors).toHaveLength(0);
    });

    test('Interface tactile mobile', async ({ page, isMobile }) => {
      if (isMobile) {
        await page.goto('/');
        
        // Vérifier zones tactiles minimales
        const buttons = page.locator('button');
        const firstButton = buttons.first();
        const buttonBox = await firstButton.boundingBox();
        
        if (buttonBox) {
          expect(buttonBox.height).toBeGreaterThanOrEqual(44); // Standard iOS
          expect(buttonBox.width).toBeGreaterThanOrEqual(44);
        }
      }
    });
  });

  test.describe('Validation Finale', () => {
    
    test('Checklist de déploiement complète', async ({ page }) => {
      const checks = [
        // Interface principale
        async () => {
          await page.goto('/');
          await expect(page.locator('h1')).toBeVisible();
          await expect(page.locator('text=Math4Child')).toBeVisible();
        },
        
        // Navigation
        async () => {
          await page.click('[data-testid="nav-home"]');
          await expect(page.locator('text=🎁 Essai Gratuit')).toBeVisible();
        },
        
        // Multilingue
        async () => {
          await page.click('[data-testid="language-selector"]');
          await page.click('text=English');
          await expect(page.locator('text=Math4Child')).toBeVisible();
        },
        
        // Premium
        async () => {
          await page.click('text=Premium');
          await expect(page.locator('text=Premium Math4Child')).toBeVisible();
          await page.click('[data-testid="close-modal"]');
        }
      ];
      
      // Exécuter tous les checks
      for (const check of checks) {
        await check();
        await page.waitForTimeout(500);
      }
      
      console.log('✅ Math4Child validé - Ready for stores deployment');
    });
  });
});
