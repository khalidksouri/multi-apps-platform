// =============================================================================
// 🌿 BRANCH INFO COMPONENTS - UI branche selon README.md
// =============================================================================

'use client';

import React, { useState, useEffect } from 'react';
import { useBranch } from '../hooks/useBranch';

export function BranchInfoProvider({ children }: { children: React.ReactNode }) {
  return (
    <>
      <EnvironmentBanner />
      {children}
      <BranchDebugWidget />
    </>
  );
}

function EnvironmentBanner() {
  const { environment, branch, isDevelopment, isStaging } = useBranch();
  
  if (!isDevelopment && !isStaging) return null;

  const bannerConfig = {
    development: {
      color: '#f97316',
      backgroundColor: '#fff7ed',
      text: `🚧 LOCAL - développement`,
    },
    staging: {
      color: '#3b82f6', 
      backgroundColor: '#eff6ff',
      text: `🧪 STAGING - ${branch}`,
    }
  };

  const config = bannerConfig[environment as keyof typeof bannerConfig];
  if (!config) return null;

  return (
    <div
      style={{
        backgroundColor: config.backgroundColor,
        color: config.color,
        padding: '8px 16px',
        textAlign: 'center',
        fontSize: '14px',
        fontWeight: '500',
        borderBottom: `2px solid ${config.color}`,
        position: 'sticky',
        top: 0,
        zIndex: 1000,
      }}
    >
      {config.text} - Math4Child v4.2.0
    </div>
  );
}

function BranchDebugWidget() {
  const [mounted, setMounted] = useState(false);
  const [isExpanded, setIsExpanded] = useState(false);
  const { branch, environment, apiUrl, features } = useBranch();

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted || environment === 'production') return null;
  
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
        zIndex: 99999,
        cursor: 'pointer',
        border: '2px solid #10b981',
        transition: 'all 0.3s ease'
      }}
      onClick={() => setIsExpanded(!isExpanded)}
    >
      {isExpanded ? (
        <div>
          <div style={{ fontWeight: 'bold', color: '#10b981', marginBottom: '8px' }}>
            🌿 Math4Child Debug
          </div>
          <div>Branch: <span style={{ color: '#10b981' }}>{branch}</span></div>
          <div>Env: <span style={{ color: '#3b82f6' }}>{environment}</span></div>
          <div>API: <span style={{ color: '#f59e0b' }}>{apiUrl}</span></div>
          <div style={{ marginTop: '8px', fontSize: '11px', opacity: 0.7 }}>
            Analytics: {features.analytics ? '✅' : '❌'} |
            Debug: {features.debugging ? '✅' : '❌'} |
            Tests: {features.testing ? '✅' : '❌'}
          </div>
          <div style={{ marginTop: '4px', fontSize: '10px', opacity: 0.6 }}>
            Clic pour réduire
          </div>
        </div>
      ) : (
        <div style={{ fontSize: '11px' }}>
          🌿 {branch} | {environment}
        </div>
      )}
    </div>
  );
}
