# =============================================
# 📄 scripts/workspace-helpers.js - Nouveau fichier
# =============================================

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

class WorkspaceManager {
  constructor() {
    this.workspaceRoot = process.cwd();
    this.appsPath = path.join(this.workspaceRoot, 'apps');
    this.packagesPath = path.join(this.workspaceRoot, 'packages');
  }

  // Obtenir toutes les applications
  getApps() {
    return fs.readdirSync(this.appsPath)
      .filter(name => fs.statSync(path.join(this.appsPath, name)).isDirectory())
      .map(name => ({
        name,
        path: path.join(this.appsPath, name),
        packageJson: path.join(this.appsPath, name, 'package.json'),
        port: this.getAppPort(name)
      }));
  }

  // Obtenir le port d'une application
  getAppPort(appName) {
    const portMap = {
      'postmath': 3001,
      'unitflip': 3002,
      'budgetcron': 3003,
      'ai4kids': 3004,
      'multiai': 3005
    };
    return portMap[appName] || 3000;
  }

  // Démarrer une application
  startApp(appName) {
    const app = this.getApps().find(a => a.name === appName);
    if (!app) throw new Error(`App ${appName} not found`);
    
    console.log(`Starting ${appName} on port ${app.port}...`);
    execSync('npm run dev', { cwd: app.path, stdio: 'inherit' });
  }

  // Démarrer toutes les applications
  startAllApps() {
    const apps = this.getApps();
    console.log(`Starting ${apps.length} applications...`);
    
    const commands = apps.map(app => `cd ${app.path} && npm run dev`);
    execSync(`concurrently --kill-others "${commands.join('" "')}"`, { 
      stdio: 'inherit' 
    });
  }

  // Builder une application
  buildApp(appName) {
    const app = this.getApps().find(a => a.name === appName);
    if (!app) throw new Error(`App ${appName} not found`);
    
    console.log(`Building ${appName}...`);
    execSync('npm run build', { cwd: app.path, stdio: 'inherit' });
  }

  // Builder toutes les applications
  buildAllApps() {
    // D'abord builder les packages
    console.log('Building shared packages...');
    execSync('npm run build:packages', { stdio: 'inherit' });
    
    // Ensuite builder les apps
    const apps = this.getApps();
    for (const app of apps) {
      this.buildApp(app.name);
    }
  }

  // Vérifier le statut des applications
  checkAppsStatus() {
    const apps = this.getApps();
    console.log('Checking applications status...');
    
    for (const app of apps) {
      try {
        execSync(`curl -f http://localhost:${app.port}/api/health`, { 
          stdio: 'pipe' 
        });
        console.log(`✅ ${app.name} (port ${app.port}) - OK`);
      } catch (error) {
        console.log(`❌ ${app.name} (port ${app.port}) - Not responding`);
      }
    }
  }
}

module.exports = { WorkspaceManager };
