// =============================================
// 📄 tests/support/config.ts - Configuration complète workspace
// =============================================

import * as path from 'path';
import * as fs from 'fs';

// =============================================
// INTERFACES ET TYPES
// =============================================

export interface ViewportConfig {
  width: number;
  height: number;
  deviceScaleFactor?: number;
  isMobile?: boolean;
  hasTouch?: boolean;
}

export interface BrowserConfig {
  name: string;
  headless: boolean;
  slowMo: number;
  devtools: boolean;
  args: string[];
  launchOptions: any;
}

export interface TimeoutConfig {
  test: number;
  action: number;
  navigation: number;
  expect: number;
  performance: number;
  accessibility: number;
  security: number;
}

export interface PerformanceConfig {
  enabled: boolean;
  collectMetrics: boolean;
  thresholds: {
    pageLoad: number;
    domContentLoaded: number;
    firstContentfulPaint: number;
    largestContentfulPaint: number;
    cumulativeLayoutShift: number;
    totalBlockingTime: number;
    interaction: number;
    apiResponse: number;
  };
  monitoring: {
    cpu: boolean;
    memory: boolean;
    network: boolean;
    fps: boolean;
  };
}

export interface AccessibilityConfig {
  enabled: boolean;
  standard: string;
  rules: {
    disabled: string[];
    custom: any[];
  };
  testing: {
    colorContrast: boolean;
    keyboardNavigation: boolean;
    screenReader: boolean;
    focusManagement: boolean;
  };
  wcagLevel: 'A' | 'AA' | 'AAA';
}

export interface SecurityConfig {
  enabled: boolean;
  checks: {
    csp: boolean;
    xss: boolean;
    clickjacking: boolean;
    https: boolean;
    headers: boolean;
    cors: boolean;
  };
  headers: {
    required: string[];
    forbidden: string[];
  };
  scanning: {
    vulnerabilities: boolean;
    dependencies: boolean;
    secrets: boolean;
  };
}

export interface WorkspaceConfig {
  root: string;
  appsPath: string;
  packagesPath: string;
  testsPath: string;
  reportsPath: string;
  sharedPackages: string[];
}

export interface AppConfig {
  name: string;
  url: string;
  port: number;
  healthCheck: string;
  startCommand?: string;
  buildCommand?: string;
  environment: Record<string, string>;
  features: string[];
  workspace: {
    path: string;
    packageJson: string;
    nextConfig?: string;
  };
  database?: {
    url: string;
    name: string;
    reset: boolean;
  };
}

export interface TestDataConfig {
  path: string;
  generate: boolean;
  cleanup: boolean;
  validate: boolean;
  seed: string | number;
  fixtures: {
    users: string;
    budget: string;
    shipping: string;
    conversion: string;
    aiServices: string;
    learningModules: string;
  };
}

export interface ReportingConfig {
  formats: string[];
  outputDir: string;
  merge: boolean;
  upload: boolean;
  retention: number;
  screenshots: {
    onFailure: boolean;
    onSuccess: boolean;
    fullPage: boolean;
    quality: number;
  };
  videos: {
    enabled: boolean;
    retain: string;
    quality: string;
    fps: number;
  };
  traces: {
    enabled: boolean;
    retain: string;
    sources: boolean;
    screenshots: boolean;
  };
}

export interface ParallelConfig {
  workers: number;
  maxFailures: number;
  fullyParallel: boolean;
  shard: {
    current: number;
    total: number;
  };
  retry: {
    count: number;
    delay: number;
    exponentialBackoff: boolean;
  };
}

export interface NetworkConfig {
  simulation: boolean;
  preset: string;
  offline: boolean;
  proxy: {
    server?: string;
    bypass?: string;
    username?: string;
    password?: string;
  };
  interceptors: {
    enabled: boolean;
    patterns: string[];
    mock: boolean;
  };
}

export interface LocalizationConfig {
  locale: string;
  timezone: string;
  currency: string;
  dateFormat: string;
  numberFormat: string;
  supported: string[];
  fallback: string;
}

