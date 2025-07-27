// Types globaux pour Math4Child

declare global {
  interface Window {
    Capacitor?: {
      platform: 'web' | 'ios' | 'android'
      getPlatform(): 'web' | 'ios' | 'android'
      Plugins?: {
        Haptics?: {
          impact(options: { style: 'light' | 'medium' | 'heavy' }): Promise<void>
        }
      }
    }
  }

  interface NetworkInformation {
    downlink: number
    effectiveType: string
    rtt: number
    saveData: boolean
  }

  interface Navigator {
    connection?: NetworkInformation
    mozConnection?: NetworkInformation
    webkitConnection?: NetworkInformation
  }
}

// Types pour les composants
export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
}

export interface PaymentProvider {
  name: 'stripe' | 'paddle' | 'lemonsqueezy' | 'revenuecat'
  priority: number
  supportedPlatforms: ('web' | 'ios' | 'android')[]
  fees: {
    percentage: number
    fixed: number
    currency: string
  }
}

export interface CheckoutOptions {
  platform?: 'web' | 'ios' | 'android'
  amount: number
  currency?: string
  planId: string
  userId?: string
}

export interface CheckoutSession {
  id: string
  provider: string
  checkoutUrl: string
  amount: number
  currency: string
  platform: string
  isNative: boolean
}

export {}
