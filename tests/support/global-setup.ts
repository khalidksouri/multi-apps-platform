// =============================================
// 📄 tests/support/global-setup.ts
// =============================================

import { chromium, FullConfig } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';
import ConfigManager from './config';

export default async function globalSetup(config: FullConfig) {
  console.log('🚀 Initialisation globale de la suite de tests...');

  const configManager = ConfigManager.getInstance();
  const testConfig = configManager.getConfig();

  // ===== CRÉATION DES DOSSIERS =====
  const dirsToCreate = [
    'reports',
    'test-results',
    'test-results/screenshots',
    'test-results/videos',
    'test-results/traces',
    'coverage'
  ];

  dirsToCreate.forEach(dir => {
    const fullPath = path.join(testConfig.workspace.root, dir);
    if (!fs.existsSync(fullPath)) {
      fs.mkdirSync(fullPath, { recursive: true });
      console.log(`📁 Dossier créé: ${dir}`);
    }
  });

  // ===== VÉRIFICATION DES APPLICATIONS =====
  console.log('🔍 Vérification de la disponibilité des applications...');
  
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  const healthChecks = Object.entries(testConfig.apps).map(async ([name, app]) => {
    try {
      const response = await page.goto(`${app.url}/api/health`, { 
        timeout: 10000,
        waitUntil: 'networkidle'
      });
      
      if (response?.ok()) {
        console.log(`✅ ${name}: Disponible (${app.url})`);
        return { name, status: 'available', url: app.url };
      } else {
        console.log(`⚠️ ${name}: Health check échoué (${app.url})`);
        return { name, status: 'unhealthy', url: app.url };
      }
    } catch (error) {
      console.log(`❌ ${name}: Non disponible (${app.url})`);
      return { name, status: 'unavailable', url: app.url, error: error.message };
    }
  });

  const results = await Promise.all(healthChecks);
  
  await page.close();
  await context.close();
  await browser.close();

  // ===== SAUVEGARDE DU STATUT =====
  const statusReport = {
    timestamp: new Date().toISOString(),
    environment: testConfig.environment,
    browser: testConfig.browser.name,
    applications: results,
    config: {
      parallel: testConfig.parallel,
      performance: testConfig.performance.enabled,
      accessibility: testConfig.accessibility.enabled,
      security: testConfig.security.enabled
    }
  };

  fs.writeFileSync(
    path.join(testConfig.workspace.root, 'reports', 'setup-status.json'),
    JSON.stringify(statusReport, null, 2)
  );

  // ===== INITIALISATION DES DONNÉES DE TEST =====
  if (testConfig.testData.generate) {
    console.log('🧪 Génération des données de test...');
    await generateTestData();
  }

  // ===== CONFIGURATION DES VARIABLES D'ENVIRONNEMENT =====
  process.env.GLOBAL_SETUP_COMPLETED = 'true';
  process.env.TEST_SESSION_ID = `test-${Date.now()}`;

  console.log('✅ Setup global terminé avec succès!');
  console.log(`📊 Applications vérifiées: ${results.length}`);
  console.log(`📁 Rapports disponibles dans: ${testConfig.reporting.outputDir}`);

  // Retourner les informations pour les tests
  return {
    applications: results,
    config: testConfig
  };
}

// ===== GÉNÉRATION DES DONNÉES DE TEST =====
async function generateTestData() {
  const configManager = ConfigManager.getInstance();
  const testConfig = configManager.getConfig();
  
  const testData = {
    users: [
      {
        id: 'test-user-1',
        email: 'test@example.com',
        name: 'Test User',
        role: 'user',
        password: 'Test123!'
      },
      {
        id: 'test-admin-1',
        email: 'admin@example.com',
        name: 'Test Admin',
        role: 'admin',
        password: 'Admin123!'
      },
      {
        id: 'test-child-1',
        email: 'parent@example.com',
        name: 'Test Child',
        role: 'child',
        age: 8,
        parentEmail: 'parent@example.com'
      }
    ],
    shipping: {
      cities: ['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice'],
      carriers: [
        { id: 'colissimo', name: 'Colissimo', basePrice: 5.50 },
        { id: 'chronopost', name: 'Chronopost', basePrice: 8.90 },
        { id: 'ups', name: 'UPS', basePrice: 12.00 }
      ]
    },
    conversion: {
      temperature: [
        { celsius: 0, fahrenheit: 32 },
        { celsius: 100, fahrenheit: 212 }
      ],
      length: [
        { meters: 1, kilometers: 0.001 },
        { meters: 1000, kilometers: 1 }
      ]
    },
    budget: {
      categories: [
        { name: 'Alimentation', budget: 500, spent: 350 },
        { name: 'Transport', budget: 300, spent: 280 },
        { name: 'Loisirs', budget: 200, spent: 90 }
      ]
    }
  };

  // Sauvegarder les données générées
  const fixturesPath = path.join(testConfig.workspace.root, testConfig.testData.path);
  if (!fs.existsSync(fixturesPath)) {
    fs.mkdirSync(fixturesPath, { recursive: true });
  }

  Object.entries(testData).forEach(([key, data]) => {
    const filename = `${key}-data.json`;
    const filepath = path.join(fixturesPath, filename);
    fs.writeFileSync(filepath, JSON.stringify(data, null, 2));
    console.log(`📄 Données générées: ${filename}`);
  });
}