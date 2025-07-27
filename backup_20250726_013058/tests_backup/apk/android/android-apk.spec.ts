import { test, expect } from '@playwright/test'

test.describe('Math4Child - Tests APK Android', () => {
  
  test.beforeEach(async ({ page }) => {
    // L'app APK est déjà lancée par le setup
    await page.waitForTimeout(8000)
  })

  test('APK Android - Lancement et écran principal', async ({ page }) => {
    // Vérifier que l'APK est chargée
    await expect(page.locator('[data-testid="app-title"]')).toBeVisible({ timeout: 45000 })
    
    // Vérifier le titre Math4Child
    await expect(page.locator('[data-testid="app-title"]')).toContainText('Math4Child')
    
    // Screenshot APK Android
    await page.screenshot({ path: 'test-results/android-apk-home.png', fullPage: true })
  })

  test('APK Android - Navigation tactile native', async ({ page }) => {
    // Test navigation par tap/swipe mobile natif
    const gameButton = page.locator('[data-testid="start-game-button"]')
    await expect(gameButton).toBeVisible()
    
    // Tap tactile natif Android
    await gameButton.tap()
    
    // Vérifier transition vers jeu
    await expect(page.locator('[data-testid="math-question"]')).toBeVisible({ timeout: 15000 })
  })

  test('APK Android - Clavier virtuel Android', async ({ page }) => {
    await page.locator('[data-testid="start-game-button"]').tap()
    
    // Tap sur input de réponse
    const responseInput = page.locator('[data-testid="answer-input"]')
    await responseInput.tap()
    
    // Test saisie avec clavier Android natif
    await responseInput.fill('42')
    await expect(responseInput).toHaveValue('42')
    
    // Test validation
    await page.keyboard.press('Enter')
  })

  test('APK Android - Rotation écran', async ({ page, context }) => {
    // Portrait initial
    await page.setViewportSize({ width: 390, height: 844 })
    await expect(page.locator('[data-testid="app-title"]')).toBeVisible()
    
    // Rotation paysage
    await page.setViewportSize({ width: 844, height: 390 })
    
    // Vérifier adaptation interface
    await expect(page.locator('[data-testid="app-title"]')).toBeVisible()
    
    // Screenshot paysage
    await page.screenshot({ path: 'test-results/android-apk-landscape.png' })
  })

  test('APK Android - Performance native', async ({ page }) => {
    const startTime = Date.now()
    
    await page.locator('[data-testid="start-game-button"]').tap()
    await page.waitForSelector('[data-testid="math-question"]')
    
    const loadTime = Date.now() - startTime
    
    // Performance APK native (< 2.5 secondes)
    expect(loadTime).toBeLessThan(2500)
    
    console.log(`🤖 Performance APK Android: ${loadTime}ms`)
  })

  test('APK Android - Mode hors ligne', async ({ page, context }) => {
    // Désactiver réseau
    await context.setOffline(true)
    
    // L'app doit continuer à fonctionner
    await page.locator('[data-testid="start-game-button"]').tap()
    await expect(page.locator('[data-testid="math-question"]')).toBeVisible()
    
    // Remettre en ligne
    await context.setOffline(false)
  })
})
