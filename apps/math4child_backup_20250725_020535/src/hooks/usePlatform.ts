'use client'

import { useState, useEffect } from 'react'

interface PlatformInfo {
  platform: 'web' | 'android' | 'ios'
  isNative: boolean
  isCapacitor: boolean
  isMobile: boolean
  isTablet: boolean
  userAgent: string
}

export function usePlatform(): PlatformInfo {
  const [platformInfo, setPlatformInfo] = useState<PlatformInfo>({
    platform: 'web',
    isNative: false,
    isCapacitor: false,
    isMobile: false,
    isTablet: false,
    userAgent: ''
  })

  useEffect(() => {
    if (typeof window === 'undefined') return

    try {
      const userAgent = navigator.userAgent
      
      // Détecter Capacitor de façon sécurisée
      const isCapacitor = !!(window as any).Capacitor
      
      // Détecter la plateforme
      let platform: 'web' | 'android' | 'ios' = 'web'
      if (isCapacitor && (window as any).Capacitor.getPlatform) {
        try {
          platform = (window as any).Capacitor.getPlatform()
        } catch (error) {
          console.warn('Erreur getPlatform:', error)
        }
      } else if (userAgent.includes('Android')) {
        platform = 'android'
      } else if (userAgent.includes('iPhone') || userAgent.includes('iPad')) {
        platform = 'ios'
      }
      
      // Détecter mobile/tablet
      const isMobile = /Android|iPhone|iPod|BlackBerry|IEMobile|Opera Mini/i.test(userAgent)
      const isTablet = /iPad|Android(?!.*Mobile)|Tablet/i.test(userAgent)
      
      setPlatformInfo({
        platform,
        isNative: isCapacitor,
        isCapacitor,
        isMobile,
        isTablet,
        userAgent
      })
    } catch (error) {
      console.warn('Erreur détection plateforme:', error)
      // Garder les valeurs par défaut
    }
  }, [])

  return platformInfo
}

// Hook pour détecter si on est en mode hybride
export function useIsHybrid(): boolean {
  const { isCapacitor } = usePlatform()
  return isCapacitor
}

// Hook pour obtenir les capacités de la plateforme
export function usePlatformCapabilities() {
  const platform = usePlatform()
  
  return {
    canInstallPWA: platform.platform === 'web' && !platform.isNative,
    canUseNativeFeatures: platform.isNative,
    canUseCamera: platform.isNative,
    canUseHaptics: platform.platform === 'ios' || platform.platform === 'android',
    canUseNotifications: true,
    canUseGeolocation: true,
    supportsPushNotifications: platform.isNative,
    supportsAppStoreReview: platform.isNative,
  }
}
