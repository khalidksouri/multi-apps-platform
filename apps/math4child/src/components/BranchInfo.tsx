'use client';

import { useBranch } from '../hooks/useBranch';

export function BranchBanner() {
  const branchInfo = useBranch();

  if (!branchInfo || branchInfo.environment === 'production' || !branchInfo.bannerText) {
    return null;
  }

  return (
    <div className={`fixed top-0 left-0 right-0 z-50 ${branchInfo.bannerColor} text-white py-2 px-4 text-center text-sm font-semibold`}>
      {branchInfo.bannerText}
    </div>
  );
}

export function DebugWidget() {
  const branchInfo = useBranch();

  if (!branchInfo || !branchInfo.debugEnabled) {
    return null;
  }

  return (
    <div className="fixed bottom-4 left-4 z-40 bg-black/80 text-white p-3 rounded-lg text-xs max-w-64">
      <div className="font-bold text-green-400 mb-2">🔧 Debug Info</div>
      <div><strong>Branche:</strong> {branchInfo.branch}</div>
      <div><strong>Env:</strong> {branchInfo.environment}</div>
      <div><strong>API:</strong> {branchInfo.apiUrl}</div>
      <div><strong>Analytics:</strong> {branchInfo.analyticsEnabled ? '✅' : '❌'}</div>
    </div>
  );
}

export function BranchInfoProvider({ children }: { children: React.ReactNode }) {
  return (
    <>
      <BranchBanner />
      {children}
      <DebugWidget />
    </>
  );
}
