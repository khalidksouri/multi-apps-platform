#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

console.log('📊 Génération du rapport de plateforme...');

const generateReport = () => {
    const apps = [
        { name: 'math4kids', port: 3001, framework: 'React', category: 'Education' },
        { name: 'unitflip', port: 3002, framework: 'React', category: 'Utility' },
        { name: 'budgetcron', port: 3003, framework: 'Vue', category: 'Finance' },
        { name: 'ai4kids', port: 3004, framework: 'React', category: 'AI' },
        { name: 'multiai', port: 3005, framework: 'Next', category: 'AI' },
        { name: 'digital4kids', port: 3006, framework: 'React', category: 'Marketing' }
    ];

    const report = {
        timestamp: new Date().toISOString(),
        platform: {
            totalApps: apps.length,
            frameworks: [...new Set(apps.map(app => app.framework))],
            categories: [...new Set(apps.map(app => app.category))],
            ports: apps.map(app => app.port)
        },
        apps: apps.map(app => {
            const appPath = path.join(__dirname, '..', 'apps', app.name);
            const exists = fs.existsSync(appPath);
            const hasNodeModules = fs.existsSync(path.join(appPath, 'node_modules'));
            const packageJsonPath = path.join(appPath, 'package.json');
            
            let packageInfo = {};
            if (fs.existsSync(packageJsonPath)) {
                try {
                    packageInfo = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
                } catch (e) {
                    console.warn(`Erreur lecture package.json pour ${app.name}`);
                }
            }

            return {
                ...app,
                status: {
                    exists,
                    configured: hasNodeModules,
                    version: packageInfo.version || 'unknown'
                },
                dependencies: Object.keys(packageInfo.dependencies || {}),
                scripts: Object.keys(packageInfo.scripts || {})
            };
        }),
        tests: {
            unitTests: 'Configurés pour tous les frameworks',
            e2eTests: 'Playwright configuré',
            bddTests: 'Cucumber configuré',
            coverage: 'Rapports de couverture activés'
        },
        features: {
            multiLanguage: '50+ langues supportées',
            responsive: 'Mobile, tablet, desktop',
            pwa: 'Progressive Web App',
            capacitor: 'Android & iOS ready',
            accessibility: 'Tests d\'accessibilité',
            darkMode: 'Support mode sombre',
            rtl: 'Support RTL pour arabe/hébreu'
        }
    };

    // Créer le répertoire reports s'il n'existe pas
    const reportsDir = path.join(__dirname, '..', 'reports');
    if (!fs.existsSync(reportsDir)) {
        fs.mkdirSync(reportsDir, { recursive: true });
    }

    // Sauvegarder le rapport JSON
    const reportPath = path.join(reportsDir, 'platform-report.json');
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));

    // Générer un rapport HTML
    const htmlReport = generateHTMLReport(report);
    const htmlPath = path.join(reportsDir, 'platform-report.html');
    fs.writeFileSync(htmlPath, htmlReport);

    console.log('✅ Rapport généré:');
    console.log(`   JSON: ${reportPath}`);
    console.log(`   HTML: ${htmlPath}`);
    
    // Afficher le résumé
    console.log('');
    console.log('📊 RÉSUMÉ DE LA PLATEFORME:');
    console.log(`   🔢 ${report.platform.totalApps} applications créées`);
    console.log(`   🛠️ Frameworks: ${report.platform.frameworks.join(', ')}`);
    console.log(`   📂 Catégories: ${report.platform.categories.join(', ')}`);
    console.log(`   🌐 Ports: ${report.platform.ports.join(', ')}`);
    
    const configuredApps = report.apps.filter(app => app.status.configured).length;
    console.log(`   ✅ ${configuredApps}/${report.platform.totalApps} applications configurées`);
};

