// =============================================================================
// 🛡️ GESTIONNAIRE D'ERREURS UNIVERSEL MATH4CHILD (CORRIGÉ)
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
  connection?: any // Type simplifié pour éviter les erreurs
}

export interface RetryConfig {
  maxRetries: number
  backoffMs: number
  exponentialBackoff: boolean
  retryCondition?: (error: Error) => boolean
}

// Types pour les erreurs
type ErrorSeverityLevel = 'low' | 'medium' | 'high' | 'critical'

const ERROR_EMOJIS: Record<ErrorSeverityLevel, string> = {
  critical: '🚨',
  high: '⚠️',
  medium: '⚡',
  low: 'ℹ️'
}

export class RobustErrorHandler {
  
  private static instance: RobustErrorHandler
  private errorQueue: Array<{ error: Error; context: ErrorContext; retryCount: number }> = []
  private isOnline = typeof navigator !== 'undefined' ? navigator.onLine : true
  
  static getInstance(): RobustErrorHandler {
    if (!this.instance) {
      this.instance = new RobustErrorHandler()
    }
    return this.instance
  }
  
  constructor() {
    if (typeof window !== 'undefined') {
      this.setupGlobalErrorHandling()
      this.setupNetworkMonitoring()
    }
  }
  
  private setupGlobalErrorHandling(): void {
    if (typeof window === 'undefined') return
    
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
  
  private setupNetworkMonitoring(): void {
    if (typeof window === 'undefined') return
    
    window.addEventListener('online', () => {
      this.isOnline = true
      this.processErrorQueue()
    })
    
    window.addEventListener('offline', () => {
      this.isOnline = false
    })
  }
  
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
        
        if (config.retryCondition && !config.retryCondition(lastError)) {
          break
        }
        
        if (attempt === config.maxRetries) {
          break
        }
        
        const delay = config.exponentialBackoff 
          ? config.backoffMs * Math.pow(2, attempt)
          : config.backoffMs
        
        console.log(`🔄 [RETRY] Tentative ${attempt + 1}/${config.maxRetries + 1} dans ${delay}ms`)
        
        await this.delay(delay)
      }
    }
    
    this.handleError(lastError!, { ...context, action: `${context.action}_retry_failed` })
    throw lastError!
  }
  
  handleError(error: Error, context: ErrorContext): void {
    const errorInfo = {
      error,
      context,
      retryCount: 0,
      id: this.generateErrorId(),
      severity: this.calculateSeverity(error, context)
    }
    
    this.logError(errorInfo)
    
    if (!this.isOnline) {
      this.errorQueue.push(errorInfo)
    } else {
      this.sendErrorToServer(errorInfo)
    }
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
    if (typeof navigator === 'undefined' || !navigator.onLine) return 'offline'
    
    const connection = (navigator as any).connection
    if (connection && connection.downlink && connection.downlink < 1) {
      return 'slow'
    }
    
    return 'online'
  }
  
  private calculateSeverity(error: Error, context: ErrorContext): ErrorSeverityLevel {
    if (error.message.includes('payment') || 
        error.message.includes('subscription') ||
        context.action.includes('payment')) {
      return 'critical'
    }
    
    if (error.message.includes('network') ||
        error.message.includes('api') ||
        context.action.includes('save')) {
      return 'high'
    }
    
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
  
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms))
  }
  
  private generateErrorId(): string {
    return `err_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
  }
  
  private logError(errorInfo: any): void {
    const emoji = ERROR_EMOJIS[errorInfo.severity as ErrorSeverityLevel] || '❓'
    
    console.error(
      `${emoji} [${errorInfo.severity.toUpperCase()}] ${errorInfo.context.component}:`,
      errorInfo.error.message,
      errorInfo
    )
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

export default RobustErrorHandler
