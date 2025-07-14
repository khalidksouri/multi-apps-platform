// =============================================
// 📄 tests/support/hooks.ts
// =============================================
import { Before, After, BeforeAll, AfterAll, Status } from '@cucumber/cucumber';
import { CustomWorld } from './world';
import * as fs from 'fs';
import * as path from 'path';

// ===== HOOKS GLOBAUX =====
BeforeAll(async function() {
  console.log('🚀 Initialisation de la suite de tests BDD...');
  
  // Créer les dossiers de rapports si nécessaire
  const reportDirs = ['reports', 'test-results', 'test-results/screenshots', 'test-results/videos'];
  reportDirs.forEach(dir => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  });
  
  console.log('📁 Dossiers de rapports créés');
});

AfterAll(async function() {
  console.log('✅ Suite de tests terminée');
  console.log('📊 Rapports disponibles dans le dossier reports/');
});

// ===== HOOKS PAR SCÉNARIO =====
Before(async function(this: CustomWorld, scenario) {
  console.log(`▶️ Démarrage: ${scenario.pickle.name}`);
  
  // Initialiser le World Playwright
  await this.init();
  
  // Enregistrer les informations du scénario
  this.setTestData('scenarioName', scenario.pickle.name);
  this.setTestData('scenarioTags', scenario.pickle.tags.map(tag => tag.name));
  this.setTestData('startTime', Date.now());
});

After(async function(this: CustomWorld, scenario) {
  const endTime = Date.now();
  const startTime = this.getTestData('startTime') || endTime;
  const duration = endTime - startTime;
  
  console.log(`⏱️ Durée: ${duration}ms - ${scenario.pickle.name}`);
  
  // Capture d'écran et vidéo en cas d'échec
  if (scenario.result?.status === Status.FAILED) {
    console.log(`❌ Échec: ${scenario.pickle.name}`);
    
    // Screenshot
    if (this.page) {
      const screenshot = await this.page.screenshot({ fullPage: true });
      this.attach(screenshot, 'image/png');
    }
    
    // HTML snapshot
    if (this.page) {
      const htmlContent = await this.page.content();
      this.attach(htmlContent, 'text/html');
    }
    
    // Performance metrics si activées
    if (process.env.ENABLE_PERFORMANCE_METRICS === 'true') {
      const metrics = Array.from(this.performance.entries());
      this.attach(JSON.stringify(metrics, null, 2), 'application/json');
    }
  } else if (scenario.result?.status === Status.PASSED) {
    console.log(`✅ Succès: ${scenario.pickle.name}`);
  }
  
  // Nettoyage
  await this.cleanup();
});

// ===== HOOKS PAR TAG =====
Before({ tags: '@performance' }, async function(this: CustomWorld) {
  console.log('🚀 Activation du monitoring de performance');
  process.env.ENABLE_PERFORMANCE_METRICS = 'true';
});

Before({ tags: '@accessibility' }, async function(this: CustomWorld) {
  console.log('♿ Activation des vérifications d\'accessibilité');
  process.env.ENABLE_A11Y_CHECKS = 'true';
});

Before({ tags: '@mobile' }, async function(this: CustomWorld) {
  console.log('📱 Configuration mobile activée');
  process.env.DEVICE_TYPE = 'mobile';
});

Before({ tags: '@debug' }, async function(this: CustomWorld) {
  console.log('🐛 Mode debug activé');
  process.env.HEADLESS = 'false';
  process.env.SLOW_MO = '1000';
});

// ===== HOOKS PAR APPLICATION =====
Before({ tags: '@ai4kids' }, async function(this: CustomWorld) {
  this.currentApp = 'ai4kids';
});

Before({ tags: '@multiai' }, async function(this: CustomWorld) {
  this.currentApp = 'multiai';
});

Before({ tags: '@budgetcron' }, async function(this: CustomWorld) {
  this.currentApp = 'budgetcron';
});

Before({ tags: '@unitflip' }, async function(this: CustomWorld) {
  this.currentApp = 'unitflip';
});

Before({ tags: '@postmath' }, async function(this: CustomWorld) {
  this.currentApp = 'postmath';
});