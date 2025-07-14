// =============================================
// 📄 scripts/workspace-helpers.js - Corrigé
// =============================================

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

/**
 * Récupère la liste des applications dans le workspace
 */
function getWorkspaceApps() {
  try {
    const appsDir = path.join(__dirname, '../apps');
    if (!fs.existsSync(appsDir)) {
      return [];
    }
    
    return fs.readdirSync(appsDir, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .map(dirent => dirent.name);
  } catch (error) {
    console.error('Erreur lors de la récupération des apps:', error);
    return [];
  }
}

/**
 * Récupère la liste des packages dans le workspace
 */
function getWorkspacePackages() {
  try {
    const packagesDir = path.join(__dirname, '../packages');
    if (!fs.existsSync(packagesDir)) {
      return [];
    }
    
    return fs.readdirSync(packagesDir, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .map(dirent => dirent.name);
  } catch (error) {
    console.error('Erreur lors de la récupération des packages:', error);
    return [];
  }
}

/**
 * Vérifie si une application est démarrée
 */
function isAppRunning(port) {
  try {
    execSync(`lsof -i :${port}`, { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
}

/**
 * Vérifie l'état de santé d'une application
 */
async function checkAppHealth(url) {
  try {
    const response = await fetch(`${url}/api/health`);
    return response.ok;
  } catch {
    return false;
  }
}

/**
 * Construit le projet workspace
 */
function buildWorkspace() {
  console.log('🏗️ Construction du workspace...');
  
  try {
    // Construire les packages partagés
    console.log('📦 Construction des packages...');
    execSync('npm run build:packages', { stdio: 'inherit' });
    
    // Construire les applications
    console.log('🚀 Construction des applications...');
    execSync('npm run build:apps', { stdio: 'inherit' });
    
    console.log('✅ Construction terminée avec succès');
    return true;
  } catch (error) {
    console.error('❌ Erreur lors de la construction:', error.message);
    return false;
  }
}

/**
 * Démarre toutes les applications
 */
function startAllApps() {
  console.log('🚀 Démarrage de toutes les applications...');
  
  try {
    execSync('npm run dev:all', { stdio: 'inherit' });
  } catch (error) {
    console.error('❌ Erreur lors du démarrage:', error.message);
  }
}

/**
 * Teste la connectivité des applications
 */
async function testAppsConnectivity() {
  const apps = [
    { name: 'ai4kids', port: 3004, url: 'http://localhost:3004' },
    { name: 'multiai', port: 3005, url: 'http://localhost:3005' },
    { name: 'budgetcron', port: 3003, url: 'http://localhost:3003' },
    { name: 'unitflip', port: 3002, url: 'http://localhost:3002' },
    { name: 'postmath', port: 3001, url: 'http://localhost:3001' }
  ];

  console.log('🔍 Test de connectivité des applications...');
  
  const results = [];
  
  for (const app of apps) {
    const isRunning = isAppRunning(app.port);
    const isHealthy = isRunning ? await checkAppHealth(app.url) : false;
    
    results.push({
      name: app.name,
      port: app.port,
      url: app.url,
      running: isRunning,
      healthy: isHealthy,
      status: isHealthy ? '✅' : isRunning ? '⚠️' : '❌'
    });
    
    console.log(`${results[results.length - 1].status} ${app.name} (port ${app.port})`);
  }
  
  return results;
}

/**
 * Nettoie le workspace
 */
function cleanWorkspace() {
  console.log('🧹 Nettoyage du workspace...');
  
  try {
    execSync('npm run clean', { stdio: 'inherit' });
    console.log('✅ Nettoyage terminé');
    return true;
  } catch (error) {
    console.error('❌ Erreur lors du nettoyage:', error.message);
    return false;
  }
}

module.exports = {
  getWorkspaceApps,
  getWorkspacePackages,
  isAppRunning,
  checkAppHealth,
  buildWorkspace,
  startAllApps,
  testAppsConnectivity,
  cleanWorkspace
};

// Si le script est exécuté directement
if (require.main === module) {
  const command = process.argv[2];
  
  switch (command) {
    case 'build':
      buildWorkspace();
      break;
    case 'start':
      startAllApps();
      break;
    case 'test':
      testAppsConnectivity();
      break;
    case 'clean':
      cleanWorkspace();
      break;
    case 'list':
      console.log('Applications:', getWorkspaceApps());
      console.log('Packages:', getWorkspacePackages());
      break;
    default:
      console.log(`
Utilisation: node workspace-helpers.js <command>

Commandes disponibles:
  build    - Construit tout le workspace
  start    - Démarre toutes les applications
  test     - Teste la connectivité des applications
  clean    - Nettoie le workspace
  list     - Liste les apps et packages

Exemple: node workspace-helpers.js build
      `);
  }
}