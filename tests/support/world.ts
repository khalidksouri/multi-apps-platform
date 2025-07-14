// =============================================
// 📄 tests/support/world.ts
// =============================================
import { setWorldConstructor, World, IWorldOptions } from '@cucumber/cucumber';
import { Browser, BrowserContext, Page, chromium, firefox, webkit } from 'playwright';
import { TestDataManager } from './test-data';
import { PerformanceMonitor } from './performance';

export interface AppUrls {
  ai4kids: string;
  multiai: string;
  budgetcron: string;
  unitflip: string;
  postmath: string;
}

export class CustomWorld extends World {
  // Playwright instances
  browser!: Browser;
  context!: BrowserContext;
  page!: Page;
  
  // Test state
  currentApp!: string;
  testData: Map<string, any> = new Map();
  performance: Map<string, number> = new Map();
  
  // Utilities
  dataManager: TestDataManager;
  performanceMonitor: PerformanceMonitor;
  
  // Configuration
  private config: any;

  constructor(options: IWorldOptions) {
    super(options);
    
    this.config = {
      browser: process.env.BROWSER || 'chromium',
      headless: process.env.HEADLESS !== 'false',
      slowMo: parseInt(process.env.SLOW_MO || '0'),
      viewport: {
        width: parseInt(process.env.VIEWPORT_WIDTH || '1280'),
        height: parseInt(process.env.VIEWPORT_HEIGHT || '720')
      },
      urls: {
        ai4kids: process.env.AI4KIDS_URL || 'http://localhost:3004',
        multiai: process.env.MULTIAI_URL || 'http://localhost:3005',
        budgetcron: process.env.BUDGETCRON_URL || 'http://localhost:3003',
        unitflip: process.env.UNITFLIP_URL || 'http://localhost:3002',
        postmath: process.env.POSTMATH_URL || 'http://localhost:3001'
      },
      features: {
        performance: process.env.ENABLE_PERFORMANCE_METRICS === 'true',
        accessibility: process.env.ENABLE_A11Y_CHECKS === 'true',
        security: process.env.ENABLE_SECURITY_CHECKS === 'true'
      }
    };
  }

  getConfig(): TestConfig {
    return this.config;
  }

  updateConfig(updates: Partial<TestConfig>): void {
    this.config = { ...this.config, ...updates };
  }

  getAppUrl(appName: string): string {
    return this.config.urls[appName.toLowerCase()] || this.config.urls.ai4kids;
  }

  isFeatureEnabled(feature: keyof TestConfig['features']): boolean {
    return this.config.features[feature];
  }
}(process.env.VIEWPORT_HEIGHT || '720')
      },
      urls: {
        ai4kids: process.env.AI4KIDS_URL || 'http://localhost:3004',
        multiai: process.env.MULTIAI_URL || 'http://localhost:3005',
        budgetcron: process.env.BUDGETCRON_URL || 'http://localhost:3003',
        unitflip: process.env.UNITFLIP_URL || 'http://localhost:3002',
        postmath: process.env.POSTMATH_URL || 'http://localhost:3001'
      }
    };
    
    this.dataManager = new TestDataManager();
    this.performanceMonitor = new PerformanceMonitor();
  }

  async init(): Promise<void> {
    // Initialiser le navigateur selon la configuration
    switch (this.config.browser) {
      case 'firefox':
        this.browser = await firefox.launch({
          headless: this.config.headless,
          slowMo: this.config.slowMo
        });
        break;
      case 'webkit':
        this.browser = await webkit.launch({
          headless: this.config.headless,
          slowMo: this.config.slowMo
        });
        break;
      default: // chromium
        this.browser = await chromium.launch({
          headless: this.config.headless,
          slowMo: this.config.slowMo,
          args: ['--no-sandbox', '--disable-dev-shm-usage']
        });
    }
    
    // Créer le contexte avec configuration
    this.context = await this.browser.newContext({
      viewport: this.config.viewport,
      locale: 'fr-FR',
      timezoneId: 'Europe/Paris',
      permissions: ['geolocation'],
      recordVideo: process.env.VIDEO === 'on' ? { dir: 'test-results/videos' } : undefined,
      recordHar: process.env.RECORD_HAR === 'true' ? { path: 'test-results/network.har' } : undefined
    });
    
    // Créer la page
    this.page = await this.context.newPage();
    
    // Configuration des timeouts
    this.page.setDefaultTimeout(parseInt(process.env.ACTION_TIMEOUT || '30000'));
    this.page.setDefaultNavigationTimeout(parseInt(process.env.NAVIGATION_TIMEOUT || '60000'));
    
    // Écouter les erreurs console
    if (process.env.CAPTURE_CONSOLE === 'true') {
      this.page.on('console', msg => {
        console.log(`[${msg.type()}] ${msg.text()}`);
      });
    }
    
    // Initialiser le monitoring de performance
    if (process.env.ENABLE_PERFORMANCE_METRICS === 'true') {
      await this.performanceMonitor.init(this.page);
    }
  }

  async cleanup(): Promise<void> {
    if (this.performanceMonitor) {
      await this.performanceMonitor.stop();
    }
    
    if (this.page) {
      await this.page.close();
    }
    
    if (this.context) {
      await this.context.close();
    }
    
    if (this.browser) {
      await this.browser.close();
    }
  }

  // Méthodes utilitaires
  getAppUrl(appName: string): string {
    return this.config.urls[appName.toLowerCase()] || this.config.urls.ai4kids;
  }

  async takeScreenshot(name: string): Promise<void> {
    if (this.page) {
      await this.page.screenshot({ 
        path: `test-results/screenshots/${name}-${Date.now()}.png`,
        fullPage: true 
      });
    }
  }

  async waitForNetworkIdle(timeout: number = 30000): Promise<void> {
    await this.page.waitForLoadState('networkidle', { timeout });
  }

  setTestData(key: string, value: any): void {
    this.testData.set(key, value);
  }

  getTestData(key: string): any {
    return this.testData.get(key);
  }

  recordPerformanceMetric(name: string, value: number): void {
    this.performance.set(name, value);
  }

  getPerformanceMetric(name: string): number | undefined {
    return this.performance.get(name);
  }
}

setWorldConstructor(CustomWorld);
