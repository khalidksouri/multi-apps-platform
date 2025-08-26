// =============================================================================
// 🪝 USE BRANCH HOOK - Hook React détection branche selon README.md
// =============================================================================

'use client';

import { useEffect, useState } from 'react';
import { BranchDetector, type BranchInfo } from '../utils/BranchDetector';

export function useBranch() {
  const [branchInfo, setBranchInfo] = useState<BranchInfo>({
    name: 'main',
    environment: 'development',
    deployUrl: 'http://localhost:3000',
    apiUrl: 'https://api-dev.math4child.com',
    features: { analytics: false, debugging: true, testing: true }
  });

  useEffect(() => {
    try {
      const detector = BranchDetector.getInstance();
      const info = detector.getBranchInfo();
      setBranchInfo(info);
      detector.logBranchInfo();
    } catch (error) {
      console.warn('Erreur détection branche:', error);
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
    branchInfo
  };
}
