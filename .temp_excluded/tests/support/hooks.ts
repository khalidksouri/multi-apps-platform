import { Before, After, BeforeAll, AfterAll, Status } from '@cucumber/cucumber';
import { CustomWorld } from './world';

BeforeAll(async function() {
  console.log('🥒 Démarrage des tests Cucumber BDD');
  console.log('🚀 Applications à tester:');
  console.log('   - Postmath: http://localhost:3001');
  console.log('   - AI4Kids: http://localhost:3004');
  console.log('   - MultiAI: http://localhost:3005');
  console.log('   - BudgetCron: http://localhost:3003');
  console.log('   - UnitFlip: http://localhost:3002');
  
  // Créer les dossiers nécessaires
  const fs = require('fs');
  const dirs = ['test-results/screenshots', 'test-results/videos', 'test-results/traces', 'reports'];
  dirs.forEach(dir => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  });
});

Before(async function(this: CustomWorld, scenario) {
  console.log(`\n🧪 Scénario: ${scenario.pickle.name}`);
  if (this.appName) {
    console.log(`📱 Application: ${this.appName}`);
  }
  
  // IMPORTANT: Initialiser le navigateur pour chaque scénario
  await this.init();
});

After(async function(this: CustomWorld, scenario) {
  // Prendre une capture d'écran en cas d'échec
  if (scenario.result?.status === Status.FAILED) {
    console.log(`❌ Échec du scénario: ${scenario.pickle.name}`);
    await this.takeScreenshot(`failed-${scenario.pickle.name.replace(/\s+/g, '-')}`);
    
    // Attacher les logs de la console si disponibles
    try {
      const logs = await this.page.evaluate(() => {
        // @ts-ignore
        return window.testLogs || [];
      });
      
      if (logs.length > 0) {
        this.attach(JSON.stringify(logs, null, 2), 'application/json');
      }
    } catch (e) {
      // Ignorer les erreurs de logs
    }
  } else if (scenario.result?.status === Status.PASSED) {
    console.log(`✅ Succès du scénario: ${scenario.pickle.name}`);
  }

  // IMPORTANT: Nettoyer après chaque scénario
  await this.cleanup();
});

AfterAll(async function() {
  console.log('\n🏁 Tests Cucumber terminés');
});
