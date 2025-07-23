// Types globaux pour Math4Child

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

interface Window {
  Capacitor?: {
    platform: 'web' | 'ios' | 'android'
  }
}

// Types pour les providers de paiement
export interface PaymentCheckoutResponse {
  success: boolean
  provider: string
  checkoutUrl?: string
  sessionId?: string
  packageId?: string
  offering?: string
}

// Types pour la robustesse
export interface ErrorSeverity {
  critical: string
  high: string
  medium: string
  low: string
}

// Types IndexedDB
interface IDBIndex {
  getAll(query?: IDBValidKey | IDBKeyRange | boolean | null): IDBRequest<any[]>
}
