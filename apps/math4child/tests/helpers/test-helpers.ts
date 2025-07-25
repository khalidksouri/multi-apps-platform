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
   * Vérifier la performance de la page (version compatible Netlify)
   */
  async checkPerformance() {
    try {
      const navigationTiming = await this.page.evaluate(() => {
        // Version compatible avec différentes implémentations de l'API Performance
        const perfEntries = performance.getEntriesByType('navigation')
        if (perfEntries.length === 0) {
          return {
            domContentLoaded: 0,
            loadComplete: 0,
            firstPaint: 0
          }
        }
        
        const timing = perfEntries[0] as any // Type plus flexible
        
        // Essayer différentes approches selon ce qui est disponible
        let domContentLoaded = 0
        let loadComplete = 0
        let firstPaint = 0
        
        // Méthode moderne (si disponible)
        if (timing.domContentLoadedEventEnd && timing.fetchStart) {
          domContentLoaded = timing.domContentLoadedEventEnd - timing.fetchStart
        } else if (timing.domContentLoadedEventEnd && timing.startTime) {
          domContentLoaded = timing.domContentLoadedEventEnd - timing.startTime
        }
        
        if (timing.loadEventEnd && timing.fetchStart) {
          loadComplete = timing.loadEventEnd - timing.fetchStart
        } else if (timing.loadEventEnd && timing.startTime) {
          loadComplete = timing.loadEventEnd - timing.startTime
        }
        
        if (timing.responseEnd && timing.fetchStart) {
          firstPaint = timing.responseEnd - timing.fetchStart
        } else if (timing.responseEnd && timing.startTime) {
          firstPaint = timing.responseEnd - timing.startTime
        }
        
        return {
          domContentLoaded: Math.max(0, domContentLoaded),
          loadComplete: Math.max(0, loadComplete),
          firstPaint: Math.max(0, firstPaint)
        }
      })

      console.log('📊 Performance:', {
        domContentLoaded: `${navigationTiming.domContentLoaded}ms`,
        loadComplete: `${navigationTiming.loadComplete}ms`, 
        firstPaint: `${navigationTiming.firstPaint}ms`
      })

      return navigationTiming
    } catch (error) {
      console.log('⚠️  Erreur lors de la mesure de performance:', error)
      // Retourner des valeurs par défaut en cas d'erreur
      return {
        domContentLoaded: 0,
        loadComplete: 0,
        firstPaint: 0
      }
    }
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
      const firstSelector = foundSelectors[0]?.selector || "body"
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
    try {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
      await this.page.screenshot({ 
        path: `test-results/screenshots/${name}-${timestamp}.png`,
        fullPage: true 
      })
      console.log(`📸 Capture d'écran sauvée: ${name}-${timestamp}.png`)
    } catch (error) {
      console.log(`⚠️  Erreur lors de la capture: ${error}`)
    }
  }

  /**
   * Vérifier l'accessibilité de base
   */
  async checkBasicAccessibility() {
    const issues = []
    
    try {
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
    } catch (error) {
      console.log(`⚠️  Erreur lors de la vérification d'accessibilité: ${error}`)
    }
    
    return issues
  }
}