export interface TestConfig {
  // Configuration de base
  environment: string;
  debug: boolean;
  ci: boolean;
  
  // Configuration workspace
  workspace: WorkspaceConfig;
  
  // Configuration navigateur
  browser: BrowserConfig;
  viewport: ViewportConfig;
  
  // Configuration temporelle
  timeouts: TimeoutConfig;
  
  // Applications
  apps: Record<string, AppConfig>;
  
  // Fonctionnalités spécialisées
  performance: PerformanceConfig;
  accessibility: AccessibilityConfig;
  security: SecurityConfig;
  
  // Configuration des tests
  testData: TestDataConfig;
  reporting: ReportingConfig;
  parallel: ParallelConfig;
  network: NetworkConfig;
  localization: LocalizationConfig;
  
  // Configuration avancée
  features: {
    [key: string]: boolean;
  };
  
  // Intégrations externes
  integrations: {
    slack?: { webhook: string; channels: string[] };
    teams?: { webhook: string };
    email?: { smtp: any; templates: any };
    monitoring?: { endpoint: string; apiKey: string };
  };
}

// =============================================
// GESTIONNAIRE DE CONFIGURATION
// =============================================

export class ConfigManager {
  private static instance: ConfigManager;
  private config: TestConfig;
  private configPath: string;
  private overrides: Partial<TestConfig> = {};

  private constructor() {
    this.configPath = this.findConfigPath();
    this.config = this.loadConfig();
    this.applyEnvironmentOverrides();
  }

  static getInstance(): ConfigManager {
    if (!ConfigManager.instance) {
      ConfigManager.instance = new ConfigManager();
    }
    return ConfigManager.instance;
  }

  // ===== CHARGEMENT DE CONFIGURATION =====
  
  private findConfigPath(): string {
    const possiblePaths = [
      path.join(process.cwd(), 'tests', 'config', 'test.config.json'),
      path.join(process.cwd(), 'test.config.json'),
      path.join(process.cwd(), 'config', 'test.json')
    ];

    for (const configPath of possiblePaths) {
      if (fs.existsSync(configPath)) {
        return configPath;
      }
    }

    // Retourner le chemin par défaut
    return path.join(process.cwd(), 'tests', 'config', 'test.config.json');
  }

  private loadConfig(): TestConfig {
    try {
      if (fs.existsSync(this.configPath)) {
        const fileContent = fs.readFileSync(this.configPath, 'utf8');
        const fileConfig = JSON.parse(fileContent);
        return this.mergeWithDefaults(fileConfig);
      }
    } catch (error) {
      console.warn(`Impossible de charger la configuration depuis ${this.configPath}, utilisation des valeurs par défaut`);
    }

    return this.getDefaultConfig();
  }

  private mergeWithDefaults(fileConfig: Partial<TestConfig>): TestConfig {
    const defaultConfig = this.getDefaultConfig();
    return this.deepMerge(defaultConfig, fileConfig);
  }

  private deepMerge(target: any, source: any): any {
    const result = { ...target };
    
    for (const key in source) {
      if (source[key] !== null && typeof source[key] === 'object' && !Array.isArray(source[key])) {
        result[key] = this.deepMerge(target[key] || {}, source[key]);
      } else {
        result[key] = source[key];
      }
    }
    
    return result;
  }

  // ===== CONFIGURATION PAR DÉFAUT (WORKSPACE) =====
  
