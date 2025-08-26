// =============================================================================
// 🌿 BRANCH DETECTOR - Détection branche temps réel selon README.md
// =============================================================================

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
    if (typeof window !== 'undefined') {
      return (window as any).__BRANCH_NAME__ || 'main';
    }
    
    if (typeof process !== 'undefined' && process.env) {
      return process.env.BRANCH || 
             process.env.VERCEL_GIT_COMMIT_REF || 
             process.env.NETLIFY_BRANCH || 'main';
    }
    
    return 'main';
  }

  private getEnvironmentFromBranch(branch: string): BranchInfo['environment'] {
    if (branch === 'main' || branch === 'master') return 'production';
    if (branch === 'feature/math4child') return 'staging';
    if (branch.startsWith('feature/')) return 'development';
    return 'development';
  }

  private getDeployUrl(branch: string): string {
    const urls = {
      'main': 'https://math4child.com',
      'feature/math4child': 'https://feature-math4child--math4child.netlify.app'
    };
    return urls[branch as keyof typeof urls] || 'http://localhost:3000';
  }

  private getApiUrl(environment: BranchInfo['environment']): string {
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
      default:
        return { analytics: false, debugging: true, testing: true };
    }
  }

  public getBranchInfo(): BranchInfo {
    return this.branchInfo;
  }

  public logBranchInfo(): void {
    if (this.branchInfo.features.debugging) {
      console.group('🌿 Branch Detection Info - Math4Child');
      console.log('Branch:', this.branchInfo.name);
      console.log('Environment:', this.branchInfo.environment);
      console.log('Deploy URL:', this.branchInfo.deployUrl);
      console.log('API URL:', this.branchInfo.apiUrl);
      console.log('Features:', this.branchInfo.features);
      console.groupEnd();
    }
  }
}
