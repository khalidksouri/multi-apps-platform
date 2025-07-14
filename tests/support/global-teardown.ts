// =============================================
// 📄 tests/support/global-teardown.ts
// =============================================

import { FullConfig } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';
import ConfigManager from './config';

export default async function globalTeardown(config: FullConfig) {
  console.log('🧹 Nettoyage global de la suite de tests...');

  const configManager = ConfigManager.getInstance();
  const testConfig = configManager.getConfig();

  // ===== GÉNÉRATION DU RAPPORT FINAL =====
  await generateFinalReport(testConfig);

  // ===== NETTOYAGE DES DONNÉES DE TEST =====
  if (testConfig.testData.cleanup) {
    await cleanupTestData(testConfig);
  }

  // ===== COMPRESSION DES RAPPORTS =====
  if (testConfig.ci) {
    await compressReports(testConfig);
  }

  // ===== NETTOYAGE DES FICHIERS TEMPORAIRES =====
  await cleanupTempFiles(testConfig);

  // ===== STATISTIQUES FINALES =====
  displayFinalStats(testConfig);

  console.log('✅ Nettoyage global terminé!');
}

// ===== GÉNÉRATION DU RAPPORT FINAL =====
async function generateFinalReport(testConfig: any) {
  console.log('📊 Génération du rapport final...');

  const reportsDir = path.join(testConfig.workspace.root, testConfig.reporting.outputDir);
  
  try {
    // Lire les différents rapports
    const reports = {
      cucumber: await readJsonFile(path.join(reportsDir, 'cucumber-report.json')),
      playwright: await readJsonFile(path.join(reportsDir, 'playwright-report.json')),
      setupStatus: await readJsonFile(path.join(reportsDir, 'setup-status.json'))
    };

    // Calculer les statistiques globales
    const stats = calculateTestStats(reports);

    // Générer le rapport consolidé
    const finalReport = {
      metadata: {
        timestamp: new Date().toISOString(),
        environment: testConfig.environment,
        sessionId: process.env.TEST_SESSION_ID,
        duration: Date.now() - (reports.setupStatus?.timestamp ? new Date(reports.setupStatus.timestamp).getTime() : Date.now())
      },
      configuration: {
        browser: testConfig.browser.name,
        parallel: testConfig.parallel.workers,
        timeout: testConfig.timeouts.test,
        features: {
          performance: testConfig.performance.enabled,
          accessibility: testConfig.accessibility.enabled,
          security: testConfig.security.enabled
        }
      },
      applications: reports.setupStatus?.applications || [],
      statistics: stats,
      summary: {
        totalTests: stats.total,
        passed: stats.passed,
        failed: stats.failed,
        skipped: stats.skipped,
        successRate: stats.total > 0 ? ((stats.passed / stats.total) * 100).toFixed(2) + '%' : '0%'
      }
    };

    // Sauvegarder le rapport final
    fs.writeFileSync(
      path.join(reportsDir, 'final-report.json'),
      JSON.stringify(finalReport, null, 2)
    );

    // Générer un résumé lisible
    const summaryText = generateTextSummary(finalReport);
    fs.writeFileSync(
      path.join(reportsDir, 'test-summary.txt'),
      summaryText
    );

    console.log('📄 Rapport final généré: final-report.json');

  } catch (error) {
    console.warn('⚠️ Erreur lors de la génération du rapport final:', error.message);
  }
}

// ===== CALCUL DES STATISTIQUES =====
function calculateTestStats(reports: any) {
  let stats = {
    total: 0,
    passed: 0,
    failed: 0,
    skipped: 0,
    duration: 0
  };

  // Statistiques Cucumber
  if (reports.cucumber?.features) {
    reports.cucumber.features.forEach((feature: any) => {
      feature.elements?.forEach((element: any) => {
        element.steps?.forEach((step: any) => {
          stats.total++;
          if (step.result?.status === 'passed') stats.passed++;
          else if (step.result?.status === 'failed') stats.failed++;
          else if (step.result?.status === 'skipped') stats.skipped++;
          
          if (step.result?.duration) {
            stats.duration += step.result.duration;
          }
        });
      });
    });
  }

  // Statistiques Playwright
  if (reports.playwright?.suites) {
    // Ajouter logique pour Playwright si nécessaire
  }

  return stats;
}

