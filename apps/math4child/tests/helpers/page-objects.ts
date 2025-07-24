import { Page, expect } from '@playwright/test'
import { TestHelpers } from './test-helpers'

export class HomePage {
  private helpers: TestHelpers

  constructor(private page: Page) {
    this.helpers = new TestHelpers(page)
  }

  async goto() {
    await this.page.goto('/', { 
      waitUntil: 'networkidle',
      timeout: 15000 
    })
  }

  async getTitle() {
    return await this.page.title()
  }

  async isLoaded() {
    return await this.page.locator('body').isVisible()
  }

  async getContent() {
    return await this.page.textContent('body')
  }

  async checkPerformance() {
    return await this.helpers.checkPerformance()
  }

  async takeScreenshot(name: string = 'homepage') {
    await this.helpers.takeScreenshot(name)
  }
}

export class PaymentPage {
  private helpers: TestHelpers

  constructor(private page: Page) {
    this.helpers = new TestHelpers(page)
  }

  async findPaymentElements() {
    const selectors = [
      'button:has-text("Premium")',
      'button:has-text("Abonnement")', 
      'text=€',
      'text=prix',
      '[data-testid*="payment"]',
      '[data-testid*="plan"]',
      '[data-testid*="pricing"]'
    ]

    return await this.helpers.findAnyElement(selectors)
  }

  async testStripeEndpoint() {
    try {
      const response = await this.page.request.get('/api/stripe/create-checkout-session')
      return {
        status: response.status(),
        ok: response.ok(),
        data: response.ok() ? await response.json() : null
      }
    } catch (error: any) {
      return {
        status: 0,
        ok: false, 
        error: error.message
      }
    }
  }

  async findPaymentLinks() {
    const selectors = [
      'a[href*="stripe"]',
      'a[href*="payment"]', 
      'a[href*="pricing"]',
      'a[href*="subscribe"]',
      'button:has-text("Test")'
    ]

    return await this.helpers.findAnyElement(selectors)
  }
}

export class TranslationPage {
  private helpers: TestHelpers

  constructor(private page: Page) {
    this.helpers = new TestHelpers(page)
  }

  async testLanguageFeatures() {
    return await this.helpers.testLanguageFeatures()
  }

  async checkForbiddenContent() {
    const forbiddenContent = [
      'en Francia',
      'في فرنسا', 
      'in France',
      'en France',
      'in Frankreich',
      'in Francia'
    ]
    
    return await this.helpers.checkForbiddenContent(forbiddenContent)
  }

  async detectMultilingualContent() {
    const content = await this.page.textContent('body') || ''
    
    // Mots-clés français
    const frenchKeywords = ['mathématiques', 'éducative', 'famille', 'gratuit', 'apprentissage']
    const foundFrench = frenchKeywords.filter(word => 
      content.toLowerCase().includes(word.toLowerCase())
    )
    
    // Scripts internationaux
    const hasArabic = /[\u0600-\u06FF]/.test(content)
    const hasChinese = /[\u4e00-\u9fff]/.test(content)
    const hasCyrillic = /[\u0400-\u04FF]/.test(content)
    
    return {
      french: foundFrench,
      arabic: hasArabic,
      chinese: hasChinese,
      cyrillic: hasCyrillic
    }
  }
}