  private getDefaultConfig(): TestConfig {
    return {
      environment: process.env.NODE_ENV || 'test',
      debug: process.env.DEBUG === 'true',
      ci: process.env.CI === 'true',

      // Configuration workspace
      workspace: {
        root: process.cwd(),
        appsPath: process.env.APPS_PATH || 'apps',
        packagesPath: process.env.PACKAGES_PATH || 'packages',
        testsPath: process.env.TESTS_PATH || 'tests',
        reportsPath: process.env.REPORTS_PATH || 'reports',
        sharedPackages: ['shared', 'ui']
      },

      browser: {
        name: process.env.BROWSER || 'chromium',
        headless: process.env.HEADLESS !== 'false',
        slowMo: parseInt(process.env.SLOW_MO || '0'),
        devtools: process.env.DEVTOOLS === 'true',
        args: [
          '--no-sandbox',
          '--disable-dev-shm-usage',
          '--disable-web-security',
          '--disable-features=VizDisplayCompositor',
          '--disable-background-timer-throttling',
          '--disable-backgrounding-occluded-windows',
          '--disable-renderer-backgrounding'
        ],
        launchOptions: {
          ignoreDefaultArgs: ['--disable-extensions'],
          env: {
            ...process.env,
            DISPLAY: process.env.DISPLAY || ':99'
          }
        }
      },

      viewport: {
        width: parseInt(process.env.VIEWPORT_WIDTH || '1280'),
        height: parseInt(process.env.VIEWPORT_HEIGHT || '720'),
        deviceScaleFactor: 1,
        isMobile: false,
        hasTouch: false
      },

      timeouts: {
        test: parseInt(process.env.TEST_TIMEOUT || '60000'),
        action: parseInt(process.env.ACTION_TIMEOUT || '30000'),
        navigation: parseInt(process.env.NAVIGATION_TIMEOUT || '60000'),
        expect: parseInt(process.env.EXPECT_TIMEOUT || '10000'),
        performance: parseInt(process.env.PERFORMANCE_TIMEOUT || '120000'),
        accessibility: parseInt(process.env.ACCESSIBILITY_TIMEOUT || '45000'),
        security: parseInt(process.env.SECURITY_TIMEOUT || '90000')
      },

      // Configuration des applications workspace
      apps: {
        ai4kids: {
          name: 'AI4Kids',
          url: process.env.AI4KIDS_URL || 'http://localhost:3004',
          port: 3004,
          healthCheck: '/api/health',
          startCommand: 'cd apps/ai4kids && npm run dev',
          buildCommand: 'cd apps/ai4kids && npm run build',
          environment: {
            NODE_ENV: 'test',
            PORT: '3004',
            NEXT_TELEMETRY_DISABLED: '1'
          },
          features: ['gamification', 'parental-controls', 'offline-mode'],
          workspace: {
            path: 'apps/ai4kids',
            packageJson: 'apps/ai4kids/package.json',
            nextConfig: 'apps/ai4kids/next.config.js'
          }
        },
        multiai: {
          name: 'MultiAI',
          url: process.env.MULTIAI_URL || 'http://localhost:3005',
          port: 3005,
          healthCheck: '/api/health',
          startCommand: 'cd apps/multiai && npm run dev',
          buildCommand: 'cd apps/multiai && npm run build',
          environment: {
            NODE_ENV: 'test',
            PORT: '3005',
            NEXT_TELEMETRY_DISABLED: '1'
          },
          features: ['api-integration', 'feature-flags', 'monitoring'],
          workspace: {
            path: 'apps/multiai',
            packageJson: 'apps/multiai/package.json',
            nextConfig: 'apps/multiai/next.config.js'
          }
        },
        budgetcron: {
          name: 'BudgetCron',
          url: process.env.BUDGETCRON_URL || 'http://localhost:3003',
          port: 3003,
          healthCheck: '/api/health',
          startCommand: 'cd apps/budgetcron && npm run dev',
          buildCommand: 'cd apps/budgetcron && npm run build',
          environment: {
            NODE_ENV: 'test',
            PORT: '3003',
            NEXT_TELEMETRY_DISABLED: '1',
            DATABASE_URL: 'mongodb://localhost:27017/budgetcron_test'
          },
          features: ['ai-insights', 'bank-sync', 'real-time-alerts'],
          workspace: {
            path: 'apps/budgetcron',
            packageJson: 'apps/budgetcron/package.json',
            nextConfig: 'apps/budgetcron/next.config.js'
          },
          database: {
            url: 'mongodb://localhost:27017/budgetcron_test',
            name: 'budgetcron_test',
            reset: true
          }
        },
        unitflip: {
          name: 'UnitFlip',
          url: process.env.UNITFLIP_URL || 'http://localhost:3002',
          port: 3002,
          healthCheck: '/api/health',
          startCommand: 'cd apps/unitflip && npm run dev',
          buildCommand: 'cd apps/unitflip && npm run build',
          environment: {
            NODE_ENV: 'test',
            PORT: '3002',
            NEXT_TELEMETRY_DISABLED: '1'
          },
          features: ['custom-units', 'batch-conversion', 'api-integration'],
          workspace: {
            path: 'apps/unitflip',
            packageJson: 'apps/unitflip/package.json',
            nextConfig: 'apps/unitflip/next.config.js'
          }
        },
        postmath: {
          name: 'Postmath',
          url: process.env.POSTMATH_URL || 'http://localhost:3001',
          port: 3001,
          healthCheck: '/api/health',
          startCommand: 'cd apps/postmath && npm run dev',
          buildCommand: 'cd apps/postmath && npm run build',
          environment: {
            NODE_ENV: 'test',
            PORT: '3001',
            NEXT_TELEMETRY_DISABLED: '1'
          },
          features: ['multi-carrier', 'carbon-footprint', 'dynamic-pricing'],
          workspace: {
            path: 'apps/postmath',
            packageJson: 'apps/postmath/package.json',
            nextConfig: 'apps/postmath/next.config.js'
          }
        }
      },

      performance: {
        enabled: process.env.ENABLE_PERFORMANCE_METRICS === 'true',
        collectMetrics: true,
        thresholds: {
          pageLoad: parseInt(process.env.PERF_PAGE_LOAD_THRESHOLD || '5000'),
          domContentLoaded: 3000,
          firstContentfulPaint: parseInt(process.env.PERF_FCP_THRESHOLD || '2000'),
          largestContentfulPaint: parseInt(process.env.PERF_LCP_THRESHOLD || '4000'),
          cumulativeLayoutShift: parseFloat(process.env.PERF_CLS_THRESHOLD || '0.1'),
          totalBlockingTime: 300,
          interaction: parseInt(process.env.PERF_INTERACTION_THRESHOLD || '2000'),
          apiResponse: parseInt(process.env.PERF_API_RESPONSE_THRESHOLD || '3000')
        },
        monitoring: {
          cpu: true,
          memory: true,
          network: true,
          fps: false
        }
      },

      accessibility: {
        enabled: process.env.ENABLE_A11Y_CHECKS === 'true',
        standard: process.env.A11Y_STANDARD || 'WCAG21AA',
        rules: {
          disabled: (process.env.A11Y_RULES_TO_DISABLE || '').split(',').filter(Boolean),
          custom: []
        },
        testing: {
          colorContrast: true,
          keyboardNavigation: true,
          screenReader: true,
          focusManagement: true
        },
        wcagLevel: 'AA' as const
      },

      security: {
        enabled: process.env.ENABLE_SECURITY_CHECKS === 'true',
        checks: {
          csp: process.env.VALIDATE_CSP === 'true',
          xss: process.env.CHECK_XSS === 'true',
          clickjacking: process.env.CHECK_CLICKJACKING === 'true',
          https: process.env.VALIDATE_HTTPS === 'true',
          headers: process.env.SECURITY_HEADERS_CHECK === 'true',
          cors: process.env.CORS_CHECK === 'true'
        },
        headers: {
          required: [
            'Content-Security-Policy',
            'X-Frame-Options',
            'X-Content-Type-Options',
            'Strict-Transport-Security'
          ],
          forbidden: [
            'Server',
            'X-Powered-By'
          ]
        },
        scanning: {
          vulnerabilities: false,
          dependencies: false,
          secrets: false
        }
      },

      testData: {
        path: process.env.TEST_DATA_PATH || 'tests/fixtures',
        generate: process.env.GENERATE_TEST_DATA === 'true',
        cleanup: process.env.CLEANUP_TEST_DATA !== 'false',
        validate: process.env.VALIDATE_TEST_DATA !== 'false',
        seed: process.env.TEST_DATA_SEED || 'test-seed-2024',
        fixtures: {
          users: 'users.json',
          budget: 'budget-data.json',
          shipping: 'shipping-data.json',
          conversion: 'conversion-data.json',
          aiServices: 'ai-services-data.json',
          learningModules: 'learning-modules-data.json'
        }
      },

      reporting: {
        formats: (process.env.REPORT_FORMAT || 'html,json,junit').split(','),
        outputDir: process.env.REPORT_PATH || 'reports',
        merge: process.env.MERGE_REPORTS === 'true',
        upload: process.env.CI_UPLOAD_ARTIFACTS === 'true',
        retention: parseInt(process.env.CI_RETAIN_ARTIFACTS || '7'),
        screenshots: {
          onFailure: process.env.SCREENSHOT !== 'off',
          onSuccess: process.env.SCREENSHOT === 'on',
          fullPage: true,
          quality: 90
        },
        videos: {
          enabled: process.env.VIDEO !== 'off',
          retain: process.env.VIDEO || 'retain-on-failure',
          quality: '720p',
          fps: 25
        },
        traces: {
          enabled: process.env.TRACE !== 'off',
          retain: process.env.TRACE || 'on-first-retry',
          sources: true,
          screenshots: true
        }
      },

      parallel: {
        workers: parseInt(process.env.PARALLEL_WORKERS || process.env.CI_PARALLEL || '4'),
        maxFailures: parseInt(process.env.MAX_FAILURES || '5'),
        fullyParallel: true,
        shard: {
          current: parseInt(process.env.SHARD_CURRENT || '1'),
          total: parseInt(process.env.SHARD_TOTAL || '1')
        },
        retry: {
          count: parseInt(process.env.RETRY_COUNT || process.env.CI_RETRY || '2'),
          delay: 1000,
          exponentialBackoff: true
        }
      },

      network: {
        simulation: process.env.NETWORK_SIMULATION === 'true',
        preset: process.env.NETWORK_PRESET || 'fast3g',
        offline: false,
        proxy: {
          server: process.env.HTTP_PROXY || process.env.HTTPS_PROXY,
          bypass: process.env.NO_PROXY
        },
        interceptors: {
          enabled: process.env.MOCK_APIS === 'true',
          patterns: ['**/api/**'],
          mock: true
        }
      },

      localization: {
        locale: process.env.LOCALE || 'fr-FR',
        timezone: process.env.TIMEZONE || 'Europe/Paris',
        currency: process.env.CURRENCY || 'EUR',
        dateFormat: process.env.DATE_FORMAT || 'DD/MM/YYYY',
        numberFormat: 'fr-FR',
        supported: (process.env.SUPPORTED_LOCALES || 'fr-FR,en-US,es-ES,de-DE').split(','),
        fallback: 'en-US'
      },

      features: {
        // Feature flags généraux
        experimentalFeatures: process.env.ENABLE_EXPERIMENTAL_FEATURES === 'true',
        betaFeatures: process.env.ENABLE_BETA_FEATURES === 'true',
        
        // Features par application
        ai4kidsGamification: true,
        multiaiFeatureFlags: true,
        budgetcronAiInsights: true,
        unitflipCustomUnits: true,
        postmathMultiCarrier: true,
        
        // Features techniques
        parallelExecution: true,
        advancedReporting: true,
        realTimeMonitoring: false,
        cloudIntegration: false,
        
        // Features workspace
        workspaceMode: true,
        packageSharing: true,
        monorepoSupport: true
      },

      integrations: {
        slack: process.env.SLACK_WEBHOOK_URL ? {
          webhook: process.env.SLACK_WEBHOOK_URL,
          channels: ['#tests', '#ci-cd']
        } : undefined,
        
        teams: process.env.TEAMS_WEBHOOK_URL ? {
          webhook: process.env.TEAMS_WEBHOOK_URL
        } : undefined,
        
        email: process.env.EMAIL_NOTIFICATIONS === 'true' ? {
          smtp: {
            host: process.env.SMTP_HOST,
            port: parseInt(process.env.SMTP_PORT || '587'),
            secure: false,
            auth: {
              user: process.env.SMTP_USER,
              pass: process.env.SMTP_PASS
            }
          },
          templates: {
            failure: 'test-failure-template.html',
            success: 'test-success-template.html'
          }
        } : undefined,
        
        monitoring: process.env.ENABLE_MONITORING === 'true' ? {
          endpoint: process.env.MONITORING_ENDPOINT || '',
          apiKey: process.env.MONITORING_API_KEY || ''
        } : undefined
      }
    };
  }

