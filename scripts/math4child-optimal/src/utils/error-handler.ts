// =============================================================================
// 🛡️ GESTIONNAIRE D'ERREURS UNIVERSEL MATH4CHILD COMPLET
// =============================================================================

export interface ErrorContext {
  component: string
  action: string
  userId?: string
  deviceInfo: DeviceInfo
  networkStatus: 'online' | 'offline' | 'slow'
  timestamp: number
}

export interface DeviceInfo {
  platform: 'web' | 'ios' | 'android' | 'desktop'
  userAgent: string
  screenSize: { width: number; height: number }
  isTouchDevice: boolean
  connection?: NetworkInformation
}

export interface RetryConfig {
  maxRetries: number
  backoffMs: number
  exponentialBackoff: boolean
  retryCondition?: (error: Error) => boolean
}

export class RobustErrorHandler {
  
  private static instance: RobustErrorHandler
  private errorQueue: Array<{ error: Error; context: ErrorContext; retryCount: number }> = []
  private isOnline = navigator.onLine
  
  static getInstance(): RobustErrorHandler {
    if (!this.instance) {
      this.instance = new RobustErrorHandler()
    }
    return this.instance
  }
  
  constructor() {
    this.setupGlobalErrorHandling()
    this.setupNetworkMonitoring()
    this.setupUnhandledPromiseRejection()
  }
  
  // Configuration automatique selon le device
  private setupGlobalErrorHandling(): void {
    // Web: Error boundaries et window.onerror
    if (typeof window !== 'undefined') {
      window.onerror = (message, source, lineno, colno, error) => {
        this.handleError(error || new Error(String(message)), {
          component: 'global',
          action: 'runtime_error',
          deviceInfo: this.getDeviceInfo(),
          networkStatus: this.getNetworkStatus(),
          timestamp: Date.now()
        })
      }
      
      window.addEventListener('unhandledrejection', (event) => {
        this.handleError(
          new Error(`Unhandled Promise Rejection: ${event.reason}`),
          {
            component: 'global',
            action: 'promise_rejection',
            deviceInfo: this.getDeviceInfo(),
            networkStatus: this.getNetworkStatus(),
            timestamp: Date.now()
          }
        )
      })
    }
    
    // Mobile: Capacitor native error handling
    if (this.isMobileApp()) {
      this.setupMobileErrorHandling()
    }
  }
  
  private setupMobileErrorHandling(): void {
    // iOS/Android specific error handling
    if (typeof window !== 'undefined' && (window as any).Capacitor) {
      const { Capacitor } = (window as any)
      
      // Écouter les erreurs natives
      document.addEventListener('deviceready', () => {
        if (Capacitor.platform === 'ios') {
          this.setupiOSErrorHandling()
        } else if (Capacitor.platform === 'android') {
          this.setupAndroidErrorHandling()
        }
      })
    }
  }
  
  private setupiOSErrorHandling(): void {
    // Gestion erreurs spécifiques iOS
    console.log('🍎 [iOS] Error handling configuré')
  }
  
  private setupAndroidErrorHandling(): void {
    // Gestion erreurs spécifiques Android
    console.log('🤖 [Android] Error handling configuré')
  }
  
  private setupNetworkMonitoring(): void {
    if (typeof window !== 'undefined') {
      window.addEventListener('online', () => {
        this.isOnline = true
        this.processErrorQueue()
      })
      
      window.addEventListener('offline', () => {
        this.isOnline = false
      })
    }
  }
  
  private setupUnhandledPromiseRejection(): void {
    if (typeof process !== 'undefined') {
      process.on('unhandledRejection', (reason, promise) => {
        this.handleError(
          new Error(`Unhandled Rejection: ${reason}`),
          {
            component: 'node',
            action: 'unhandled_rejection',
            deviceInfo: this.getDeviceInfo(),
            networkStatus: this.getNetworkStatus(),
            timestamp: Date.now()
          }
        )
      })
    }
  }
  
