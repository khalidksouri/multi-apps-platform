'use client';

import { useState, useEffect } from 'react';
import { BranchDetector, type BranchInfo } from '../utils/BranchDetector';

export function useBranch() {
  const [branchInfo, setBranchInfo] = useState<BranchInfo | null>(null);

  useEffect(() => {
    const info = BranchDetector.detect();
    setBranchInfo(info);
    
    // Log des informations en développement
    if (info.debugEnabled) {
      console.log('🌿 Math4Child Branch Info:', info);
    }
  }, []);

  return branchInfo;
}