  // ===== SURCHARGES D'ENVIRONNEMENT =====
  
  private applyEnvironmentOverrides(): void {
    // Surcharges spécifiques par environnement
    switch (this.config.environment) {
      case 'development':
        this.applyDevelopmentOverrides();
        break;
      case 'staging':
        this.applyStagingOverrides();
        break;
      case 'production':
        this.applyProductionOverrides();
        break;
      case 'ci':
        this.applyCiOverrides();
        break;
    }

    // Appliquer les surcharges manuelles
    if (Object.keys(this.overrides).length > 0) {
      this.config = this.deepMerge(this.config, this.overrides);
    }
  }

  private applyDevelopmentOverrides(): void {
    this.config.browser.headless = false;
    this.config.browser.slowMo = 500;
    this.config.browser.devtools = true;
    this.config.debug = true;
    this.config.parallel.workers = 1;
    this.config.timeouts.test = 300000; // 5 minutes pour debug
  }

  private applyStagingOverrides(): void {
    this.config.parallel.workers = 2;
    this.config.parallel.retry.count = 3;
    this.config.performance.enabled = true;
    this.config.accessibility.enabled = true;
    this.config.security.enabled = true;
  }

  private applyProductionOverrides(): void {
    this.config.parallel.workers = 1;
    this.config.parallel.retry.count = 5;
    this.config.timeouts.test = 45000;
    this.config.reporting.upload = true;
    
    // URLs de production pour workspace
    this.config.apps.ai4kids.url = process.env.PROD_AI4KIDS_URL || 'https://ai4kids.example.com';
    this.config.apps.multiai.url = process.env.PROD_MULTIAI_URL || 'https://multiai.example.com';
    this.config.apps.budgetcron.url = process.env.PROD_BUDGETCRON_URL || 'https://budgetcron.example.com';
    this.config.apps.unitflip.url = process.env.PROD_UNITFLIP_URL || 'https://unitflip.example.com';
    this.config.apps.postmath.url = process.env.PROD_POSTMATH_URL || 'https://postmath.example.com';
  }

