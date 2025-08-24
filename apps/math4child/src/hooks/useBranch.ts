// src/hooks/useBranch.ts - VERSION CORRIGÉE COMPLÈTE
import { useEffect, useState } from 'react';
import { BranchDetector, type BranchInfo } from '../utils/BranchDetector';

interface UseBranchReturn {
  branch: string;
  environment: BranchInfo['environment'];
  isProduction: boolean;
  isDevelopment: boolean;
  isStaging: boolean;
  apiUrl: string;
  deployUrl: string;
  features: BranchInfo['features'];
  branchInfo: BranchInfo;
  shouldShowDebugInfo: boolean;
  shouldEnableAnalytics: boolean;
  shouldRunTests: boolean;
}

const defaultBranchInfo: BranchInfo = {
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

export function useBranch(): UseBranchReturn {
  const [branchInfo, setBranchInfo] = useState<BranchInfo>(defaultBranchInfo);
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    try {
      const detector = BranchDetector.getInstance();
      const info = detector.getBranchInfo();
      
      if (info) {
        setBranchInfo(info);
        detector.logBranchInfo();
      }
    } catch (error) {
      console.warn('Erreur useBranch:', error);
      setBranchInfo(defaultBranchInfo);
    } finally {
      setIsReady(true);
    }
  }, []);

  return {
    branch: branchInfo.name,
    environment: branchInfo.environment,
    isProduction: branchInfo.environment === 'production',
    isDevelopment: branchInfo.environment === 'development',
    isStaging: branchInfo.environment === 'staging',
    apiUrl: branchInfo.apiUrl,
    deployUrl: branchInfo.deployUrl,
    features: branchInfo.features,
    branchInfo,
    shouldShowDebugInfo: branchInfo.features.debugging,
    shouldEnableAnalytics: branchInfo.features.analytics,
    shouldRunTests: branchInfo.features.testing,
  };
}

export function useBranchBanner() {
  const { environment, branch, isDevelopment, isStaging } = useBranch();
  
  const shouldShowBanner = isDevelopment || isStaging;
  
  const getBannerConfig = () => {
    switch (environment) {
      case 'development':
        return {
          show: true,
          color: '#f97316',
          backgroundColor: '#fff7ed',
          text: `🚧 Développement - Branche: ${branch}`,
        };
      case 'staging':
        return {
          show: true,
          color: '#3b82f6',
          backgroundColor: '#eff6ff',
          text: `🧪 Test - Branche: ${branch}`,
        };
      default:
        return {
          show: false,
          color: '',
          backgroundColor: '',
          text: '',
        };
    }
  };

  return {
    shouldShowBanner,
    bannerConfig: getBannerConfig(),
  };
}

export function useApiConfig() {
  const { apiUrl, isProduction, features } = useBranch();
  
  return {
    apiUrl,
    config: {
      baseURL: apiUrl,
      timeout: isProduction ? 10000 : 30000,
      debug: features.debugging,
      headers: {
        'X-Environment': isProduction ? 'production' : 'development',
      },
    },
  };
}