  // Retry automatique avec backoff exponentiel
  async withRetry<T>(
    operation: () => Promise<T>,
    context: ErrorContext,
    config: RetryConfig = {
      maxRetries: 3,
      backoffMs: 1000,
      exponentialBackoff: true
    }
  ): Promise<T> {
    
    let lastError: Error
    
    for (let attempt = 0; attempt <= config.maxRetries; attempt++) {
      try {
        return await operation()
      } catch (error) {
        lastError = error as Error
        
        // Vérifier si on doit retry
        if (config.retryCondition && !config.retryCondition(lastError)) {
          break
        }
        
        if (attempt === config.maxRetries) {
          break
        }
        
        // Calculer délai de retry
        const delay = config.exponentialBackoff 
          ? config.backoffMs * Math.pow(2, attempt)
          : config.backoffMs
        
        console.log(`🔄 [RETRY] Tentative ${attempt + 1}/${config.maxRetries + 1} dans ${delay}ms`)
        
        await this.delay(delay)
      }
    }
    
    // Toutes les tentatives ont échoué
    this.handleError(lastError!, { ...context, action: `${context.action}_retry_failed` })
    throw lastError!
  }
  
  // Gestion intelligente des erreurs selon le device
  handleError(error: Error, context: ErrorContext): void {
    const errorInfo = {
      error,
      context,
      retryCount: 0,
      id: this.generateErrorId(),
      severity: this.calculateSeverity(error, context)
    }
    
    // Log local immédiat
    this.logError(errorInfo)
    
    // Stratégie selon le device
    if (this.isMobileApp()) {
      this.handleMobileError(errorInfo)
    } else if (this.isDesktop()) {
      this.handleDesktopError(errorInfo)
    } else {
      this.handleWebError(errorInfo)
    }
    
    // Envoi différé si hors ligne
    if (!this.isOnline) {
      this.errorQueue.push(errorInfo)
    } else {
      this.sendErrorToServer(errorInfo)
    }
  }
  
  private handleMobileError(errorInfo: any): void {
    // Tactile feedback et notifications natives
    if (this.isVibrationSupported()) {
      this.vibrate([100, 50, 100]) // Pattern d'erreur
    }
    
    // Toast natif si disponible
    this.showNativeToast(`Erreur: ${errorInfo.error.message}`, 'error')
  }
  
  private handleDesktopError(errorInfo: any): void {
    // Notifications desktop
    if ('Notification' in window && Notification.permission === 'granted') {
      new Notification('Math4Child - Erreur', {
        body: errorInfo.error.message,
        icon: '/favicon.ico'
      })
    }
  }
  
  private handleWebError(errorInfo: any): void {
    // Feedback visuel web
    this.showWebNotification(errorInfo.error.message, errorInfo.severity)
  }
  
  // Utilitaires device detection
  private isMobileApp(): boolean {
    return typeof window !== 'undefined' && 
           !!(window as any).Capacitor && 
           ['ios', 'android'].includes((window as any).Capacitor.platform)
  }
  
  private isDesktop(): boolean {
    return typeof window !== 'undefined' && 
           window.innerWidth >= 1024 && 
           !('ontouchstart' in window)
  }
  
  private getDeviceInfo(): DeviceInfo {
    if (typeof window === 'undefined') {
      return {
        platform: 'web',
        userAgent: 'server',
        screenSize: { width: 0, height: 0 },
        isTouchDevice: false
      }
    }
    
    return {
      platform: this.detectPlatform(),
      userAgent: navigator.userAgent,
      screenSize: {
        width: window.innerWidth,
        height: window.innerHeight
      },
      isTouchDevice: 'ontouchstart' in window,
      connection: (navigator as any).connection
    }
  }
  
  private detectPlatform(): 'web' | 'ios' | 'android' | 'desktop' {
    if (typeof window === 'undefined') return 'web'
    
    if ((window as any).Capacitor) {
      return (window as any).Capacitor.platform
    }
    
    const ua = navigator.userAgent.toLowerCase()
    if (ua.includes('iphone') || ua.includes('ipad')) return 'ios'
    if (ua.includes('android')) return 'android'
    if (window.innerWidth >= 1024 && !('ontouchstart' in window)) return 'desktop'
    
    return 'web'
  }
  
  private getNetworkStatus(): 'online' | 'offline' | 'slow' {
    if (!navigator.onLine) return 'offline'
    
    const connection = (navigator as any).connection
    if (connection) {
      // Connexion lente si < 1 Mbps
      if (connection.downlink && connection.downlink < 1) {
        return 'slow'
      }
    }
    
    return 'online'
  }
  
