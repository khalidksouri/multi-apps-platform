'use client';

import React from 'react';

// Composant simple sans dépendances externes
export function BranchInfoProvider({ children }: { children: React.ReactNode }) {
  return (
    <>
      {children}
      <BranchDebugWidget />
    </>
  );
}

function BranchDebugWidget() {
  // Widget debug simple
  const branch = process.env.NEXT_PUBLIC_BRANCH || 'main';
  const env = process.env.NODE_ENV || 'development';
  
  if (env === 'production') return null;
  
  return (
    <div style={{
      position: 'fixed',
      bottom: '20px',
      left: '20px',
      backgroundColor: '#1f2937',
      color: '#f9fafb',
      padding: '8px 12px',
      borderRadius: '6px',
      fontSize: '12px',
      fontFamily: 'monospace',
      zIndex: 9999,
      opacity: 0.8
    }}>
      🌿 {branch} | {env}
    </div>
  );
}
