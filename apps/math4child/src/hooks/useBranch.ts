import { useEffect, useState } from 'react';
import { BranchDetector, type BranchInfo } from '../utils/BranchDetector';

interface UseBranchReturn {
  branch: string;
  environment: BranchInfo['environment'];
  isProduction: boolean;
  isDevelopment: boolean;
  isStaging: boolean;
  apiUrl: string;
  deployUrl?: string;
  features: BranchInfo['features'];
  branchInfo: BranchInfo;
  shouldShowDebugInfo: boolean;
  shouldEnableAnalytics: boolean;
  shouldRunTests: boolean;
}

export function useBranch(): UseBranchReturn {
  const [branchDetector] = useState(() => BranchDetector.getInstance());
  const [branchInfo, setBranchInfo] = useState<BranchInfo>(() => branchDetector.getBranchInfo());

  useEffect(() => {
    branchDetector.logBranchInfo();
    
    const currentInfo = branchDetector.getBranchInfo();
    if (JSON.stringify(currentInfo) !== JSON.stringify(branchInfo)) {
      setBranchInfo(currentInfo);
    }
  }, [branchDetector, branchInfo]);

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
          text: `🚧 Environnement de développement - Branche: ${branch}`,
        };
      case 'staging':
        return {
          show: true,
          color: '#3b82f6',
          backgroundColor: '#eff6ff',
          text: `🧪 Environnement de test - Branche: ${branch}`,
        };
      case 'preview':
        return {
          show: true,
          color: '#8b5cf6',
          backgroundColor: '#f5f3ff',
          text: `👀 Aperçu de déploiement - Branche: ${branch}`,
        };
      default:
        return { show: false, color: '', backgroundColor: '', text: '' };
    }
  };

  return {
    shouldShowBanner,
    bannerConfig: getBannerConfig(),
  };
}

export function useApiConfig() {
  const { apiUrl, isProduction, features } = useBranch();
  
  const getApiConfig = () => ({
    baseURL: apiUrl,
    timeout: isProduction ? 10000 : 30000,
    retries: isProduction ? 3 : 1,
    debug: features.debugging,
    cache: isProduction,
    headers: {
      'X-Environment': isProduction ? 'production' : 'development',
      'X-Debug': features.debugging ? 'true' : 'false',
    },
  });

  return { apiUrl, config: getApiConfig() };
}