  private calculateSeverity(error: Error, context: ErrorContext): 'low' | 'medium' | 'high' | 'critical' {
    // Erreurs critiques
    if (error.message.includes('payment') || 
        error.message.includes('subscription') ||
        context.action.includes('payment')) {
      return 'critical'
    }
    
    // Erreurs importantes
    if (error.message.includes('network') ||
        error.message.includes('api') ||
        context.action.includes('save')) {
      return 'high'
    }
    
    // Erreurs moyennes
    if (error.message.includes('validation') ||
        context.action.includes('ui')) {
      return 'medium'
    }
    
    return 'low'
  }
  
  private async sendErrorToServer(errorInfo: any): Promise<void> {
    try {
      await fetch('/api/errors', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          id: errorInfo.id,
          message: errorInfo.error.message,
          stack: errorInfo.error.stack,
          context: errorInfo.context,
          severity: errorInfo.severity,
          timestamp: Date.now()
        })
      })
    } catch {
      // Erreur lors de l'envoi - ajouter à la queue
      this.errorQueue.push(errorInfo)
    }
  }
  
  private processErrorQueue(): void {
    if (this.errorQueue.length === 0) return
    
    const errors = [...this.errorQueue]
    this.errorQueue = []
    
    errors.forEach(errorInfo => {
      this.sendErrorToServer(errorInfo)
    })
  }
  
  // Utilitaires
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
  
  private generateErrorId(): string {
    return `err_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
  }
  
  private logError(errorInfo: any): void {
    const emoji = {
      critical: '🚨',
      high: '⚠️',
      medium: '⚡',
      low: 'ℹ️'
    }[errorInfo.severity] || '❓'
    
    console.error(
      `${emoji} [${errorInfo.severity.toUpperCase()}] ${errorInfo.context.component}:`,
      errorInfo.error.message,
      errorInfo
    )
  }
  
  private isVibrationSupported(): boolean {
    return typeof navigator !== 'undefined' && 'vibrate' in navigator
  }
  
  private vibrate(pattern: number[]): void {
    if (this.isVibrationSupported()) {
      navigator.vibrate(pattern)
    }
  }
  
  private showNativeToast(message: string, type: 'success' | 'error' | 'info'): void {
    // Implémentation toast native via Capacitor
    if (typeof window !== 'undefined' && (window as any).Capacitor) {
      // Toast plugin
      console.log(`📱 [TOAST] ${type}: ${message}`)
    }
  }
  
  private showWebNotification(message: string, severity: string): void {
    // Implémentation notification web
    const notification = document.createElement('div')
    notification.className = `notification notification-${severity}`
    notification.textContent = message
    notification.style.cssText = `
      position: fixed;
      top: 20px;
      right: 20px;
      background: ${severity === 'critical' ? '#ef4444' : '#3b82f6'};
      color: white;
      padding: 12px 16px;
      border-radius: 8px;
      z-index: 9999;
      box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    `
    
    document.body.appendChild(notification)
    
    setTimeout(() => {
      notification.remove()
    }, 5000)
  }
}

// Hook React pour gestion d'erreurs
export function useRobustErrorHandler() {
  const errorHandler = RobustErrorHandler.getInstance()
  
  const handleError = (error: Error, component: string, action: string) => {
    errorHandler.handleError(error, {
      component,
      action,
      deviceInfo: errorHandler['getDeviceInfo'](),
      networkStatus: errorHandler['getNetworkStatus'](),
      timestamp: Date.now()
    })
  }
  
  const withRetry = <T>(
    operation: () => Promise<T>,
    component: string,
    action: string,
    config?: Partial<RetryConfig>
  ) => {
    return errorHandler.withRetry(
      operation,
      {
        component,
        action,
        deviceInfo: errorHandler['getDeviceInfo'](),
        networkStatus: errorHandler['getNetworkStatus'](),
        timestamp: Date.now()
      },
      config as RetryConfig
    )
  }
  
  return { handleError, withRetry }
}

// Export par défaut
export default RobustErrorHandler
