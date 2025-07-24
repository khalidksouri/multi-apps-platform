import { Page } from '@playwright/test'

export class TestHelpers {
  constructor(private page: Page) {}

  /**
   * Attendre qu'un élément soit visible avec timeout personnalisé
   */
  async waitForElement(selector: string, timeout = 10000): Promise<boolean> {
    try {
      await this.page.locator(selector).first().waitFor({ 
        state: 'visible', 
        timeout 
      })
      return true
    } catch {
      return false
    }
  }

  /**
   * Rechercher des éléments avec plusieurs sélecteurs
   */
  async findAnyElement(selectors: string[]): Promise<{ selector: string; found: boolean }[]> {
    const results = []
    
    for (const selector of selectors) {
      const found = await this.waitForElement(selector, 2000)
      results.push({ selector, found })
      
      if (found) {
        console.log(`✅ Élément trouvé: ${selector}`)
      }
    }
    
    return results
  }

  /**
   * Vérifier l'absence de texte interdit
   */
  async checkForbiddenContent(forbiddenTexts: string[]): Promise<string[]> {
    const bodyText = await this.page.textContent('body') || ''
    const found = forbiddenTexts.filter(text => 
      bodyText.toLowerCase().includes(text.toLowerCase())
    )
    
    if (found.length > 0) {
      console.log(`❌ Contenu interdit trouvé: ${found.join(', ')}`)
    } else {
      console.log('✅ Aucun contenu interdit détecté')
    }
    
    return found
  }

  /**
   * Capturer les erreurs JavaScript
   */
  async captureJSErrors(): Promise<string[]> {
    const jsErrors: string[] = []
    
    this.page.on('console', msg => {
      if (msg.type() === 'error') {
        jsErrors.push(msg.text())
      }
    })
    
    // Attendre un peu pour capturer les erreurs
    await this.page.waitForTimeout(2000)
    
    // Filtrer les erreurs non critiques
    return jsErrors.filter(error =>
      !error.includes('favicon') &&
      !error.includes('Extension') &&
      !error.includes('chrome-extension') &&
      !error.includes('analytics')
    )
  }

  /**
   * Vérifier la performance de la page
   */
  async checkPerformance() {
    const navigationTiming = await this.page.evaluate(() => {
      const timing = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming
      return {
        domContentLoaded: timing.domContentLoadedEventEnd - timing.navigationStart,
        loadComplete: timing.loadEventEnd - timing.navigationStart,
        firstPaint: timing.responseEnd - timing.navigationStart
      }
    })

    console.log('📊 Performance:', {
      domContentLoaded: `${navigationTiming.domContentLoaded}ms`,
      loadComplete: `${navigationTiming.loadComplete}ms`, 
      firstPaint: `${navigationTiming.firstPaint}ms`
    })

    return navigationTiming
  }

  /**
   * Tester les fonctionnalités de langue
   */
  async testLanguageFeatures(): Promise<boolean> {
    const languageSelectors = [
      'select[name="language"]',
      'select[name="lang"]', 
      '[data-testid*="language"]',
      'button:has-text("Français")',
      'button:has-text("English")',
      '.language-selector',
      '.lang-switch'
    ]

    const results = await this.findAnyElement(languageSelectors)
    const foundSelectors = results.filter(r => r.found)

    if (foundSelectors.length > 0) {
      console.log(`✅ ${foundSelectors.length} sélecteur(s) de langue trouvé(s)`)
      
      // Essayer d'interagir avec le premier sélecteur trouvé
      const firstSelector = foundSelectors[0].selector
      try {
        const element = this.page.locator(firstSelector).first()
        
        if (firstSelector.includes('select')) {
          await element.selectOption({ index: 1 })
          console.log('✅ Changement de langue via select tenté')
        } else {
          await element.click()
          console.log('✅ Clic sur sélecteur de langue tenté')
        }
        
        await this.page.waitForTimeout(1000)
        return true
      } catch (error) {
        console.log(`ℹ️  Interaction échouée: ${error}`)
        return false
      }
    }

    return false
  }

  /**
   * Prendre une capture d'écran avec nom personnalisé
   */
  async takeScreenshot(name: string) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
    await this.page.screenshot({ 
      path: `test-results/screenshots/${name}-${timestamp}.png`,
      fullPage: true 
    })
  }

  /**
   * Vérifier l'accessibilité de base
   */
  async checkBasicAccessibility() {
    const issues = []
    
    // Vérifier les images sans alt
    const imagesWithoutAlt = await this.page.locator('img:not([alt])').count()
    if (imagesWithoutAlt > 0) {
      issues.push(`${imagesWithoutAlt} image(s) sans attribut alt`)
    }
    
    // Vérifier les liens sans texte
    const emptyLinks = await this.page.locator('a:not(:has-text(" "))').count()
    if (emptyLinks > 0) {
      issues.push(`${emptyLinks} lien(s) sans texte`)
    }
    
    // Vérifier la structure des titres
    const h1Count = await this.page.locator('h1').count()
    if (h1Count === 0) {
      issues.push('Aucun titre H1 trouvé')
    } else if (h1Count > 1) {
      issues.push(`${h1Count} titres H1 trouvés (recommandé: 1 seul)`)
    }
    
    if (issues.length > 0) {
      console.log(`⚠️  Problèmes d'accessibilité: ${issues.join(', ')}`)
    } else {
      console.log('✅ Vérifications d\'accessibilité basiques OK')
    }
    
    return issues
  }
}
