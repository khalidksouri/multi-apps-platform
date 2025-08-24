// src/app/page.tsx - VERSION CORRIGÉE
'use client';

import { useBranch, useApiConfig } from '../hooks/useBranch';
import { useEffect } from 'react';

export default function HomePage() {
  const { 
    branch, 
    environment, 
    isProduction, 
    shouldShowDebugInfo,
    shouldEnableAnalytics 
  } = useBranch();
  
  const { apiUrl } = useApiConfig();

  useEffect(() => {
    if (shouldEnableAnalytics) {
      console.log('🔍 Analytics activées pour:', environment);
    }

    console.log('🌐 API URL configurée:', apiUrl);
    
    if (!isProduction) {
      console.log('🧪 Mode de test activé');
    }
  }, [environment, apiUrl, shouldEnableAnalytics, isProduction]);

  return (
    <div style={{ padding: '20px', fontFamily: 'system-ui' }}>
      <h1>Math4Child 🧮</h1>
      <p>Plateforme d'apprentissage des mathématiques pour enfants</p>
      
      {shouldShowDebugInfo && (
        <div style={{ 
          margin: '20px 0', 
          padding: '15px', 
          backgroundColor: '#f3f4f6',
          borderRadius: '8px',
          border: '1px solid #d1d5db'
        }}>
          <h3 style={{ margin: '0 0 10px 0' }}>🔧 Debug Info:</h3>
          <p><strong>Branche:</strong> {branch}</p>
          <p><strong>Environnement:</strong> {environment}</p>
          <p><strong>API:</strong> {apiUrl}</p>
          <p><strong>Build:</strong> {new Date().toLocaleString()}</p>
        </div>
      )}
      
      <main>
        <div style={{ 
          padding: '20px', 
          backgroundColor: '#e0f2fe',
          borderRadius: '12px',
          marginTop: '20px'
        }}>
          <h2>🎯 Fonctionnalités Math4Child</h2>
          <ul>
            <li>🧮 6 Innovations révolutionnaires</li>
            <li>🎓 3 Modes d'apprentissage uniques</li>
            <li>📈 5 Niveaux de progression</li>
            <li>➕ 5 Opérations mathématiques</li>
            <li>🌍 200+ Langues supportées</li>
            <li>💎 Plans d'abonnement conformes</li>
          </ul>
          
          <div style={{ marginTop: '20px' }}>
            <strong>🚀 Statut de déploiement:</strong>
            <span style={{ 
              marginLeft: '10px',
              padding: '4px 8px',
              borderRadius: '4px',
              backgroundColor: isProduction ? '#dcfce7' : '#fef3c7',
              color: isProduction ? '#166534' : '#92400e'
            }}>
              {environment.toUpperCase()}
            </span>
          </div>
        </div>
      </main>
    </div>
  );
}
