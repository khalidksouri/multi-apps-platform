'use client';

import React from 'react';
import { useBranch, useBranchBanner } from '../hooks/useBranch';

export function EnvironmentBanner() {
  const { shouldShowBanner, bannerConfig } = useBranchBanner();

  if (!shouldShowBanner || !bannerConfig.show) return null;

  return (
    <div
      style={{
        backgroundColor: bannerConfig.backgroundColor,
        color: bannerConfig.color,
        padding: '8px 16px',
        textAlign: 'center',
        fontSize: '14px',
        fontWeight: '500',
        borderBottom: `2px solid ${bannerConfig.color}`,
        position: 'sticky',
        top: 0,
        zIndex: 1000,
      }}
    >
      {bannerConfig.text}
    </div>
  );
}

export function BranchDebugWidget() {
  const { branch, environment, apiUrl, deployUrl, features, shouldShowDebugInfo } = useBranch();

  if (!shouldShowDebugInfo) return null;

  return (
    <div
      style={{
        position: 'fixed',
        bottom: '20px',
        left: '20px',
        backgroundColor: '#1f2937',
        color: '#f9fafb',
        padding: '12px',
        borderRadius: '8px',
        fontSize: '12px',
        fontFamily: 'monospace',
        zIndex: 9999,
        maxWidth: '300px',
        boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)',
      }}
    >
      <div style={{ marginBottom: '8px', fontWeight: 'bold' }}>🌿 Branch Info</div>
      <div>Branch: <span style={{ color: '#10b981' }}>{branch}</span></div>
      <div>Env: <span style={{ color: '#3b82f6' }}>{environment}</span></div>
      <div>API: <span style={{ color: '#f59e0b' }}>{apiUrl}</span></div>
      {deployUrl && <div>Deploy: <span style={{ color: '#8b5cf6' }}>{deployUrl}</span></div>}
      <div style={{ marginTop: '8px', fontSize: '11px', opacity: 0.7 }}>
        Analytics: {features.analytics ? '✅' : '❌'} |
        Debug: {features.debugging ? '✅' : '❌'} |
        Tests: {features.testing ? '✅' : '❌'}
      </div>
    </div>
  );
}

export function BranchInfoProvider({ children }: { children: React.ReactNode }) {
  return (
    <>
      <EnvironmentBanner />
      {children}
      <BranchDebugWidget />
    </>
  );
}

export function BranchMetaTags() {
  const { branch, environment, apiUrl } = useBranch();

  React.useEffect(() => {
    (window as any).__BRANCH_INFO__ = {
      branch,
      environment,
      apiUrl,
      timestamp: new Date().toISOString(),
    };

    const meta = document.createElement('meta');
    meta.name = 'x-branch-name';
    meta.content = branch;
    document.head.appendChild(meta);

    const envMeta = document.createElement('meta');
    envMeta.name = 'x-environment';
    envMeta.content = environment;
    document.head.appendChild(envMeta);

    return () => {
      document.head.removeChild(meta);
      document.head.removeChild(envMeta);
    };
  }, [branch, environment, apiUrl]);

  return null;
}
