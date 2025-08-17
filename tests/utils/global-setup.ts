import { chromium, FullConfig } from '@playwright/test';

async function globalSetup(config: FullConfig) {
  console.log('🚀 Setup global Math4Child v4.2.0 - Révolution Éducative Mondiale');
  
  // Créer un navigateur pour les vérifications préliminaires
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  try {
    // Vérifier que l'application est accessible
    await page.goto('http://localhost:3000', { timeout: 30000 });
    await page.waitForLoadState('networkidle');
    
    // Vérifications de conformité essentielles
    const conformityChecks = {
      hasBody: await page.locator('body').isVisible(),
      hasTitle: (await page.title()).length > 0,
      noGotest: await page.locator('text=GOTEST').count() === 0,
      noSiret: await page.locator('text=53958712100028').count() === 0,
      noDevEmail: await page.locator('text=gotesttech@gmail.com').count() === 0,
      hasMath4Child: await page.locator('text=Math4Child').count() > 0
    };
    
    console.log('✅ Vérifications de conformité:', conformityChecks);
    
    if (!conformityChecks.hasBody || !conformityChecks.hasMath4Child) {
      throw new Error('❌ Application non conforme aux spécifications README.md');
    }
    
    if (!conformityChecks.noGotest || !conformityChecks.noSiret || !conformityChecks.noDevEmail) {
      throw new Error('❌ Éléments interdits détectés dans l\'application');
    }
    
    console.log('✅ Application Math4Child v4.2.0 conforme et prête pour les tests');
    
  } catch (error) {
    console.error('❌ Erreur lors du setup global:', error);
    throw error;
  } finally {
    await browser.close();
  }
}

export default globalSetup;