  private applyCiOverrides(): void {
    this.config.browser.headless = true;
    this.config.browser.args.push('--disable-gpu');
    this.config.parallel.workers = parseInt(process.env.CI_PARALLEL || '2');
    this.config.parallel.retry.count = parseInt(process.env.CI_RETRY || '3');
    this.config.reporting.upload = true;
    this.config.reporting.merge = true;
  }

  // ===== MÉTHODES PUBLIQUES =====
  
  getConfig(): TestConfig {
    return this.config;
  }

  getWorkspaceConfig(): WorkspaceConfig {
    return this.config.workspace;
  }

  getAppConfig(appName: string): AppConfig | undefined {
    return this.config.apps[appName.toLowerCase()];
  }

  getAppUrl(appName: string): string {
    const app = this.getAppConfig(appName);
    return app?.url || this.config.apps.ai4kids.url;
  }

  getAppWorkspacePath(appName: string): string {
    const app = this.getAppConfig(appName);
    return app?.workspace.path || `apps/${appName}`;
  }

  isFeatureEnabled(feature: string): boolean {
    return this.config.features[feature] === true;
  }

  getBrowserConfig(): BrowserConfig {
    return this.config.browser;
  }

  getTimeoutConfig(): TimeoutConfig {
    return this.config.timeouts;
  }

