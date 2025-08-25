// BranchDetector Math4Child v4.2.0 - Détection branche intelligente
export type Environment = 'production' | 'staging' | 'development' | 'preview';
export type Branch = 'main' | 'feature/math4child' | string;

export interface BranchInfo {
  branch: string;
  environment: Environment;
  apiUrl: string;
  debugEnabled: boolean;
  analyticsEnabled: boolean;
  bannerColor: string;
  bannerText: string;
}

export class BranchDetector {
  static detect(): BranchInfo {
    // Détection via variables d'environnement Netlify
    const netlifyContext = process.env.CONTEXT || 'development';
    const branchName = process.env.BRANCH || process.env.HEAD || 'development';
    const appEnv = process.env.NEXT_PUBLIC_APP_ENV as Environment || 'development';
    
    let environment: Environment;
    let apiUrl: string;
    let debugEnabled: boolean;
    let analyticsEnabled: boolean;
    let bannerColor: string;
    let bannerText: string;

    // Logique de détection selon README.md
    switch (netlifyContext) {
      case 'production':
        environment = 'production';
        apiUrl = 'https://api.math4child.com';
        debugEnabled = false;
        analyticsEnabled = true;
        bannerColor = '';
        bannerText = '';
        break;
        
      case 'branch-deploy':
        if (branchName === 'feature/math4child') {
          environment = 'staging';
          apiUrl = 'https://api-staging.math4child.com';
          debugEnabled = true;
          analyticsEnabled = true;
          bannerColor = 'bg-blue-600';
          bannerText = '🧪 ENVIRONNEMENT STAGING';
        } else {
          environment = 'development';
          apiUrl = 'https://api-dev.math4child.com';
          debugEnabled = true;
          analyticsEnabled = false;
          bannerColor = 'bg-orange-600';
          bannerText = `🚧 DÉVELOPPEMENT - ${branchName}`;
        }
        break;
        
      case 'deploy-preview':
        environment = 'preview';
        apiUrl = 'https://api-preview.math4child.com';
        debugEnabled = true;
        analyticsEnabled = false;
        bannerColor = 'bg-purple-600';
        bannerText = '👀 APERÇU PULL REQUEST';
        break;
        
      default:
        environment = 'development';
        apiUrl = 'http://localhost:3001/api';
        debugEnabled = true;
        analyticsEnabled = false;
        bannerColor = 'bg-orange-600';
        bannerText = `🔧 LOCAL - ${branchName}`;
    }

    return {
      branch: branchName,
      environment,
      apiUrl,
      debugEnabled,
      analyticsEnabled,
      bannerColor,
      bannerText
    };
  }

  static isProduction(): boolean {
    return this.detect().environment === 'production';
  }

  static isStaging(): boolean {
    return this.detect().environment === 'staging';
  }

  static isDevelopment(): boolean {
    return this.detect().environment === 'development';
  }
}
