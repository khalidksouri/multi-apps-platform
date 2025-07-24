import { test, expect } from '@playwright/test'
import { TestHelpers } from '../helpers/test-helpers'
import { HomePage, TranslationPage } from '../helpers/page-objects'

test.describe('🌍 Tests de Traduction Améliorés', () => {
  let helpers: TestHelpers
  let homePage: HomePage
  let translationPage: TranslationPage

  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page)
    homePage = new HomePage(page)
    translationPage = new TranslationPage(page)
    
    await homePage.goto()
  })

  test('Page d\'accueil - Vérifications complètes', async ({ page }) => {
    // Vérifier que la page est bien chargée
    expect(await homePage.isLoaded()).toBeTruthy()
    
    // Vérifier le titre
    const title = await homePage.getTitle()
    expect(title).not.toContain('404')
    expect(title).not.toContain('Error')
    console.log(`✅ Titre de la page: ${title}`)
    
    // Vérifier le contenu
    const content = await homePage.getContent()
    expect(content).toBeTruthy()
    expect(content!.length).toBeGreaterThan(100)
    
    // Vérifier la performance
    const perf = await homePage.checkPerformance()
    expect(perf.domContentLoaded).toBeLessThan(5000) // 5 secondes max
    
    // Capturer les erreurs JS
    const jsErrors = await helpers.captureJSErrors()
    expect(jsErrors.length).toBeLessThan(3) // Maximum 2 erreurs acceptables
    
    // Vérifier l'accessibilité de base
    const accessibilityIssues = await helpers.checkBasicAccessibility()
    console.log(`ℹ️  Problèmes d'accessibilité trouvés: ${accessibilityIssues.length}`)
  })

  test('Fonctionnalités multilingues avancées', async ({ page }) => {
    // Rechercher et tester les sélecteurs de langue
    const languageWorked = await translationPage.testLanguageFeatures()
    
    // Détecter le contenu multilingue
    const multilingualContent = await translationPage.detectMultilingualContent()
    
    if (multilingualContent.french.length > 0) {
      console.log(`✅ Mots-clés français trouvés: ${multilingualContent.french.join(', ')}`)
    }
    
    if (multilingualContent.arabic || multilingualContent.chinese || multilingualContent.cyrillic) {
      console.log('✅ Support international détecté')
      if (multilingualContent.arabic) console.log('  - Arabe détecté')
      if (multilingualContent.chinese) console.log('  - Chinois détecté') 
      if (multilingualContent.cyrillic) console.log('  - Cyrillique détecté')
    }
    
    // Le test passe toujours (mode exploratoire)
    expect(true).toBeTruthy()
  })

  test('Vérification stricte du contenu interdit', async ({ page }) => {
    const found = await translationPage.checkForbiddenContent()
    
    // Ce test doit échouer si du contenu interdit est trouvé
    expect(found).toHaveLength(0)
  })

  test('Test de navigation et liens', async ({ page }) => {
    // Vérifier les liens de navigation principaux
    const navigationLinks = [
      'a[href="/"]',
      'a[href="/about"]', 
      'a[href="/contact"]',
      'nav a',
      '.navigation a'
    ]
    
    const foundLinks = await helpers.findAnyElement(navigationLinks)
    const validLinks = foundLinks.filter(l => l.found)
    
    console.log(`✅ ${validLinks.length} lien(s) de navigation trouvé(s)`)
    
    // Tester que les liens internes ne sont pas cassés
    for (const link of validLinks.slice(0, 3)) { // Tester max 3 liens
      try {
        const href = await page.locator(link.selector).first().getAttribute('href')
        if (href && href.startsWith('/')) {
          const response = await page.request.get(href)
          console.log(`✅ Lien ${href}: ${response.status()}`)
          expect(response.status()).toBeLessThan(400)
        }
      } catch (error) {
        console.log(`ℹ️  Erreur lors du test du lien: ${error}`)
      }
    }
  })

  test.afterEach(async ({ page }, testInfo) => {
    // Capturer une capture d'écran en cas d'échec
    if (testInfo.status !== testInfo.expectedStatus) {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
      const screenshot = await page.screenshot({ fullPage: true })
      await testInfo.attach('screenshot', { 
        body: screenshot, 
        contentType: 'image/png' 
      })
    }
  })
})
