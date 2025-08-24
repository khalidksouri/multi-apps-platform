// src/utils/BranchDetector.ts - VERSION CORRIGÉE COMPLÈTE
export interface BranchInfo {
  name: string;
  environment: 'production' | 'staging' | 'development' | 'preview';
  deployUrl: string;
  apiUrl: string;
  features: {
    analytics: boolean;
    debugging: boolean;
    testing: boolean;
  };
}

export class BranchDetector {
  private static instance: BranchDetector;
  private branchInfo: BranchInfo;

  constructor() {
    try {
      this.branchInfo = this.detectBranch();
    } catch (error) {
      console.warn('Erreur détection branche, fallback:', error);
      this.branchInfo = this.getFallbackBranchInfo();
    }
  }

  static getInstance(): BranchDetector {
    if (!BranchDetector.instance) {
      BranchDetector.instance = new BranchDetector();
    }
    return BranchDetector.instance;
  }

  private getFallbackBranchInfo(): BranchInfo {
    return {
      name: 'main',
      environment: 'development',
      deployUrl: 'http://localhost:3000',
      apiUrl: 'https://api-dev.math4child.com',
      features: {
        analytics: false,
        debugging: true,
        testing: true
      }
    };
  }

  private detectBranch(): BranchInfo {
    const branchName = this.getBranchName();
    const environment = this.getEnvironmentFromBranch(branchName);
    const apiUrl = this.getApiUrl(environment);
    const deployUrl = this.getDeployUrl(branchName);
    const features = this.getFeatures(environment);
    
    return {
      name: branchName,
      environment,
      deployUrl,
      apiUrl,
      features
    };
  }

  private getBranchName(): string {
    try {
      // Côté client
      if (typeof window !== 'undefined') {
        return (window as any).__BRANCH_NAME__ || 'main';
      }

      // Côté serveur
      if (typeof process !== 'undefined' && process.env) {
        return process.env.BRANCH ||
               process.env.VERCEL_GIT_COMMIT_REF ||
               process.env.NETLIFY_BRANCH ||
               process.env.HEAD ||
               process.env.GITHUB_REF_NAME ||
               'main';
      }

      return 'main';
    } catch (error) {
      console.warn('Erreur getBranchName:', error);
      return 'main';
    }
  }

  private getEnvironmentFromBranch(branch: string): BranchInfo['environment'] {
    if (branch === 'main' || branch === 'master') return 'production';
    if (branch === 'develop' || branch === 'staging') return 'staging';
    if (branch.startsWith('feature/')) return 'development';
    return 'development';
  }

  private getDeployUrl(branch: string): string {
    if (typeof window !== 'undefined') {
      return window.location.origin;
    }
    
    switch (branch) {
      case 'main':
        return 'https://math4child.com';
      case 'feature/math4child':
        return 'https://feature-math4child--math4child.netlify.app';
      default:
        return 'http://localhost:3000';
    }
  }

  private getApiUrl(environment: BranchInfo['environment']): string {
    try {
      if (typeof process !== 'undefined' && process.env?.NEXT_PUBLIC_API_URL) {
        return process.env.NEXT_PUBLIC_API_URL;
      }
    } catch (error) {
      console.warn('Erreur getApiUrl process.env:', error);
    }

    const urls = {
      production: 'https://api.math4child.com',
      staging: 'https://api-staging.math4child.com',
      development: 'https://api-dev.math4child.com',
      preview: 'https://api-preview.math4child.com'
    };
    
    return urls[environment];
  }

  private getFeatures(environment: BranchInfo['environment']): BranchInfo['features'] {
    switch (environment) {
      case 'production':
        return { analytics: true, debugging: false, testing: false };
      case 'staging':
        return { analytics: true, debugging: true, testing: true };
      case 'development':
        return { analytics: false, debugging: true, testing: true };
      case 'preview':
        return { analytics: false, debugging: true, testing: false };
      default:
        return { analytics: false, debugging: true, testing: true };
    }
  }

  // Méthodes publiques SÉCURISÉES
  public getBranchInfo(): BranchInfo {
    if (!this.branchInfo) {
      this.branchInfo = this.getFallbackBranchInfo();
    }
    return this.branchInfo;
  }

  public getCurrentBranch(): string {
    return this.getBranchInfo().name;
  }

  public getEnvironment(): BranchInfo['environment'] {
    return this.getBranchInfo().environment;
  }

  public isProduction(): boolean {
    return this.getBranchInfo().environment === 'production';
  }

  public isDevelopment(): boolean {
    return this.getBranchInfo().environment === 'development';
  }

  public isStaging(): boolean {
    return this.getBranchInfo().environment === 'staging';
  }

  public getApiUrl(): string {
    return this.getBranchInfo().apiUrl;
  }

  public shouldShowDebugInfo(): boolean {
    return this.getBranchInfo().features.debugging;
  }

  public shouldEnableAnalytics(): boolean {
    return this.getBranchInfo().features.analytics;
  }

  public shouldRunTests(): boolean {
    return this.getBranchInfo().features.testing;
  }

  public logBranchInfo(): void {
    if (this.shouldShowDebugInfo()) {
      const info = this.getBranchInfo();
      console.group('🌿 Branch Detection Info');
      console.log('Branch:', info.name);
      console.log('Environment:', info.environment);
      console.log('Deploy URL:', info.deployUrl);
      console.log('API URL:', info.apiUrl);
      console.log('Features:', info.features);
      console.groupEnd();
    }
  }
}
