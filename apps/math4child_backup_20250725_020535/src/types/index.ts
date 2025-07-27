// Types de base pour Math4Child

export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
}

export interface PlatformInfo {
  platform: 'web' | 'android' | 'ios'
  isNative: boolean
  isCapacitor: boolean
  isMobile: boolean
  isTablet: boolean
  userAgent: string
}

// Étendre Window pour Capacitor
declare global {
  interface Window {
    Capacitor?: {
      getPlatform: () => 'web' | 'android' | 'ios'
      isNativePlatform: () => boolean
      Plugins?: any
    }
  }
}

export {}
