const { execSync } = require('child_process');

console.log('🥒 Test Cucumber simple...');

try {
  // Test sans profil
  console.log('Test 1: Sans profil');
  execSync('TS_NODE_PROJECT=tsconfig.cucumber.json npx cucumber-js tests/features/smoke.feature --require "tests/steps/**/*.ts" --require "tests/support/**/*.ts" --require-module ts-node/register', {
    stdio: 'inherit',
    env: { ...process.env, TS_NODE_PROJECT: 'tsconfig.cucumber.json' }
  });
  
  console.log('✅ Test réussi !');
} catch (error) {
  console.error('❌ Erreur:', error.message);
}
