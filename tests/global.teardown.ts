// ===================================================================
// TEARDOWN GLOBAL DES TESTS MATH4CHILD
// Nettoyage après tous les tests
// ===================================================================

import { FullConfig } from '@playwright/test';
import fs from 'fs';
import path from 'path';

async function globalTeardown(config: FullConfig) {
  console.log('\n🧹 Nettoyage global des tests Math4Child...\n');
  
  try {
    // Nettoyer les fichiers temporaires
    const testResultsDir = path.join(process.cwd(), 'test-results');
    if (fs.existsSync(testResultsDir)) {
      console.log('📁 Nettoyage des anciens résultats de tests...');
      // Garder seulement les 5 derniers rapports
      cleanOldTestReports(testResultsDir);
    }
    
    // Générer un résumé des tests
    generateTestSummary();
    
  } catch (error) {
    console.error('❌ Erreur lors du nettoyage:', error);
  }
  
  console.log('✅ Nettoyage global terminé\n');
}

function cleanOldTestReports(dir: string) {
  try {
    const files = fs.readdirSync(dir)
      .filter(file => file.includes('playwright-report') || file.includes('screenshots'))
      .map(file => ({
        name: file,
        path: path.join(dir, file),
        time: fs.statSync(path.join(dir, file)).mtime.getTime()
      }))
      .sort((a, b) => b.time - a.time);
    
    // Supprimer tous sauf les 5 plus récents
    files.slice(5).forEach(file => {
      if (fs.existsSync(file.path)) {
        fs.rmSync(file.path, { recursive: true, force: true });
      }
    });
  } catch (error) {
    console.log('⚠️  Impossible de nettoyer les anciens rapports');
  }
}

function generateTestSummary() {
  const summary = {
    timestamp: new Date().toISOString(),
    app: 'Math4Child',
    version: process.env.APP_VERSION || '2.0.0',
    environment: process.env.NODE_ENV || 'test',
    totalDuration: process.hrtime()
  };
  
  console.log('📊 Résumé des tests généré');
}

export default globalTeardown;
