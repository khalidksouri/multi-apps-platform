// ===================================================================
// SETUP GLOBAL DES TESTS MATH4CHILD
// Configuration avant tous les tests
// ===================================================================

import { chromium, FullConfig } from '@playwright/test';
import path from 'path';

async function globalSetup(config: FullConfig) {
  console.log('\n🚀 Setup global des tests Math4Child...\n');
  
  // Vérifier que l'application est disponible
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  try {
    console.log('📡 Vérification de la disponibilité de l\'application...');
    await page.goto(config.projects[0].use.baseURL || 'http://localhost:3000', {
      timeout: 60000,
      waitUntil: 'networkidle'
    });
    
    // Vérifier que Math4Child est bien chargé
    await page.waitForSelector('h1:has-text("Math4Child")', { timeout: 30000 });
    console.log('✅ Application Math4Child disponible');
    
    // Setup initial des données de test si nécessaire
    await setupTestData(page);
    
  } catch (error) {
    console.error('❌ Erreur lors de la vérification de l\'application:', error);
    throw error;
  } finally {
    await browser.close();
  }
  
  console.log('🎉 Setup global terminé\n');
}

async function setupTestData(page: any) {
  // Initialiser le localStorage avec des données de test
  await page.evaluate(() => {
    // Données de progression de test
    const testProgress = {
      level: 'beginner',
      correctAnswers: {
        beginner: 5,
        elementary: 0,
        intermediate: 0,
        advanced: 0,
        expert: 0
      },
      unlockedLevels: ['beginner'],
      totalQuestions: 10,
      freeQuestionsUsed: 5
    };
    
    localStorage.setItem('math4child-progress', JSON.stringify(testProgress));
    localStorage.setItem('math4child-language', 'en');
    localStorage.setItem('math4child-test-mode', 'true');
  });
  
  console.log('📊 Données de test initialisées');
}

export default globalSetup;