  getPerformanceConfig(): PerformanceConfig {
    return this.config.performance;
  }

  getAccessibilityConfig(): AccessibilityConfig {
    return this.config.accessibility;
  }

  getSecurityConfig(): SecurityConfig {
    return this.config.security;
  }

  getReportingConfig(): ReportingConfig {
    return this.config.reporting;
  }

  getParallelConfig(): ParallelConfig {
    return this.config.parallel;
  }

  // ===== MÉTHODES DE MODIFICATION =====
  
  updateConfig(updates: Partial<TestConfig>): void {
    this.config = this.deepMerge(this.config, updates);
  }

  setOverride(key: string, value: any): void {
    this.overrides = this.deepMerge(this.overrides, { [key]: value });
    this.applyEnvironmentOverrides();
  }

  removeOverride(key: string): void {
    delete this.overrides[key];
    this.applyEnvironmentOverrides();
  }

  resetToDefaults(): void {
    this.overrides = {};
    this.config = this.loadConfig();
    this.applyEnvironmentOverrides();
  }

  // ===== MÉTHODES UTILITAIRES =====
  
  isDevelopment(): boolean {
    return this.config.environment === 'development';
  }

  isProduction(): boolean {
    return this.config.environment === 'production';
  }

  isCi(): boolean {
    return this.config.ci;
  }

