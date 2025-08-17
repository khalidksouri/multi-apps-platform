import { FullConfig } from '@playwright/test';

async function globalTeardown(config: FullConfig) {
  console.log('🧹 Nettoyage global Math4Child v4.2.0');
  console.log('📊 Tests terminés - Vérifiez les rapports dans test-results/');
  console.log('🎉 Math4Child v4.2.0 - Révolution Éducative Mondiale validée !');
}

export default globalTeardown;
