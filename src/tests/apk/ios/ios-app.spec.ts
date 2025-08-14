import { test, expect } from '@playwright/test'

test.describe('Math4Child - Tests App iOS', () => {
  
  test.beforeEach(async ({ page }) => {
    // L'app iOS est déjà lancée par le setup
    await page.waitForTimeout(8000)
  })

  test('iOS App - Lancement et écran principal', async ({ page }) => {
    // Vérifier que l'app iOS est chargée
    await expect(page.locator('[data-testid="app-title"]')).toBeVisible({ timeout: 45000 })
    
    // Screenshot iOS
    await page.screenshot({ path: 'test-results/ios-app-home.png', fullPage: true })
  })

  test('iOS App - Safe Areas iPhone', async ({ page }) => {
    // Test safe areas spécifiques iPhone (notch, home indicator)
    const header = page.locator('header')
    const headerBox = await header.boundingBox()
    
    // Sur iPhone, header doit respecter safe area
    if (headerBox) {
      expect(headerBox.y).toBeGreaterThan(40) // Notch space
    }
  })

  test('iOS App - Navigation tactile iOS', async ({ page }) => {
    const gameButton = page.locator('[data-testid="start-game-button"]')
    
    // Tap iOS natif
    await gameButton.tap()
    
    await expect(page.locator('[data-testid="math-question"]')).toBeVisible()
  })

  test('iOS App - Performance native iOS', async ({ page }) => {
    const startTime = Date.now()
    
    await page.locator('[data-testid="start-game-button"]').tap()
    await page.waitForSelector('[data-testid="math-question"]')
    
    const loadTime = Date.now() - startTime
    expect(loadTime).toBeLessThan(2000) // iOS généralement plus rapide
    
    console.log(`🍎 Performance App iOS: ${loadTime}ms`)
  })
})
