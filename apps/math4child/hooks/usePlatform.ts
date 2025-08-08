'use client';

import { useState, useEffect } from 'react';

interface PlatformInfo {
  isWeb: boolean;
  isMobile: boolean;
  isAndroid: boolean;
  isIOS: boolean;
  isCapacitor: boolean;
  platform: 'web' | 'android' | 'ios';
  userAgent: string;
  screenSize: 'mobile' | 'tablet' | 'desktop';
}

export const usePlatform = (): PlatformInfo => {
  const [platformInfo, setPlatformInfo] = useState<PlatformInfo>({
    isWeb: true,
    isMobile: false,
    isAndroid: false,
    isIOS: false,
    isCapacitor: false,
    platform: 'web',
    userAgent: '',
    screenSize: 'desktop'
  });

  useEffect(() => {
    if (typeof window === 'undefined') return;

    const userAgent = navigator.userAgent;
    const isCapacitor = !!(window as any).Capacitor?.isNativePlatform?.();
    
    // Détection de la taille d'écran
    const getScreenSize = (): 'mobile' | 'tablet' | 'desktop' => {
      const width = window.innerWidth;
      if (width < 768) return 'mobile';
      if (width < 1024) return 'tablet';
      return 'desktop';
    };
    
    if (isCapacitor) {
      // Environnement Capacitor
      import('@capacitor/core').then(({ Capacitor }) => {
        const platform = Capacitor.getPlatform();
        
        setPlatformInfo({
          isWeb: platform === 'web',
          isMobile: platform !== 'web',
          isAndroid: platform === 'android',
          isIOS: platform === 'ios',
          isCapacitor: true,
          platform: platform as 'web' | 'android' | 'ios',
          userAgent,
          screenSize: getScreenSize()
        });
      }).catch(() => {
        // Fallback si import échoue
        setPlatformInfo(prev => ({ ...prev, isCapacitor: false }));
      });
    } else {
      // Environnement web standard
      const isMobileWeb = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(userAgent);
      const isAndroidWeb = /Android/i.test(userAgent);
      const isIOSWeb = /iPhone|iPad|iPod/i.test(userAgent);
      
      setPlatformInfo({
        isWeb: true,
        isMobile: isMobileWeb,
        isAndroid: isAndroidWeb,
        isIOS: isIOSWeb,
        isCapacitor: false,
        platform: 'web',
        userAgent,
        screenSize: getScreenSize()
      });
    }

    // Écouter les changements de taille d'écran
    const handleResize = () => {
      setPlatformInfo(prev => ({
        ...prev,
        screenSize: getScreenSize()
      }));
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return platformInfo;
};

// Hook utilitaire pour les styles conditionnels
export const usePlatformStyles = () => {
  const platform = usePlatform();
  
  return {
    // Classes Tailwind conditionnelles
    container: platform.isCapacitor 
      ? 'pb-20' // Espace pour navigation native
      : platform.isMobile 
      ? 'pb-16' // Espace pour navigation web mobile
      : 'pb-4', // Desktop normal
      
    navigation: platform.isCapacitor
      ? 'fixed bottom-0 native-nav'
      : 'web-nav',
      
    // Styles pour les interactions tactiles
    touchTarget: platform.isMobile 
      ? 'min-h-[44px] min-w-[44px]' // Cible tactile minimum
      : 'min-h-[32px]',
      
    // Safe areas pour les appareils avec encoche
    safeArea: platform.isIOS && platform.isCapacitor
      ? 'pb-safe-bottom pt-safe-top'
      : ''
  };
};
