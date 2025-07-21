import { World, IWorldOptions, setWorldConstructor } from '@cucumber/cucumber';
import { Browser, BrowserContext, Page, chromium, firefox, webkit } from 'playwright';

export interface CustomWorldOptions extends IWorldOptions {
  parameters: {
    baseUrl?: string;
    browser?: string;
    headless?: boolean;
    viewport?: { width: number; height: number };
    appName?: string;
    workspacePath?: string;
    environment?: string;
    timeout?: number;
    slowMo?: number;
    screenshot?: string;
    video?: string;
    trace?: string;
    urls?: Record<string, string>;
  };
}

export class CustomWorld extends World {
  public browser!: Browser;
  public context!: BrowserContext;
  public page!: Page;
  public appName?: string;
  public workspacePath?: string;
  public baseUrl: string;

  constructor(options: CustomWorldOptions) {
    super(options);
    
    this.baseUrl = options.parameters?.baseUrl || 'http://localhost:3001';
    this.appName = options.parameters?.appName;
    this.workspacePath = options.parameters?.workspacePath;
  }

  async init() {
    const browserName = this.parameters?.browser || 'chromium';
    const headless = this.parameters?.headless !== false;
    const slowMo = this.parameters?.slowMo || 0;

    // Lancer le navigateur
    switch (browserName) {
      case 'firefox':
        this.browser = await firefox.launch({ headless, slowMo });
        break;
      case 'webkit':
        this.browser = await webkit.launch({ headless, slowMo });
        break;
      default:
        this.browser = await chromium.launch({ headless, slowMo });
    }

    // Créer le contexte
    this.context = await this.browser.newContext({
      viewport: this.parameters?.viewport || { width: 1280, height: 720 },
      recordVideo: this.parameters?.video ? { dir: 'test-results/videos' } : undefined,
    });

    // Activer le tracing si demandé
    if (this.parameters?.trace) {
      await this.context.tracing.start({ screenshots: true, snapshots: true });
    }

    // Créer la page
    this.page = await this.context.newPage();

    // Configurer les timeouts
    this.page.setDefaultTimeout(this.parameters?.timeout || 30000);
    this.page.setDefaultNavigationTimeout(this.parameters?.timeout || 30000);
  }

  async cleanup() {
    if (this.parameters?.trace && this.context) {
      await this.context.tracing.stop({ 
        path: `test-results/traces/${this.appName || 'app'}-trace.zip` 
      });
    }

    if (this.page) await this.page.close();
    if (this.context) await this.context.close();
    if (this.browser) await this.browser.close();
  }

  async takeScreenshot(name: string) {
    if (this.page) {
      const screenshot = await this.page.screenshot({ 
        path: `test-results/screenshots/${name}-${Date.now()}.png`,
        fullPage: true 
      });
      
      // Attacher au rapport Cucumber
      this.attach(screenshot, 'image/png');
      return screenshot;
    }
  }

  async navigateTo(path: string = '') {
    // Vérifier que la page est initialisée
    if (!this.page) {
      throw new Error('La page n\'est pas initialisée. Appelez init() d\'abord.');
    }
    
    const url = `${this.baseUrl}${path}`;
    console.log(`🌐 Navigation vers: ${url}`);
    await this.page.goto(url, { waitUntil: 'networkidle' });
  }
}

setWorldConstructor(CustomWorld);
