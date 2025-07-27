// Export principal des helpers
export { TestHelpers } from './test-helpers'
export { HomePage, PaymentPage, TranslationPage } from './page-objects'

// Types utiles
export interface PerformanceMetrics {
  domContentLoaded: number
  loadComplete: number
  firstPaint: number
}

export interface MultilingualContent {
  french: string[]
  arabic: boolean
  chinese: boolean
  cyrillic: boolean
}

export interface ElementSearchResult {
  selector: string
  found: boolean
}

export interface ApiTestResult {
  status: number
  ok: boolean
  data?: any
  error?: string
}
