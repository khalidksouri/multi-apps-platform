// src/utils/BranchDetector.ts
export interface BranchInfo {
  name: string;
  environment: 'production' | 'staging' | 'development' | 'preview';
  deployUrl?: string;
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
    this.branchInfo = this.detectBranch();
  }

  static getInstance(): BranchDetector {
    if (!BranchDetector.instance) {
      BranchDetector.instance = new BranchDetector();
    }
    return BranchDetector.instance;
  }

  private detectBranch(): BranchInfo {
    const branchName = this.getBranchName();
    const environment = this.getEnvironmentFromBranch(branchName);
    
    return {
      name: branchName,
      environment,
      deployUrl: this.getDeployUrl(branchName),
      apiUrl: this.getApiUrl(environment),
      features: this.getFeatures(environment)
    };
  }

  private getBranchName(): string {
    if (typeof window === 'undefined') {
      return process.env.BRANCH ||
             process.env.VERCEL_GIT_COMMIT_REF ||
             process.env.NETLIFY_BRANCH ||
             process.env.HEAD ||
             process.env.GITHUB_REF_NAME ||
             process.env.CI_COMMIT_REF_NAME ||
             'main';
    } else {
      return (window as any).__BRANCH_NAME__ || 
             process.env.NEXT_PUBLIC_BRANCH ||
             'main';
    }
  }

  private getEnvironmentFromBranch(branch: string): BranchInfo['environment'] {
    if (branch === 'main' || branch === 'master') return 'production';
    if (branch === 'develop' || branch === 'staging') return 'staging';
    if (branch.startsWith('feature/')) return 'development';
    if (branch.startsWith('hotfix/')) return 'staging';
    if (branch.startsWith('release/')) return 'staging';
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
        return `https://${branch.replace(/[^a-zA-Z0-9]/g, '-')}--math4child.netlify.app`;
    }
  }

  private getApiUrl(environment: BranchInfo['environment']): string {
    const urls = {
      production: 'https://api.math4child.com',
      staging: 'https://api-staging.math4child.com',
      development: 'https://api-dev.math4child.com',
      preview: 'https://api-preview.math4child.com'
    };
    
    return process.env.NEXT_PUBLIC_API_URL || urls[environment];
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
    }
  }

  public getBranchInfo(): BranchInfo { return this.branchInfo; }
  public getCurrentBranch(): string { return this.branchInfo.name; }
  public getEnvironment(): BranchInfo['environment'] { return this.branchInfo.environment; }
  public isProduction(): boolean { return this.branchInfo.environment === 'production'; }
  public isDevelopment(): boolean { return this.branchInfo.environment === 'development'; }
  public isStaging(): boolean { return this.branchInfo.environment === 'staging'; }
  public getApiUrl(): string { return this.branchInfo.apiUrl; }
  public shouldShowDebugInfo(): boolean { return this.branchInfo.features.debugging; }
  public shouldEnableAnalytics(): boolean { return this.branchInfo.features.analytics; }
  public shouldRunTests(): boolean { return this.branchInfo.features.testing; }

  public logBranchInfo(): void {
    if (this.shouldShowDebugInfo()) {
      console.group('🌿 Branch Detection Info');
      console.log('Branch:', this.branchInfo.name);
      console.log('Environment:', this.branchInfo.environment);
      console.log('Deploy URL:', this.branchInfo.deployUrl);
      console.log('API URL:', this.branchInfo.apiUrl);
      console.log('Features:', this.branchInfo.features);
      console.groupEnd();
    }
  }
}