// ===== GÉNÉRATION DU RÉSUMÉ TEXTUEL =====
function generateTextSummary(report: any): string {
  const { metadata, statistics, summary, applications } = report;
  
  const durationMinutes = Math.round(metadata.duration / 60000);
  const appsStatus = applications.map((app: any) => 
    `  ${app.status === 'available' ? '✅' : '❌'} ${app.name}: ${app.status}`
  ).join('\n');

  return `
# 📊 RAPPORT DE TESTS - ${new Date(metadata.timestamp).toLocaleString('fr-FR')}

## 🎯 Résumé Exécutif
- **Taux de succès**: ${summary.successRate}
- **Tests exécutés**: ${summary.totalTests}
- **Durée totale**: ${durationMinutes} minutes
- **Environnement**: ${metadata.environment}

## 📈 Statistiques Détaillées
- ✅ **Réussis**: ${statistics.passed}
- ❌ **Échoués**: ${statistics.failed}
- ⏭️ **Ignorés**: ${statistics.skipped}

## 🏗️ Applications Testées
${appsStatus}

## ⚙️ Configuration
- **Navigateur**: ${report.configuration.browser}
- **Workers parallèles**: ${report.configuration.parallel}
- **Timeout**: ${report.configuration.timeout}ms
- **Performance**: ${report.configuration.features.performance ? 'Activé' : 'Désactivé'}
- **Accessibilité**: ${report.configuration.features.accessibility ? 'Activé' : 'Désactivé'}
- **Sécurité**: ${report.configuration.features.security ? 'Activé' : 'Désactivé'}

## 📁 Fichiers Générés
- 📊 Rapport final: reports/final-report.json
- 📝 Résumé: reports/test-summary.txt
- 🥒 Rapport Cucumber: reports/cucumber-report.html
- 🎭 Rapport Playwright: reports/playwright-report/

---
Généré par Multi-App Testing Suite v${process.env.npm_package_version || '1.0.0'}
Session ID: ${metadata.sessionId}
`;
}

// ===== NETTOYAGE DES DONNÉES DE TEST =====
async function cleanupTestData(testConfig: any) {
  console.log('🧹 Nettoyage des données de test...');

  const tempDataPaths = [
    path.join(testConfig.workspace.root, 'temp'),
    path.join(testConfig.workspace.root, '.cache'),
    path.join(testConfig.workspace.root, 'node_modules/.cache')
  ];

  for (const dirPath of tempDataPaths) {
    if (fs.existsSync(dirPath)) {
      try {
        await fs.promises.rm(dirPath, { recursive: true, force: true });
        console.log(`🗑️ Supprimé: ${dirPath}`);
      } catch (error) {
        console.warn(`⚠️ Impossible de supprimer ${dirPath}:`, error.message);
      }
    }
  }
}

// ===== COMPRESSION DES RAPPORTS =====
async function compressReports(testConfig: any) {
  console.log('📦 Compression des rapports pour CI...');
  
  // Cette fonction pourrait utiliser une bibliothèque de compression
  // comme archiver ou tar pour créer des archives des rapports
  
  const reportsDir = path.join(testConfig.workspace.root, testConfig.reporting.outputDir);
  
  if (fs.existsSync(reportsDir)) {
    console.log(`📁 Rapports disponibles dans: ${reportsDir}`);
    
    // TODO: Implémenter la compression si nécessaire
    // Par exemple: tar -czf reports.tar.gz reports/
  }
}

// ===== NETTOYAGE DES FICHIERS TEMPORAIRES =====
async function cleanupTempFiles(testConfig: any) {
  const tempFiles = [
    '.tsbuildinfo',
    'junit.xml',
    'test-report.xml'
  ];

  const workspaceRoot = testConfig.workspace.root;

  for (const file of tempFiles) {
    const filePath = path.join(workspaceRoot, file);
    if (fs.existsSync(filePath)) {
      try {
        await fs.promises.unlink(filePath);
        console.log(`🗑️ Fichier temporaire supprimé: ${file}`);
      } catch (error) {
        console.warn(`⚠️ Impossible de supprimer ${file}:`, error.message);
      }
    }
  }
}

// ===== AFFICHAGE DES STATISTIQUES FINALES =====
function displayFinalStats(testConfig: any) {
  const reportsDir = path.join(testConfig.workspace.root, testConfig.reporting.outputDir);
  
  console.log('\n🎯 STATISTIQUES FINALES');
  console.log('========================');
  
  try {
    const finalReport = JSON.parse(
      fs.readFileSync(path.join(reportsDir, 'final-report.json'), 'utf8')
    );

    console.log(`✅ Taux de succès: ${finalReport.summary.successRate}`);
    console.log(`🧪 Tests total: ${finalReport.summary.totalTests}`);
    console.log(`⏱️ Durée: ${Math.round(finalReport.metadata.duration / 60000)} minutes`);
    console.log(`🏗️ Applications: ${finalReport.applications.length}`);
    
    if (finalReport.summary.failed > 0) {
      console.log(`❌ Échecs: ${finalReport.summary.failed}`);
    }

  } catch (error) {
    console.log('📊 Statistiques non disponibles');
  }

  console.log(`📁 Rapports: ${reportsDir}`);
  console.log('========================\n');
}

// ===== UTILITAIRES =====
async function readJsonFile(filePath: string): Promise<any> {
  try {
    if (fs.existsSync(filePath)) {
      const content = await fs.promises.readFile(filePath, 'utf8');
      return JSON.parse(content);
    }
  } catch (error) {
    console.warn(`⚠️ Impossible de lire ${filePath}:`, error.message);
  }
  return null;
}