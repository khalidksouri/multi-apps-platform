import { test, expect } from '@playwright/test'

const MAIN_LANGUAGES = ['fr', 'en', 'es', 'de', 'ar', 'zh'] as const

test.describe('Math4Child - Tests multilingues', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForSelector('[data-testid="app-title"]')
  })

  for (const language of MAIN_LANGUAGES) {
    test(`Interface traduite correctement en ${language}`, async ({ page }) => {
      // Changer la langue
      await page.selectOption('[data-testid="language-selector"]', language)
      
      // Attendre que la traduction soit appliquée
      await page.waitForTimeout(500)
      
      // Vérifier que le titre de l'app est présent
      const titleElement = page.locator('[data-testid="app-title"]')
      await expect(titleElement).toBeVisible()
      await expect(titleElement).toContainText('Math4Child')
      
      // Vérifier que le tagline est traduit
      const taglineElement = page.locator('[data-testid="tagline"]')
      await expect(taglineElement).toBeVisible()
      
      // Vérifier que les opérations mathématiques sont visibles
      const operationsContainer = page.locator('[data-testid="math-operations"]')
      await expect(operationsContainer).toBeVisible()
      
      // Vérifier les statistiques des langues
      const statsElement = page.locator('[data-testid="total-languages"]')
      await expect(statsElement).toContainText('20 langues')
    })
  }

  test('Support RTL pour l\'arabe', async ({ page }) => {
    // Changer vers l'arabe
    await page.selectOption('[data-testid="language-selector"]', 'ar')
    
    // Attendre l'application du RTL
    await page.waitForTimeout(500)
    
    // Vérifier que la direction RTL est appliquée
    const html = page.locator('html')
    const direction = await html.getAttribute('dir')
    expect(direction).toBe('rtl')
    
    // Vérifier du contenu en arabe
    await expect(page.locator('body')).toContainText(/العربية|الرياضيات/)
    
    // Vérifier l'indicateur RTL dans les stats
    const currentLangElement = page.locator('[data-testid="current-language"]')
    await expect(currentLangElement).toContainText('RTL')
  })

  test('Changement de langue persiste après rechargement', async ({ page }) => {
    // Changer vers l'espagnol
    await page.selectOption('[data-testid="language-selector"]', 'es')
    await page.waitForTimeout(500)
    
    // Vérifier que c'est en espagnol
    const taglineElement = page.locator('[data-testid="tagline"]')
    const spanishText = await taglineElement.textContent()
    
    // Recharger la page
    await page.reload()
    await page.waitForSelector('[data-testid="app-title"]')
    
    // Vérifier que la langue espagnole est toujours active
    const selectorValue = await page.locator('[data-testid="language-selector"]').inputValue()
    expect(selectorValue).toBe('es')
    
    // Vérifier que le contenu est encore en espagnol
    const taglineAfterReload = page.locator('[data-testid="tagline"]')
    await expect(taglineAfterReload).toHaveText(spanishText!)
  })

  test('Exactement 20 langues disponibles', async ({ page }) => {
    const languageOptions = page.locator('[data-testid="language-selector"] option')
    const count = await languageOptions.count()
    expect(count).toBe(20)
    
    // Vérifier que les statistiques affichent bien 20
    const statsElement = page.locator('[data-testid="total-languages"]')
    await expect(statsElement).toContainText('Exactement 20 langues')
  })

  test('Toutes les opérations mathématiques sont traduites', async ({ page }) => {
    for (const language of ['fr', 'en', 'es']) {
      await page.selectOption('[data-testid="language-selector"]', language)
      await page.waitForTimeout(300)
      
      // Vérifier que les 4 opérations sont visibles et ont du contenu
      const operations = page.locator('[data-testid="math-operations"] .math-card')
      await expect(operations).toHaveCount(4)
      
      for (let i = 0; i < 4; i++) {
        const operation = operations.nth(i)
        await expect(operation).toBeVisible()
        const text = await operation.textContent()
        expect(text!.length).toBeGreaterThan(0)
      }
    }
  })

  test('Niveaux de difficulté traduits', async ({ page }) => {
    for (const language of ['fr', 'en', 'de']) {
      await page.selectOption('[data-testid="language-selector"]', language)
      await page.waitForTimeout(300)
      
      const levelsContainer = page.locator('[data-testid="difficulty-levels"]')
      await expect(levelsContainer).toBeVisible()
      
      // Vérifier qu'il y a 5 niveaux
      const levels = levelsContainer.locator('span')
      await expect(levels).toHaveCount(5)
    }
  })

  test('Bouton "Commencer l\'apprentissage" traduit', async ({ page }) => {
    for (const language of MAIN_LANGUAGES) {
      await page.selectOption('[data-testid="language-selector"]', language)
      await page.waitForTimeout(300)
      
      const startButton = page.locator('[data-testid="start-learning-button"]')
      await expect(startButton).toBeVisible()
      
      const buttonText = await startButton.textContent()
      expect(buttonText!.length).toBeGreaterThan(0)
      expect(buttonText).toContain('🚀')
    }
  })

  test('Statut opérationnel affiché', async ({ page }) => {
    const statusElement = page.locator('[data-testid="operational-status"]')
    await expect(statusElement).toBeVisible()
    await expect(statusElement).toContainText('3001')
    await expect(statusElement).toContainText('2.0.0')
    await expect(statusElement).toContainText('github.com')
  })

  test('Démo des traductions fonctionne', async ({ page }) => {
    const demoElement = page.locator('[data-testid="translations-demo"]')
    await expect(demoElement).toBeVisible()
    
    // Changer de langue et vérifier que la démo se met à jour
    await page.selectOption('[data-testid="language-selector"]', 'fr')
    await page.waitForTimeout(300)
    const frenchContent = await demoElement.textContent()
    
    await page.selectOption('[data-testid="language-selector"]', 'en')
    await page.waitForTimeout(300)
    const englishContent = await demoElement.textContent()
    
    expect(frenchContent).not.toBe(englishContent)
  })
})
