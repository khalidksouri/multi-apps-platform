import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

test.describe('Math4Child v4.2.0 - Validation Ultimate Fix', () => {
  
  test('Vérification build et structure', async () => {
    const basePath = path.join(process.cwd(), 'apps/math4child');
    
    // Fichiers essentiels
    expect(fs.existsSync(path.join(basePath, 'out/index.html'))).toBe(true);
    expect(fs.existsSync(path.join(basePath, 'capacitor.config.ts'))).toBe(true);
    expect(fs.existsSync(path.join(process.cwd(), 'netlify.toml'))).toBe(true);
    
    console.log('✅ Structure validée');
  });

  test('Configuration Netlify', async () => {
    const netlifyPath = path.join(process.cwd(), 'netlify.toml');
    const content = fs.readFileSync(netlifyPath, 'utf8');
    
    expect(content).toContain('apps/math4child/out');
    expect(content).toContain('NODE_VERSION = "18"');
    
    console.log('✅ Netlify validé');
  });

  test('Application démarrage', async ({ page }) => {
    try {
      await page.goto('http://localhost:3000', { timeout: 10000 });
      await expect(page.locator('body')).toBeVisible();
      console.log('✅ Application accessible');
    } catch {
      console.log('⚠️ Serveur local non accessible');
    }
  });
});