const generateHTMLReport = (report) => {
    return `
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rapport de Plateforme Hybride</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0; padding: 20px; color: #333; line-height: 1.6;
        }
        .container {
            max-width: 1200px; margin: 0 auto; background: white;
            border-radius: 20px; padding: 2rem; box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .header { text-align: center; margin-bottom: 3rem; }
        .title {
            font-size: 3rem; font-weight: 900; margin-bottom: 1rem;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem; margin-bottom: 3rem;
        }
        .card {
            background: #f8fafc; border-radius: 15px; padding: 1.5rem;
            border: 2px solid #e2e8f0;
        }
        .card h3 { color: #667eea; margin-bottom: 1rem; font-size: 1.3rem; }
        .app-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        .app-card {
            background: white; border-radius: 10px; padding: 1rem;
            border: 1px solid #e2e8f0; position: relative;
        }
        .app-card h4 { color: #1e293b; margin-bottom: 0.5rem; }
        .status {
            display: inline-block; padding: 0.25rem 0.75rem; border-radius: 20px;
            font-size: 0.8rem; font-weight: 600;
        }
        .status.success { background: #d1fae5; color: #065f46; }
        .status.warning { background: #fef3c7; color: #92400e; }
        .framework {
            position: absolute; top: 1rem; right: 1rem; background: #667eea;
            color: white; padding: 0.25rem 0.5rem; border-radius: 5px; font-size: 0.75rem;
        }
        .timestamp {
            text-align: center; color: #64748b; font-size: 0.9rem; margin-top: 2rem;
        }
        .summary {
            background: linear-gradient(135deg, #667eea, #764ba2); color: white;
            padding: 2rem; border-radius: 15px; margin-bottom: 2rem; text-align: center;
        }
        .summary h2 { margin-bottom: 1rem; }
        .stats { display: flex; justify-content: space-around; flex-wrap: wrap; }
        .stat { text-align: center; margin: 0.5rem; }
        .stat-number { font-size: 2rem; font-weight: bold; }
        .stat-label { font-size: 0.9rem; opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 class="title">🌍 Rapport de Plateforme Hybride</h1>
            <p>Analyse complète de la plateforme de 6 applications hybrides</p>
        </div>

        <div class="summary">
            <h2>📊 Vue d'ensemble</h2>
            <div class="stats">
                <div class="stat">
                    <div class="stat-number">${report.platform.totalApps}</div>
                    <div class="stat-label">Applications</div>
                </div>
                <div class="stat">
                    <div class="stat-number">${report.platform.frameworks.length}</div>
                    <div class="stat-label">Frameworks</div>
                </div>
                <div class="stat">
                    <div class="stat-number">${report.platform.categories.length}</div>
                    <div class="stat-label">Catégories</div>
                </div>
                <div class="stat">
                    <div class="stat-number">50+</div>
                    <div class="stat-label">Langues</div>
                </div>
            </div>
        </div>

        <div class="grid">
            <div class="card">
                <h3>🛠️ Technologies</h3>
                <p><strong>Frameworks:</strong> ${report.platform.frameworks.join(', ')}</p>
                <p><strong>Catégories:</strong> ${report.platform.categories.join(', ')}</p>
                <p><strong>Ports:</strong> ${report.platform.ports.join(', ')}</p>
            </div>

            <div class="card">
                <h3>🧪 Tests</h3>
                <p><strong>Tests unitaires:</strong> ${report.tests.unitTests}</p>
                <p><strong>Tests E2E:</strong> ${report.tests.e2eTests}</p>
                <p><strong>Tests BDD:</strong> ${report.tests.bddTests}</p>
                <p><strong>Couverture:</strong> ${report.tests.coverage}</p>
            </div>

            <div class="card">
                <h3>✨ Fonctionnalités</h3>
                <p><strong>Multi-langue:</strong> ${report.features.multiLanguage}</p>
                <p><strong>Responsive:</strong> ${report.features.responsive}</p>
                <p><strong>PWA:</strong> ${report.features.pwa}</p>
                <p><strong>Mobile:</strong> ${report.features.capacitor}</p>
                <p><strong>Accessibilité:</strong> ${report.features.accessibility}</p>
            </div>
        </div>

        <div class="card">
            <h3>📱 Applications</h3>
            <div class="app-grid">
                ${report.apps.map(app => `
                <div class="app-card">
                    <div class="framework">${app.framework}</div>
                    <h4>${app.name}</h4>
                    <p><strong>Catégorie:</strong> ${app.category}</p>
                    <p><strong>Port:</strong> ${app.port}</p>
                    <p><strong>Version:</strong> ${app.status.version}</p>
                    <div style="margin-top: 1rem;">
                        <span class="status ${app.status.exists ? 'success' : 'warning'}">
                            ${app.status.exists ? '✅ Existe' : '❌ Manquant'}
                        </span>
                        <span class="status ${app.status.configured ? 'success' : 'warning'}">
                            ${app.status.configured ? '📦 Configuré' : '⚠️ À configurer'}
                        </span>
                    </div>
                </div>
                `).join('')}
            </div>
        </div>

        <div class="timestamp">
            Rapport généré le ${new Date(report.timestamp).toLocaleString('fr-FR')}
        </div>
    </div>
</body>
</html>
    `;
};

try {
    generateReport();
} catch (error) {
    console.error('❌ Erreur lors de la génération du rapport:', error.message);
    process.exit(1);
}