  isDebugMode(): boolean {
    return this.config.debug;
  }

  isWorkspaceMode(): boolean {
    return this.config.features.workspaceMode;
  }

  shouldTakeScreenshots(): boolean {
    return this.config.reporting.screenshots.onFailure;
  }

  shouldRecordVideos(): boolean {
    return this.config.reporting.videos.enabled;
  }

  shouldCollectTraces(): boolean {
    return this.config.reporting.traces.enabled;
  }

  getFixturePath(fixture: string): string {
    return path.join(
      this.config.workspace.root,
      this.config.testData.path,
      this.config.testData.fixtures[fixture] || `${fixture}.json`
    );
  }

  getReportPath(filename: string): string {
    return path.join(this.config.workspace.root, this.config.reporting.outputDir, filename);
  }

  getWorkspacePath(subPath: string = ''): string {
    return path.join(this.config.workspace.root, subPath);
  }

  // ===== VALIDATION =====
  
  validateConfig(): { valid: boolean; errors: string[] } {
    const errors: string[] = [];

    // Valider les URLs d'applications
    Object.entries(this.config.apps).forEach(([name, app]) => {
      try {
        new URL(app.url);
      } catch {
        errors.push(`URL invalide pour l'application ${name}: ${app.url}`);
      }
      
      // Valider les chemins workspace
      const workspacePath = path.join(this.config.workspace.root, app.workspace.path);
      if (!fs.existsSync(workspacePath)) {
        errors.push(`Chemin workspace inexistant pour ${name}: ${workspacePath}`);
      }
    });

    // Valider les timeouts
    if (this.config.timeouts.test < 1000) {
      errors.push('Le timeout de test doit être d\'au moins 1000ms');
    }

    // Valider la configuration de parallélisme
    if (this.config.parallel.workers < 1) {
      errors.push('Le nombre de workers doit être d\'au moins 1');
    }

    // Valider les seuils de performance
    if (this.config.performance.enabled) {
      Object.entries(this.config.performance.thresholds).forEach(([metric, threshold]) => {
        if (threshold < 0) {
          errors.push(`Seuil de performance invalide pour ${metric}: ${threshold}`);
        }
      });
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }

  // ===== SAUVEGARDE =====
  
  saveConfig(filePath?: string): void {
    const savePath = filePath || this.configPath;
    const dir = path.dirname(savePath);
    
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    
    fs.writeFileSync(savePath, JSON.stringify(this.config, null, 2));
  }

  // ===== MÉTHODES STATIQUES =====
  
  static createDefault(): ConfigManager {
    return new ConfigManager();
  }

  static fromFile(configPath: string): ConfigManager {
    const manager = new ConfigManager();
    manager.configPath = configPath;
    manager.config = manager.loadConfig();
    manager.applyEnvironmentOverrides();
    return manager;
  }
}

// ===== EXPORT PAR DÉFAUT =====

export default ConfigManager.getInstance();